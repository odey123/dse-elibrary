import 'package:flutter/material.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> levelUpgradeSuccessDialog<T>({
  required BuildContext context,
  required String name,
  required String buttonText,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: kPrimaryWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kSmallPadding),
        ),
        child: SizedBox(
          width: 350,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kSmallPadding),
                  child: Text(
                    'Upgraded Successfully',
                    style: textTheme.displayMedium!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: kBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: 200,
                  child: Text(
                    'You have successfully upgraded all students level',
                    style: textTheme.displayMedium!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kGry600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextForBorderButton(
                      text: close,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: kPrimaryWhite,
                      textColor: kDarkYellow,
                      borderColor: kDarkYellow,
                    ),
                    CustomTextButton(
                      text: buttonText,
                      isLoading: false,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: kDarkYellow,
                      textColor: kPrimaryWhite,
                      borderColor: kTransparent,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}
