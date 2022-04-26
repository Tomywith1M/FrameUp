import 'package:flutter/material.dart';
import 'package:frameup/state/models/user.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

enum Opinion {
  activityOpinion,
  reactionOpinion,
}

class CommentFocus {
  const CommentFocus({
    required this.opinion,
    required this.id,
    required this.user,
    this.reaction,
  });

  final Reaction? reaction;
  final Opinion opinion;
  final String id;
  final FrameUser user;
}

class OpinionState extends ChangeNotifier {
  OpinionState({
    required this.activityId,
    required this.activityOwnerData,
  });

  final String activityId;

  final FrameUser activityOwnerData;

  late CommentFocus commentFocus = CommentFocus(
    opinion: Opinion.activityOpinion,
    id: activityId,
    user: activityOwnerData,
  );

  void setCommentFocus(CommentFocus focus) {
    commentFocus = focus;
    notifyListeners();
  }

  void resetCommentFocus() {
    commentFocus = CommentFocus(
      opinion: Opinion.activityOpinion,
      id: activityId,
      user: activityOwnerData,
    );
    notifyListeners();
  }
}
