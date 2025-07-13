import 'package:flutter/material.dart';
import 'package:systems_app/utils/constant.dart';

Future<bool> confirmationDialog({
  required BuildContext context,
  required bool mounted,
  required String body,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Confirmation dialog!',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: textTheme.displayMedium!.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: kDeepOcean,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRegularPadding),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: const Color(0xFFFFFFFF),
        content: Text(
          body,
          textAlign: TextAlign.center,
        ),
        contentTextStyle: textTheme.displayMedium!.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: kDeepOcean,
        ),
        titlePadding: const EdgeInsets.only(
          top: kMacroPadding,
        ),
        actionsPadding: const EdgeInsets.only(
          bottom: kRegularPadding,
          left: kRegularPadding,
          right: kRegularPadding,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all<Size>(
                      const Size(150, 40),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color(0xFFF3F3F3),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'NO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(kPrimaryColor),
                    minimumSize: WidgetStateProperty.all<Size>(
                      const Size(150, 40),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'YES',
                    style: TextStyle(
                        fontFamily: 'DMMono',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF4F4F4)),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  ).then((value) {
    if (value == null) {
      return false;
    } else {
      return value;
    }
  });
}
