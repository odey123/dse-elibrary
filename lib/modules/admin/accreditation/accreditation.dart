import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/admin/accreditation/tab_five_screen.dart';
import 'package:systems_app/modules/admin/accreditation/tab_four_screen.dart';
import 'package:systems_app/modules/admin/accreditation/tab_one_screen.dart';
import 'package:systems_app/modules/admin/accreditation/tab_three_screen.dart';
import 'package:systems_app/modules/admin/accreditation/tab_two_screen.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class Accreditation extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const Accreditation({super.key, this.navigatorKeyForDesktopWeb});

  @override
  ConsumerState<Accreditation> createState() => _AccreditationState();
}

class _AccreditationState extends ConsumerState<Accreditation>
    with SingleTickerProviderStateMixin {
  late final AuthenticationAsyncNotifier _auth;
  late final TabController _tabController;
  bool _showSignOut = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (!kIsWeb || isPhoneWeb)
                    ? Container()
                    : Padding(
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
                                          'Accreditation',
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
                                    overlayColor: const WidgetStatePropertyAll(
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kRegularPadding),
                  child: Text(
                    'Accreditation',
                    style: textTheme.bodySmall!.copyWith(
                      color: kBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kRegularPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 0.5,
                          decoration:
                              BoxDecoration(color: kGry500.withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kMediumPadding,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: kPrimaryColor,
                    indicatorWeight: 1.5,
                    labelPadding: const EdgeInsets.only(
                      bottom: kPadding,
                    ),
                    indicatorPadding:
                        const EdgeInsets.only(right: kRegularPadding),
                    overlayColor: WidgetStateProperty.all(kTransparent),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.only(right: kMediumPadding),
                        child: Text(
                          university,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 12,
                            height: 1.2,
                            color: _tabController.index == 0
                                ? kPrimaryColor
                                : kBlack,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: kRegularPadding),
                        child: Text(
                          department,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 12,
                            height: 1.2,
                            color: _tabController.index == 1
                                ? kPrimaryColor
                                : kBlack,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: kRegularPadding),
                        child: Text(
                          accreditation,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 12,
                            height: 1.2,
                            color: _tabController.index == 2
                                ? kPrimaryColor
                                : kBlack,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: kRegularPadding),
                        child: Text(
                          documents,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 12,
                            height: 1.2,
                            color: _tabController.index == 3
                                ? kPrimaryColor
                                : kBlack,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: kRegularPadding),
                        child: Text(
                          courses,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 12,
                            height: 1.2,
                            color: _tabController.index == 4
                                ? kPrimaryColor
                                : kBlack,
                          ),
                        ),
                      ),
                    ],
                    onTap: (index) {
                      setState(() {});
                      _tabController.animateTo(index);
                    },
                  ),
                ),
                const SizedBox(
                  height: kRegularPadding,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kRegularPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 0.5,
                          decoration:
                              BoxDecoration(color: kGry500.withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kRegularPadding,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      TabOneScreen(),
                      TabTwoScreen(),
                      TabThreeScreen(),
                      TabFourScreen(),
                      TabFiveScreen(),
                    ],
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
