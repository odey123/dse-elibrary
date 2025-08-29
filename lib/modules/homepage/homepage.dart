import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/navigator/navigator.dart';
import 'package:systems_app/modules/homepage/view_area.dart';
import 'package:systems_app/modules/reuseables/empty_state_home_widget.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/reuseables/tab_item.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/cloud_profile.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final AuthenticationAsyncNotifier _auth;
  late final DatabaseAsyncNotifier _database;
  String tabSelected = dashboard;

  final GlobalKey<NavigatorState> navigatorKeyForDesktopWeb =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _auth.currentUser!.getIdTokenResult(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final userToken = snapshot.data as IdTokenResult;
                  final role = userToken.claims?['role'];
                  return FutureBuilder(
                    future: _database
                        .getUserProfile(
                          ownerUserId: _auth.currentUser!.uid,
                          role: role,
                        )
                        .first,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final profile = snapshot.data as CloudProfile;
                            SessionManager.setUserId(profile.userId);
                            SessionManager.setEmail(profile.email);
                            SessionManager.setFirstName(profile.firstName);
                            SessionManager.setLastName(profile.lastName);
                            SessionManager.setGender(profile.gender);
                            SessionManager.setLevel(profile.level);
                            SessionManager.setRole(profile.role);
                            SessionManager.setPrefix(profile.prefix);
                            SessionManager.setLevelCourseAdvisor(
                                profile.levelCourseAdvisor);
                            SessionManager.setPreferredAcademicName(
                                profile.preferredAcademicName);
                            SessionManager.setProfileImageUrl(
                                profile.profileImageUrl);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (isPhoneWeb)
                                    ? Container()
                                    : Container(
                                        width: 200,
                                        decoration: const BoxDecoration(
                                            color: kLighterAsh,
                                            border: Border(
                                                right: BorderSide(
                                                    color: kLightAsh))),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              YBox(kSmallPadding),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: kRegularPadding,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: (!kIsWeb ||
                                                              isPhoneWeb)
                                                          ? 40
                                                          : 30,
                                                      width: (!kIsWeb ||
                                                              isPhoneWeb)
                                                          ? 40
                                                          : 30,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: kPrimaryWhite,
                                                      ),
                                                      child: ClipOval(
                                                        child: Image.asset(
                                                          AssetPaths
                                                              .departmentLogo,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    XBox(kSmallPadding),
                                                    Transform.translate(
                                                      offset:
                                                          const Offset(0, 2),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Systems E.',
                                                            style: textTheme
                                                                .headlineMedium!
                                                                .copyWith(
                                                              fontSize: 18,
                                                              color: kBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              YBox(kSmallPadding),
                                              Container(
                                                height: 1,
                                                width: 200,
                                                decoration: const BoxDecoration(
                                                    color: kLightAsh),
                                              ),
                                              YBox(kRegularPadding),
                                              TabItem(
                                                label: dashboard,
                                                iconPath: AssetPaths.homeIcon,
                                                selectedTab: tabSelected,
                                                currentTab: dashboard,
                                                unselectedtextColor:
                                                    kPrimaryWhite,
                                                onTap: (tab) {
                                                  navigateTo(
                                                    homeDashboardRoute,
                                                    navigatorKeyForDesktopWeb,
                                                  );
                                                  setState(() {
                                                    tabSelected = tab;
                                                  });
                                                },
                                              ),
                                              (role == lecturerRole ||
                                                      role == hodRole)
                                                  ? TabItem(
                                                      label: myCourses,
                                                      iconPath:
                                                          AssetPaths.courses,
                                                      selectedTab: tabSelected,
                                                      currentTab: myCourses,
                                                      unselectedtextColor:
                                                          kPrimaryWhite,
                                                      onTap: (tab) {
                                                        navigateTo(
                                                          myCoursesRoute,
                                                          navigatorKeyForDesktopWeb,
                                                        );
                                                        setState(() {
                                                          tabSelected = tab;
                                                        });
                                                      },
                                                    )
                                                  : TabItem(
                                                      label: courses,
                                                      iconPath:
                                                          AssetPaths.courses,
                                                      selectedTab: tabSelected,
                                                      currentTab: courses,
                                                      unselectedtextColor:
                                                          kPrimaryWhite,
                                                      onTap: (tab) {
                                                        navigateTo(
                                                          coursesRoute,
                                                          navigatorKeyForDesktopWeb,
                                                        );
                                                        setState(() {
                                                          tabSelected = tab;
                                                        });
                                                      },
                                                    ),
                                              (role == lecturerRole ||
                                                      role == hodRole)
                                                  ? TabItem(
                                                      label: addNew,
                                                      iconPath:
                                                          AssetPaths.plusIcon,
                                                      selectedTab: tabSelected,
                                                      currentTab: addNew,
                                                      unselectedtextColor:
                                                          kPrimaryWhite,
                                                      onTap: (tab) {
                                                        navigateTo(
                                                          addNewRoute,
                                                          navigatorKeyForDesktopWeb,
                                                        );
                                                        setState(() {
                                                          tabSelected = tab;
                                                        });
                                                      },
                                                    )
                                                  : Container(),
                                              (role == lecturerRole ||
                                                      role == hodRole)
                                                  ? TabItem(
                                                      label: allCourses,
                                                      iconPath:
                                                          AssetPaths.courses,
                                                      selectedTab: tabSelected,
                                                      currentTab: allCourses,
                                                      unselectedtextColor:
                                                          kPrimaryWhite,
                                                      onTap: (tab) {
                                                        navigateTo(
                                                          allCoursesRoute,
                                                          navigatorKeyForDesktopWeb,
                                                        );
                                                        setState(() {
                                                          tabSelected = tab;
                                                        });
                                                      },
                                                    )
                                                  : Container(),
                                              TabItem(
                                                label: books,
                                                iconPath:
                                                    AssetPaths.bookOpenIcon,
                                                selectedTab: tabSelected,
                                                currentTab: books,
                                                unselectedtextColor:
                                                    kPrimaryWhite,
                                                onTap: (tab) {
                                                  navigateTo(
                                                    booksRoute,
                                                    navigatorKeyForDesktopWeb,
                                                  );
                                                  setState(() {
                                                    tabSelected = tab;
                                                  });
                                                },
                                              ),
                                              TabItem(
                                                label: projects,
                                                iconPath:
                                                    AssetPaths.projectIcon,
                                                selectedTab: tabSelected,
                                                currentTab: projects,
                                                unselectedtextColor:
                                                    kPrimaryWhite,
                                                onTap: (tab) {
                                                  navigateTo(
                                                    projectsRoute,
                                                    navigatorKeyForDesktopWeb,
                                                  );
                                                  setState(
                                                    () {
                                                      tabSelected = tab;
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                Expanded(
                                  child: ViewArea(
                                    navigatorKey: navigatorKeyForDesktopWeb,
                                    role: role,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const EmptyStateHomeWidget();
                          }
                        default:
                          return const EmptyStateHomeWidget();
                      }
                    },
                  );
                } else {
                  return const EmptyStateHomeWidget();
                }
              default:
                return const EmptyStateHomeWidget();
            }
          }),
    );
  }
}
