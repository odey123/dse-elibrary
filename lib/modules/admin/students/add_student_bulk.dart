import 'dart:convert';
import 'dart:developer';

import 'package:fast_csv/fast_csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/custom_snack_bar/custom_snack_bar_for_empty_field.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/dialogs/onboarding_success_dialog.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/function/functions_actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';

class AddStudentBulk extends ConsumerStatefulWidget {
  const AddStudentBulk({super.key});

  @override
  ConsumerState<AddStudentBulk> createState() => _AddStudentSingleState();
}

class _AddStudentSingleState extends ConsumerState<AddStudentBulk> {
  late final AuthenticationAsyncNotifier _auth;
  late final FunctionsAsyncNotifier _function;
  PlatformFile? _filePicked;
  bool _isFileUploaded = false;
  bool _isLoading = false;
  bool _showSignOut = false;
  bool isCsvValid = true;
  String _filename = '';

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _function = ref.read(functionsAsyncNotifierProvider.notifier);

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

  List<Map<String, String>> parseCsvToMap(String csvString) {
    List<List<String>> rows = parse(csvString);
    List<String> headers = rows.first;
    return rows.skip(1).map((row) {
      return Map.fromIterables(headers, row);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _getDataFromFile({
    required PlatformFile file,
  }) async {
    List<Map<String, dynamic>> students = [];
    final fileBytes = file.bytes;
    if (fileBytes != null) {
      try {
        final csvData = utf8.decode(fileBytes);
        List<Map<String, String>> rows = parseCsvToMap(csvData).toList();

        for (int i = 0; i < rows.length; i++) {
          var student = rows[i];
          students.add(student);
        }
      } catch (e) {
        log("Error parsing CSV: $e");
      }
    }
    return students;
  }

  List<String> _validateCsvData(List<Map<String, dynamic>> students) {
    List<String> errors = [];

    for (int i = 0; i < students.length; i++) {
      var student = students[i];

      String? firstName = student['First Name'];
      String? lastName = student['Last Name'];
      String? email = student['Email'];
      String? gender = student['Gender'];
      String? level = student['Level'];

      if (firstName == null || firstName.isEmpty) {
        errors.add('Row ${i + 2}: First name is required.');
      }
      if (lastName == null || lastName.isEmpty) {
        errors.add('Row ${i + 2}: Last name is required.');
      }
      if (email == null || email.isEmpty) {
        errors.add('Row ${i + 2}: Email is required.');
      }
      if (gender == null || gender.isEmpty) {
        errors.add('Row ${i + 2}: Gender is required.');
      }
      if (level == null || level.isEmpty) {
        errors.add('Row ${i + 2}: Level is required.');
      }
    }

    return errors;
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
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
                                          'Students',
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
                                    overlayColor: const WidgetStatePropertyAll(
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
                                addAStudent,
                                style: textTheme.titleMedium!.copyWith(
                                  fontSize: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                students,
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
                                upload,
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
                                uploadOneSupportedCSV,
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
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: kGry450),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Transform.translate(
                                            offset: const Offset(0, 2),
                                            child: Text(
                                              _filename,
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
                                                _filePicked = null;
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
                                        final result =
                                            await _pickFile(type: ['csv']);
                                        if (result != null &&
                                            result.files.isNotEmpty) {
                                          setState(() {
                                            _isFileUploaded = true;
                                            _filename = result.files.first.name;
                                            _filePicked = result.files.first;
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
                              YBox(kLargePadding),
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
                                      final pickedfile = _filePicked;
                                      if (pickedfile == null) {
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
                                          final studentsMap =
                                              await _getDataFromFile(
                                                  file: _filePicked!);
                                          final validationErrors =
                                              _validateCsvData(studentsMap);
                                          if (validationErrors.isEmpty) {
                                            await _function
                                                .onboardStudentsFromCSV(
                                              students: studentsMap,
                                              adminUId: _auth.currentUser!.uid,
                                            );
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            LoadingScreen().hide();
                                            await showOnboardingSuccessDialog(
                                              context: mainContext,
                                              name: theGroupOfStudents,
                                              placeholder: userString,
                                              buttonText: addStudent,
                                            );
                                          } else {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            LoadingScreen().hide();
                                            showErrorDialog(
                                              context: mainContext,
                                              text:
                                                  'This CSV is Missing some required input fields.',
                                            );
                                          }
                                        } on Exception catch (_) {
                                          if (mounted) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            LoadingScreen().hide();
                                            showErrorDialog(
                                              context: mainContext,
                                              text:
                                                  'The request took too long, please try again.',
                                            );
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
                          height: 28,
                          width: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ProfileImage(
                            imageUrl: SessionManager.getProfileImageUrl() ?? '',
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
    );
  }
}
