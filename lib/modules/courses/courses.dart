import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_for_empty_field.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/my_courses/add_course.dart';
import 'package:systems_app/modules/reuseables/course_card.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/course_details.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/cloud_profile.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/model/course.dart';
import 'package:systems_app/services/cloud/storage/storage.actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';
import 'package:systems_app/utils/text_field_comp.dart';

class Courses extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const Courses({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<Courses> createState() => _CoursesState();
}

class _CoursesState extends ConsumerState<Courses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  late final StorageAsyncNotifier _storage;
  final TextEditingController _searchTextField = TextEditingController();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _prefix;
  late final TextEditingController _levelCourseAdvisor;
  late final TextEditingController _currentLevel;
  late final TextEditingController _email;
  bool _isProfileEditLoading = false;
  bool _showSignOut = false;

  @override
  void initState() {
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _storage = ref.read(storageAsyncNotifierProvider.notifier);
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

  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context)?.settings.arguments as CloudProfile;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kRegularPadding,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    hoverColor: kTransparent,
                    onTap: () {
                      pickImage(
                        context: context,
                        storage: _storage,
                        database: _database,
                        auth: _auth,
                        mounted: mounted,
                      );
                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: kRegularPadding),
                            child: Container(
                              width: 93,
                              height: 93,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ProfileImage(
                                imageUrl:
                                    SessionManager.getProfileImageUrl() ?? '',
                                radius: 46.5,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: kRegularPadding + 64,
                                left: 50,
                              ),
                              child: SvgPicture.asset(
                                AssetPaths.profileEditIcon,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  YBox(kSmallPadding),
                  CustomTextInputField(
                    label: firstName,
                    hintText: enterFirstName,
                    controller: _firstName,
                  ),
                  YBox(kSmallPadding),
                  CustomTextInputField(
                    label: lastName,
                    hintText: enterLastName,
                    controller: _lastName,
                  ),
                  YBox(kSmallPadding),
                  SessionManager.getRole() == lecturerRole
                      ? CustomTextInputField(
                          label: preferredAcademicName,
                          hintText: enterPreferredAcademicName,
                          controller: _prefferedAcademicName,
                        )
                      : Container(),
                  YBox(kSmallPadding),
                  CustomTextInputField(
                    label: SessionManager.getRole() == lecturerRole
                        ? lecturerEmailAddress
                        : studentEmailAddress,
                    hintText: SessionManager.getRole() == lecturerRole
                        ? enterLecturerEmailAddress
                        : enterStudentEmailAddress,
                    controller: _email,
                    isReadOnly: true,
                    textColor: kGry600,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  YBox(kSmallPadding),
                  SessionManager.getRole() == lecturerRole
                      ? CustomDropdownField(
                          label: levelCourseAdvisor,
                          hintText: selectLevel,
                          items: levels,
                          controller: _levelCourseAdvisor,
                          isReadOnly: true,
                          textColor: kGry600,
                          iconColor: kGry600,
                          dropdownColor: kPrimaryWhite,
                          dropdownIcon: Icons.keyboard_arrow_down,
                        )
                      : CustomDropdownField(
                          label: currentLevel,
                          hintText: selectLevel,
                          items: levels,
                          controller: _currentLevel,
                          isReadOnly: true,
                          textColor: kGry600,
                          iconColor: kGry600,
                          dropdownColor: kPrimaryWhite,
                          dropdownIcon: Icons.keyboard_arrow_down,
                        ),
                  YBox(kSmallPadding),
                  SessionManager.getRole() == lecturerRole
                      ? CustomDropdownField(
                          label: prefix,
                          hintText: selectPrefix,
                          items: prefixs,
                          controller: _prefix,
                          dropdownColor: kPrimaryWhite,
                          dropdownIcon: Icons.keyboard_arrow_down,
                        )
                      : Container(),
                  YBox(kSmallPadding),
                  CustomTextButton(
                    text: submit,
                    onPressed: () async {
                      if (SessionManager.getRole() == lecturerRole) {
                        final firstName = _firstName.text;
                        final lastName = _lastName.text;
                        final preferredAcademicName =
                            _prefferedAcademicName.text;
                        final prefix = _prefix.text;
                        if (firstName.isEmpty ||
                            lastName.isEmpty ||
                            preferredAcademicName.isEmpty ||
                            prefix.isEmpty) {
                          CustomSnackBarForEmptyField.show(
                            context,
                            'Field must not be empty',
                            40,
                          );
                        } else {
                          setState(() {
                            _isProfileEditLoading = true;
                          });
                          LoadingScreen()
                              .show(context: context, showProgress: false);
                          try {
                            await _database.editLecturerProfile(
                              userId: _auth.currentUser!.uid,
                              firstName: firstName,
                              lastName: lastName,
                              preferredAcademicName: preferredAcademicName,
                              prefix: prefix,
                            );
                            SessionManager.setFirstName(firstName);
                            SessionManager.setLastName(lastName);
                            SessionManager.setPreferredAcademicName(
                                preferredAcademicName);
                            SessionManager.setPrefix(prefix);
                            setState(() {
                              _isProfileEditLoading = false;
                            });
                            LoadingScreen().hide();
                          } on Exception {
                            setState(() {
                              _isProfileEditLoading = false;
                            });
                            LoadingScreen().hide();
                            if (mounted) {
                              await showErrorDialog(
                                context: context,
                                text: 'Please try again later.',
                              );
                            }
                          }
                        }
                      } else {
                        final firstName = _firstName.text;
                        final lastName = _lastName.text;
                        if (firstName.isEmpty || lastName.isEmpty) {
                          CustomSnackBarForEmptyField.show(
                            context,
                            'Field must not be empty',
                            40,
                          );
                        } else {
                          setState(() {
                            _isProfileEditLoading = true;
                          });
                          LoadingScreen()
                              .show(context: context, showProgress: false);
                          try {
                            await _database.editStudentProfile(
                              userId: _auth.currentUser!.uid,
                              firstName: firstName,
                              lastName: lastName,
                            );
                            SessionManager.setFirstName(firstName);
                            SessionManager.setLastName(lastName);
                            setState(() {
                              _isProfileEditLoading = false;
                            });
                            LoadingScreen().hide();
                          } on Exception {
                            setState(() {
                              _isProfileEditLoading = false;
                            });
                            LoadingScreen().hide();
                            if (mounted) {
                              await showErrorDialog(
                                context: context,
                                text: 'Please try again later.',
                              );
                            }
                          }
                        }
                      }
                    },
                    isLoading: _isProfileEditLoading,
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
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                (isPhoneWeb)
                    ? Container()
                    : Padding(
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
                                        height: 16,
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
                                            fontSize: 14,
                                            color: kGry800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              XBox(kLargePadding + kSmallPadding),
                              Container(
                                width: screenSize.width * 0.37,
                                height: 34,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  color: kPrimaryWhite,
                                  border: Border.all(
                                    color: kGry800,
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchTextField,
                                  keyboardType: TextInputType.text,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search books articles and more.....',
                                    hintStyle: textTheme.titleMedium!.copyWith(
                                      fontSize: 13,
                                      color: kGry800,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      bottom: kPadding * 2.5,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                        AssetPaths.searchIcon,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  cursorColor: kBlack,
                                ),
                              ),
                              XBox(kPadding),
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
                YBox(kRegularPadding),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (!kIsWeb || isPhoneWeb)
                            ? YBox(kMediumPadding)
                            : Container(),
                        (!kIsWeb || isPhoneWeb)
                            ? InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: kMediumPadding,
                                  ),
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
                                ),
                              )
                            : Container(),
                        (!kIsWeb || isPhoneWeb)
                            ? YBox(kMediumPadding)
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kSmallPadding,
                          ),
                          child: Text(
                            firstSemester,
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 18 : 16,
                              color: kBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kRegularPadding,
                              vertical: kPadding,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  StreamBuilder(
                                    stream: _database.getAllCoursesPerSemester(
                                      level: profile.level,
                                      semester: first,
                                    ),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                          if (snapshot.hasData) {
                                            final courses =
                                                snapshot.data as List<Course>;
                                            if (courses.isEmpty) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: kFullPadding,
                                                ),
                                                child: Text(
                                                  'No course available for this semester',
                                                  style: textTheme.bodyMedium!
                                                      .copyWith(
                                                    color: kBlack,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              );
                                            }
                                            return Wrap(
                                              spacing: kSmallPadding,
                                              runSpacing: kPadding,
                                              children: List.generate(
                                                courses.length,
                                                (index) {
                                                  return CourseCard(
                                                    title: courses[index]
                                                        .courseName,
                                                    units: courses[index].unit,
                                                    coordinatorName:
                                                        courses[index]
                                                            .ownerName,
                                                    avatarPath: courses[index]
                                                        .profileImageUrl,
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            CourseDetailScreen(
                                                          course:
                                                              courses[index],
                                                          userUid: _auth
                                                              .currentUser!.uid,
                                                        ),
                                                      ));
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            return Wrap(
                                              spacing: kSmallPadding,
                                              runSpacing: kPadding,
                                              children: List.generate(
                                                7,
                                                (index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right:
                                                                kSmallPadding),
                                                    child: Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[200]!,
                                                      highlightColor:
                                                          Colors.grey[50]!,
                                                      child: Container(
                                                        height: 130,
                                                        width: 250,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        default:
                                          return Wrap(
                                            spacing: kSmallPadding,
                                            runSpacing: kPadding,
                                            children: List.generate(
                                              7,
                                              (index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: kSmallPadding),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[200]!,
                                                    highlightColor:
                                                        Colors.grey[50]!,
                                                    child: Container(
                                                      height: 130,
                                                      width: 250,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        YBox(kMediumPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kSmallPadding,
                          ),
                          child: Text(
                            secondSemester,
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 18 : 16,
                              color: kBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kRegularPadding,
                              vertical: kPadding,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  StreamBuilder(
                                    stream: _database.getAllCoursesPerSemester(
                                      level: profile.level,
                                      semester: second,
                                    ),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                          if (snapshot.hasData) {
                                            final courses =
                                                snapshot.data as List<Course>;
                                            if (courses.isEmpty) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: kFullPadding,
                                                ),
                                                child: Text(
                                                  'No course available for this semester',
                                                  style: textTheme.bodyMedium!
                                                      .copyWith(
                                                    color: kBlack,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              );
                                            }
                                            return Wrap(
                                              spacing: kSmallPadding,
                                              runSpacing: kPadding,
                                              children: List.generate(
                                                courses.length,
                                                (index) {
                                                  return CourseCard(
                                                    title: courses[index]
                                                        .courseName,
                                                    units: courses[index].unit,
                                                    coordinatorName:
                                                        courses[index]
                                                            .ownerName,
                                                    avatarPath: courses[index]
                                                        .profileImageUrl,
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            CourseDetailScreen(
                                                          course:
                                                              courses[index],
                                                          userUid: _auth
                                                              .currentUser!.uid,
                                                        ),
                                                      ));
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            return Wrap(
                                              spacing: kSmallPadding,
                                              runSpacing: kPadding,
                                              children: List.generate(
                                                7,
                                                (index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right:
                                                                kSmallPadding),
                                                    child: Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[200]!,
                                                      highlightColor:
                                                          Colors.grey[50]!,
                                                      child: Container(
                                                        height: 130,
                                                        width: 250,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        default:
                                          return Wrap(
                                            spacing: kSmallPadding,
                                            runSpacing: kPadding,
                                            children: List.generate(
                                              7,
                                              (index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: kSmallPadding),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[200]!,
                                                    highlightColor:
                                                        Colors.grey[50]!,
                                                    child: Container(
                                                      height: 130,
                                                      width: 250,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        YBox(kMediumPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomTextButton(
                              text: addNew,
                              icon: Icons.add,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AddCourse(),
                                ));
                              },
                              isLoading: false,
                              backgroundColor: kDarkYellow.withOpacity(
                                0.1,
                              ),
                              textColor: kDarkYellow,
                              borderColor: kDarkYellow,
                              padding: EdgeInsets.only(
                                left: (!kIsWeb || isPhoneWeb)
                                    ? kMediumPadding
                                    : kFullPadding,
                                right: (!kIsWeb || isPhoneWeb)
                                    ? kMediumPadding
                                    : kFullPadding,
                                bottom: (!kIsWeb || isPhoneWeb)
                                    ? kSmallPadding
                                    : kRegularPadding + 2,
                                top: (!kIsWeb || isPhoneWeb)
                                    ? kSmallPadding
                                    : kRegularPadding + 2,
                              ),
                            ),
                          ),
                        ),
                        YBox(kLargePadding),
                      ],
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
