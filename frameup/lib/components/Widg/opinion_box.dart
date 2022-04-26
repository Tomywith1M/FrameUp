import 'package:flutter/material.dart';
import 'package:frameup/app/theme.dart';
import 'package:frameup/components/Widg/Characters.dart';
import 'package:frameup/state/models/user.dart';

class OpionionBox extends StatelessWidget {
  const OpionionBox({
    Key? key,
    required this.commenter,
    required this.textEditingController,
    required this.focusNode,
    required this.onSubmitted,
  }) : super(key: key);

  final FrameUser commenter;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String?) onSubmitted;

  @override
  Widget build(BuildContext context) {
    final border = _border(context);
    return Container(
      decoration: BoxDecoration(
        color: (Theme.of(context).brightness == Brightness.light)
            ? AppColors.light
            : AppColors.dark,
        border: Border(
            top: BorderSide(
          color: (Theme.of(context).brightness == Brightness.light)
              ? AppColors.ligthGrey
              : AppColors.grey,
        )),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _emojiText('⭐'),
                _emojiText('🙌'),
                _emojiText('🔥'),
                _emojiText('😉'),
                _emojiText('😑'),
                _emojiText('😍'),
                _emojiText('😮'),
                _emojiText('😂'),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Character.medium(frameUser: commenter),
              ),
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: onSubmitted,
                  minLines: 1,
                  maxLines: 10,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                      suffix: _FinishButton(
                        textEditorFocusNode: focusNode,
                        textEditingController: textEditingController,
                        onSubmitted: onSubmitted,
                      ),
                      hintText: 'State Your Opinion',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      focusedBorder: border,
                      border: border,
                      enabledBorder: border),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      borderSide: BorderSide(
        color: (Theme.of(context).brightness == Brightness.light)
            ? AppColors.grey.withOpacity(0.4)
            : AppColors.light.withOpacity(0.6),
        width: 0.5,
      ),
    );
  }

  Widget _emojiText(String emoji) {
    return GestureDetector(
      onTap: () {
        focusNode.requestFocus();
        textEditingController.text = textEditingController.text + emoji;
        textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: textEditingController.text.length));
      },
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

class _FinishButton extends StatefulWidget {
  const _FinishButton({
    Key? key,
    required this.onSubmitted,
    required this.textEditorFocusNode,
    required this.textEditingController,
  }) : super(key: key);

  final Function(String?) onSubmitted;
  final FocusNode textEditorFocusNode;
  final TextEditingController textEditingController;

  @override
  State<_FinishButton> createState() => _FinishButtonState();
}

class _FinishButtonState extends State<_FinishButton> {
  final fadedTextStyle =
      AppTextStyle.textStyleAction.copyWith(color: Colors.grey);
  late TextStyle textStyle = fadedTextStyle;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      if (widget.textEditingController.text.isNotEmpty) {
        textStyle = AppTextStyle.textStyleAction;
      } else {
        textStyle = fadedTextStyle;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.textEditorFocusNode.hasFocus
        ? GestureDetector(
            onTap: () {
              widget.onSubmitted(widget.textEditingController.text);
            },
            child: Text(
              'Finish',
              style: textStyle,
            ),
          )
        : const SizedBox.shrink();
  }
}
