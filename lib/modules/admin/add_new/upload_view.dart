import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class UploadViewAdmin extends ConsumerStatefulWidget {
  const UploadViewAdmin({super.key});

  @override
  ConsumerState<UploadViewAdmin> createState() => _UploadViewAdminState();
}

class _UploadViewAdminState extends ConsumerState<UploadViewAdmin> {
  late final AuthenticationAsyncNotifier _auth;
  final TextEditingController _searchTextField = TextEditingController();
  bool _showSignOut = false;
  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      child: Image.asset(
                                        AssetPaths.avatar,
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
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: kGry400,
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(
                          left: kMicroPadding,
                          right: kMicroPadding,
                          bottom: kMicroPadding,
                          top: kLargePadding,
                        ),
                        backgroundColor: kPrimaryWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Upload your files',
                            style: textTheme.headlineSmall!.copyWith(
                              fontSize: 18,
                              color: kBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          YBox(kSmallPadding),
                          Text(
                            'File should be Jpg,png,pdf',
                            style: textTheme.headlineSmall!.copyWith(
                              fontSize: 10,
                              color: kGry800,
                            ),
                          ),
                          YBox(kLargePadding),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kLargePadding * 1.5,
                              vertical: kRegularPadding,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: DashedBorder(
                                dashLength: 5,
                                left:
                                    BorderSide(color: kDarkYellow, width: 1.5),
                                top: BorderSide(color: kDarkYellow, width: 1.5),
                                right:
                                    BorderSide(color: kDarkYellow, width: 1.5),
                                bottom:
                                    BorderSide(color: kDarkYellow, width: 1.5),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: Image.asset(
                                    AssetPaths.upload,
                                  ),
                                ),
                                YBox(kRegularPadding),
                                Text(
                                  'Max file is 11mb',
                                  style: textTheme.headlineSmall!.copyWith(
                                    fontSize: 10,
                                    color: kGry800,
                                  ),
                                ),
                                YBox(kPadding),
                                Text(
                                  'drag and drop your file here',
                                  style: textTheme.headlineSmall!.copyWith(
                                    fontSize: 10,
                                    color: kGry800,
                                  ),
                                ),
                                YBox(kRegularPadding),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kRegularPadding,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.only(
                                        left: kSmallPadding,
                                        right: kSmallPadding,
                                        bottom: kRegularPadding,
                                        top: kRegularPadding + 4,
                                      ),
                                      backgroundColor: kDarkYellow,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      browseFile,
                                      style: textTheme.titleSmall!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
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
                          height: 27,
                          width: 27,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            AssetPaths.avatar,
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
    );
  }
}
