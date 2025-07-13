import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_for_empty_field.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/dialogs/incorrect_password_error_dialog.dart';
import 'package:systems_app/app/dialogs/internet_dialog.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/auth_exception.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class SignInAsAdmin extends ConsumerStatefulWidget {
  const SignInAsAdmin({super.key});

  @override
  ConsumerState<SignInAsAdmin> createState() => _SignInAsAdminState();
}

class _SignInAsAdminState extends ConsumerState<SignInAsAdmin> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final AuthenticationAsyncNotifier _auth;
  bool _isPasswordVisible = false;
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  Color emailBorderColor = kGry450;
  Color passwordBorderColor = kGry450;
  bool _isLoading = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  Future<void> handleSubmit(
      {required BuildContext context,
      required AuthenticationAsyncNotifier auth}) async {
    final email = _email.text;
    final password = _password.text;
    if (email.isEmpty && password.isEmpty) {
      setState(() {
        emailBorderColor = kError;
        passwordBorderColor = kError;
      });
      CustomSnackBarForEmptyField.show(
        context,
        'Field must not be empty',
        40,
      );
    } else if (email.isEmpty) {
      setState(() {
        emailBorderColor = kError;
      });
      CustomSnackBarForEmptyField.show(
        context,
        'Field must not be empty',
        40,
      );
    } else if (password.isEmpty) {
      setState(() {
        passwordBorderColor = kError;
      });
      CustomSnackBarForEmptyField.show(
        context,
        'Field must not be empty',
        40,
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      LoadingScreen().show(context: context, showProgress: false);
      try {
        await auth.logOut();
        final user = await auth.logIn(email: email, password: password);
        final adminChecker = await auth.checkIfAdmin();
        setState(() {
          _isLoading = false;
        });
        if (adminChecker) {
          LoadingScreen().hide();
          log('$user');
          Navigator.pushNamedAndRemoveUntil(
              context, homeAdminRoute, (route) => false);
        } else {
          await auth.logOut();
          LoadingScreen().hide();
          CustomSnackBarForEmptyField.show(
            context,
            'Access denied. Admins only.',
            40,
          );
        }
      } on Exception catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          LoadingScreen().hide();
          if (e is UserNotFoundAuthException) {
            showErrorDialog(
              context: context,
              text: 'There is no account associated with this email address.',
            );
          } else if (e is InvalidCredentialAuthException) {
            showErrorDialog(
              context: context,
              text: 'There is no account associated with this credentials',
            );
          } else if (e is WrongPasswordAuthException) {
            showIncorrectPasswordErrorDialog(
              context: context,
              text: 'The password entered is incorrect.',
            );
          } else if (e is UserDisabledAuthException) {
            showIncorrectPasswordErrorDialog(
              context: context,
              text: 'Your classs account has been disabled',
            );
          } else if (e is NetworkRequestFailedAuthException) {
            showInternetDialog(
              context: context,
              text: "There is no internet connection.",
            );
          } else if (e is TooManyRequestAuthException) {
            showErrorDialog(
              context: context,
              text: 'Please attempt it again after some time',
            );
          } else if (e is GenericAuthException) {
            showErrorDialog(
              context: context,
              text: 'Authentication Error',
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
        body: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (!kIsWeb || isPhoneWeb) ? 15 : 25,
                vertical: (!kIsWeb || isPhoneWeb) ? 40 : 25,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 9,
                    right: 9,
                    top: 6,
                    bottom: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kGry300,
                    border: Border.all(
                      color: kGry450,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: SizedBox(
                    width: 9,
                    height: 15,
                    child: SvgPicture.asset(
                      AssetPaths.back,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign In As Admin',
                style: textTheme.titleSmall!.copyWith(
                  color: kBlack,
                  fontSize: (!kIsWeb || isPhoneWeb) ? 30 : 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              YBox(kSmallPadding),
              Text(
                'Welcome to the E-Library',
                style: textTheme.bodySmall!.copyWith(
                  color: kGry800,
                  fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              YBox(kMacroPadding),
              Container(
                height: (!kIsWeb || isPhoneWeb) ? 44 : 40,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color:
                        _focusNodeEmail.hasFocus ? kGry450 : emailBorderColor,
                  ),
                  color: kTextfieldLoginBackground,
                ),
                child: TextField(
                  controller: _email,
                  focusNode: _focusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: textTheme.bodySmall!.copyWith(
                    color: kBlack,
                    fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 13,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        emailBorderColor = kGry450;
                      });
                    }
                  },
                  onSubmitted: (value) async {
                    await handleSubmit(
                      context: context,
                      auth: _auth,
                    );
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                    ),
                    hintText: 'Email Address',
                    hintStyle: textTheme.bodySmall!.copyWith(
                      color: kgry700,
                      fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 13,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                  ),
                  cursorColor: kBlack,
                ),
              ),
              (emailBorderColor == kError)
                  ? const Padding(
                      padding: EdgeInsets.only(
                        top: 2,
                        left: 0,
                      ),
                      child: Text(
                        'Email Address is required.',
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFF0000),
                            fontSize: 11),
                      ),
                    )
                  : const SizedBox(
                      height: 6,
                    ),
              const SizedBox(height: kSmallPadding),
              Container(
                height: (!kIsWeb || isPhoneWeb) ? 44 : 40,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: _focusNodePassword.hasFocus
                        ? kGry450
                        : passwordBorderColor,
                  ),
                  color: kTextfieldLoginBackground,
                ),
                child: TextField(
                  controller: _password,
                  focusNode: _focusNodePassword,
                  keyboardType: TextInputType.visiblePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: !_isPasswordVisible,
                  style: textTheme.bodySmall!.copyWith(
                    color: kBlack,
                    fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 13,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    if (value.length >= 6) {
                      setState(() {
                        passwordBorderColor = kGry450;
                      });
                    }
                  },
                  onSubmitted: (value) async {
                    await handleSubmit(
                      context: context,
                      auth: _auth,
                    );
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                    ),
                    hintText: 'Password',
                    hintStyle: textTheme.bodySmall!.copyWith(
                      color: kgry700,
                      fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 13,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      icon: _isPasswordVisible
                          ? const Icon(
                              Icons.visibility,
                              size: 20,
                              color: kgry700,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              size: 20,
                              color: kgry700,
                            ),
                    ),
                  ),
                  cursorColor: kBlack,
                ),
              ),
              (passwordBorderColor == kError)
                  ? const Padding(
                      padding: EdgeInsets.only(
                        top: 2,
                        left: 0,
                      ),
                      child: Text(
                        'Password is required.',
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFF0000),
                            fontSize: 11),
                      ),
                    )
                  : const SizedBox(
                      height: 6,
                    ),
              const SizedBox(height: kSmallPadding),
              SizedBox(
                width: 300,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      forgotPasswordRoute,
                    );
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: kRegularPadding,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: textTheme.bodySmall!.copyWith(
                        color: kDarkYellow,
                        fontSize: (!kIsWeb || isPhoneWeb) ? 13 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
              YBox(kMacroPadding),
              SizedBox(
                height: (!kIsWeb || isPhoneWeb) ? 45 : 38,
                width: 300,
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(
                          left: kSmallPadding,
                          right: kSmallPadding,
                          bottom: kRegularPadding,
                          top: kRegularPadding + 4,
                        ),
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        await handleSubmit(
                          context: context,
                          auth: _auth,
                        );
                      },
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kPrimaryWhite,
                              ),
                            )
                          : Text(
                              enter,
                              style: textTheme.titleSmall!.copyWith(
                                fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
