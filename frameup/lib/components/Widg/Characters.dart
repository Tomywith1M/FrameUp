import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frameup/state/models/user.dart';

class Character extends StatelessWidget {
  const Character.tiny({
    Key? key,
    required this.frameUser,
  })  : _characterSize = _tinyCharacterSize,
        _coloredCircle = _tinyColoredCircle,
        documentedLog = false,
        fontSize = 12,
        isThumbnail = true,
        super(key: key);

  const Character.small({
    Key? key,
    required this.frameUser,
  })  : _characterSize = _smallCharacterSize,
        _coloredCircle = _smallColoredCircle,
        documentedLog = false,
        fontSize = 14,
        isThumbnail = true,
        super(key: key);

  const Character.medium({
    Key? key,
    this.documentedLog = false,
    required this.frameUser,
  })  : _characterSize = _mediumCharacterSize,
        _coloredCircle = _mediumColoredCircle,
        fontSize = 21,
        isThumbnail = true,
        super(key: key);

  const Character.big({
    Key? key,
    this.documentedLog = false,
    required this.frameUser,
  })  : _characterSize = _largeCharacterSize,
        _coloredCircle = _largeColoredCircle,
        fontSize = 25,
        isThumbnail = false,
        super(key: key);

  const Character.huge({
    Key? key,
    this.documentedLog = false,
    required this.frameUser,
  })  : _characterSize = _hugeCharacterSize,
        _coloredCircle = _hugeColoredCircle,
        fontSize = 28,
        isThumbnail = false,
        super(key: key);

  final bool documentedLog;

  final FrameUser frameUser;

  final double fontSize;

  final double _characterSize;
  final double _coloredCircle;

  static const _tinyCharacterSize = 23.0;
  static const _tinyPaddedCircle = _tinyCharacterSize + 2;
  static const _tinyColoredCircle = _tinyPaddedCircle * 2 + 4;

  static const _smallCharacterSize = 32.0;
  static const _smallPaddedCircle = _smallCharacterSize + 2;
  static const _smallColoredCircle = _smallPaddedCircle * 2 + 4;

  static const _mediumCharacterSize = 42.0;
  static const _mediumPaddedCircle = _mediumCharacterSize + 2;
  static const _mediumColoredCircle = _mediumPaddedCircle * 2 + 4;

  static const _largeCharacterSize = 88.0;
  static const _largPaddedCircle = _largeCharacterSize + 2;
  static const _largeColoredCircle = _largPaddedCircle * 2 + 4;

  static const _hugeCharacterSize = 118.0;
  static const _hugePaddedCircle = _hugeCharacterSize + 2;
  static const _hugeColoredCircle = _hugePaddedCircle * 2 + 4;

  final bool isThumbnail;

  @override
  Widget build(BuildContext context) {
    final picture = _CircularProfilePicture(
      size: _characterSize,
      userData: frameUser,
      fontSize: fontSize,
      isThumbnail: isThumbnail,
    );

    if (!documentedLog) {
      return picture;
    }
    return Container(
      width: _coloredCircle,
      height: _coloredCircle,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Center(child: picture),
    );
  }
}

class _CircularProfilePicture extends StatelessWidget {
  const _CircularProfilePicture({
    Key? key,
    required this.size,
    required this.userData,
    required this.fontSize,
    this.isThumbnail = false,
  }) : super(key: key);

  final FrameUser userData;

  final double size;
  final double fontSize;

  final bool isThumbnail;

  @override
  Widget build(BuildContext context) {
    final profilePhoto = isThumbnail
        ? userData.profilePhotoThumbnail
        : userData.profilePhotoResized;

    return (profilePhoto == null)
        ? Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${userData.firstName[0]}${userData.lastName[0]}',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          )
        : SizedBox(
            width: size,
            height: size,
            child: CachedNetworkImage(
              imageUrl: profilePhoto,
              fit: BoxFit.contain,
              imageBuilder: (context, imageProvider) => Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
          );
  }
}
