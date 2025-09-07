import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/app/dialogs/confirmation_dialog.dart';
import 'package:systems_app/app/dialogs/error_dialog.dart';
import 'package:systems_app/app/dialogs/level_upgrade_success_dialog.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_pdf_screen.dart';
import 'package:systems_app/app/loading/loading_screen.dart';
import 'package:systems_app/modules/admin/students/add_students.dart';
import 'package:systems_app/modules/admin/students/students_list_view.dart';
import 'package:systems_app/modules/reuseables/empty_state_widget.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/function/function_exception.dart';
import 'package:systems_app/services/cloud/function/functions_actions.dart';
import 'package:systems_app/services/cloud/model/student.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';

class Students extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const Students({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<Students> createState() => _StudentsState();
}

class _StudentsState extends ConsumerState<Students> {
  late final AuthenticationAsyncNotifier _auth;
  late final DatabaseAsyncNotifier _database;
  late final FunctionsAsyncNotifier _function;
  final TextEditingController _searchController = TextEditingController();
  bool _showSignOut = false;
  bool _isLoading = false;
  String _searchTerm = '';

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _function = ref.read(functionsAsyncNotifierProvider.notifier);
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
      });
    });
    super.initState();
  }

  void openFileInNewTab(Uint8List fileBytes, String mimeType, String fileName) {
    final blob = html.Blob([fileBytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = '_blank'
      ..download = fileName;

    anchor.click();

    Future.delayed(const Duration(seconds: 10), () {
      html.Url.revokeObjectUrl(url);
    });
  }

  @override
  Widget build(BuildContext mainContext) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kPrimaryWhite,
        body: StreamBuilder(
          stream: _database.getAllStudents(
            searchTerm: _searchTerm,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final students = snapshot.data as List<Student>;
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (isPhoneWeb)
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kMediumPadding,
                                    vertical: kPadding,
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
                                                    style: textTheme
                                                        .titleMedium!
                                                        .copyWith(
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
                                              decoration: const BoxDecoration(
                                                  color: kLightAsh),
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
                                  onPressed: () async {
                                    LoadingPdfScreen().show(
                                        context: mainContext,
                                        showProgress: true);
                                    try {
                                      final currentUser = _auth.currentUser;
                                      final byte =
                                          await _function.exportStudentsToCSv(
                                        uid: currentUser!.uid,
                                      );
                                      LoadingPdfScreen().hide();
                                      if (byte != null) {
                                        openFileInNewTab(
                                          byte,
                                          textCSV,
                                          'Students.csv',
                                        );
                                      }
                                    } catch (_) {}
                                  },
                                  backgroundColor: kPrimaryWhite,
                                  textColor: kDarkYellow,
                                  borderColor: kGry500,
                                  isLoading: false,
                                  padding: const EdgeInsets.only(
                                    left: kMediumPadding,
                                    right: kMediumPadding,
                                    top: kMediumPadding + 2,
                                    bottom: kMediumPadding - 2,
                                  ),
                                ),
                                XBox(kSmallPadding),
                                CustomTextButton(
                                  text: addStudent,
                                  isLoading: false,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const AddStudents(),
                                    ));
                                  },
                                  backgroundColor: kDarkYellow,
                                  textColor: kPrimaryWhite,
                                  borderColor: kTransparent,
                                  icon: Icons.add,
                                ),
                                XBox(kSmallPadding),
                                CustomTextButton(
                                  text: upgradeLevel,
                                  isLoading: _isLoading,
                                  onPressed: () async {
                                    final checker = await confirmationDialog(
                                      context: context,
                                      body:
                                          "Are you sure you want to upgrade all student level to the next level",
                                    );
                                    if (checker) {
                                      try {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        LoadingScreen().show(
                                            context: mainContext,
                                            showProgress: false);
                                        final uids = await _database
                                            .upgradeAllStudents();
                                        await _function.removeUser(
                                          uids: uids,
                                          adminUId: _auth.currentUser!.uid,
                                        );
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        LoadingScreen().hide();
                                        await levelUpgradeSuccessDialog(
                                          context: mainContext,
                                          name: firstName,
                                          buttonText: continuee,
                                        );
                                      } on Exception catch (e) {
                                        if (mounted) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          LoadingScreen().hide();
                                          if (e
                                              is PermissionDeniedFunctionException) {
                                            showErrorDialog(
                                              context: mainContext,
                                              text:
                                                  'You do not have permission to upgrade students.',
                                            );
                                          } else if (e
                                              is DeadlineExceededFunctionException) {
                                            showErrorDialog(
                                              context: mainContext,
                                              text:
                                                  'The request took too long, please try again.',
                                            );
                                          } else if (e
                                              is ResourceExhaustedFunctionException) {
                                            showErrorDialog(
                                              context: mainContext,
                                              text:
                                                  'Too many requests, please try later.',
                                            );
                                          } else if (e
                                              is GenericFunctionException) {
                                            showErrorDialog(
                                              context: mainContext,
                                              text: 'Please try again later.',
                                            );
                                          }
                                        }
                                      }
                                    }
                                  },
                                  backgroundColor: kPrimaryColor,
                                  textColor: kPrimaryWhite,
                                  borderColor: kTransparent,
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
                                      mainAxisSize: MainAxisSize.min,
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
                                              width: screenSize.width * 0.37,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                color: kPrimaryWhite,
                                                border: Border.all(
                                                  color:
                                                      const Color(0xffEBE6F0),
                                                ),
                                              ),
                                              child: TextField(
                                                controller: _searchController,
                                                keyboardType:
                                                    TextInputType.text,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: textTheme.titleMedium!
                                                    .copyWith(
                                                  fontSize: 12,
                                                  color: kGry800,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'Search',
                                                  hintStyle: textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: kGry800,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    bottom: kPadding * 2.7,
                                                  ),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5.0,
                                                      bottom: 5.0,
                                                    ),
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
                                          child: SizedBox(
                                            height: 400,
                                            child: SingleChildScrollView(
                                              child: StudentsListView(
                                                students: students,
                                              ),
                                            ),
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
                  );
                } else {
                  return EmptyStateWidget(
                    namePlaceholder: student,
                    actionButton: CustomTextButton(
                      text: addStudent,
                      isLoading: false,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddStudents(),
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
                  namePlaceholder: student,
                  actionButton: CustomTextButton(
                    text: addStudent,
                    isLoading: false,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddStudents(),
                      ));
                    },
                    backgroundColor: kDarkYellow,
                    textColor: kPrimaryWhite,
                    borderColor: kTransparent,
                    icon: Icons.add,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
