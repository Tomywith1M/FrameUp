import 'package:flutter/material.dart';
import 'package:frameup/app/utils.dart';
import 'package:frameup/components/Widg/opinion_box.dart';
import 'package:frameup/state/models/user.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'widgets/widgets.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final ValueNotifier<bool> _showOpionionBox = ValueNotifier(false);
  final TextEditingController _commentTextController = TextEditingController();
  final FocusNode _opinionFocusNode = FocusNode();
  EnrichedActivity? activeActivity;

  void openOpionionBox(EnrichedActivity activity, {String? message}) {
    _commentTextController.text = message ?? '';
    _commentTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentTextController.text.length));
    activeActivity = activity;
    _showOpionionBox.value = true;
    _opinionFocusNode.requestFocus();
  }

  Future<void> addComment(String? message) async {
    if (activeActivity != null &&
        message != null &&
        message.isNotEmpty &&
        message != '') {
      await FeedProvider.of(context).bloc.onAddReaction(
        kind: 'comment',
        activity: activeActivity!,
        feedGroup: 'log',
        data: {'message': message},
      );
      _commentTextController.clear();
      FocusScope.of(context).unfocus();
      _showOpionionBox.value = false;
    }
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    _opinionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _showOpionionBox.value = false;
      },
      child: Stack(
        children: [
          FlatFeedCore(
            feedGroup: 'log',
            errorBuilder: (context, error) =>
                const Text('Could not load profile'),
            loadingBuilder: (context) => const SizedBox(),
            emptyBuilder: (context) => const Center(
              child: Text('No Posts\nGo and post something'),
            ),
            flags: EnrichmentFlags()
              ..withOwnReactions()
              ..withRecentReactions()
              ..withReactionCounts(),
            feedBuilder: (context, activities) {
              return RefreshIndicator(
                onRefresh: () {
                  return FeedProvider.of(context).bloc.queryEnrichedActivities(
                        feedGroup: 'log',
                        flags: EnrichmentFlags()
                          ..withOwnReactions()
                          ..withRecentReactions()
                          ..withReactionCounts(),
                      );
                },
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      key: ValueKey('post-${activities[index].id}'),
                      enrichedActivity: activities[index],
                      onAddComment: openOpionionBox,
                    );
                  },
                ),
              );
            },
          ),
          _OpionionBox(
            commenter: context.appState.frameUser!,
            textEditingController: _commentTextController,
            focusNode: _opinionFocusNode,
            addComment: addComment,
            showOpionionBox: _showOpionionBox,
          )
        ],
      ),
    );
  }
}

class _OpionionBox extends StatefulWidget {
  const _OpionionBox({
    Key? key,
    required this.commenter,
    required this.textEditingController,
    required this.focusNode,
    required this.addComment,
    required this.showOpionionBox,
  }) : super(key: key);

  final FrameUser commenter;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String?) addComment;
  final ValueNotifier<bool> showOpionionBox;

  @override
  __OpinionBoxState createState() => __OpinionBoxState();
}

class __OpinionBoxState extends State<_OpionionBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          visibility = false;
        });
      } else {
        setState(() {
          visibility = true;
        });
      }
    });
    widget.showOpionionBox.addListener(_HideandSeekOpinionBox);
  }

  void _HideandSeekOpinionBox() {
    if (widget.showOpionionBox.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: FadeTransition(
        opacity: _animation,
        child: Builder(builder: (context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: OpionionBox(
              commenter: widget.commenter,
              textEditingController: widget.textEditingController,
              focusNode: widget.focusNode,
              onSubmitted: widget.addComment,
            ),
          );
        }),
      ),
    );
  }
}
