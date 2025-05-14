import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/utils/constant.dart';

class EmptyStateHomeWidget extends StatefulWidget {
  const EmptyStateHomeWidget({super.key});

  @override
  State<EmptyStateHomeWidget> createState() => _EmptyStateHomeWidgetState();
}

class _EmptyStateHomeWidgetState extends State<EmptyStateHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(
            (!kIsWeb || isPhoneWeb) ? kPadding : kRegularPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (!kIsWeb || isPhoneWeb)
                ? Container()
                : Column(
                    children: [
                      Container(
                        width: 200,
                        height: screenSize.height,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[50]!,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            XBox(kRegularPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (!kIsWeb || isPhoneWeb) ? YBox(kMacroPadding) : Container(),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[50]!,
                    child: Container(
                      height: 130,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  YBox(kMicroPadding),
                  Wrap(
                    spacing: (!kIsWeb || isPhoneWeb)
                        ? kRegularPadding
                        : kSmallPadding,
                    runSpacing: kMicroPadding,
                    children: List.generate(
                      8,
                      (index) => Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.grey[50]!,
                        child: Container(
                          height: 130,
                          width: (!kIsWeb || isPhoneWeb) ? 145 : 250,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
