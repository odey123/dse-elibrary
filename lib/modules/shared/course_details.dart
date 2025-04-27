import 'package:dio/dio.dart';
import 'package:systems_app/app/dialogs/confirmation_dialog.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
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
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  late final TabController _tabController;
  String tabSelected = weeksTopics;
  bool _showSignOut = false;

  @override
  void initState() {
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kRegularPadding,
                          vertical: kPadding,
                        ),
                        child: Text(
                          '$courseTitle: ${widget.course.courseName}'
                              .toUpperCase(),
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 17,
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
                            fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 17,
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
                            fontSize: (!kIsWeb || isPhoneWeb) ? 20 : 17,
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: (!kIsWeb || isPhoneWeb) ? 20 : 18,
                                  width: (!kIsWeb || isPhoneWeb) ? 20 : 18,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(AssetPaths.avatar),
                                ),
                                const SizedBox(width: kPadding),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    widget.course.ownerName,
                                    style: textTheme.titleSmall!.copyWith(
                                      fontSize:
                                          (!kIsWeb || isPhoneWeb) ? 15 : 13,
                                      color: kBlack,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
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
                          width: (!kIsWeb || isPhoneWeb) ? 28 : 23,
                          height: (!kIsWeb || isPhoneWeb) ? 28 : 23,
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
                                    ? kRegularPadding
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
                                    ? kRegularPadding
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
                                    ownerUid: widget.course.ownerUid),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        final topicsFromStream = snapshot.data
                                            as Map<String, String>;
                                        if (topicsFromStream.isEmpty) {
                                          return (widget.course.ownerUid ==
                                                  widget.userUid)
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
                                                          builder: (context) =>
                                                              AddTopic(
                                                            course:
                                                                widget.course,
                                                          ),
                                                        ));
                                                      },
                                                      backgroundColor:
                                                          kDarkYellow,
                                                      textColor: kPrimaryWhite,
                                                      borderColor: kTransparent,
                                                      icon: Icons.add,
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
                                                    style: textTheme.bodyMedium!
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
                                              (widget.course.ownerUid ==
                                                      widget.userUid)
                                                  ? InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddTopic(
                                                            course:
                                                                widget.course,
                                                          ),
                                                        ));
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
                                                              ? kRegularPadding
                                                              : kPadding + 2,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kPrimaryColor,
                                                          borderRadius:
                                                              BorderRadius.all(
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
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons.add,
                                                              color:
                                                                  kPrimaryWhite,
                                                              size: 15,
                                                            ),
                                                            XBox(kPadding),
                                                            Transform.translate(
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
                                    ownerUid: widget.course.ownerUid),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        final materialsFromStream = snapshot
                                            .data as Map<String, String>;
                                        if (materialsFromStream.isEmpty) {
                                          return (widget.course.ownerUid ==
                                                  widget.userUid)
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
                                                          builder: (context) =>
                                                              UploadFile(
                                                            course:
                                                                widget.course,
                                                          ),
                                                        ));
                                                      },
                                                      backgroundColor:
                                                          kDarkYellow,
                                                      textColor: kPrimaryWhite,
                                                      borderColor: kTransparent,
                                                      icon: Icons.add,
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
                                                    style: textTheme.bodyMedium!
                                                        .copyWith(
                                                      color: kBlack,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                );
                                        }
                                        return SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: kRegularPadding,
                                              vertical: kSmallPadding,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (widget.course.ownerUid ==
                                                        widget.userUid)
                                                    ? InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      UploadFile(
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
                                                                ? kRegularPadding
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
                                                                  addNewMaterial,
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
                                                ...materialsFromStream.entries
                                                    .map(
                                                  (entry) {
                                                    final materialName =
                                                        entry.key.replaceAll(
                                                            '_dot_', '.');
                                                    final url = entry.value;
                                                    return MaterialCard(
                                                      title: materialName,
                                                      url: url,
                                                      coordinatorName: widget
                                                          .course.ownerName,
                                                      avatarPath:
                                                          AssetPaths.avatar,
                                                      onTap: () async {
                                                        final checker =
                                                            await confirmationDialog(
                                                          context: context,
                                                          mounted: mounted,
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
