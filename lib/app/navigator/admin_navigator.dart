import 'package:flutter/widgets.dart';
import 'package:systems_app/routes.dart';

void adminNavigateTo(
  String route,
  GlobalKey<NavigatorState> navigatorKey,
) {
  if (route == homeDashboardRoute) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(route, (route) => false);
  } else {
    navigatorKey.currentState?.pushNamed(route);
  }
}
