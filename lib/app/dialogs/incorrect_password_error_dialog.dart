import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/dialogs/generic_dialog_one.dart';
import 'package:systems_app/utils/assets_path.dart';

Future<void> showIncorrectPasswordErrorDialog({
  required BuildContext context,
  required String text,
}) {
  return showGenericDialogOne(
    context: context,
    content: text,
    icon: SvgPicture.asset(AssetPaths.incorrectPassword),
    isIncorrectPassword: true,
    optionBuilder: () => {
      'Try Again': null,
    },
  );
}
