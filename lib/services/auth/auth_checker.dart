import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:systems_app/modules/admin/homepage/homepage.dart';
import 'package:systems_app/modules/homepage/homepage.dart';
import 'package:systems_app/modules/onboarding/onboarding.dart';
import 'package:systems_app/services/auth/auth_state.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authenticationAsyncNotifierProvider.notifier);

    final appState = authNotifier.appInitializer();

    if (appState == AuthState.loggedOut) {
      return const OnBoarding();
    } else {
      return FutureBuilder(
        future: authNotifier.checkIfAdmin(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.done:
              if (snapshot.hasData) {
                final isAdmin = snapshot.data as bool;
                if (isAdmin) {
                  return const HomePageAdmin();
                } else {
                  return const HomePage();
                }
              } else {
                return Container();
              }
            default:
              return Container();
          }
        },
      );
    }
  }
}
