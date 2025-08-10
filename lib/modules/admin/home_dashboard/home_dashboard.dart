import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/app/navigator/admin_navigator.dart';
import 'package:systems_app/modules/shared/course_details.dart';
import 'package:systems_app/modules/reuseables/course_card.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/reuseables/tab_item.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/model/course.dart';
import 'package:systems_app/services/cloud/model/lecturer.dart';
import 'package:systems_app/services/cloud/model/project_paper.dart';
import 'package:systems_app/services/cloud/model/student.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class HomeDashboardAdmin extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const HomeDashboardAdmin({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<HomeDashboardAdmin> createState() => _HomeDashboardAdminState();
}

class _HomeDashboardAdminState extends ConsumerState<HomeDashboardAdmin> {
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  final TextEditingController _searchController = TextEditingController();
  String tabSelected = dashboard;
  bool _showSignOut = false;
  String _searchTerm = '';

  @override
  void initState() {
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: (!kIsWeb || isPhoneWeb)
            ? AppBar(
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                actions: [
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
                        'Ayo.O',
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
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ProfileImage(
                        imageUrl: SessionManager.getProfileImageUrl() ?? '',
                        radius: 25,
                      ),
                    ),
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
                                    'Systems E.',
                                    style: textTheme.headlineMedium!.copyWith(
                                      fontSize: 18,
                                      color: kBlack,
                                      fontWeight: FontWeight.w600,
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
                        currentTab: dashboard,
                        unselectedtextColor: kPrimaryWhite,
                        onTap: (tab) {
                          adminNavigateTo(homeDashboardRoute, navigatorKey);
                          setState(() {
                            tabSelected = tab;
                          });
                        },
                      ),
                      TabItem(
                        label: students,
                        iconPath: AssetPaths.students,
                        selectedTab: tabSelected,
                        currentTab: students,
                        unselectedtextColor: kPrimaryWhite,
                        onTap: (tab) {
                          setState(() {
                            tabSelected = tab;
                          });
                        },
                      ),
                      TabItem(
                        label: lecturers,
                        iconPath: AssetPaths.projectIcon,
                        selectedTab: tabSelected,
                        currentTab: lecturers,
                        unselectedtextColor: kPrimaryWhite,
                        onTap: (tab) {
                          setState(() {
                            tabSelected = tab;
                          });
                        },
                      ),
                      TabItem(
                        label: hod,
                        iconPath: AssetPaths.projectIcon,
                        selectedTab: tabSelected,
                        currentTab: hod,
                        unselectedtextColor: kPrimaryWhite,
                        onTap: (tab) {
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
                          adminNavigateTo(addNewAdminRoute, navigatorKey);
                          setState(() {
                            tabSelected = tab;
                          });
                        },
                      ),
                      TabItem(
                        label: courses,
                        iconPath: AssetPaths.homeIcon,
                        selectedTab: tabSelected,
                        currentTab: courses,
                        unselectedtextColor: kPrimaryWhite,
                        onTap: (tab) {
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
                          adminNavigateTo(booksRoute, navigatorKey);
                          setState(() {
                            tabSelected = tab;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                (isPhoneWeb)
                    ? Container()
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kLargePadding,
                              vertical: kSmallPadding - 3,
                            ),
                            child: SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenSize.width * 0.37,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: kPrimaryWhite,
                                      border: Border.all(
                                        color: const Color(0xffEBE6F0),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _searchController,
                                      keyboardType: TextInputType.text,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: textTheme.titleMedium!.copyWith(
                                        fontSize: 12,
                                        color: kGry800,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Search by course code',
                                        hintStyle:
                                            textTheme.titleMedium!.copyWith(
                                          fontSize: 12,
                                          color: kGry800,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                          bottom: kPadding * 2.7,
                                        ),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5.0,
                                            bottom: 5.0,
                                          ),
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
                                        decoration: const BoxDecoration(
                                            color: kLightAsh),
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
                          YBox(1),
                          Container(
                            height: 1,
                            width: double.infinity,
                            decoration: const BoxDecoration(color: kLightAsh),
                          ),
                        ],
                      ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kRegularPadding,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      YBox(kSmallPadding),
                                      Text(
                                        '$welcomeBack Admin',
                                        style: textTheme.titleMedium!.copyWith(
                                          fontSize: 24,
                                        ),
                                      ),
                                      YBox(kMicroPadding),
                                      Text(
                                        '$dashboardSubHeaderOne ${(!kIsWeb || isPhoneWeb) ? dashboardSubHeaderTwo : ''}',
                                        style: textTheme.titleMedium!.copyWith(
                                          fontSize:
                                              (!kIsWeb || isPhoneWeb) ? 15 : 13,
                                        ),
                                      ),
                                      YBox(kPadding),
                                      (!kIsWeb || isPhoneWeb)
                                          ? Container()
                                          : Text(
                                              dashboardSubHeaderTwo,
                                              style: textTheme.titleMedium!
                                                  .copyWith(
                                                fontSize:
                                                    (!kIsWeb || isPhoneWeb)
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
                          ),
                          child: Row(
                            children: [
                              StreamBuilder(
                                stream: _database.getAllStudents(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        final students =
                                            snapshot.data as List<Student>;
                                        return Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: kSmallPadding),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: kMacroPadding,
                                                horizontal: kMediumPadding,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kPrimaryWhite,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(
                                                    8,
                                                  ),
                                                ),
                                                border: Border.all(
                                                  color: kGry500,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 31,
                                                    width: 31,
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kLightSkyeBlue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      AssetPaths.students,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                  XBox(kSmallPadding),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Total students',
                                                        style: textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? 19
                                                              : 14,
                                                          color: kGry600,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      YBox(kSmallPadding),
                                                      Text(
                                                        '${students.length}',
                                                        style: textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? 19
                                                              : 15,
                                                          color: kBlack,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: kSmallPadding),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[200]!,
                                              highlightColor: Colors.grey[50]!,
                                              child: Container(
                                                height: 100,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    default:
                                      return Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: kSmallPadding),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[200]!,
                                            highlightColor: Colors.grey[50]!,
                                            child: Container(
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                  }
                                },
                              ),
                              StreamBuilder(
                                stream: _database.getAllLecturers(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        final lecturers =
                                            snapshot.data as List<Lecturer>;
                                        return Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: kSmallPadding),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: kMacroPadding,
                                                horizontal: kMediumPadding,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kPrimaryWhite,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(
                                                    8,
                                                  ),
                                                ),
                                                border: Border.all(
                                                  color: kGry500,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 31,
                                                    width: 31,
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kLightSkyeBlue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      AssetPaths.projectIcon,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                  XBox(kSmallPadding),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Total lecturers',
                                                        style: textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? 19
                                                              : 14,
                                                          color: kGry600,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      YBox(kSmallPadding),
                                                      Text(
                                                        '${lecturers.length}',
                                                        style: textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? 19
                                                              : 15,
                                                          color: kBlack,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: kSmallPadding),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[200]!,
                                              highlightColor: Colors.grey[50]!,
                                              child: Container(
                                                height: 100,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    default:
                                      return Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: kSmallPadding),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[200]!,
                                            highlightColor: Colors.grey[50]!,
                                            child: Container(
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                  }
                                },
                              ),
                              StreamBuilder(
                                stream: _database.getAllCourses(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        final courses =
                                            snapshot.data as List<Course>;
                                        return Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: kSmallPadding),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: kMacroPadding,
                                                horizontal: kMediumPadding,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kPrimaryWhite,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(
                                                    8,
                                                  ),
                                                ),
                                                border: Border.all(
                                                  color: kGry500,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 31,
                                                    width: 31,
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kLightSkyeBlue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      AssetPaths.courses,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                  XBox(kSmallPadding),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Total courses',
                                                        style: textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? 19
                                                              : 14,
                                                          color: kGry600,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      YBox(kSmallPadding),
                                                      Text(
                                                        '${courses.length}',
                                                        style: textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? 19
                                                              : 15,
                                                          color: kBlack,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: kSmallPadding),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[200]!,
                                              highlightColor: Colors.grey[50]!,
                                              child: Container(
                                                height: 100,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    default:
                                      return Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: kSmallPadding),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[200]!,
                                            highlightColor: Colors.grey[50]!,
                                            child: Container(
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                  }
                                },
                              ),
                              StreamBuilder(
                                stream: _database.getAllProjectPapers(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        final projectPapers =
                                            snapshot.data as List<ProjectPaper>;
                                        return Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: kSmallPadding),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: kMacroPadding,
                                                horizontal: kMediumPadding,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kPrimaryWhite,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(
                                                    8,
                                                  ),
                                                ),
                                                border: Border.all(
                                                  color: kGry500,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 31,
                                                    width: 31,
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kLightSkyeBlue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      AssetPaths.projectPapers,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                  XBox(kSmallPadding),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Project papers',
                                                        style: textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? 19
                                                              : 14,
                                                          color: kGry600,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      YBox(kSmallPadding),
                                                      Text(
                                                        '${projectPapers.length}',
                                                        style: textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                          fontSize: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? 19
                                                              : 15,
                                                          color: kBlack,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: kSmallPadding),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[200]!,
                                              highlightColor: Colors.grey[50]!,
                                              child: Container(
                                                height: 100,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    default:
                                      return Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: kSmallPadding),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[200]!,
                                            highlightColor: Colors.grey[50]!,
                                            child: Container(
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        YBox(kMediumPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kSmallPadding,
                          ),
                          child: Text(
                            yearOnecourses,
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 16,
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
                                        stream: _database.getAllCourses(
                                          level: hundred,
                                          searchTerm: _searchTerm,
                                        ),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                            case ConnectionState.active:
                                              if (snapshot.hasData) {
                                                final courses = snapshot.data
                                                    as List<Course>;
                                                if (courses.isEmpty) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: kFullPadding,
                                                    ),
                                                    child: Text(
                                                      'No course added for this level',
                                                      style: textTheme
                                                          .bodyMedium!
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
                                                        avatarPath: courses[
                                                                index]
                                                            .profileImageUrl,
                                                        onTap: () {
                                                          Navigator.of(context)
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
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right:
                                                                kSmallPadding),
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[200]!,
                                                          highlightColor:
                                                              Colors.grey[50]!,
                                                          child: Container(
                                                            height: 130,
                                                            width: 250,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
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
                                      onPressed: () {},
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
                        YBox(kMediumPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kSmallPadding,
                          ),
                          child: Text(
                            yearTwocourses,
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 16,
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
                                        stream: _database.getAllCourses(
                                          level: twoHundred,
                                          searchTerm: _searchTerm,
                                        ),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                            case ConnectionState.active:
                                              if (snapshot.hasData) {
                                                final courses = snapshot.data
                                                    as List<Course>;
                                                if (courses.isEmpty) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: kFullPadding,
                                                    ),
                                                    child: Text(
                                                      'No course added for this level',
                                                      style: textTheme
                                                          .bodyMedium!
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
                                                        avatarPath: courses[
                                                                index]
                                                            .profileImageUrl,
                                                        onTap: () {
                                                          Navigator.of(context)
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
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right:
                                                                kSmallPadding),
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[200]!,
                                                          highlightColor:
                                                              Colors.grey[50]!,
                                                          child: Container(
                                                            height: 130,
                                                            width: 250,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
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
                                      onPressed: () {},
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
                        YBox(kMediumPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kSmallPadding,
                          ),
                          child: Text(
                            yearThreecourses,
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 16,
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
                                        stream: _database.getAllCourses(
                                          level: threeHundred,
                                          searchTerm: _searchTerm,
                                        ),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                            case ConnectionState.active:
                                              if (snapshot.hasData) {
                                                final courses = snapshot.data
                                                    as List<Course>;
                                                if (courses.isEmpty) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: kFullPadding,
                                                    ),
                                                    child: Text(
                                                      'No course added for this level',
                                                      style: textTheme
                                                          .bodyMedium!
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
                                                        avatarPath: courses[
                                                                index]
                                                            .profileImageUrl,
                                                        onTap: () {
                                                          Navigator.of(context)
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
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right:
                                                                kSmallPadding),
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[200]!,
                                                          highlightColor:
                                                              Colors.grey[50]!,
                                                          child: Container(
                                                            height: 130,
                                                            width: 250,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
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
                                      onPressed: () {},
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
                        YBox(kMediumPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kSmallPadding,
                          ),
                          child: Text(
                            yearFourcourses,
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 16,
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
                                        stream: _database.getAllCourses(
                                          level: fourHundred,
                                          searchTerm: _searchTerm,
                                        ),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                            case ConnectionState.active:
                                              if (snapshot.hasData) {
                                                final courses = snapshot.data
                                                    as List<Course>;
                                                if (courses.isEmpty) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: kFullPadding,
                                                    ),
                                                    child: Text(
                                                      'No course added for this level',
                                                      style: textTheme
                                                          .bodyMedium!
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
                                                        avatarPath: courses[
                                                                index]
                                                            .profileImageUrl,
                                                        onTap: () {
                                                          Navigator.of(context)
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
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right:
                                                                kSmallPadding),
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[200]!,
                                                          highlightColor:
                                                              Colors.grey[50]!,
                                                          child: Container(
                                                            height: 130,
                                                            width: 250,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
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
                                      onPressed: () {},
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
                        YBox(kMediumPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kSmallPadding,
                          ),
                          child: Text(
                            yearFivecourses,
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 16,
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
                                        stream: _database.getAllCourses(
                                          level: fiveHundred,
                                          searchTerm: _searchTerm,
                                        ),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                            case ConnectionState.active:
                                              if (snapshot.hasData) {
                                                final courses = snapshot.data
                                                    as List<Course>;
                                                if (courses.isEmpty) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: kFullPadding,
                                                    ),
                                                    child: Text(
                                                      'No course added for this level',
                                                      style: textTheme
                                                          .bodyMedium!
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
                                                        avatarPath: courses[
                                                                index]
                                                            .profileImageUrl,
                                                        onTap: () {
                                                          Navigator.of(context)
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
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right:
                                                                kSmallPadding),
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[200]!,
                                                          highlightColor:
                                                              Colors.grey[50]!,
                                                          child: Container(
                                                            height: 130,
                                                            width: 250,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
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
                                      onPressed: () {},
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
                              imageUrl:
                                  SessionManager.getProfileImageUrl() ?? '',
                              radius: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: kMediumPadding),
                            child: Text(
                              'Admin',
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
                          //   InkWell(
                          //     onTap: () {},
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(
                          //         top: kSmallPadding,
                          //       ),
                          //       child: Row(
                          //         children: [
                          //           SvgPicture.asset(AssetPaths.profileIcon),
                          //           XBox(kPadding),
                          //           Text(
                          //             pROfile,
                          //             style: textTheme.titleMedium!.copyWith(
                          //               fontSize: 13,
                          //               color: kBlack,
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
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
