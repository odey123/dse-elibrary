import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/admin/hod/add_hod.dart';
import 'package:systems_app/modules/reuseables/empty_state_widget.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/model/hod.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';

class Hod extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const Hod({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<Hod> createState() => _HodState();
}

class _HodState extends ConsumerState<Hod> {
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  bool _showSignOut = false;

  @override
  void initState() {
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: StreamBuilder(
            stream: _database.getHod(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final hods = snapshot.data as List<HOD>;
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Column(
                          children: [
                            (isPhoneWeb)
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      left: kLargePadding,
                                      right: kLargePadding,
                                      top: kPadding,
                                      bottom: kRegularPadding,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                      style: textTheme
                                                          .titleMedium!
                                                          .copyWith(
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
                                                decoration:
                                                    const BoxDecoration(),
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
                                                overlayColor:
                                                    const WidgetStatePropertyAll(
                                                        kTransparent),
                                                hoverColor: kTransparent,
                                                onTap: () {
                                                  setState(() {
                                                    _showSignOut =
                                                        !_showSignOut;
                                                  });
                                                },
                                                child: Container(
                                                  height: 28,
                                                  width: 28,
                                                  decoration:
                                                      const BoxDecoration(
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
                              padding: const EdgeInsets.only(
                                left: kRegularPadding,
                                right: kRegularPadding,
                                top: kRegularPadding,
                                bottom: kPadding,
                              ),
                              child: Row(
                                children: [
                                  CustomTextButton(
                                    text: exportCsv,
                                    onPressed: () {},
                                    backgroundColor: kPrimaryWhite,
                                    textColor: kDarkYellow,
                                    borderColor: kGry500,
                                    isLoading: false,
                                    padding: const EdgeInsets.only(
                                      left: kMediumPadding,
                                      right: kMediumPadding,
                                      top: kMediumPadding + 2,
                                      bottom: kMediumPadding - 2,
                                    ),
                                  ),
                                  XBox(kSmallPadding),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: kMediumPadding),
                                        child: Text(
                                          '${SessionManager.getLastName()} ${SessionManager.getFirstName()}',
                                          style:
                                              textTheme.titleMedium!.copyWith(
                                            fontSize: 13,
                                            color: kBlack,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: kSmallPadding,
                                            bottom: kPadding),
                                        child: Text(
                                          SessionManager.getEmail() ?? '',
                                          style:
                                              textTheme.titleMedium!.copyWith(
                                            fontSize: 13,
                                            color: kBlack,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: kSmallPadding,
                                            bottom: kPadding),
                                        child: Container(
                                          height: 1,
                                          decoration: const BoxDecoration(
                                            color: kGry600,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          LoadingScreen().show(
                                              context: context,
                                              showProgress: true);
                                          await _auth.logOut();
                                          LoadingScreen().hide();
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pushNamedAndRemoveUntil(
                                            signInRoute,
                                            (route) => false,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: kSmallPadding,
                                              bottom: kPadding),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  AssetPaths.logoutIcon),
                                              XBox(kPadding),
                                              Text(
                                                logout,
                                                style: textTheme.titleMedium!
                                                    .copyWith(
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
                                              SvgPicture.asset(
                                                  AssetPaths.profileIcon),
                                              XBox(kPadding),
                                              Text(
                                                pROfile,
                                                style: textTheme.titleMedium!
                                                    .copyWith(
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
                    );
                  } else {
                    return EmptyStateWidget(
                      namePlaceholder: hod,
                      actionButton: CustomTextButton(
                        text: addHod,
                        isLoading: false,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddHod(),
                          ));
                        },
                        backgroundColor: kDarkYellow,
                        textColor: kPrimaryWhite,
                        borderColor: kTransparent,
                        icon: Icons.add,
                      ),
                    );
                  }
                default:
                  return EmptyStateWidget(
                    namePlaceholder: hod,
                    actionButton: CustomTextButton(
                      text: addHod,
                      isLoading: false,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddHod(),
                        ));
                      },
                      backgroundColor: kDarkYellow,
                      textColor: kPrimaryWhite,
                      borderColor: kTransparent,
                      icon: Icons.add,
                    ),
                  );
              }
            }),
      ),
    );
  }
}
