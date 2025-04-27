import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';

class CustomSnackBarForEmptyField {
  static void show(
    BuildContext context,
    String message,
    double height,
  ) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: height,
        left: 0,
        right: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Material(
              color: const Color(0xFFFCE4E5),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AssetPaths.cancelIcon),
                    const SizedBox(width: 10),
                    Text(
                      message,
                      style: textTheme.bodySmall!.copyWith(
                        color: kGry900,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay after 2 seconds
    Timer(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
