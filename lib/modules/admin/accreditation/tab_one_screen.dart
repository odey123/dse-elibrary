import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/image_url.dart';
import 'package:systems_app/utils/strings.dart';

class TabOneScreen extends StatefulWidget {
  const TabOneScreen({super.key});

  @override
  State<TabOneScreen> createState() => _TabOneScreenState();
}

class _TabOneScreenState extends State<TabOneScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                SizedBox(
                  height: 300,
                  width: screenSize.width,
                  child: Image.asset(
                    AssetPaths.accBackgroundOne,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kRegularPadding,
                    vertical: kRegularPadding,
                  ),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About the university',
                        style: textTheme.bodyMedium!.copyWith(
                          color: kPrimaryWhite,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: kSmallPadding,
                      ),
                      Text(
                        'History of the',
                        style: textTheme.bodyMedium!.copyWith(
                          color: kPrimaryWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'University of Lagos.',
                        style: textTheme.bodyMedium!.copyWith(
                          color: kPrimaryWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: kRegularPadding,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: screenSize.width * 0.5,
              padding: const EdgeInsets.only(
                right: kMediumPadding,
              ),
              child: Text(
                universityShortHistory,
                style: textTheme.bodySmall!.copyWith(
                  color: kGry900,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: kFullPadding + kSmallPadding,
          ),
          Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMediumPadding),
                      child: Text(
                        missionOfTheUniversity,
                        style: textTheme.titleMedium!.copyWith(
                          fontSize: 17,
                          color: kBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kSmallPadding,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: screenSize.width * 0.4,
                        padding: const EdgeInsets.only(
                          left: kMediumPadding,
                        ),
                        child: Text(
                          missionStatement,
                          style: textTheme.bodySmall!.copyWith(
                            color: kGry900,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kMacroPadding,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMediumPadding),
                      child: Text(
                        visionOfTheUniversity,
                        style: textTheme.titleMedium!.copyWith(
                          fontSize: 17,
                          color: kBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kSmallPadding,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: screenSize.width * 0.4,
                        padding: const EdgeInsets.only(
                          left: kMediumPadding,
                        ),
                        child: Text(
                          visionStatement,
                          style: textTheme.bodySmall!.copyWith(
                            color: kGry900,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kMacroPadding,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMediumPadding),
                      child: Text(
                        motto,
                        style: textTheme.titleMedium!.copyWith(
                          fontSize: 17,
                          color: kBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kSmallPadding,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: screenSize.width * 0.3,
                        padding: const EdgeInsets.only(
                          left: kMediumPadding,
                        ),
                        child: Text(
                          mottoStatement,
                          style: textTheme.bodySmall!.copyWith(
                            color: kGry900,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 300,
                alignment: Alignment.center,
                child: Image.asset(AssetPaths.accBackgroundTwo),
              )
            ],
          ),
          const SizedBox(
            height: kFullPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Text(
              universityLeadership,
              style: textTheme.titleMedium!.copyWith(
                fontSize: 17,
                color: kBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: kRegularPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kRegularPadding),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 0.5,
                    decoration: BoxDecoration(color: kGry500.withOpacity(0.8)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: kRegularPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kRegularPadding + kMediumPadding,
              vertical: kRegularPadding,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: kRegularPadding,
                        top: kRegularPadding,
                      ),
                      child: Container(
                        height: 190,
                        width: 200,
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    ImageNetwork(
                      image: folasadeImageUrl,
                      height: 190,
                      width: 200,
                      duration: 500,
                      onPointer: true,
                      debugPrint: false,
                      backgroundColor: kPrimaryColor.withOpacity(0.3),
                      fitAndroidIos: BoxFit.cover,
                      fitWeb: BoxFitWeb.fill,
                      onError: const Icon(Icons.error),
                    ),
                  ],
                ),
                const SizedBox(
                  width: kRegularPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: kMediumPadding,
                    ),
                    Text(
                      viceChancellor,
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 16,
                        color: kBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                    Text(
                      profFolasadeTolulopeOgunsola,
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 15,
                        color: kBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                    Text(
                      vcQualification,
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 13,
                        color: kGry900,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kRegularPadding,
              vertical: kRegularPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kRegularPadding,
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: kMicroPadding,
                                top: kRegularPadding,
                              ),
                              child: Container(
                                height: 190,
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            ImageNetwork(
                              image: folusoImageUrl,
                              height: 190,
                              width: 200,
                              duration: 500,
                              onPointer: true,
                              debugPrint: false,
                              backgroundColor: kPrimaryColor.withOpacity(0.3),
                              fitAndroidIos: BoxFit.cover,
                              fitWeb: BoxFitWeb.fill,
                              onError: const Icon(Icons.error),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          dvcOne,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15.5,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          dvcOneName,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          dvcOneQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kRegularPadding,
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: kMicroPadding,
                                top: kRegularPadding,
                              ),
                              child: Container(
                                height: 190,
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            ImageNetwork(
                              image: falaiyeImageUrl,
                              height: 190,
                              width: 200,
                              duration: 500,
                              onPointer: true,
                              debugPrint: false,
                              backgroundColor: kPrimaryColor.withOpacity(0.3),
                              fitAndroidIos: BoxFit.cover,
                              fitWeb: BoxFitWeb.fill,
                              onError: const Icon(Icons.error),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          dvcTwo,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15.5,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          dvcTwoName,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          dvcTwoQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kRegularPadding,
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: kMicroPadding,
                                top: kRegularPadding,
                              ),
                              child: Container(
                                height: 190,
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            ImageNetwork(
                              image: bolanleImageUrl,
                              height: 190,
                              width: 200,
                              duration: 500,
                              onPointer: true,
                              debugPrint: false,
                              backgroundColor: kPrimaryColor.withOpacity(0.3),
                              fitAndroidIos: BoxFit.cover,
                              fitWeb: BoxFitWeb.fill,
                              onError: const Icon(Icons.error),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          dvcThree,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15.5,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          dvcThreeName,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          dvcThreeQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kRegularPadding,
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: kMicroPadding,
                                top: kRegularPadding,
                              ),
                              child: Container(
                                height: 190,
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            ImageNetwork(
                              image: abosodeImageUrl,
                              height: 190,
                              width: 200,
                              duration: 500,
                              onPointer: true,
                              debugPrint: false,
                              backgroundColor: kPrimaryColor.withOpacity(0.3),
                              fitAndroidIos: BoxFit.cover,
                              fitWeb: BoxFitWeb.fill,
                              onError: const Icon(Icons.error),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          theActingRegistrar,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15.5,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          mrsOlakunleEstherMakinde,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          registrarQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kRegularPadding,
              vertical: kRegularPadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kRegularPadding,
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: kMicroPadding,
                                top: kRegularPadding,
                              ),
                              child: Container(
                                height: 190,
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            ImageNetwork(
                              image: oluwafunmilolaImageUrl,
                              height: 190,
                              width: 200,
                              duration: 500,
                              onPointer: true,
                              debugPrint: false,
                              backgroundColor: kPrimaryColor.withOpacity(0.3),
                              fitAndroidIos: BoxFit.cover,
                              fitWeb: BoxFitWeb.fill,
                              onError: const Icon(Icons.error),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          theBursar,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15.5,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          theBursarName,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          bursarQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kRegularPadding,
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: kMicroPadding,
                                top: kRegularPadding,
                              ),
                              child: Container(
                                height: 190,
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            ImageNetwork(
                              image: olatokunboImageUrl,
                              height: 190,
                              width: 200,
                              duration: 500,
                              onPointer: true,
                              debugPrint: false,
                              backgroundColor: kPrimaryColor.withOpacity(0.3),
                              fitAndroidIos: BoxFit.cover,
                              fitWeb: BoxFitWeb.fill,
                              onError: const Icon(Icons.error),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          theLibrarian,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15.5,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          theLibrarianName,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          librarianQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kRegularPadding,
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 190,
                          width: 210,
                          decoration: const BoxDecoration(
                            color: kTransparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: kRegularPadding,
                      left: kMediumPadding,
                      right: kMediumPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 190,
                          width: 210,
                          decoration: const BoxDecoration(
                            color: kTransparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: kMediumPadding,
          ),
        ],
      ),
    );
  }
}
