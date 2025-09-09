import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/function/handle_profile_submit.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/profile_drawer.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/storage/storage.actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';
import 'package:systems_app/utils/text_field_comp.dart';

class AddAcademicFile extends ConsumerStatefulWidget {
  const AddAcademicFile({super.key});

  @override
  ConsumerState<AddAcademicFile> createState() => _AddAcademicFileState();
}

class _AddAcademicFileState extends ConsumerState<AddAcademicFile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AuthenticationAsyncNotifier _auth;
  late final DatabaseAsyncNotifier _database;
  late final StorageAsyncNotifier _storage;
  late final TextEditingController _title;
  late final TextEditingController _author;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _prefix;
  late final TextEditingController _levelCourseAdvisor;
  late final TextEditingController _currentLevel;
  late final TextEditingController _email;
  late final TextEditingController _category;
  bool _isProfileEditLoading = false;
  PlatformFile? _bookPicked;
  PlatformFile? _coverPicked;
  bool _isLoading = false;
  bool _isCoverUploaded = false;
  bool _isFileUploaded = false;
  String _bookFilename = '';
  String _coverFilename = '';
  bool _showSignOut = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _storage = ref.read(storageAsyncNotifierProvider.notifier);
    _title = TextEditingController();
    _author = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _prefferedAcademicName = TextEditingController();
    _prefix = TextEditingController();
    _levelCourseAdvisor = TextEditingController();
    _currentLevel = TextEditingController();
    _email = TextEditingController();
    _category = TextEditingController();
    setControllerText();
    super.initState();
  }

  Future<FilePickerResult?> _pickFile({required List<String> type}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type,
      allowCompression: true,
    );
    return result;
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

  void _undoController() {
    _title.clear();
    _author.clear();
    _category.clear();
    setState(() {
      _isFileUploaded = false;
      _isCoverUploaded = false;
      _bookFilename = '';
      _coverFilename = '';
      _bookPicked = null;
      _coverPicked = null;
    });
  }

  @override
  Widget build(BuildContext mainContext) {
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
                                            addNew,
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
                      ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kRegularPadding,
                      ),
                      child: Column(
                        children: [
                          (!kIsWeb || isPhoneWeb)
                              ? YBox(kMacroPadding)
                              : Container(),
                          (!kIsWeb || isPhoneWeb)
                              ? InkWell(
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
                                )
                              : Container(),
                          (!kIsWeb || isPhoneWeb)
                              ? YBox(kPadding)
                              : Container(),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: kMacroPadding,
                              vertical: kMediumPadding - 3,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryWhite,
                              border: Border.all(color: kGry500),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  addAcademicFile,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Text(
                                  academicFile,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 11 : 9,
                                    fontWeight: FontWeight.w400,
                                    color: kGry600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          YBox(kMacroPadding),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: kMacroPadding,
                              vertical: kMacroPadding,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryWhite,
                              border: Border.all(color: kGry500),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  academicFileInfo,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: kBlack,
                                  ),
                                ),
                                YBox(kMacroPadding),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 0.5,
                                        decoration: BoxDecoration(
                                            color: kGry500.withOpacity(0.8)),
                                      ),
                                    ),
                                  ],
                                ),
                                YBox(kMacroPadding),
                                CustomTextInputField(
                                  label: fileTitle,
                                  hintText: enterFileTitle,
                                  controller: _title,
                                ),
                                YBox(kMacroPadding),
                                CustomTextInputField(
                                  label: author,
                                  hintText: enterAuthorName,
                                  controller: _author,
                                ),
                                YBox(kMacroPadding),
                                CustomDropdownField(
                                  label: category,
                                  hintText: selectBookCategory,
                                  items: bookCategory,
                                  controller: _category,
                                ),
                                YBox(kMacroPadding),
                                Text(
                                  uploadCoverImage,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 16 : 13,
                                    fontWeight: FontWeight.w400,
                                    color: kBlack,
                                  ),
                                ),
                                YBox(kSmallPadding),
                                Text(
                                  uploadOneSupportedImage,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 11,
                                    fontWeight: FontWeight.w400,
                                    color: kGry600,
                                  ),
                                ),
                                YBox(kSmallPadding),
                                _isCoverUploaded
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kSmallPadding,
                                          vertical: kPadding + 3,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(color: kGry450),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Transform.translate(
                                              offset: const Offset(0, 2),
                                              child: Text(
                                                _coverFilename,
                                                style: textTheme.titleMedium!
                                                    .copyWith(
                                                  fontSize:
                                                      (!kIsWeb || isPhoneWeb)
                                                          ? 14
                                                          : 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: kBlack,
                                                ),
                                              ),
                                            ),
                                            XBox(kPadding),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isCoverUploaded = false;
                                                  _coverPicked = null;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.cancel,
                                                color: kPrimaryColor,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () async {
                                          final result = await _pickFile(type: [
                                            'jpg',
                                            'png',
                                            'jpeg',
                                          ]);
                                          if (result != null &&
                                              result.files.isNotEmpty) {
                                            setState(() {
                                              _isCoverUploaded = true;
                                              _coverFilename =
                                                  result.files.first.name;
                                              _coverPicked = result.files.first;
                                            });
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kSmallPadding,
                                            vertical: kSmallPadding,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            side: const BorderSide(
                                                color: kGry450),
                                          ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.file_upload,
                                              color: kPrimaryColor,
                                              size: 20,
                                            ),
                                            XBox(kPadding),
                                            Transform.translate(
                                              offset: const Offset(0, 2),
                                              child: Text(
                                                addFile,
                                                style: textTheme.titleMedium!
                                                    .copyWith(
                                                  fontSize:
                                                      (!kIsWeb || isPhoneWeb)
                                                          ? 14
                                                          : 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                            XBox(kSmallPadding),
                                          ],
                                        ),
                                      ),
                                YBox(kMicroPadding),
                                Text(
                                  uploadFile,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 16 : 13,
                                    fontWeight: FontWeight.w400,
                                    color: kBlack,
                                  ),
                                ),
                                YBox(kSmallPadding),
                                Text(
                                  uploadOneSupportedPDF,
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 11,
                                    fontWeight: FontWeight.w400,
                                    color: kGry600,
                                  ),
                                ),
                                YBox(kSmallPadding),
                                _isFileUploaded
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kSmallPadding,
                                          vertical: kPadding + 3,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(color: kGry450),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Transform.translate(
                                              offset: const Offset(0, 2),
                                              child: Text(
                                                _bookFilename,
                                                style: textTheme.titleMedium!
                                                    .copyWith(
                                                  fontSize:
                                                      (!kIsWeb || isPhoneWeb)
                                                          ? 14
                                                          : 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: kBlack,
                                                ),
                                              ),
                                            ),
                                            XBox(kPadding),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isFileUploaded = false;
                                                  _bookPicked = null;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.cancel,
                                                color: kPrimaryColor,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () async {
                                          final result = await _pickFile(type: [
                                            'pdf',
                                          ]);
                                          if (result != null &&
                                              result.files.isNotEmpty) {
                                            setState(() {
                                              _isFileUploaded = true;
                                              _bookFilename =
                                                  result.files.first.name;
                                              _bookPicked = result.files.first;
                                            });
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kSmallPadding,
                                            vertical: kSmallPadding,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            side: const BorderSide(
                                                color: kGry450),
                                          ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.file_upload,
                                              color: kPrimaryColor,
                                              size: 20,
                                            ),
                                            XBox(kPadding),
                                            Transform.translate(
                                              offset: const Offset(0, 2),
                                              child: Text(
                                                addFile,
                                                overflow: TextOverflow.ellipsis,
                                                style: textTheme.titleMedium!
                                                    .copyWith(
                                                  fontSize:
                                                      (!kIsWeb || isPhoneWeb)
                                                          ? 14
                                                          : 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                            XBox(kSmallPadding),
                                          ],
                                        ),
                                      ),
                                YBox(kMacroPadding),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 0.5,
                                        decoration: BoxDecoration(
                                            color: kGry500.withOpacity(0.8)),
                                      ),
                                    ),
                                  ],
                                ),
                                YBox(kMacroPadding),
                                Row(
                                  children: [
                                    CustomTextButton(
                                      text: submit,
                                      onPressed: () {},
                                      isLoading: _isLoading,
                                      backgroundColor: kDarkYellow,
                                      textColor: kPrimaryWhite,
                                      borderColor: kTransparent,
                                      padding: EdgeInsets.only(
                                        left: kMacroPadding - 3,
                                        right: kMacroPadding,
                                        top: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 4
                                            : kRegularPadding + 4,
                                        bottom: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 1
                                            : kRegularPadding + 1,
                                      ),
                                    ),
                                    XBox(kMacroPadding),
                                    CustomTextButton(
                                      text: cancel,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      isLoading: false,
                                      backgroundColor: kRed.withOpacity(0.25),
                                      textColor: kRed,
                                      borderColor: kTransparent,
                                      padding: EdgeInsets.only(
                                        left: kMacroPadding - 3,
                                        right: kMacroPadding,
                                        top: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 4
                                            : kRegularPadding + 4,
                                        bottom: (!kIsWeb || isPhoneWeb)
                                            ? kSmallPadding + 1
                                            : kRegularPadding + 1,
                                      ),
                                    ),
                                  ],
                                ),
                                YBox(kMediumPadding),
                              ],
                            ),
                          ),
                          YBox(kFullPadding),
                        ],
                      ),
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
