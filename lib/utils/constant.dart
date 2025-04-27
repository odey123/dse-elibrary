import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final textTheme = Theme.of(navigatorKey.currentState!.context).textTheme;
final screenSize = MediaQuery.of(navigatorKey.currentState!.context).size;

// Web Device Type
final bool isPhoneWeb = kIsWeb && screenSize.width > 700 ? false : true;

// Spacing
const double kPadding = 5;
const double kSmallPadding = 10;
const double kRegularPadding = 15;
const double kMediumPadding = 20;
const double kMicroPadding = 24;
const double kMacroPadding = 30;
const double kLargePadding = 40;
const double kFullPadding = 60;
const double kSupremePadding = 100;

const double kIconSize = 24;

// Colors
// Brand Colors
const Color kBlack = Color(0xff000000);
const Color kDarkBlue800 = Color(0xff022D4F);
const Color kBlack800 = Color(0xff282828);
const Color kPrimaryWhite = Colors.white;
const Color kPrimaryColor = Color(0xff3498DB);
const Color kGry300 = Color(0xffF4F4F4);
const Color kGry400 = Color(0xffF7F7F7);
const Color kGry450 = Color(0xffDEDEDE);
const Color kGry500 = Color(0xffE0E0E0);
const Color kGry550 = Color(0xffD9D9D9);
const Color kGry600 = Color(0xff898989);
const Color kgry700 = Color(0xff858383);
const Color kGry800 = Color(0xff828282);
const Color kGry900 = Color(0xFF616161);
const Color kRed = Color(0xffC5221F);
const Color kDarkYellow = Color(0xfff1c40f);
const Color kOrange500 = Color(0xFFEAC217);
const Color kTransparent = Colors.transparent;
const Color kBlue800 = Color(0xff14B3FC);
const Color kTextfieldLoginBackground = Color(0xffF4F4F4);
const Color kDeepOcean = Color(0xFF163641);
const Color kError = Color(0xFFFF0000);
const Color kSearchBack = Color(0xff1C1C1C);
const Color kGreenSuccess = Color(0xFF00711F);
// Text
TextStyle kDisplayLargeTextStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  color: kPrimaryWhite,
  fontSize: 24,
  fontFamily: "KumbhSans",
);

TextStyle kDisplayMediumTextStyle = const TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 18,
  color: kPrimaryWhite,
  fontFamily: "KumbhSans",
);

TextStyle kBodyMediumStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  color: kPrimaryWhite,
  fontSize: 26,
  fontFamily: "KumbhSans",
);

TextStyle kHeadlineMediumTextStyle = const TextStyle(
  fontWeight: FontWeight.w600,
  color: kPrimaryWhite,
  fontSize: 20,
  fontFamily: "KumbhSans",
);

TextStyle kTitleMediumStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: kPrimaryWhite,
  fontFamily: "KumbhSans",
);

TextStyle kDisplaySmallTextStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: kPrimaryWhite,
  fontFamily: "KumbhSans",
);

TextStyle kTitleSmallStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  color: kPrimaryWhite,
  fontSize: 14,
  fontFamily: "KumbhSans",
);

TextStyle kBodyLargeStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  color: kPrimaryWhite,
  fontSize: 14,
  fontFamily: "KumbhSans",
);

// ThemeData
ThemeData kThemeData = ThemeData.light(useMaterial3: false).copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: kPrimaryWhite,
  iconTheme: const IconThemeData(size: kIconSize, color: kPrimaryColor),
  // dividerColor: kLightGrey,
  primaryColor: kPrimaryColor,
  canvasColor: kPrimaryWhite,
  // backgroundColor: kPrimaryWhite,
  // textSelectionTheme: const TextSelectionThemeData(
  //   selectionHandleColor: kColorGreen,
  //   cursorColor: kPrimaryColor,
  //   selectionColor: kLightGrey,
  // ),
  dialogBackgroundColor: kTransparent,
  appBarTheme: AppBarTheme(
    color: kPrimaryWhite,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: kPrimaryWhite,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
    elevation: 0,
    iconTheme: const IconThemeData(size: kIconSize, color: kPrimaryColor),
    titleTextStyle:
        kTitleMediumStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
  ),
  textTheme: TextTheme(
      displayLarge: kDisplayLargeTextStyle,
      displayMedium: kDisplayMediumTextStyle,
      bodyMedium: kBodyMediumStyle,
      titleMedium: kTitleMediumStyle,
      displaySmall: kDisplaySmallTextStyle,
      titleSmall: kTitleSmallStyle,
      bodyLarge: kBodyLargeStyle,
      headlineMedium: kHeadlineMediumTextStyle),
);
