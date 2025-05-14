import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/app/function/handle_profile_submit.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/my_courses/add_course.dart';
import 'package:systems_app/modules/reuseables/profile_drawer.dart';
import 'package:systems_app/modules/shared/course_details.dart';
import 'package:systems_app/modules/reuseables/course_card.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
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

class MyCourses extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const MyCourses({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends ConsumerState<MyCourses> {
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
  bool _showSignOut = false;
  bool _isProfileEditLoading = false;

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
                (!kIsWeb || isPhoneWeb)
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
                                  Container(
                                    height: 28,
                                    width: 28,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: StreamBuilder(
                                      stream: _database.getUserProfile(
                                        ownerUserId: _auth.currentUser!.uid,
                                        role: SessionManager.getRole() ?? '',
                                      ),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                          case ConnectionState.active:
                                            if (snapshot.hasData) {
                                              final profile =
                                                  snapshot.data as CloudProfile;
                                              return ProfileImage(
                                                imageUrl:
                                                    profile.profileImageUrl,
                                                radius: 14,
                                                onTap: () {
                                                  setState(() {
                                                    _showSignOut =
                                                        !_showSignOut;
                                                  });
                                                },
                                              );
                                            } else {
                                              return ProfileImage(
                                                imageUrl: '',
                                                radius: 14,
                                                onTap: () {
                                                  setState(() {
                                                    _showSignOut =
                                                        !_showSignOut;
                                                  });
                                                },
                                              );
                                            }
                                          default:
                                            return ProfileImage(
                                              imageUrl: '',
                                              radius: 14,
                                              onTap: () {
                                                setState(() {
                                                  _showSignOut = !_showSignOut;
                                                });
                                              },
                                            );
                                        }
                                      },
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
                                  navigatorKey.currentState?.pop();
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
                                    stream: _database.getLecturerCourses(
                                      ownerUid: _auth.currentUser!.uid,
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
                                                      (!kIsWeb || isPhoneWeb)
                                                          ? navigatorKey
                                                              .currentState!
                                                              .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CourseDetailScreen(
                                                                  course:
                                                                      courses[
                                                                          index],
                                                                  userUid: _auth
                                                                      .currentUser!
                                                                      .uid,
                                                                ),
                                                              ),
                                                            )
                                                          : widget
                                                              .navigatorKeyForDesktopWeb!
                                                              .currentState!
                                                              .push(
                                                                  MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CourseDetailScreen(
                                                                course: courses[
                                                                    index],
                                                                userUid: _auth
                                                                    .currentUser!
                                                                    .uid,
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
                                    stream: _database.getLecturerCourses(
                                      ownerUid: _auth.currentUser!.uid,
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
                                                      (!kIsWeb || isPhoneWeb)
                                                          ? navigatorKey
                                                              .currentState!
                                                              .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CourseDetailScreen(
                                                                  course:
                                                                      courses[
                                                                          index],
                                                                  userUid: _auth
                                                                      .currentUser!
                                                                      .uid,
                                                                ),
                                                              ),
                                                            )
                                                          : widget
                                                              .navigatorKeyForDesktopWeb!
                                                              .currentState!
                                                              .push(
                                                                  MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CourseDetailScreen(
                                                                course: courses[
                                                                    index],
                                                                userUid: _auth
                                                                    .currentUser!
                                                                    .uid,
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
                                (!kIsWeb || isPhoneWeb)
                                    ? navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                        builder: (context) => const AddCourse(),
                                      ))
                                    : widget.navigatorKeyForDesktopWeb!
                                        .currentState!
                                        .push(MaterialPageRoute(
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
