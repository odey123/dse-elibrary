import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/app/function/handle_profile_submit.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/profile_drawer.dart';
import 'package:systems_app/modules/shared/course_details.dart';
import 'package:systems_app/modules/reuseables/course_card.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
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

class AllCourses extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const AllCourses({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<AllCourses> createState() => _AllCoursesState();
}

class _AllCoursesState extends ConsumerState<AllCourses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  late final StorageAsyncNotifier _storage;
  final TextEditingController _searchTextField = TextEditingController();
  String? selectedCourseCategory;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _prefix;
  late final TextEditingController _levelCourseAdvisor;
  late final TextEditingController _currentLevel;
  late final TextEditingController _email;
  bool _isProfileEditLoading = false;
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
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
              onLoadingStart: () =>
                  setState(() => _isProfileEditLoading = true),
              onLoadingEnd: () => setState(() => _isProfileEditLoading = false),
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
          isLoading: _isProfileEditLoading,
        ),
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
                                              final profile =
                                                  snapshot.data as CloudProfile;
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
                                                  _showSignOut = !_showSignOut;
                                                });
                                              },
                                            );
                                        }
                                      },
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
                            allCoursesFromYear1To5,
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 18 : 16,
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
                                              fontSize: 15,
                                              color: kGry800,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(
                                              bottom: kPadding,
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
                                              hintStyle: textTheme.titleMedium!
                                                  .copyWith(
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: kSmallPadding,
                                                  ),
                                                  child: Text(
                                                    selectedCourseCategory ??
                                                        'Categories',
                                                    style: textTheme
                                                        .titleMedium!
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kRegularPadding,
                          ),
                          child: Text(
                            year1,
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
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      StreamBuilder(
                                        stream: _database.getAllCourses(
                                          level: hundredLevel,
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
                            vertical: kRegularPadding,
                          ),
                          child: Text(
                            year2,
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
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      StreamBuilder(
                                        stream: _database.getAllCourses(
                                          level: twoHundedLevel,
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
                            vertical: kRegularPadding,
                          ),
                          child: Text(
                            year3,
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
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      StreamBuilder(
                                        stream: _database.getAllCourses(
                                          level: threeHundredLevel,
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
                            vertical: kRegularPadding,
                          ),
                          child: Text(
                            year4,
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
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      StreamBuilder(
                                        stream: _database.getAllCourses(
                                          level: fourHundredLevel,
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
                            vertical: kRegularPadding,
                          ),
                          child: Text(
                            year5,
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
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      StreamBuilder(
                                        stream: _database.getAllCourses(
                                          level: fiveHundredLevel,
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
      ),
    );
  }
}
