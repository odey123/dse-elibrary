import 'dart:developer';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/app/function/handle_profile_submit.dart';
import 'package:systems_app/app/function/image_picker.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/app/loading/loading_pdf_screen.dart';
import 'package:systems_app/modules/reuseables/book_card.dart';
import 'package:systems_app/modules/reuseables/profile_drawer.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/function/functions_actions.dart';
import 'package:systems_app/services/cloud/model/book.dart';
import 'package:systems_app/services/cloud/storage/storage.actions.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class Books extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const Books({
    super.key,
    this.navigatorKeyForDesktopWeb,
  });

  @override
  ConsumerState<Books> createState() => _BooksState();
}

class _BooksState extends ConsumerState<Books> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final DatabaseAsyncNotifier _database;
  late final AuthenticationAsyncNotifier _auth;
  late final StorageAsyncNotifier _storage;
  late final FunctionsAsyncNotifier _function;
  final TextEditingController _searchController = TextEditingController();
  String? selectedBookCategory;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _prefferedAcademicName;
  late final TextEditingController _prefix;
  late final TextEditingController _levelCourseAdvisor;
  late final TextEditingController _currentLevel;
  late final TextEditingController _email;
  bool _isProfileEditLoading = false;
  String _searchTerm = '';

  @override
  void initState() {
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    _storage = ref.read(storageAsyncNotifierProvider.notifier);
    _function = ref.read(functionsAsyncNotifierProvider.notifier);
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _prefferedAcademicName = TextEditingController();
    _prefix = TextEditingController();
    _levelCourseAdvisor = TextEditingController();
    _currentLevel = TextEditingController();
    _email = TextEditingController();
    setControllerText();
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
      });
    });
    super.initState();
  }

  void openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void openFileInNewTab(Uint8List fileBytes, String mimeType, String fileName) {
    final blob = html.Blob([fileBytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.window.open(url, '_blank');

    Future.delayed(const Duration(seconds: 10), () {
      html.Url.revokeObjectUrl(url);
    });
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
    if (result == all) {
      return null;
    }
    return result;
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
                                          books,
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
                                          controller: _searchController,
                                          keyboardType: TextInputType.text,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                            hintText: 'Search',
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
                                            listItems: bookCategory,
                                          );
                                          setState(() {
                                            selectedBookCategory = selected;
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
                                                  selectedBookCategory ??
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
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(11),
                                            color: kPrimaryWhite,
                                            border: Border.all(
                                              color: const Color(0xffEBE6F0),
                                            ),
                                          ),
                                          child: TextField(
                                            controller: _searchController,
                                            keyboardType: TextInputType.text,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            style:
                                                textTheme.titleMedium!.copyWith(
                                              fontSize: 12,
                                              color: kGry800,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Search',
                                              hintStyle: textTheme.titleMedium!
                                                  .copyWith(
                                                fontSize: 12,
                                                color: kGry800,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                bottom: kPadding * 2.7,
                                              ),
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.only(
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
                                              listItems: bookCategory,
                                            );
                                            setState(() {
                                              selectedBookCategory = selected;
                                            });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          child: Container(
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(11),
                                              color: kPrimaryWhite,
                                              border: Border.all(
                                                color: const Color(0xffEBE6F0),
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
                                                    selectedBookCategory ??
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
                        YBox(kMediumPadding),
                        (!kIsWeb || isPhoneWeb)
                            ? StreamBuilder(
                                stream: _database.getAllBooks(
                                  filter: selectedBookCategory,
                                  searchTerm: _searchTerm,
                                ),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        final books =
                                            snapshot.data as List<Book>;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: kRegularPadding),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Wrap(
                                                  spacing: kSmallPadding,
                                                  runSpacing: kPadding,
                                                  children: List.generate(
                                                    books.length,
                                                    (index) {
                                                      return BookCard(
                                                        title:
                                                            books[index].title,
                                                        author:
                                                            books[index].author,
                                                        coverImagePath:
                                                            books[index]
                                                                .coverUrl,
                                                        bookUrl: books[index]
                                                            .bookUrl,
                                                        onTap: () {},
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kRegularPadding,
                                            vertical: kPadding,
                                          ),
                                          child: Wrap(
                                            spacing: kRegularPadding,
                                            runSpacing: kRegularPadding,
                                            children: List.generate(
                                              14,
                                              (index) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[200]!,
                                                  highlightColor:
                                                      Colors.grey[50]!,
                                                  child: Container(
                                                    height: 240,
                                                    width: 160,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    default:
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kRegularPadding,
                                          vertical: kPadding,
                                        ),
                                        child: Wrap(
                                          spacing: kRegularPadding,
                                          runSpacing: kRegularPadding,
                                          children: List.generate(
                                            14,
                                            (index) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[200]!,
                                                highlightColor:
                                                    Colors.grey[50]!,
                                                child: Container(
                                                  height: 240,
                                                  width: 160,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                  }
                                },
                              )
                            : StreamBuilder(
                                stream: _database.getAllBooks(
                                  filter: selectedBookCategory,
                                  searchTerm: _searchTerm,
                                ),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      if (snapshot.hasData) {
                                        final books =
                                            snapshot.data as List<Book>;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kRegularPadding,
                                            vertical: kPadding,
                                          ),
                                          child: Wrap(
                                            spacing: kRegularPadding,
                                            runSpacing: kRegularPadding,
                                            children: List.generate(
                                              books.length,
                                              (index) {
                                                log(books[index].coverUrl);
                                                return BookCard(
                                                  title: books[index].title,
                                                  author: books[index].author,
                                                  coverImagePath:
                                                      books[index].coverUrl,
                                                  bookUrl: books[index].bookUrl,
                                                  onTap: () async {
                                                    LoadingPdfScreen().show(
                                                      context: context,
                                                      showProgress: true,
                                                    );
                                                    final docbytes =
                                                        await _function
                                                            .getPdfBytesFromUrl(
                                                      fileUrl:
                                                          books[index].bookUrl,
                                                      requesterUid: _auth
                                                          .currentUser!.uid,
                                                    );
                                                    LoadingPdfScreen().hide();
                                                    if (docbytes != null) {
                                                      openFileInNewTab(
                                                        docbytes,
                                                        applicationPdf,
                                                        books[index].title,
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kRegularPadding,
                                            vertical: kPadding,
                                          ),
                                          child: Wrap(
                                            spacing: kRegularPadding,
                                            runSpacing: kRegularPadding,
                                            children: List.generate(
                                              14,
                                              (index) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[200]!,
                                                  highlightColor:
                                                      Colors.grey[50]!,
                                                  child: Container(
                                                    height: 240,
                                                    width: 160,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    default:
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kRegularPadding,
                                          vertical: kPadding,
                                        ),
                                        child: Wrap(
                                          spacing: kRegularPadding,
                                          runSpacing: kRegularPadding,
                                          children: List.generate(
                                            14,
                                            (index) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[200]!,
                                                highlightColor:
                                                    Colors.grey[50]!,
                                                child: Container(
                                                  height: 240,
                                                  width: 160,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                  }
                                },
                              ),
                        YBox(kLargePadding),
                      ],
                    ),
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
