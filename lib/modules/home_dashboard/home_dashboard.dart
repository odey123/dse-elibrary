import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/app/function/handle_profile_submit.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/app/navigator/navigator.dart';
import 'package:systems_app/modules/reuseables/profile_drawer.dart';
import 'package:systems_app/modules/shared/course_details.dart';
import 'package:systems_app/modules/reuseables/course_card.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/reuseables/tab_item.dart';
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

class HomeDashboard extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const HomeDashboard({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends ConsumerState<HomeDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchTextField = TextEditingController();
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  late final StorageAsyncNotifier _storage;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _prefix;
  late final TextEditingController _levelCourseAdvisor;
  late final TextEditingController _currentLevel;
  late final TextEditingController _email;
  String tabSelected = dashboard;
  bool _isLoading = false;
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
  Widget build(BuildContext mainContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: (!kIsWeb || isPhoneWeb)
          ? AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        AssetPaths.searchIcon,
                        fit: BoxFit.scaleDown,
                        color: kBlack,
                      ),
                    ),
                    XBox(kSmallPadding),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: Text(
                          '${SessionManager.getFirstName()}.${SessionManager.getLastName()![0]}',
                          style: textTheme.titleSmall!.copyWith(
                            fontSize: 16,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kSmallPadding),
                      child: ProfileImage(
                        imageUrl: SessionManager.getProfileImageUrl() ?? '',
                        radius: 13,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : null,
      drawer: (!kIsWeb || isPhoneWeb)
          ? Drawer(
              width: screenSize.width * 0.8,
              shape: const Border(),
              child: Container(
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (!kIsWeb || isPhoneWeb)
                        ? YBox(kLargePadding + kSmallPadding)
                        : YBox(kMacroPadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kRegularPadding,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: (!kIsWeb || isPhoneWeb) ? 50 : 40,
                            width: (!kIsWeb || isPhoneWeb) ? 50 : 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryWhite,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                AssetPaths.departmentLogo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          XBox(kSmallPadding),
                          Transform.translate(
                            offset: const Offset(0, 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Systems',
                                  style: textTheme.headlineMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 18,
                                  ),
                                ),
                                YBox(kPadding),
                                Text(
                                  'Engineering',
                                  style: textTheme.headlineMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    YBox(kRegularPadding),
                    Container(
                      height: 1,
                      width: (!kIsWeb || isPhoneWeb) ? null : 200,
                      decoration: const BoxDecoration(color: kPrimaryWhite),
                    ),
                    YBox(kRegularPadding),
                    TabItem(
                      label: dashboard,
                      iconPath: AssetPaths.homeIcon,
                      selectedTab: tabSelected,
                      unselectedtextColor: kPrimaryWhite,
                      currentTab: dashboard,
                      onTap: (tab) {
                        navigateTo(
                          homeDashboardRoute,
                          navigatorKey,
                        );
                        setState(() {
                          tabSelected = tab;
                        });
                      },
                    ),
                    TabItem(
                      label: myCourses,
                      iconPath: AssetPaths.homeIcon,
                      selectedTab: tabSelected,
                      currentTab: myCourses,
                      unselectedtextColor: kPrimaryWhite,
                      onTap: (tab) {
                        navigateTo(
                          myCoursesRoute,
                          navigatorKey,
                        );
                        setState(() {
                          tabSelected = tab;
                        });
                      },
                    ),
                    TabItem(
                      label: allCourses,
                      iconPath: AssetPaths.homeIcon,
                      selectedTab: tabSelected,
                      currentTab: allCourses,
                      unselectedtextColor: kPrimaryWhite,
                      onTap: (tab) {
                        navigateTo(
                          allCoursesRoute,
                          navigatorKey,
                        );
                        setState(() {
                          tabSelected = tab;
                        });
                      },
                    ),
                    TabItem(
                      label: addNew,
                      iconPath: AssetPaths.plusIcon,
                      selectedTab: tabSelected,
                      currentTab: addNew,
                      unselectedtextColor: kPrimaryWhite,
                      onTap: (tab) {
                        navigateTo(
                          addNewRoute,
                          navigatorKey,
                        );
                        setState(() {
                          tabSelected = tab;
                        });
                      },
                    ),
                    TabItem(
                      label: books,
                      iconPath: AssetPaths.bookOpenIcon,
                      selectedTab: tabSelected,
                      currentTab: books,
                      unselectedtextColor: kPrimaryWhite,
                      onTap: (tab) {
                        navigateTo(
                          booksRoute,
                          navigatorKey,
                        );
                        setState(() {
                          tabSelected = tab;
                        });
                      },
                    ),
                    TabItem(
                      label: projects,
                      iconPath: AssetPaths.projectIcon,
                      selectedTab: tabSelected,
                      currentTab: projects,
                      unselectedtextColor: kPrimaryWhite,
                      onTap: (tab) {
                        navigateTo(
                          projectsRoute,
                          navigatorKey,
                        );
                        setState(
                          () {
                            tabSelected = tab;
                          },
                        );
                      },
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: kSmallPadding, bottom: kPadding),
                      child: Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          color: kPrimaryWhite,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        openEndDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: kRegularPadding,
                          top: kSmallPadding,
                          bottom: kRegularPadding,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AssetPaths.profileIcon,
                              color: kPrimaryWhite,
                              width: 17,
                            ),
                            XBox(kRegularPadding),
                            Text(
                              pROfile,
                              style: textTheme.titleMedium!.copyWith(
                                fontSize: 16,
                                color: kPrimaryWhite,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        LoadingScreen()
                            .show(context: context, showProgress: true);
                        await _auth.logOut();
                        LoadingScreen().hide();
                        (!kIsWeb || isPhoneWeb)
                            ? navigatorKey.currentState!
                                .pushNamedAndRemoveUntil(
                                signInRoute,
                                (route) => false,
                              )
                            : widget.navigatorKeyForDesktopWeb!.currentState!
                                .pushNamedAndRemoveUntil(
                                signInRoute,
                                (route) => false,
                              );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: kRegularPadding,
                          top: kSmallPadding,
                          bottom: kSmallPadding,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AssetPaths.logoutIcon,
                              color: kPrimaryWhite,
                              width: 15,
                            ),
                            XBox(kRegularPadding),
                            Text(
                              logout,
                              style: textTheme.titleMedium!.copyWith(
                                fontSize: 16,
                                color: kPrimaryWhite,
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
          : null,
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
            onLoadingStart: () => setState(() => _isLoading = true),
            onLoadingEnd: () => setState(() => _isLoading = false),
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
        isLoading: _isLoading,
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
                        horizontal: kLargePadding + kSmallPadding,
                        vertical: kSmallPadding,
                      ),
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Home/Dashboard',
                              style: textTheme.titleMedium!.copyWith(
                                fontSize: 13,
                                color: kGry800,
                              ),
                            ),
                            XBox(kPadding),
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
                                                final profile = snapshot.data
                                                    as CloudProfile;
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
                                                    _showSignOut =
                                                        !_showSignOut;
                                                  });
                                                },
                                              );
                                          }
                                        })),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kSmallPadding,
                          vertical: kPadding,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                kPrimaryColor,
                                kDarkYellow,
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                12,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: kLargePadding,
                            horizontal: kMediumPadding,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    YBox(kSmallPadding),
                                    Text(
                                      '$welcomeBack ${(SessionManager.getRole() == lecturerRole) ? SessionManager.getPreferredAcademicName() : SessionManager.getFirstName()}',
                                      style: textTheme.titleMedium!.copyWith(
                                        fontSize:
                                            (!kIsWeb || isPhoneWeb) ? 21 : 24,
                                      ),
                                    ),
                                    YBox(kMicroPadding),
                                    Text(
                                      '$dashboardSubHeaderOne ${(!kIsWeb || isPhoneWeb) ? dashboardSubHeaderTwo : ''}',
                                      style: textTheme.titleMedium!.copyWith(
                                        height: 1.2,
                                        fontSize:
                                            (!kIsWeb || isPhoneWeb) ? 15 : 13,
                                      ),
                                    ),
                                    YBox(kPadding),
                                    (!kIsWeb || isPhoneWeb)
                                        ? Container()
                                        : Text(
                                            dashboardSubHeaderTwo,
                                            style:
                                                textTheme.titleMedium!.copyWith(
                                              fontSize: (!kIsWeb || isPhoneWeb)
                                                  ? 15
                                                  : 13,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      YBox(kSmallPadding),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kRegularPadding,
                          vertical: kSmallPadding,
                        ),
                        child: Text(
                          myCourses,
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
                                  stream:
                                      (SessionManager.getRole() == lecturerRole)
                                          ? _database.getLecturerCourses(
                                              ownerUid: _auth.currentUser!.uid,
                                            )
                                          : _database.getAllCourses(
                                              level: SessionManager.getLevel(),
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
                                                'No course added yet',
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
                                                  title:
                                                      courses[index].courseName,
                                                  units: courses[index].unit,
                                                  coordinatorName:
                                                      courses[index].ownerName,
                                                  avatarPath: courses[index]
                                                      .profileImageUrl,
                                                  onTap: () {
                                                    (!kIsWeb || isPhoneWeb)
                                                        ? navigatorKey
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
                                                          ))
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
                                      default:
                                        return Wrap(
                                          spacing: kSmallPadding,
                                          runSpacing: kPadding,
                                          children: List.generate(
                                            7,
                                            (index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: kSmallPadding),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[200]!,
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
                      YBox(
                        (!kIsWeb || isPhoneWeb)
                            ? kRegularPadding
                            : kMicroPadding,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kRegularPadding,
                          vertical: kSmallPadding,
                        ),
                        child: Text(
                          recentlyViewedCourses,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: (!kIsWeb || isPhoneWeb) ? 18 : 15,
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
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    StreamBuilder(
                                      stream: (SessionManager.getRole() ==
                                              lecturerRole)
                                          ? _database.getLecturerCourses(
                                              ownerUid: _auth.currentUser!.uid,
                                            )
                                          : _database.getAllCourses(
                                              level: SessionManager.getLevel(),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: kFullPadding,
                                                  ),
                                                  child: Text(
                                                    'No course viewed yet',
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
                                                      units:
                                                          courses[index].unit,
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
                                                              );
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
                                                      padding: const EdgeInsets
                                                          .only(
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
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8),
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
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              YBox(kMediumPadding),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kRegularPadding,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.only(
                                        left: kSmallPadding,
                                        right: kSmallPadding,
                                        bottom: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding
                                            : kRegularPadding,
                                        top: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 5
                                            : kRegularPadding + 4,
                                      ),
                                      backgroundColor: kDarkYellow,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            (!kIsWeb || isPhoneWeb) ? 10 : 6),
                                      ),
                                    ),
                                    onPressed: () {
                                      (!kIsWeb || isPhoneWeb)
                                          ? navigateTo(
                                              allCoursesRoute,
                                              navigatorKey,
                                            )
                                          : navigateTo(
                                              allCoursesRoute,
                                              widget.navigatorKeyForDesktopWeb!,
                                            );
                                    },
                                    child: Text(
                                      viewAll,
                                      style: textTheme.titleSmall!.copyWith(
                                        fontSize:
                                            (!kIsWeb || isPhoneWeb) ? 16 : 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                            imageUrl: SessionManager.getProfileImageUrl() ?? '',
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
    );
  }
}
