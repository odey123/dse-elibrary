import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_for_empty_field.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/dialogs/onboarding_success_dialog.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/function/function_exception.dart';
import 'package:systems_app/services/cloud/function/functions_actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';
import 'package:systems_app/utils/text_field_comp.dart';

class AddHod extends ConsumerStatefulWidget {
  const AddHod({super.key});

  @override
  ConsumerState<AddHod> createState() => _AddHodState();
}

class _AddHodState extends ConsumerState<AddHod> {
  late final AuthenticationAsyncNotifier _auth;
  late final FunctionsAsyncNotifier _function;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefix;
  late final TextEditingController _gender;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _email;
  late final TextEditingController _levelCourseAdvisor;
  bool _isLoading = false;
  bool _showSignOut = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _function = ref.read(functionsAsyncNotifierProvider.notifier);
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _prefix = TextEditingController();
    _gender = TextEditingController();
    _prefferedAcademicName = TextEditingController();
    _email = TextEditingController();
    _levelCourseAdvisor = TextEditingController();
    super.initState();
  }

  void _undoController() {
    _firstName.clear();
    _lastName.clear();
    _levelCourseAdvisor.clear();
    _prefferedAcademicName.clear();
    _prefix.clear();
    _gender.clear();
    _email.clear();
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      backgroundColor: kGry400,
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              (isPhoneWeb)
                  ? Container()
                  : Container(
                      color: kPrimaryWhite,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kLargePadding,
                          vertical: kPadding,
                        ),
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    right: kMediumPadding,
                                    top: kSmallPadding,
                                    bottom: kSmallPadding,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: kTransparent,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 14,
                                        height: 15,
                                        child: SvgPicture.asset(
                                          AssetPaths.arrowBack,
                                        ),
                                      ),
                                      XBox(kSmallPadding),
                                      Transform.translate(
                                        offset: const Offset(0, 1),
                                        child: Text(
                                          back,
                                          style:
                                              textTheme.titleMedium!.copyWith(
                                            fontSize: 13,
                                            color: kGry800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 24,
                                    width: 24,
                                    decoration: const BoxDecoration(),
                                    child: const Icon(
                                      Icons.notifications_none,
                                      weight: 100,
                                      color: kBlack800,
                                    ),
                                  ),
                                  XBox(kRegularPadding),
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                      color: kOrange500,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  XBox(kRegularPadding),
                                  InkWell(
                                    overlayColor: const WidgetStatePropertyAll(
                                        kTransparent),
                                    hoverColor: kTransparent,
                                    onTap: () {
                                      setState(() {
                                        _showSignOut = !_showSignOut;
                                      });
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        AssetPaths.avatar,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kRegularPadding,
                    ),
                    child: Column(
                      children: [
                        YBox(kMacroPadding),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kMacroPadding,
                            vertical: kMediumPadding - 3,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryWhite,
                            border: Border.all(color: kGry500),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                addALecturer,
                                style: textTheme.titleMedium!.copyWith(
                                  fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                lecturers,
                                style: textTheme.titleMedium!.copyWith(
                                  fontSize: (!kIsWeb || isPhoneWeb) ? 11 : 9,
                                  fontWeight: FontWeight.w400,
                                  color: kGry600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        YBox(kMacroPadding),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kMacroPadding,
                            vertical: kMacroPadding,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryWhite,
                            border: Border.all(color: kGry500),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                basicInfo,
                                style: textTheme.titleMedium!.copyWith(
                                  fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: kBlack,
                                ),
                              ),
                              YBox(kMacroPadding),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 0.5,
                                      decoration: BoxDecoration(
                                          color: kGry500.withOpacity(0.8)),
                                    ),
                                  ),
                                ],
                              ),
                              YBox(kMacroPadding),
                              Row(
                                children: [
                                  CustomTextInputField(
                                    label: firstName,
                                    hintText: enterFirstName,
                                    controller: _firstName,
                                  ),
                                  XBox(kFullPadding),
                                  CustomDropdownField(
                                    label: levelCourseAdvisor,
                                    hintText: selectLevel,
                                    items: levels,
                                    controller: _levelCourseAdvisor,
                                    dropdownColor: kPrimaryWhite,
                                    dropdownIcon: Icons.keyboard_arrow_down,
                                  ),
                                ],
                              ),
                              YBox(kMacroPadding),
                              CustomTextInputField(
                                label: lastName,
                                hintText: enterLastName,
                                controller: _lastName,
                              ),
                              YBox(kMacroPadding),
                              CustomDropdownField(
                                label: gender,
                                hintText: selectGender,
                                items: genders,
                                controller: _gender,
                                dropdownColor: kPrimaryWhite,
                                dropdownIcon: Icons.keyboard_arrow_down,
                              ),
                              YBox(kMacroPadding),
                              CustomDropdownField(
                                label: prefix,
                                hintText: selectPrefix,
                                items: prefixs,
                                controller: _prefix,
                                dropdownColor: kPrimaryWhite,
                                dropdownIcon: Icons.keyboard_arrow_down,
                              ),
                              YBox(kMacroPadding),
                              CustomTextInputField(
                                label: preferredAcademicName,
                                hintText: enterPreferredAcademicName,
                                controller: _prefferedAcademicName,
                              ),
                              YBox(kMacroPadding),
                              CustomTextInputField(
                                label: emailAddress,
                                hintText: enterEmailAddress,
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              YBox(kLargePadding),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 0.5,
                                      decoration: BoxDecoration(
                                          color: kGry500.withOpacity(0.8)),
                                    ),
                                  ),
                                ],
                              ),
                              YBox(kMacroPadding),
                              Row(
                                children: [
                                  CustomTextButton(
                                    text: submit,
                                    onPressed: () async {
                                      final firstName = _firstName.text;
                                      final lastName = _lastName.text;
                                      final level = _levelCourseAdvisor.text;
                                      final email = _email.text;
                                      final gender = _gender.text;
                                      final preferredName =
                                          _prefferedAcademicName.text;
                                      final prefix = _prefix.text;
                                      if (firstName.isEmpty ||
                                          lastName.isEmpty ||
                                          level.isEmpty ||
                                          email.isEmpty ||
                                          gender.isEmpty ||
                                          preferredName.isEmpty ||
                                          prefix.isEmpty) {
                                        CustomSnackBarForEmptyField.show(
                                          mainContext,
                                          'Field must not be empty',
                                          40,
                                        );
                                      } else {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        LoadingScreen().show(
                                            context: mainContext,
                                            showProgress: false);
                                        try {
                                          final currentUser = _auth.currentUser;
                                          log('$currentUser');
                                          await _function.onboardHod(
                                            firstName: firstName,
                                            lastName: lastName,
                                            email: email,
                                            gender: gender,
                                            levelCourseAdvisor: level,
                                            preferredAcademicName:
                                                preferredName,
                                            prefix: prefix,
                                            adminUId: currentUser!.uid,
                                          );
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          LoadingScreen().hide();
                                          _undoController();
                                          await showOnboardingSuccessDialog(
                                            context: mainContext,
                                            name: firstName,
                                            placeholder: userString,
                                            buttonText: addStudent,
                                          );
                                        } on Exception catch (e) {
                                          if (mounted) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            LoadingScreen().hide();
                                            if (e
                                                is UnAuthenticatedFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text: 'User must be signed in.',
                                              );
                                            } else if (e
                                                is PermissionDeniedFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text:
                                                    'You do not have permission to onboard HOD.',
                                              );
                                            } else if (e
                                                is InvalidArgumentFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text:
                                                    'Invalid or missing input fields.',
                                              );
                                            } else if (e
                                                is AlreadyExistsFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text:
                                                    'HOD has already been onboarded.',
                                              );
                                            } else if (e
                                                is FailedPreconditionFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text:
                                                    'Email/password authentication is disabled.',
                                              );
                                            } else if (e
                                                is WeakPasswordFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text:
                                                    'The password is too weak.',
                                              );
                                            } else if (e
                                                is DeadlineExceededFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text:
                                                    'The request took too long, please try again.',
                                              );
                                            } else if (e
                                                is ResourceExhaustedFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text:
                                                    'Too many requests, please try later.',
                                              );
                                            } else if (e
                                                is GenericFunctionException) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text: 'Please try again later.',
                                              );
                                            }
                                          }
                                        }
                                      }
                                    },
                                    isLoading: _isLoading,
                                    backgroundColor: kDarkYellow,
                                    textColor: kPrimaryWhite,
                                    borderColor: kTransparent,
                                    padding: const EdgeInsets.only(
                                      left: kMacroPadding - 3,
                                      right: kMacroPadding,
                                      top: kRegularPadding + 4,
                                      bottom: kRegularPadding + 1,
                                    ),
                                  ),
                                  XBox(kMacroPadding),
                                  CustomTextButton(
                                    text: cancel,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    isLoading: false,
                                    backgroundColor: kRed.withOpacity(0.25),
                                    textColor: kRed,
                                    borderColor: kTransparent,
                                    padding: const EdgeInsets.only(
                                      left: kMacroPadding - 3,
                                      right: kMacroPadding,
                                      top: kRegularPadding + 4,
                                      bottom: kRegularPadding + 1,
                                    ),
                                  ),
                                ],
                              ),
                              YBox(kMediumPadding),
                            ],
                          ),
                        ),
                        YBox(kFullPadding),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _showSignOut
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: kFullPadding,
                    right: kRegularPadding,
                  ),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: kPrimaryWhite,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        border: Border.all(
                          color: kGry500,
                          width: 0.5,
                        )),
                    padding: const EdgeInsets.symmetric(
                      vertical: kSmallPadding,
                      horizontal: kSmallPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 27,
                          width: 27,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            AssetPaths.avatar,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: kMediumPadding),
                          child: Text(
                            '${SessionManager.getLastName()} ${SessionManager.getFirstName()}',
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: 13,
                              color: kBlack,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: kSmallPadding, bottom: kPadding),
                          child: Text(
                            SessionManager.getEmail() ?? '',
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: 13,
                              color: kBlack,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: kSmallPadding, bottom: kPadding),
                          child: Container(
                            height: 1,
                            decoration: const BoxDecoration(
                              color: kGry600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            LoadingScreen()
                                .show(context: context, showProgress: true);
                            await _auth.logOut();
                            LoadingScreen().hide();
                            Navigator.of(context, rootNavigator: true)
                                .pushNamedAndRemoveUntil(
                              signInRoute,
                              (route) => false,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: kSmallPadding, bottom: kPadding),
                            child: Row(
                              children: [
                                SvgPicture.asset(AssetPaths.logoutIcon),
                                XBox(kPadding),
                                Text(
                                  logout,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: 13,
                                    color: kBlack,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: kSmallPadding,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(AssetPaths.profileIcon),
                                XBox(kPadding),
                                Text(
                                  pROfile,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: 13,
                                    color: kBlack,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
