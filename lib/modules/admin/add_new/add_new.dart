import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/add_book.dart';
import 'package:systems_app/modules/shared/add_project_paper.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class AddNewAdmin extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const AddNewAdmin({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<AddNewAdmin> createState() => _AddNewAdminState();
}

class _AddNewAdminState extends ConsumerState<AddNewAdmin> {
  late final AuthenticationAsyncNotifier _auth;
  bool _showSignOut = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                      ),
                YBox(kMicroPadding),
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
                        (!kIsWeb || isPhoneWeb) ? YBox(kPadding) : Container(),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kRegularPadding,
                              vertical: kSmallPadding,
                            ),
                            child: Text(
                              whatUpload,
                              style: textTheme.titleMedium!.copyWith(
                                fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                                color: kBlack,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        YBox(kRegularPadding),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AddProjectPaper(),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kRegularPadding,
                              vertical: kPadding,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: kPrimaryWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    4,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: kRegularPadding,
                                horizontal: kMediumPadding,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: kBlue800,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: kPrimaryWhite,
                                        size: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                                      ),
                                    ),
                                  ),
                                  XBox(kSmallPadding),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4.0,
                                    ),
                                    child: Text(
                                      projectPapers,
                                      style: textTheme.titleSmall!.copyWith(
                                        fontSize:
                                            (!kIsWeb || isPhoneWeb) ? 16 : 13,
                                        color: kBlack,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        YBox(kPadding),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AddBook(),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kRegularPadding,
                              vertical: kPadding,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: kPrimaryWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    4,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: kRegularPadding,
                                horizontal: kMediumPadding,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: kBlue800,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: kPrimaryWhite,
                                        size: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                                      ),
                                    ),
                                  ),
                                  XBox(kSmallPadding),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4.0,
                                    ),
                                    child: Text(
                                      books,
                                      style: textTheme.titleSmall!.copyWith(
                                        fontSize:
                                            (!kIsWeb || isPhoneWeb) ? 15 : 13,
                                        color: kBlack,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        YBox(kPadding),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kRegularPadding,
                              vertical: kPadding,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: kPrimaryWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    4,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: kRegularPadding,
                                horizontal: kMediumPadding,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: kBlue800,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: kPrimaryWhite,
                                        size: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                                      ),
                                    ),
                                  ),
                                  XBox(kSmallPadding),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4.0,
                                    ),
                                    child: Text(
                                      others,
                                      style: textTheme.titleSmall!.copyWith(
                                        fontSize:
                                            (!kIsWeb || isPhoneWeb) ? 15 : 13,
                                        color: kBlack,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
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
      ),
    );
  }
}
