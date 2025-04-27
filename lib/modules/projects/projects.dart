import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/projects_card.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/model/project_paper.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class Projects extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const Projects({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends ConsumerState<Projects> {
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  final TextEditingController _searchTextField = TextEditingController();
  String? selectedCourseCategory;
  bool _showSignOut = false;

  @override
  void initState() {
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    super.initState();
  }

  Future<String?> _showMenu({
    required BuildContext context,
    required double width,
    required List<String> listItems,
  }) async {
    final result = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(
        100,
        120,
        60,
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          width: 0.2,
        ),
      ),
      items: List<PopupMenuItem<String>>.generate(
        listItems.length,
        (int index) {
          String name = listItems[index];
          return PopupMenuItem<String>(
            value: name,
            height: 35,
            child: SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 13,
                      bottom: 13,
                    ),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: kGry800,
                      ),
                    ),
                  ),
                  (index != listItems.length - 1)
                      ? Container(
                          height: 0.3,
                          width: width,
                          decoration: const BoxDecoration(
                            color: kGry800,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
    return result;
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
                                        style: textTheme.titleMedium!.copyWith(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kRegularPadding,
                          vertical: kSmallPadding,
                        ),
                        child: Text(
                          allProjectsPapers,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: (!kIsWeb || isPhoneWeb) ? 18 : 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      (!kIsWeb || isPhoneWeb)
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: kRegularPadding,
                                right: kRegularPadding,
                                top: kSmallPadding,
                                bottom: kSmallPadding,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: kPadding,
                                    ),
                                    child: Container(
                                      height: 40,
                                      width: screenSize.width,
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
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          hintText: 'Search.....',
                                          hintStyle:
                                              textTheme.titleMedium!.copyWith(
                                            fontSize: 15,
                                            color: kGry800,
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                            bottom: kPadding,
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: kSmallPadding,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        final selected = await _showMenu(
                                          context: context,
                                          width: 400,
                                          listItems: courseCategory,
                                        );
                                        setState(() {
                                          selectedCourseCategory = selected;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          color: kPrimaryWhite,
                                          border: Border.all(
                                            color: kGry800,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: kSmallPadding,
                                              ),
                                              child: Text(
                                                selectedCourseCategory ??
                                                    'Categories',
                                                style: textTheme.titleMedium!
                                                    .copyWith(
                                                  fontSize: 15,
                                                  color: kGry800,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  right: kSmallPadding),
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 25,
                                                color: kGry800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: kRegularPadding,
                                right: kLargePadding * 3,
                                top: kSmallPadding,
                                bottom: kSmallPadding,
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: kLargePadding,
                                      ),
                                      child: Container(
                                        height: 32,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
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
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                            hintText: 'Search.....',
                                            hintStyle:
                                                textTheme.titleMedium!.copyWith(
                                              fontSize: 13,
                                              color: kGry800,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(
                                              bottom: kPadding * 2.5,
                                            ),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: kLargePadding,
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          final selected = await _showMenu(
                                            context: context,
                                            width: 400,
                                            listItems: courseCategory,
                                          );
                                          setState(() {
                                            selectedCourseCategory = selected;
                                          });
                                        },
                                        child: Container(
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                            color: kPrimaryWhite,
                                            border: Border.all(
                                              color: kGry800,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: kSmallPadding,
                                                ),
                                                child: Text(
                                                  selectedCourseCategory ??
                                                      'Categories',
                                                  style: textTheme.titleMedium!
                                                      .copyWith(
                                                    fontSize: 13,
                                                    color: kGry800,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    right: kSmallPadding),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 23,
                                                  color: kGry800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: kRegularPadding,
                                      vertical: kPadding,
                                    ),
                                    child: Wrap(
                                      spacing: kSmallPadding,
                                      runSpacing: kRegularPadding,
                                      children: List.generate(
                                        projectPapers.length,
                                        (index) {
                                          return ProjectsCard(
                                            title: projectPapers[index].title,
                                            writtenBy:
                                                projectPapers[index].writtenBy,
                                            avatarPath: AssetPaths.avatar,
                                            onTap: () {},
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      7,
                                      (index) {
                                        return Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: kSmallPadding,
                                                  horizontal: kRegularPadding,
                                                ),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[200]!,
                                                  highlightColor:
                                                      Colors.grey[50]!,
                                                  child: Container(
                                                    height: 130,
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
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }
                              default:
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    7,
                                    (index) {
                                      return Row(
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: kSmallPadding,
                                                horizontal: kRegularPadding,
                                              ),
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey[200]!,
                                                highlightColor:
                                                    Colors.grey[50]!,
                                                child: Container(
                                                  height: 130,
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
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                            }
                          }),
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
