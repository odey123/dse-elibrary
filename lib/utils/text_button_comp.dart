import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/utils/constant.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final IconData? icon;
  final EdgeInsets padding;
  final bool isLoading;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.isLoading,
    this.icon,
    this.padding = const EdgeInsets.only(
      left: kMediumPadding - 3,
      right: kMediumPadding,
      top: kRegularPadding + 4,
      bottom: kRegularPadding + 1,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (!kIsWeb || isPhoneWeb) ? 45 : 38,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          minimumSize: const Size(50, 35),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Transform.translate(
                offset: const Offset(0, -1),
                child: Icon(
                  icon,
                  size: 17,
                  color: textColor,
                ),
              ),
            if (icon != null) XBox(kSmallPadding),
            isLoading
                ? const SizedBox(
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: kPrimaryWhite,
                    ),
                  )
                : Text(
                    text,
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class CustomTextForBorderButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final IconData? icon;
  final EdgeInsets padding;

  const CustomTextForBorderButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.icon,
    this.padding = const EdgeInsets.only(
      left: kRegularPadding,
      right: kRegularPadding,
      top: kRegularPadding + 2,
      bottom: kRegularPadding,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        minimumSize: const Size(0, 35),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: textTheme.titleMedium!.copyWith(
              fontSize: (!kIsWeb || isPhoneWeb) ? 17 : 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          (icon != null) ? XBox(kPadding) : const SizedBox(),
          (icon != null)
              ? Transform.translate(
                  offset: const Offset(0, -1),
                  child: Icon(
                    icon,
                    size: 17,
                    color: textColor,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
