import 'package:flutter/material.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_for_empty_field.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';

Future<void> handleProfileSubmit({
  required BuildContext context,
  required bool isLecturer,
  required TextEditingController firstNameController,
  required TextEditingController lastNameController,
  required TextEditingController? preferredAcademicNameController,
  required TextEditingController? prefixController,
  required AuthenticationAsyncNotifier auth,
  required DatabaseAsyncNotifier database,
  required VoidCallback onLoadingStart,
  required VoidCallback onLoadingEnd,
  required bool mounted,
}) async {
  final firstName = firstNameController.text.trim();
  final lastName = lastNameController.text.trim();
  final preferredAcademicName =
      preferredAcademicNameController?.text.trim() ?? '';
  final prefix = prefixController?.text.trim() ?? '';

  if (firstName.isEmpty ||
      lastName.isEmpty ||
      (isLecturer && (preferredAcademicName.isEmpty || prefix.isEmpty))) {
    CustomSnackBarForEmptyField.show(
      context,
      'Field must not be empty',
      40,
    );
    return;
  }

  onLoadingStart();
  LoadingScreen().show(context: context, showProgress: false);

  try {
    if (isLecturer) {
      await database.editLecturerProfile(
        userId: auth.currentUser!.uid,
        firstName: firstName,
        lastName: lastName,
        preferredAcademicName: preferredAcademicName,
        prefix: prefix,
      );
      SessionManager.setFirstName(firstName);
      SessionManager.setLastName(lastName);
      SessionManager.setPreferredAcademicName(preferredAcademicName);
      SessionManager.setPrefix(prefix);
    } else {
      await database.editStudentProfile(
        userId: auth.currentUser!.uid,
        firstName: firstName,
        lastName: lastName,
      );
      SessionManager.setFirstName(firstName);
      SessionManager.setLastName(lastName);
    }

    onLoadingEnd();
    LoadingScreen().hide();
  } catch (e) {
    onLoadingEnd();
    LoadingScreen().hide();
    if (mounted) {
      await showErrorDialog(
        context: context,
        text: 'Please try again later.',
      );
    }
  }
}
