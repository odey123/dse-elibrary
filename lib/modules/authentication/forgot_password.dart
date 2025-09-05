import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_for_empty_field.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_one.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/dialogs/internet_dialog.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/auth_exception.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  late final TextEditingController _email;
  late final AuthenticationAsyncNotifier _auth;
  final FocusNode _focusNodeEmail = FocusNode();
  Color emailBorderColor = kGry450;
  bool _isLoading = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _email = TextEditingController();
    super.initState();
  }

  Future<void> handleSubmit(
      {required BuildContext context,
      required AuthenticationAsyncNotifier auth}) async {
    final email = _email.text;

    if (email.isEmpty) {
      setState(() {
        emailBorderColor = kError;
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
        await auth.sendPasswordReset(toEmail: email);
        setState(() {
          _isLoading = false;
        });
        LoadingScreen().hide();
        if (mounted) {
          CustomSnackBarOne.show(
            context,
            'Reset password link sent!',
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
              text: 'Please attempt it again after some time',
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Reset Password',
                  style: textTheme.titleSmall!.copyWith(
                    color: kPrimaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                YBox(kSmallPadding),
                Text(
                  'Don’t worry it happens. Please enter the email associated with your account',
                  style: textTheme.bodySmall!.copyWith(
                    color: kGry800,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'and we’ll send an email with a recovery link to reset your password.',
                  style: textTheme.bodySmall!.copyWith(
                    color: kGry800,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                YBox(kLargePadding),
                Container(
                  height: 40,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          emailBorderColor = kGry450;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 10,
                      ),
                      hintText: 'Enter Your Email Address',
                      hintStyle: textTheme.bodySmall!.copyWith(
                        color: kgry700,
                        fontSize: 13,
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
                YBox(kMacroPadding),
                SizedBox(
                  height: 38,
                  width: 300,
                  child: TextButton(
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
                            sendCode,
                            style: textTheme.titleSmall!.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                ),
                YBox(kMacroPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember Password ? ',
                      style: textTheme.bodySmall!.copyWith(
                        color: kGry800,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          signInRoute,
                        );
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: kTransparent,
                        ),
                        child: Text(
                          'Sign In Here',
                          style: textTheme.bodySmall!.copyWith(
                            color: kDarkYellow,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
