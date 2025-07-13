import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_for_empty_field.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/dialogs/onboarding_success_dialog.dart';
import 'package:systems_app/app/function/handle_profile_submit.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/profile_drawer.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/function/function_exception.dart';
import 'package:systems_app/services/cloud/function/functions_actions.dart';
import 'package:systems_app/services/cloud/storage/storage.actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';
import 'package:systems_app/utils/text_field_comp.dart';

class AddCourse extends ConsumerStatefulWidget {
  const AddCourse({
    super.key,
  });

  @override
  ConsumerState<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends ConsumerState<AddCourse> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AuthenticationAsyncNotifier _auth;
  late final DatabaseAsyncNotifier _database;
  late final FunctionsAsyncNotifier _function;
  late final StorageAsyncNotifier _storage;
  late final TextEditingController _courseName;
  late final TextEditingController _courseCode;
  late final TextEditingController _numOfUnit;
  late final TextEditingController _semester;
  late final TextEditingController _level;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _prefix;
  late final TextEditingController _levelCourseAdvisor;
  late final TextEditingController _currentLevel;
  late final TextEditingController _email;
  bool _isLoading = false;
  bool _isProfileEditLoading = false;
  bool _showSignOut = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _function = ref.read(functionsAsyncNotifierProvider.notifier);
    _storage = ref.read(storageAsyncNotifierProvider.notifier);
    _courseName = TextEditingController();
    _courseCode = TextEditingController();
    _numOfUnit = TextEditingController();
    _semester = TextEditingController();
    _level = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _prefferedAcademicName = TextEditingController();
    _prefix = TextEditingController();
    _levelCourseAdvisor = TextEditingController();
    _currentLevel = TextEditingController();
    _email = TextEditingController();
    setControllerText();
    super.initState();
  }

  void openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void setControllerText() {
    _firstName.text = SessionManager.getFirstName() ?? '';
    _lastName.text = SessionManager.getLastName() ?? '';
    _prefferedAcademicName.text =
        SessionManager.getPreferredAcademicName() ?? '';
    _prefix.text = SessionManager.getPrefix() ?? '';
    _levelCourseAdvisor.text = SessionManager.getLevelCourseAdvisor() ?? '';
    _currentLevel.text = SessionManager.getLevel() ?? '';
    _email.text = SessionManager.getEmail() ?? '';
  }

  void _undoController() {
    _courseName.clear();
    _courseCode.clear();
    _numOfUnit.clear();
    _semester.clear();
    _level.clear();
  }

  @override
  Widget build(BuildContext mainContext) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!kIsWeb || isPhoneWeb) {
          if (!didPop) {
            navigatorKey.currentState?.pop();
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kGry400,
        endDrawer: ProfileDrawer(
          firstNameController: _firstName,
          lastNameController: _lastName,
          emailController: _email,
          levelController: SessionManager.getRole() == lecturerRole
              ? _levelCourseAdvisor
              : _currentLevel,
          prefixController: _prefix,
          preferredAcademicNameController: _prefferedAcademicName,
          profileStream: _database.getUserProfile(
            ownerUserId: _auth.currentUser!.uid,
            role: SessionManager.getRole() ?? '',
          ),
          onSubmit: () async {
            await handleProfileSubmit(
              context: context,
              isLecturer: SessionManager.getRole() == lecturerRole,
              firstNameController: _firstName,
              lastNameController: _lastName,
              preferredAcademicNameController: _prefferedAcademicName,
              prefixController: _prefix,
              auth: _auth,
              database: _database,
              onLoadingStart: () =>
                  setState(() => _isProfileEditLoading = true),
              onLoadingEnd: () => setState(() => _isProfileEditLoading = false),
              mounted: mounted,
            );
          },
          onImageTap: () => pickImage(
            context: context,
            storage: _storage,
            database: _database,
            auth: _auth,
            mounted: mounted,
          ),
          isLecturer: SessionManager.getRole() == lecturerRole,
          isLoading: _isProfileEditLoading,
        ),
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
                            horizontal: kMediumPadding,
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
                                        const Icon(
                                          Icons.arrow_back_ios,
                                          color: kBlack,
                                          size: 16,
                                        ),
                                        XBox(kPadding),
                                        Transform.translate(
                                          offset: const Offset(0, 1),
                                          child: Text(
                                            'Back',
                                            style:
                                                textTheme.titleMedium!.copyWith(
                                              fontSize: 13,
                                              color: kBlack,
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
                                      height: 25,
                                      width: 25,
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: kLightSkyeBlue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        AssetPaths.notificationIcon,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    XBox(kRegularPadding),
                                    Container(
                                      height: 25,
                                      width: 1,
                                      decoration:
                                          const BoxDecoration(color: kLightAsh),
                                    ),
                                    XBox(kRegularPadding),
                                    InkWell(
                                      overlayColor:
                                          const WidgetStatePropertyAll(
                                              kTransparent),
                                      hoverColor: kTransparent,
                                      onTap: () {
                                        setState(() {
                                          _showSignOut = !_showSignOut;
                                        });
                                      },
                                      child: Container(
                                        height: 26,
                                        width: 26,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: ProfileImage(
                                          imageUrl: SessionManager
                                                  .getProfileImageUrl() ??
                                              '',
                                          radius: 14,
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
                          (!kIsWeb || isPhoneWeb)
                              ? YBox(kMacroPadding)
                              : Container(
                                  height: kMacroPadding,
                                ),
                          (!kIsWeb || isPhoneWeb)
                              ? InkWell(
                                  onTap: () {
                                    navigatorKey.currentState?.pop();
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
                                          width: 18,
                                          height: 20,
                                          child: SvgPicture.asset(
                                            AssetPaths.arrowBack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          (!kIsWeb || isPhoneWeb)
                              ? YBox(kPadding)
                              : Container(),
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
                                  addACourse,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Text(
                                  courses,
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
                                  courseInfo,
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
                                CustomTextInputField(
                                  label: courseName,
                                  hintText: enterCourseName,
                                  controller: _courseName,
                                ),
                                YBox(kMacroPadding),
                                CustomTextInputField(
                                  label: courseCode,
                                  hintText: enterCourseCode,
                                  controller: _courseCode,
                                ),
                                YBox(kMacroPadding),
                                CustomTextInputField(
                                  label: courseUnit,
                                  hintText: enterCourseUnits,
                                  controller: _numOfUnit,
                                  keyboardType: TextInputType.number,
                                ),
                                YBox(kMacroPadding),
                                CustomDropdownField(
                                  label: semester,
                                  hintText: selectSemester,
                                  items: semesters,
                                  controller: _semester,
                                  dropdownColor: kPrimaryWhite,
                                  dropdownIcon: Icons.keyboard_arrow_down,
                                ),
                                YBox(kMacroPadding),
                                CustomDropdownField(
                                  label: courseLevel,
                                  hintText: selectLevel,
                                  items: levels,
                                  controller: _level,
                                  dropdownColor: kPrimaryWhite,
                                  dropdownIcon: Icons.keyboard_arrow_down,
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
                                    CustomTextButton(
                                      text: submit,
                                      onPressed: () async {
                                        final courseName = _courseName.text;
                                        final courseCode = _courseCode.text;
                                        final units = _numOfUnit.text;
                                        final level = _level.text;
                                        final semester = _semester.text;

                                        if (courseName.isEmpty ||
                                            courseCode.isEmpty ||
                                            units.isEmpty ||
                                            level.isEmpty ||
                                            semester.isEmpty) {
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
                                            final profile = await _database
                                                .getUserProfile(
                                                  ownerUserId:
                                                      _auth.currentUser!.uid,
                                                  role: lecturerRole,
                                                )
                                                .first;
                                            final currentUser =
                                                _auth.currentUser;

                                            await _function.addCourse(
                                              courseName: courseName,
                                              courseCode: courseCode,
                                              unit: units,
                                              level: level,
                                              semester: semester,
                                              ownerName:
                                                  profile.preferredAcademicName,
                                              ownerUid: currentUser!.uid,
                                            );
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            LoadingScreen().hide();
                                            _undoController();
                                            await showOnboardingSuccessDialog(
                                              context: mainContext,
                                              name: courseCode,
                                              buttonText: addCourse,
                                              placeholder: course,
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
                                                  text:
                                                      'User must be signed in.',
                                                );
                                              } else if (e
                                                  is PermissionDeniedFunctionException) {
                                                showErrorDialog(
                                                  context: mainContext,
                                                  text:
                                                      'You do not have permission to add a course.',
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
                                                      'Course has already been added.',
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
                                                  text:
                                                      'Please try again later.',
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
                                      padding: EdgeInsets.only(
                                        left: kMacroPadding - 3,
                                        right: kMacroPadding,
                                        top: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 4
                                            : kRegularPadding + 4,
                                        bottom: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 1
                                            : kRegularPadding + 1,
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
                                      padding: EdgeInsets.only(
                                        left: kMacroPadding - 3,
                                        right: kMacroPadding,
                                        top: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 4
                                            : kRegularPadding + 4,
                                        bottom: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 1
                                            : kRegularPadding + 1,
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
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ProfileImage(
                              imageUrl:
                                  SessionManager.getProfileImageUrl() ?? '',
                              radius: 14,
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
                            onTap: () {
                              openEndDrawer();
                              setState(() {
                                _showSignOut = !_showSignOut;
                              });
                            },
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
      ),
    );
  }
}
