import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialogOne<T>({
  required BuildContext context,
  required String content,
  required Widget icon,
  required DialogOptionBuilder optionBuilder,
  bool isNoInternet = false,
  bool isIncorrectPassword = false,
}) {
  final options = optionBuilder();
  if (options.isEmpty) return Future.value(null);

  final optionTitle = options.keys.first;
  final value = options[optionTitle];

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kPrimaryWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRegularPadding),
        ),
        icon: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Padding(
              padding: isNoInternet
                  ? const EdgeInsets.only(top: 12)
                  : const EdgeInsets.only(top: 7),
              child: icon,
            ),
            Padding(
              padding: isIncorrectPassword
                  ? const EdgeInsets.only(left: 80, top: 14)
                  : isNoInternet
                      ? const EdgeInsets.only(left: 48)
                      : const EdgeInsets.only(left: 27),
              child: SvgPicture.asset(AssetPaths.smallError),
            ),
          ],
        ),
        title: const Text('Oops'),
        titleTextStyle: textTheme.displayMedium!.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: kDeepOcean,
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        contentTextStyle: textTheme.displayMedium!.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: kDeepOcean,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: kPrimaryColor,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(value);
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all<Size>(
                    const Size(200, 40),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(kPrimaryColor),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Text(optionTitle,
                    style: textTheme.displayMedium!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFFFFFF),
                    )),
              ),
            ),
          ),
          const SizedBox(height: kSmallPadding),
        ],
      );
    },
  );
}
