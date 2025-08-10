import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_one.dart';
import 'package:systems_app/app/function/handle_profile_submit.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/modules/reuseables/profile_drawer.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/model/course.dart';
import 'package:systems_app/services/cloud/storage/storage.actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class UploadFile extends ConsumerStatefulWidget {
  final Course course;

  const UploadFile({
    super.key,
    required this.course,
  });

  @override
  ConsumerState<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends ConsumerState<UploadFile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  late final StorageAsyncNotifier _storage;
  late DropzoneViewController dropController;
  bool isHighlighted = false;
  List<String> filenames = [];
  List<bool> uploadCompleted = [];
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _prefix;
  late final TextEditingController _levelCourseAdvisor;
  late final TextEditingController _currentLevel;
  late final TextEditingController _email;
  bool _isProfileEditLoading = false;

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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'jpeg',
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx'
      ],
    );

    if (result != null && result.files.isNotEmpty) {
      final files = result.files;

      for (var file in files) {
        setState(() {
          filenames.add(file.name);
          uploadCompleted.add(false);
        });
        try {
          final url = await _storage.addMaterialToCourse(
            course: widget.course,
            uid: _auth.currentUser!.uid,
            filename: file.name,
            bytes: file.bytes!,
            path: file.path!,
          );

          await _database.addMaterialToCourse(
            courseId: widget.course.courseId,
            courseCode: widget.course.courseCode,
            materialName: file.name.replaceAll('.', '_dot_'),
            materialUrl: url,
          );

          setState(() {
            final index = filenames.indexOf(file.name);
            if (index != -1) {
              uploadCompleted[index] = true;
            }
          });

          CustomSnackBarOne.show(
            context,
            '${file.name} uploaded successfully',
            40,
          );

          await Future.delayed(const Duration(seconds: 2));

          setState(() {
            final index = filenames.indexOf(file.name);
            if (index != -1) {
              filenames.removeAt(index);
              uploadCompleted.removeAt(index);
            }
          });
        } catch (e) {
          log('${e}');
        }
      }
    }
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
        backgroundColor: kGry400,
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
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                (!kIsWeb || isPhoneWeb)
                    ? Container()
                    : Container(
                        color: kPrimaryWhite,
                        child: Padding(
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
                      ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      DropzoneView(
                        operation: DragOperation.copy,
                        cursor: CursorType.Default,
                        onCreated: (ctrl) => dropController = ctrl,
                        onHover: () => setState(() => isHighlighted = true),
                        onLeave: () => setState(() => isHighlighted = false),
                        onDropFile: (file) async {
                          final name = file.name.toLowerCase();
                          final extension = name.split('.').last;

                          // Validate extension
                          if (!allowedExtensions.contains(extension)) {
                            setState(() {
                              isHighlighted = false;
                            });
                            log('Rejected file: $name');
                            return;
                          }

                          try {
                            final bytes =
                                await dropController.getFileData(file);

                            setState(() {
                              isHighlighted = false;
                              filenames.add(file.name);
                              uploadCompleted.add(false);
                            });

                            // Upload logic (same as _pickFile)
                            final url = await _storage.addMaterialToCourse(
                              course: widget.course,
                              uid: _auth.currentUser!.uid,
                              filename: name,
                              bytes: bytes,
                              path: '',
                            );

                            await _database.addMaterialToCourse(
                              courseId: widget.course.courseId,
                              courseCode: widget.course.courseCode,
                              materialName: file.name,
                              materialUrl: url,
                            );

                            setState(() {
                              final index = filenames.indexOf(file.name);
                              if (index != -1) {
                                uploadCompleted[index] = true;
                              }
                            });

                            CustomSnackBarOne.show(
                              context,
                              '${file.name} uploaded successfully',
                              40,
                            );

                            await Future.delayed(const Duration(seconds: 2));

                            setState(() {
                              final index = filenames.indexOf(file.name);
                              if (index != -1) {
                                filenames.removeAt(index);
                                uploadCompleted.removeAt(index);
                              }
                            });
                          } catch (e) {
                            log('Upload error: $e');
                            setState(() {
                              isHighlighted = false;
                            });
                          }
                        },
                      ),
                      Container(
                        color: isHighlighted
                            ? kDarkYellow.withOpacity(0.1)
                            : kTransparent,
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: kMicroPadding,
                            right: kMicroPadding,
                            bottom: kMicroPadding,
                            top: kLargePadding,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryWhite,
                            borderRadius: BorderRadius.circular(10),
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
                                'Files can be JPG, PNG, PDF, DOCX, PPTX...',
                                style: textTheme.headlineSmall!.copyWith(
                                  fontSize: 10,
                                  color: kGry800,
                                ),
                              ),
                              YBox(kLargePadding),
                              TextButton(
                                onPressed: () async {
                                  _pickFile();
                                },
                                style: ButtonStyle(
                                  padding: const WidgetStatePropertyAll(
                                      EdgeInsets.zero),
                                  backgroundColor: const WidgetStatePropertyAll(
                                      kPrimaryWhite),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  overlayColor:
                                      WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.hovered)) {
                                        return kDarkYellow
                                            .withOpacity(0.1); // hover color
                                      }
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return kDarkYellow
                                            .withOpacity(0.2); // press color
                                      }
                                      return null; // default
                                    },
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kLargePadding * 1.5,
                                    vertical: kRegularPadding,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    border: DashedBorder(
                                      dashLength: 5,
                                      left: BorderSide(
                                          color: kDarkYellow, width: 1.5),
                                      top: BorderSide(
                                          color: kDarkYellow, width: 1.5),
                                      right: BorderSide(
                                          color: kDarkYellow, width: 1.5),
                                      bottom: BorderSide(
                                          color: kDarkYellow, width: 1.5),
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
                                        style:
                                            textTheme.headlineSmall!.copyWith(
                                          fontSize: 10,
                                          color: kGry800,
                                        ),
                                      ),
                                      YBox(kPadding),
                                      Text(
                                        'drag and drop your file here',
                                        style:
                                            textTheme.headlineSmall!.copyWith(
                                          fontSize: 10,
                                          color: kGry800,
                                        ),
                                      ),
                                      YBox(kRegularPadding),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kRegularPadding,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            left: kRegularPadding + 3,
                                            right: kRegularPadding + 3,
                                            bottom: kSmallPadding,
                                            top: kSmallPadding,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kDarkYellow,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            browseFile,
                                            style:
                                                textTheme.titleSmall!.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: filenames.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kSmallPadding,
                                vertical: kSmallPadding,
                              ),
                              child: SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (uploadCompleted.isNotEmpty &&
                                            uploadCompleted[index] == true)
                                        ? const Icon(
                                            Icons.check,
                                            size: 18,
                                            color: kGreenSuccess,
                                          )
                                        : const SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: CircularProgressIndicator(
                                              color: kPrimaryColor,
                                              strokeWidth: 1.5,
                                            ),
                                          ),
                                    XBox(kSmallPadding),
                                    SizedBox(
                                      width: 300,
                                      child: Text(
                                        filenames[index],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 12,
                                          color: kBlack,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      (!kIsWeb || isPhoneWeb)
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: kMacroPadding,
                                  left: kMediumPadding,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    navigatorKey.currentState?.pop();
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
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
