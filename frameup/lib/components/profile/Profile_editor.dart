import 'package:flutter/material.dart';
import 'package:frameup/app/theme.dart';
import 'package:frameup/app/utils.dart';
import 'package:frameup/components/Widg/Characters.dart';
import 'package:frameup/state/app_state.dart';
import 'package:frameup/state/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEditorScreen extends StatelessWidget {
  const ProfileEditorScreen({
    Key? key,
  }) : super(key: key);

  static Route get route => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ProfileEditorScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutQuint));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final frameUser =
        context.select<AppState, FrameUser?>((value) => value.frameUser);
    if (frameUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('You should not see this.\nUser data is empty.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: (Theme.of(context).brightness == Brightness.dark)
                ? const TextStyle(color: AppColors.light)
                : const TextStyle(color: AppColors.dark),
          ),
        ),
        leadingWidth: 80,
        title: const Text(
          ' Edit profile',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: ListView(
        children: [
          const _ChangeProfilePictureButton(),
          const Divider(
            color: Colors.white24,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Name',
                    style: AppTextStyle.textStyleBoldMedium,
                  ),
                ),
                Text(
                  '${frameUser.fullName} ',
                  style: AppTextStyle.textStyleBoldMedium,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Username',
                    style: AppTextStyle.textStyleBoldMedium,
                  ),
                ),
                Text(
                  '${context.appState.user.id} ',
                  style: AppTextStyle.textStyleBoldMedium,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}

class _ChangeProfilePictureButton extends StatefulWidget {
  const _ChangeProfilePictureButton({
    Key? key,
  }) : super(key: key);

  @override
  __ChangeProfilePictureButtonState createState() =>
      __ChangeProfilePictureButtonState();
}

class __ChangeProfilePictureButtonState
    extends State<_ChangeProfilePictureButton> {
  final _picker = ImagePicker();

  Future<void> _changePicture() async {
    if (context.appState.isUploadingProfilePicture == true) {
      return;
    }

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 799,
      maxHeight: 799,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      await context.appState.updateProfilePhoto(pickedFile.path);
    } else {
      context.removeAndShowSnackbar('No picture selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final frameUser =
        context.select<AppState, FrameUser>((value) => value.frameUser!);
    final isUploadingProfilePicture = context
        .select<AppState, bool>((value) => value.isUploadingProfilePicture);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: Center(
              child: isUploadingProfilePicture
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                      onTap: _changePicture,
                      child: Character.huge(frameUser: frameUser),
                    ),
            ),
          ),
          GestureDetector(
            onTap: _changePicture,
            child: const Text('Change Profile Photo',
                style: AppTextStyle.textStyleAction),
          ),
        ],
      ),
    );
  }
}
