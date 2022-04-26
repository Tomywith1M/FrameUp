import 'package:flutter/material.dart';
import 'package:frameup/state/models/user.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'demo_users.dart';

class AppState extends ChangeNotifier {
  AppState({
    required StreamFeedClient client,
  }) : _client = client;

  late final StreamFeedClient _client;

  StreamFeedClient get client => _client;

  StreamUser get user => _client.currentUser!;

  FrameUser? _frameUser;
  var isUploadingProfilePicture = false;

  FrameUser? get frameUser => _frameUser;

  FlatFeed get currentUserFeed => _client.flatFeed('user', user.id);

  FlatFeed get currentLogFeed => _client.flatFeed('log', user.id);

  Future<bool> connect(DemoAppUser demoUser) async {
    final currentUser = await _client.setUser(
      User(id: demoUser.id),
      demoUser.token!,
      extraData: demoUser.data,
    );

    if (currentUser.data != null) {
      _frameUser = FrameUser.fromMap(currentUser.data!);
      await currentLogFeed.follow(currentUserFeed);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateProfilePhoto(String filePath) async {
    isUploadingProfilePicture = true;
    notifyListeners();

    final imageUrl = await client.images.upload(AttachmentFile(path: filePath));
    if (imageUrl == null) {
      debugPrint('Could not upload the image. Not setting profile picture');
      isUploadingProfilePicture = false;
      notifyListeners();
      return;
    }

    final results = await Future.wait([
      client.images.getResized(
        imageUrl,
        const Resize(500, 500),
      ),
      client.images.getResized(
        imageUrl,
        const Resize(50, 50),
      )
    ]);

    _frameUser = _frameUser?.copyWith(
      profilePhoto: imageUrl,
      profilePhotoResized: results[0],
      profilePhotoThumbnail: results[1],
    );

    isUploadingProfilePicture = false;

    if (_frameUser != null) {
      await client.currentUser!.update(_frameUser!.toMap());
    }

    notifyListeners();
  }
}
