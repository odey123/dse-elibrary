import 'package:flutter/material.dart';
import 'package:systems_app/app/loading/loading_screen_controller.dart';
import 'package:systems_app/utils/constant.dart';

class LoadingScreen {
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required bool showProgress,
  }) {
    controller = showOverlay(context: context, showProgress: showProgress);
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required bool showProgress,
  }) {
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: kTransparent,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      (showProgress)
                          ? const CircularProgressIndicator(
                              strokeWidth: 3,
                              color: kPrimaryColor,
                            )
                          : Container(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }
}
