import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_for_empty_field.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/dialogs/success_dialog.dart';
import 'package:systems_app/app/function/reference.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/storage/cloud_storage_exception.dart';
import 'package:systems_app/services/cloud/storage/storage.actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';
import 'package:systems_app/utils/text_field_comp.dart';

class AddProjectPaper extends ConsumerStatefulWidget {
  const AddProjectPaper({
    super.key,
  });

  @override
  ConsumerState<AddProjectPaper> createState() => _AddProjectPaperState();
}

class _AddProjectPaperState extends ConsumerState<AddProjectPaper> {
  late final AuthenticationAsyncNotifier _auth;
  late final DatabaseAsyncNotifier _database;
  late final StorageAsyncNotifier _storage;
  late final TextEditingController _projectTitle;
  late final TextEditingController _writtenBy;
  PlatformFile? _paperPicked;
  bool _isLoading = false;
  bool _isPaperUploaded = false;
  String _paperFilename = '';
  bool _showSignOut = false;

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _storage = ref.read(storageAsyncNotifierProvider.notifier);
    _projectTitle = TextEditingController();
    _writtenBy = TextEditingController();
    super.initState();
  }

  Future<FilePickerResult?> _pickFile({required List<String> type}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type,
    );
    return result;
  }

  void _undoController() {
    _projectTitle.clear();
    _writtenBy.clear();
    setState(() {
      _isPaperUploaded = false;
      _paperFilename = '';
      _paperPicked = null;
    });
  }

  @override
  Widget build(BuildContext mainContext) {
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
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kRegularPadding,
                    ),
                    child: Column(
                      children: [
                        YBox(kMacroPadding),
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
                                addAProjectPaper,
                                style: textTheme.titleMedium!.copyWith(
                                  fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                projectPaper,
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
                                projectInfo,
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
                                label: projectTitle,
                                hintText: enterProjectTitle,
                                controller: _projectTitle,
                              ),
                              YBox(kMacroPadding),
                              CustomTextInputField(
                                label: writtenBy,
                                hintText: enterStudentName,
                                controller: _writtenBy,
                              ),
                              YBox(kMacroPadding),
                              Text(
                                uploadProjectPaper,
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
                              _isPaperUploaded
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: kSmallPadding,
                                        vertical: kPadding + 3,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: kGry450),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Transform.translate(
                                            offset: const Offset(0, 2),
                                            child: Text(
                                              _paperFilename,
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
                                                _isPaperUploaded = false;
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
                                            _isPaperUploaded = true;
                                            _paperFilename =
                                                result.files.first.name;
                                            _paperPicked = result.files.first;
                                          });
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kSmallPadding,
                                          vertical: kPadding + 3,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side:
                                              const BorderSide(color: kGry450),
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
                                    onPressed: () async {
                                      final title = _projectTitle.text;
                                      final writtenBy = _writtenBy.text;
                                      final pickedfile = _paperPicked;
                                      if (title.isEmpty ||
                                          writtenBy.isEmpty ||
                                          pickedfile == null) {
                                        CustomSnackBarForEmptyField.show(
                                          mainContext,
                                          'Field must not be empty',
                                          40,
                                        );
                                      } else {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        LoadingScreen().show(
                                            context: mainContext,
                                            showProgress: false);
                                        try {
                                          final url =
                                              await _storage.addProjectPaper(
                                            title: title,
                                            path: pickedfile.path!,
                                            bytes: pickedfile.bytes!,
                                            projectSupervisorUid:
                                                _auth.currentUser!.uid,
                                          );
                                          final profile = await _database
                                              .getUserProfile(
                                                ownerUserId:
                                                    _auth.currentUser!.uid,
                                                role: lecturerRole,
                                              )
                                              .first;
                                          await _database.addProjectPaper(
                                            title: title,
                                            writtenBy: writtenBy,
                                            coordinatorName:
                                                profile.preferredAcademicName,
                                            paperUrl: url,
                                            id: generateReference(),
                                          );
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          LoadingScreen().hide();
                                          _undoController();
                                          await showSuccessDialog(
                                            context: mainContext,
                                            name: title,
                                            buttonText: addProjectPaper,
                                            placeholder: projectPaper,
                                          );
                                        } on Exception catch (e) {
                                          if (mounted) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            LoadingScreen().hide();
                                            if (e is ErrorUploadingFile) {
                                              showErrorDialog(
                                                context: mainContext,
                                                text: 'Error uploading file',
                                              );
                                            } else {
                                              showErrorDialog(
                                                context: mainContext,
                                                text: 'Try again later',
                                              );
                                            }
                                          }
                                        }
                                      }
                                    },
                                    isLoading: _isLoading,
                                    backgroundColor: kDarkYellow,
                                    textColor: kPrimaryWhite,
                                    borderColor: kTransparent,
                                    padding: const EdgeInsets.only(
                                      left: kMacroPadding - 3,
                                      right: kMacroPadding,
                                      top: kRegularPadding + 4,
                                      bottom: kRegularPadding + 1,
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
                                    padding: const EdgeInsets.only(
                                      left: kMacroPadding - 3,
                                      right: kMacroPadding,
                                      top: kRegularPadding + 4,
                                      bottom: kRegularPadding + 1,
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
