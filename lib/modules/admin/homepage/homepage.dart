import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:systems_app/app/navigator/admin_navigator.dart';
import 'package:systems_app/modules/admin/homepage/view_area.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/reuseables/tab_item.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  String tabSelected = dashboard;

  final GlobalKey<NavigatorState> navigatorKeyForDesktopWeb =
      GlobalKey<NavigatorState>();

  Future<void> _launchURL() async {
    if (await canLaunchUrl(Uri.parse(projectExternalUrl))) {
      await launchUrl(Uri.parse(projectExternalUrl));
    } else {
      throw 'Could not launch $projectExternalUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isPhoneWeb)
              ? Container()
              : Container(
                  width: 200,
                  decoration: const BoxDecoration(
                      color: kLighterAsh,
                      border: Border(right: BorderSide(color: kLightAsh))),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        YBox(kSmallPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: (!kIsWeb || isPhoneWeb) ? 40 : 30,
                                width: (!kIsWeb || isPhoneWeb) ? 40 : 30,
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
                        YBox(kSmallPadding),
                        Container(
                          height: 1,
                          width: 200,
                          decoration: const BoxDecoration(color: kLightAsh),
                        ),
                        YBox(kRegularPadding),
                        TabItem(
                          label: dashboard,
                          iconPath: AssetPaths.homeIcon,
                          selectedTab: tabSelected,
                          currentTab: dashboard,
                          unselectedtextColor: kPrimaryWhite,
                          onTap: (tab) {
                            adminNavigateTo(
                                homeDashboardRoute, navigatorKeyForDesktopWeb);
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
                            adminNavigateTo(
                                studentRoute, navigatorKeyForDesktopWeb);
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
                            adminNavigateTo(
                                lecturersRoute, navigatorKeyForDesktopWeb);
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
                            adminNavigateTo(
                                hodRoute, navigatorKeyForDesktopWeb);
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
                            adminNavigateTo(
                                addNewAdminRoute, navigatorKeyForDesktopWeb);
                            setState(
                              () {
                                tabSelected = tab;
                              },
                            );
                          },
                        ),
                        TabItem(
                          label: books,
                          iconPath: AssetPaths.bookOpenIcon,
                          selectedTab: tabSelected,
                          currentTab: books,
                          unselectedtextColor: kPrimaryWhite,
                          onTap: (tab) {
                            adminNavigateTo(
                                booksRoute, navigatorKeyForDesktopWeb);
                            setState(
                              () {
                                tabSelected = tab;
                              },
                            );
                          },
                        ),
                        TabItem(
                          label: accreditation,
                          iconPath: AssetPaths.accreditationIcon,
                          selectedTab: tabSelected,
                          currentTab: accreditation,
                          unselectedtextColor: kPrimaryWhite,
                          onTap: (tab) {
                            adminNavigateTo(
                              accreditationRoute,
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
            child: ViewAreaAdmin(
              navigatorKey: navigatorKeyForDesktopWeb,
            ),
          ),
        ],
      ),
    );
  }
}
