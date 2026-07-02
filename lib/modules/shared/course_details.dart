import 'package:dio/dio.dart';
import 'package:systems_app/app/dialogs/confirmation_dialog.dart';
import 'package:systems_app/app/function/handle_profile_submit.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/modules/reuseables/profile_drawer.dart';
import 'package:systems_app/modules/shared/course_coordinator_list_view.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/cloud_profile.dart';
import 'package:systems_app/services/cloud/storage/storage.actions.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/modules/my_courses/add_topic.dart';
import 'package:systems_app/modules/reuseables/material_card.dart';
import 'package:systems_app/modules/shared/upload_file.dart';
import 'package:systems_app/modules/shared/week_topic_list_view.dart';
import 'package:systems_app/modules/reuseables/empty_state_widget.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/model/course.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';
import 'package:systems_app/modules/ai_chat/ai_chat_sidebar.dart';
import 'package:systems_app/modules/ai_chat/audio_summary_player.dart';

class CourseDetailScreen extends ConsumerStatefulWidget {
  final Course course;
  final String userUid;

  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.userUid,
  });

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  late final StorageAsyncNotifier _storage;
  late final TabController _tabController;
  String tabSelected = weeksTopics;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _prefix;
  late final TextEditingController _levelCourseAdvisor;
  late final TextEditingController _currentLevel;
  late final TextEditingController _email;
  bool _isProfileEditLoading = false;
  bool _showChat = false;
  bool _showAudioPlayer = false;
  String? _audioMaterialUrl;
  String? _audioMaterialName;
  Map<String, String> _courseMaterials = {};

  @override
  void initState() {
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _storage = ref.read(storageAsyncNotifierProvider.notifier);
    _tabController = TabController(length: 2, vsync: this);
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

  Future<void> downloadFile(String url, String filename) async {
    if (kIsWeb) {
      html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
    } else {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final savePath = '${dir.path}/$filename';
        final response = await Dio().download(url, savePath);

        if (response.statusCode == 200) {
          debugPrint('Downloaded to $savePath');
          // Optionally show a snackbar or open the file
        } else {
          debugPrint('Download failed');
        }
      } catch (e) {
        debugPrint('Error downloading file: $e');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!kIsWeb || isPhoneWeb) {
          if (!didPop) {
            navigatorKey.currentState?.pop();
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: ProfileDrawer(
          firstNameController: _firstName,
          lastNameController: _lastName,
          emailController: _email,
          levelController: SessionManager.getRole() == lecturerRole ||
                  SessionManager.getRole() == hodRole
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
              isLecturer: SessionManager.getRole() == lecturerRole ||
                  SessionManager.getRole() == hodRole,
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
          isLecturer: SessionManager.getRole() == lecturerRole ||
              SessionManager.getRole() == hodRole,
          isLoading: _isProfileEditLoading,
        ),
        floatingActionButton: _courseMaterials.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    _showChat = !_showChat;
                  });
                },
                backgroundColor: kPrimaryColor,
                icon: Icon(
                  _showChat ? Icons.close : Icons.chat_rounded,
                  color: kPrimaryWhite,
                ),
                label: Text(
                  _showChat ? 'Close Chat' : 'Ask AI',
                  style: textTheme.titleMedium!.copyWith(
                    color: kPrimaryWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              )
            : null,
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
                                          'Back',
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
                                  navigatorKey.currentState?.pop();
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: kRegularPadding,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kPadding,
                          ),
                          child: Text(
                            '$courseTitle: ${widget.course.courseName}'
                                .toUpperCase(),
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 17,
                              color: kBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kPadding,
                          ),
                          child: Text(
                            '$courseCODE: ${widget.course.courseCode}'
                                .toUpperCase(),
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 17,
                              color: kBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kPadding,
                          ),
                          child: Text(
                            '$units: ${widget.course.unit}'.toUpperCase(),
                            style: textTheme.titleMedium!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 17,
                              color: kBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        YBox(kSmallPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Course co-ordinator',
                                style: textTheme.titleSmall!.copyWith(
                                  fontSize: (!kIsWeb || isPhoneWeb) ? 13 : 11,
                                  color: kGry800,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: kSmallPadding),
                              FutureBuilder(
                                future: _database.getLecturerProfiles(
                                  uids: widget.course.ownerUids,
                                ),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.done:
                                      if (snapshot.hasData) {
                                        final profile =
                                            snapshot.data as List<CloudProfile>;
                                        return CourseCoordinatorListView(
                                          profiles: profile,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    default:
                                      return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        YBox(kSmallPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kPadding,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: (!kIsWeb || isPhoneWeb) ? 15 : 14,
                                height: (!kIsWeb || isPhoneWeb) ? 17 : 16,
                                child: SvgPicture.asset(
                                  AssetPaths.paperIcon,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  '${widget.course.unit} Units',
                                  style: textTheme.titleSmall!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 13 : 11,
                                    color: kGry800,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        YBox(kSmallPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                            vertical: kPadding,
                          ),
                          child: Container(
                            width: (!kIsWeb || isPhoneWeb) ? 26 : 23,
                            height: (!kIsWeb || isPhoneWeb) ? 26 : 23,
                            padding: const EdgeInsets.only(
                              bottom: kPadding + 2,
                              top: kPadding - 2,
                            ),
                            decoration: const BoxDecoration(
                              color: kDarkYellow,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              AssetPaths.arrowDownward,
                            ),
                          ),
                        ),
                        YBox(kRegularPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kRegularPadding,
                          ),
                          child: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabAlignment: TabAlignment.start,
                            indicatorColor: kTransparent,
                            indicatorWeight: 1.5,
                            labelPadding: EdgeInsets.zero,
                            overlayColor: WidgetStateProperty.all(kTransparent),
                            tabs: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: (!kIsWeb || isPhoneWeb)
                                      ? kMicroPadding
                                      : kMediumPadding,
                                  vertical: (!kIsWeb || isPhoneWeb)
                                      ? kSmallPadding
                                      : kPadding + 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _tabController.index == 0
                                      ? kDarkYellow
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      (!kIsWeb || isPhoneWeb) ? 8 : 6,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  weeksTopics,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                                    color: _tabController.index == 0
                                        ? kPrimaryWhite
                                        : kBlack,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: (!kIsWeb || isPhoneWeb)
                                      ? kMicroPadding
                                      : kMediumPadding,
                                  vertical: (!kIsWeb || isPhoneWeb)
                                      ? kSmallPadding
                                      : kPadding + 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _tabController.index == 1
                                      ? kDarkYellow
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      (!kIsWeb || isPhoneWeb) ? 8 : 6,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  materials,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                                    color: _tabController.index == 1
                                        ? kPrimaryWhite
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
                        YBox(kRegularPadding),
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 750,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                StreamBuilder(
                                  stream: _database.streamCourseTopics(
                                      courseId: widget.course.courseId,
                                      courseCode: widget.course.courseCode),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.active:
                                        if (snapshot.hasData) {
                                          final topicsFromStream = snapshot.data
                                              as Map<String, String>;
                                          if (topicsFromStream.isEmpty) {
                                            return (widget.course.ownerUids.any(
                                                    (uid) =>
                                                        uid == widget.userUid))
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: kFullPadding,
                                                      vertical: kSmallPadding,
                                                    ),
                                                    child: EmptyStateWidgetTwo(
                                                      namePlaceholder: topics,
                                                      actionButton:
                                                          CustomTextButton(
                                                        text: addNewTopic,
                                                        isLoading: false,
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddTopic(
                                                              course:
                                                                  widget.course,
                                                            ),
                                                          ));
                                                        },
                                                        backgroundColor:
                                                            kDarkYellow,
                                                        textColor:
                                                            kPrimaryWhite,
                                                        borderColor:
                                                            kTransparent,
                                                        icon: Icons.add,
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: kMediumPadding -
                                                              3,
                                                          right: kMediumPadding,
                                                          top: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? kSmallPadding +
                                                                  4
                                                              : kRegularPadding +
                                                                  4,
                                                          bottom: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? kSmallPadding +
                                                                  1
                                                              : kRegularPadding +
                                                                  1,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: kFullPadding,
                                                      horizontal: kFullPadding,
                                                    ),
                                                    child: Text(
                                                      'No topic have been added yet',
                                                      style: textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                        color: kBlack,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  );
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: kRegularPadding,
                                              vertical: kSmallPadding,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (widget.course.ownerUids.any(
                                                        (uid) =>
                                                            uid ==
                                                            widget.userUid))
                                                    ? InkWell(
                                                        onTap: () {
                                                          (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? navigatorKey
                                                                  .currentState!
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AddTopic(
                                                                      course: widget
                                                                          .course,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Navigator.of(
                                                                      context)
                                                                  .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AddTopic(
                                                                      course: widget
                                                                          .course,
                                                                    ),
                                                                  ),
                                                                );
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: (!kIsWeb ||
                                                                    isPhoneWeb)
                                                                ? kMicroPadding
                                                                : kMediumPadding,
                                                            vertical: (!kIsWeb ||
                                                                    isPhoneWeb)
                                                                ? kSmallPadding
                                                                : kPadding + 2,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kPrimaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                (!kIsWeb ||
                                                                        isPhoneWeb)
                                                                    ? 8
                                                                    : 6,
                                                              ),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Icon(
                                                                Icons.add,
                                                                color:
                                                                    kPrimaryWhite,
                                                                size: 15,
                                                              ),
                                                              XBox(kPadding),
                                                              Transform
                                                                  .translate(
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
                                                                child: Text(
                                                                  addNewTopic,
                                                                  style: textTheme
                                                                      .titleMedium!
                                                                      .copyWith(
                                                                    fontSize:
                                                                        (!kIsWeb ||
                                                                                isPhoneWeb)
                                                                            ? 15
                                                                            : 12,
                                                                    color:
                                                                        kPrimaryWhite,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                YBox(kMacroPadding),
                                                WeekTopicListView(
                                                  weekAndTopics:
                                                      widget.course.weekTopics,
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              7,
                                              (index) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: kSmallPadding,
                                                    horizontal: kRegularPadding,
                                                  ),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[200]!,
                                                    highlightColor:
                                                        Colors.grey[50]!,
                                                    child: Container(
                                                      height: 30,
                                                      width: 500,
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
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      default:
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            7,
                                            (index) {
                                              return Padding(
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
                                                    height: 30,
                                                    width: 500,
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
                                              );
                                            },
                                          ),
                                        );
                                    }
                                  },
                                ),
                                StreamBuilder(
                                  stream: _database.streamCourseMaterials(
                                      courseId: widget.course.courseId,
                                      courseCode: widget.course.courseCode),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.active:
                                        if (snapshot.hasData) {
                                          final materialsFromStream = snapshot
                                              .data as Map<String, String>;
                                          // Store materials for AI chat
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (mounted) {
                                              _courseMaterials = Map.fromEntries(
                                                materialsFromStream.entries.map((e) =>
                                                  MapEntry(e.key.replaceAll('_dot_', '.'), e.value),
                                                ),
                                              );
                                            }
                                          });
                                          if (materialsFromStream.isEmpty) {
                                            return (widget.course.ownerUids.any(
                                                    (uid) =>
                                                        uid == widget.userUid))
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: kFullPadding,
                                                      vertical: kSmallPadding,
                                                    ),
                                                    child: EmptyStateWidgetTwo(
                                                      namePlaceholder: material,
                                                      actionButton:
                                                          CustomTextButton(
                                                        text: addCourseMaterial,
                                                        isLoading: false,
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    UploadFile(
                                                              course:
                                                                  widget.course,
                                                            ),
                                                          ));
                                                        },
                                                        backgroundColor:
                                                            kDarkYellow,
                                                        textColor:
                                                            kPrimaryWhite,
                                                        borderColor:
                                                            kTransparent,
                                                        icon: Icons.add,
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: kMediumPadding -
                                                              3,
                                                          right: kMediumPadding,
                                                          top: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? kSmallPadding +
                                                                  4
                                                              : kRegularPadding +
                                                                  4,
                                                          bottom: (!kIsWeb ||
                                                                  isPhoneWeb)
                                                              ? kSmallPadding +
                                                                  1
                                                              : kRegularPadding +
                                                                  1,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: kFullPadding,
                                                      horizontal: kFullPadding,
                                                    ),
                                                    child: Text(
                                                      'No materials have been added yet',
                                                      style: textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                        color: kBlack,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  );
                                          }
                                          return SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: kRegularPadding,
                                                vertical: kSmallPadding,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  (widget.course.ownerUids.any(
                                                          (uid) =>
                                                              uid ==
                                                              widget.userUid))
                                                      ? InkWell(
                                                          onTap: () {
                                                            (!kIsWeb ||
                                                                    isPhoneWeb)
                                                                ? navigatorKey
                                                                    .currentState!
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              UploadFile(
                                                                        course:
                                                                            widget.course,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Navigator.of(
                                                                        context)
                                                                    .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              UploadFile(
                                                                        course:
                                                                            widget.course,
                                                                      ),
                                                                    ),
                                                                  );
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: (!kIsWeb ||
                                                                      isPhoneWeb)
                                                                  ? kMicroPadding
                                                                  : kMediumPadding,
                                                              vertical: (!kIsWeb ||
                                                                      isPhoneWeb)
                                                                  ? kSmallPadding
                                                                  : kPadding +
                                                                      2,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kPrimaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                  (!kIsWeb ||
                                                                          isPhoneWeb)
                                                                      ? 8
                                                                      : 6,
                                                                ),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Icon(
                                                                  Icons.add,
                                                                  color:
                                                                      kPrimaryWhite,
                                                                  size: 15,
                                                                ),
                                                                XBox(kPadding),
                                                                Transform
                                                                    .translate(
                                                                  offset:
                                                                      const Offset(
                                                                          0, 2),
                                                                  child: Text(
                                                                    addNewMaterial,
                                                                    style: textTheme
                                                                        .titleMedium!
                                                                        .copyWith(
                                                                      fontSize: (!kIsWeb ||
                                                                              isPhoneWeb)
                                                                          ? 15
                                                                          : 12,
                                                                      color:
                                                                          kPrimaryWhite,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                  YBox(kMacroPadding),
                                                  ...materialsFromStream.entries
                                                      .map(
                                                    (entry) {
                                                      final materialName =
                                                          entry.key.replaceAll(
                                                              '_dot_', '.');
                                                      final url = entry.value;
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          MaterialCard(
                                                            title: materialName,
                                                            url: url,
                                                            coordinatorName: widget
                                                                .course.ownerName,
                                                            avatarPath: widget
                                                                .course
                                                                .profileImageUrl,
                                                            onTap: () async {
                                                              final checker =
                                                                  await confirmationDialog(
                                                                context: context,
                                                                body:
                                                                    'Are you sure you want to download this material',
                                                              );
                                                              if (checker) {
                                                                await downloadFile(
                                                                  url,
                                                                  materialName,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          // Audio Summary Button
                                                          Padding(
                                                            padding: const EdgeInsets.only(
                                                              left: kSmallPadding,
                                                              bottom: kSmallPadding,
                                                            ),
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  _showAudioPlayer = true;
                                                                  _audioMaterialUrl = url;
                                                                  _audioMaterialName = materialName;
                                                                });
                                                              },
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Container(
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: kSmallPadding,
                                                                  vertical: kPadding,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                  gradient: const LinearGradient(
                                                                    colors: [
                                                                      Color(0xFF6C63FF),
                                                                      Color(0xFF3498DB),
                                                                    ],
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.headphones_rounded,
                                                                      color: Colors.white,
                                                                      size: 14,
                                                                    ),
                                                                    const SizedBox(width: 5),
                                                                    Text(
                                                                      'Audio Summary',
                                                                      style: textTheme.titleSmall!.copyWith(
                                                                        color: Colors.white,
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
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
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: kSmallPadding,
                                                    horizontal: kRegularPadding,
                                                  ),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[200]!,
                                                    highlightColor:
                                                        Colors.grey[50]!,
                                                    child: Container(
                                                      height: 30,
                                                      width: 500,
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
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      default:
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            7,
                                            (index) {
                                              return Padding(
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
                                                    height: 30,
                                                    width: 500,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // AI Chat Sidebar Overlay
            if (_showChat)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showChat = false;
                    });
                  },
                  child: Container(
                    color: kBlack.withOpacity(0.3),
                  ),
                ),
              ),
            if (_showChat)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: AIChatSidebar(
                  courseId: widget.course.courseId,
                  courseName: widget.course.courseName,
                  materials: _courseMaterials,
                  onClose: () {
                    setState(() {
                      _showChat = false;
                    });
                  },
                ),
              ),
            // Audio Summary Player Overlay
            if (_showAudioPlayer && _audioMaterialUrl != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAudioPlayer = false;
                    });
                  },
                  child: Container(
                    color: kBlack.withOpacity(0.5),
                  ),
                ),
              ),
            if (_showAudioPlayer && _audioMaterialUrl != null)
              Positioned(
                left: (!kIsWeb || isPhoneWeb) ? 0 : null,
                right: (!kIsWeb || isPhoneWeb) ? 0 : 0,
                bottom: 0,
                width: (!kIsWeb || isPhoneWeb) ? null : 420,
                child: AudioSummaryPlayer(
                  materialUrl: _audioMaterialUrl!,
                  materialName: _audioMaterialName ?? 'Material',
                  courseName: widget.course.courseName,
                  onClose: () {
                    setState(() {
                      _showAudioPlayer = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
