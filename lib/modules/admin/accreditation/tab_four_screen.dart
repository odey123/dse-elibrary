import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/app/dialogs/pdf_viewer_dialog.dart';
import 'package:systems_app/app/loading/loading_pdf_screen.dart';
import 'package:systems_app/services/auth/authentication_actions.dart';
import 'package:systems_app/services/cloud/database/database_actions.dart';
import 'package:systems_app/services/cloud/function/functions_actions.dart';
import 'package:systems_app/services/cloud/model/hand_book.dart';
import 'package:systems_app/services/cloud/model/lab_manual.dart';
import 'package:systems_app/services/cloud/model/lab_report.dart';
import 'package:systems_app/utils/constant.dart';

class TabFourScreen extends ConsumerStatefulWidget {
  const TabFourScreen({super.key});

  @override
  ConsumerState<TabFourScreen> createState() => _TabFourScreenState();
}

class _TabFourScreenState extends ConsumerState<TabFourScreen> {
  late final FunctionsAsyncNotifier _function;
  late final AuthenticationAsyncNotifier _auth;
  late final DatabaseAsyncNotifier _database;

  @override
  void initState() {
    _function = ref.read(functionsAsyncNotifierProvider.notifier);
    _auth = ref.read(authenticationAsyncNotifierProvider.notifier);
    _database = ref.read(databaseAsyncNotifierProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext mainContext) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kRegularPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: kMediumPadding,
                vertical: kMediumPadding,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: kGry500),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lab manuals',
                    style: textTheme.bodySmall!.copyWith(
                      color: kBlack,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: kMediumPadding,
                  ),
                  StreamBuilder(
                    stream: _database.getAllLabManual(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final labManual = snapshot.data as List<LabManual>;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kRegularPadding,
                                vertical: kPadding,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kRegularPadding,
                                  vertical: kPadding,
                                ),
                                child: Row(
                                  children:
                                      List.generate(labManual.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: kMacroPadding),
                                      child: ImageNetwork(
                                        image: labManual[index].coverUrl,
                                        width: 150,
                                        height: 200,
                                        duration: 500,
                                        onPointer: true,
                                        debugPrint: false,
                                        backgroundColor:
                                            kPrimaryColor.withOpacity(0.3),
                                        fitAndroidIos: BoxFit.cover,
                                        fitWeb: BoxFitWeb.fill,
                                        onError: const Icon(Icons.error),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        onTap: () async {
                                          try {
                                            LoadingPdfScreen().show(
                                                context: context,
                                                showProgress: true);

                                            final docbytes =
                                                await _function.getPdfBytes(
                                              filePath:
                                                  labManual[index].filePath,
                                              requesterUid:
                                                  _auth.currentUser!.uid,
                                            );
                                            LoadingPdfScreen().hide();
                                            if (docbytes != null) {
                                              await showPdfViewerDialog(
                                                  mainContext, docbytes);
                                            }
                                          } catch (e) {
                                            LoadingPdfScreen().hide();
                                            return;
                                          }
                                        },
                                      ),
                                    );
                                  }),
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
                                  7,
                                  (index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.grey[50]!,
                                      child: Container(
                                        width: 150,
                                        height: 200,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
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
                                7,
                                (index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.grey[50]!,
                                    child: Container(
                                      width: 150,
                                      height: 200,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
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
                ],
              ),
            ),
            const SizedBox(
              height: kMicroPadding,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: kMediumPadding,
                vertical: kMediumPadding,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: kGry500),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hand book',
                    style: textTheme.bodySmall!.copyWith(
                      color: kBlack,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: kMediumPadding,
                  ),
                  StreamBuilder(
                    stream: _database.getAllHandbook(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final handbook = snapshot.data as List<HandBook>;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kRegularPadding,
                                vertical: kPadding,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kRegularPadding,
                                  vertical: kPadding,
                                ),
                                child: Row(
                                  children:
                                      List.generate(handbook.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: kMacroPadding),
                                      child: ImageNetwork(
                                        image: handbook[index].coverUrl,
                                        width: 150,
                                        height: 200,
                                        duration: 500,
                                        onPointer: true,
                                        debugPrint: false,
                                        backgroundColor:
                                            kPrimaryColor.withOpacity(0.3),
                                        fitAndroidIos: BoxFit.cover,
                                        fitWeb: BoxFitWeb.fill,
                                        onError: const Icon(Icons.error),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        onTap: () async {
                                          try {
                                            LoadingPdfScreen().show(
                                                context: context,
                                                showProgress: true);

                                            final docbytes =
                                                await _function.getPdfBytes(
                                              filePath:
                                                  handbook[index].filePath,
                                              requesterUid:
                                                  _auth.currentUser!.uid,
                                            );
                                            LoadingPdfScreen().hide();
                                            if (docbytes != null) {
                                              await showPdfViewerDialog(
                                                  mainContext, docbytes);
                                            }
                                          } catch (e) {
                                            LoadingPdfScreen().hide();
                                            return;
                                          }
                                        },
                                      ),
                                    );
                                  }),
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
                                  7,
                                  (index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.grey[50]!,
                                      child: Container(
                                        width: 150,
                                        height: 200,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
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
                                7,
                                (index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.grey[50]!,
                                    child: Container(
                                      width: 150,
                                      height: 200,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
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
                ],
              ),
            ),
            const SizedBox(
              height: kMicroPadding,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: kMediumPadding,
                vertical: kMediumPadding,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: kGry500),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Laboratory report',
                    style: textTheme.bodySmall!.copyWith(
                      color: kBlack,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: kMediumPadding,
                  ),
                  StreamBuilder(
                    stream: _database.getAllLabReport(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final labReport = snapshot.data as List<LabReport>;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kRegularPadding,
                                vertical: kPadding,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kRegularPadding,
                                  vertical: kPadding,
                                ),
                                child: Row(
                                  children:
                                      List.generate(labReport.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: kMacroPadding),
                                      child: ImageNetwork(
                                        image: labReport[index].coverUrl,
                                        width: 150,
                                        height: 200,
                                        duration: 500,
                                        onPointer: true,
                                        debugPrint: false,
                                        backgroundColor:
                                            kPrimaryColor.withOpacity(0.3),
                                        fitAndroidIos: BoxFit.cover,
                                        fitWeb: BoxFitWeb.fill,
                                        onError: const Icon(Icons.error),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        onTap: () async {
                                          try {
                                            LoadingPdfScreen().show(
                                                context: context,
                                                showProgress: true);

                                            final docbytes =
                                                await _function.getPdfBytes(
                                              filePath:
                                                  labReport[index].filePath,
                                              requesterUid:
                                                  _auth.currentUser!.uid,
                                            );
                                            LoadingPdfScreen().hide();
                                            if (docbytes != null) {
                                              await showPdfViewerDialog(
                                                  mainContext, docbytes);
                                            }
                                          } catch (e) {
                                            LoadingPdfScreen().hide();
                                            return;
                                          }
                                        },
                                      ),
                                    );
                                  }),
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
                                  7,
                                  (index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.grey[50]!,
                                      child: Container(
                                        width: 150,
                                        height: 200,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
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
                                7,
                                (index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.grey[50]!,
                                    child: Container(
                                      width: 150,
                                      height: 200,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
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
                ],
              ),
            ),
            const SizedBox(
              height: kMicroPadding,
            ),
          ],
        ),
      ),
    );
  }
}
