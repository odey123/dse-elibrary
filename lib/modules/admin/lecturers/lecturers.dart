import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/admin/lecturers/add_lecturers.dart';
import 'package:systems_app/modules/admin/lecturers/lecturers_list_view.dart';
import 'package:systems_app/modules/reuseables/empty_state_widget.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/model/lecturer.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';

class Lecturers extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const Lecturers({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<Lecturers> createState() => _LecturersState();
}

class _LecturersState extends ConsumerState<Lecturers> {
  late final AuthenticationAsyncNotifier _auth;
  late final DatabaseAsyncNotifier _database;
  final TextEditingController _searchTextField = TextEditingController();
  bool _showSignOut = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kPrimaryWhite,
        body: StreamBuilder(
            stream: _database.getAllLecturers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final lecturers = snapshot.data as List<Lecturer>;
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
                                    isLoading: false,
                                    backgroundColor: kPrimaryWhite,
                                    textColor: kDarkYellow,
                                    borderColor: kGry500,
                                    padding: const EdgeInsets.only(
                                      left: kMediumPadding,
                                      right: kMediumPadding,
                                      top: kMediumPadding + 2,
                                      bottom: kMediumPadding - 2,
                                    ),
                                  ),
                                  XBox(kSmallPadding),
                                  CustomTextButton(
                                    text: addLecturer,
                                    isLoading: false,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const AddLecturers(),
                                      ));
                                    },
                                    backgroundColor: kDarkYellow,
                                    textColor: kPrimaryWhite,
                                    borderColor: kTransparent,
                                    icon: Icons.add,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kRegularPadding,
                                    vertical: kRegularPadding,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: kGry400,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: kRegularPadding,
                                        vertical: kLargePadding,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CustomTextForBorderButton(
                                                text: addFilter,
                                                onPressed: () {},
                                                backgroundColor: kPrimaryWhite,
                                                textColor: kGry600,
                                                borderColor: kGry500,
                                                icon: Icons.keyboard_arrow_down,
                                              ),
                                              XBox(kPadding),
                                              Container(
                                                width: screenSize.width * 0.3,
                                                height: 34,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: kPrimaryWhite,
                                                  border: Border.all(
                                                    color: kGry500,
                                                  ),
                                                ),
                                                child: TextField(
                                                  controller: _searchTextField,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: textTheme.titleMedium!
                                                      .copyWith(
                                                    fontSize: 12.5,
                                                    color: kBlack,
                                                  ),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: kSearchBack
                                                        .withOpacity(0.05),
                                                    hintText:
                                                        'Search for a lecturer.....',
                                                    hintStyle: textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                      fontSize: 13,
                                                      color: kGry800,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color:
                                                                        kTransparent)),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color:
                                                                        kTransparent)),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color:
                                                                        kTransparent)),
                                                    contentPadding:
                                                        const EdgeInsets.only(),
                                                    prefixIcon:
                                                        SvgPicture.asset(
                                                      AssetPaths.searchIcon,
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  cursorColor: kBlack,
                                                ),
                                              ),
                                            ],
                                          ),
                                          YBox(kRegularPadding),
                                          Container(
                                            width: screenSize.width,
                                            decoration: const BoxDecoration(
                                              color: kPrimaryWhite,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7)),
                                            ),
                                            child: LecturersListView(
                                              lecturers: lecturers,
                                            ),
                                          ),
                                        ],
                                      ),
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
                      namePlaceholder: lecturer,
                      actionButton: CustomTextButton(
                        text: addLecturer,
                        isLoading: false,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddLecturers(),
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
                    namePlaceholder: lecturer,
                    actionButton: CustomTextButton(
                      text: addLecturer,
                      isLoading: false,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddLecturers(),
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
