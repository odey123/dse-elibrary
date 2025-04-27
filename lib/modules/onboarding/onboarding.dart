import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool showSecondText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (!kIsWeb || isPhoneWeb) ? YBox(kMacroPadding * 3) : YBox(0),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Welcome to',
                  textStyle: textTheme.headlineMedium!.copyWith(
                    color: kPrimaryColor,
                    fontSize: (!kIsWeb || isPhoneWeb) ? 28 : 30,
                    fontWeight: FontWeight.w500,
                  ),
                  speed: const Duration(milliseconds: 150),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 500),
              displayFullTextOnTap: true,
              onFinished: () {
                setState(() {
                  showSecondText = true;
                });
              },
            ),
            YBox(kMediumPadding),
            if (showSecondText)
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Department of Systems Engineering',
                    textAlign: TextAlign.center,
                    textStyle: textTheme.headlineMedium!.copyWith(
                      color: kPrimaryColor,
                      fontSize: (!kIsWeb || isPhoneWeb) ? 28 : 30,
                      fontWeight: FontWeight.w500,
                    ),
                    speed: const Duration(milliseconds: 150),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 500),
                displayFullTextOnTap: true,
                onFinished: () {},
              ),
            YBox(kMediumPadding),
            FadeInText(
              text: 'E-Library',
              style: textTheme.headlineMedium!.copyWith(
                color: kPrimaryColor,
                fontSize: (!kIsWeb || isPhoneWeb) ? 28 : 30,
                fontWeight: FontWeight.w500,
              ),
              delay: const Duration(seconds: 5),
              duration: const Duration(seconds: 1),
            ),
            YBox(kMediumPadding),
            SizedBox(
              width: (!kIsWeb || isPhoneWeb) ? 100 : 90,
              height: (!kIsWeb || isPhoneWeb) ? 100 : 90,
              child: IconButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    signInRoute,
                  );
                },
                icon: Image.asset(
                  AssetPaths.onBoard,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FadeInText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final Duration duration;

  const FadeInText({
    super.key,
    required this.text,
    required this.style,
    this.delay = Duration.zero,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<FadeInText> createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }
}
