import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_one.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/storage/cloud_storage_exception.dart';
import 'package:systems_app/services/cloud/storage/storage.actions.dart';

Future<void> pickImage({
  required BuildContext context,
  required StorageAsyncNotifier storage,
  required DatabaseAsyncNotifier database,
  required AuthenticationAsyncNotifier auth,
  required bool mounted,
}) async {
  final screenHeight = MediaQuery.of(context).size.height;

  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowCompression: true,
  );
  if (result != null && result.files.isNotEmpty) {
    final PlatformFile image = result.files.first;

    try {
      if (mounted) {
        LoadingScreen().show(context: context, showProgress: true);
      }

      final profileImageUrl = await storage.uploadProfileImage(
        bytes: image.bytes!,
        ext: image.name.split('.').last,
        path: image.path!,
        uid: auth.currentUser!.uid,
      );

      await database.addImageUrlToUserProfile(
        userId: auth.currentUser!.uid,
        profileImageUrl: profileImageUrl,
        role: SessionManager.getRole() ?? '',
      );
      SessionManager.setProfileImageUrl(profileImageUrl);

      LoadingScreen().hide();

      if (mounted) {
        CustomSnackBarOne.show(
          context,
          'Updated Successfully',
          screenHeight * 0.06,
        );
      }
    } on ErrorUploadingFile {
      if (mounted) {
        LoadingScreen().hide();
        await showErrorDialog(
          context: context,
          text: 'Error uploading profile image',
        );
      }
    }
  }
}
