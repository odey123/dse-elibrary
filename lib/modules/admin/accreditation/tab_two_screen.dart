import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:systems_app/modules/reuseables/lecturer_card.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/image_url.dart';
import 'package:systems_app/utils/strings.dart';

class TabTwoScreen extends StatefulWidget {
  const TabTwoScreen({super.key});

  @override
  State<TabTwoScreen> createState() => _TabTwoScreenState();
}

class _TabTwoScreenState extends State<TabTwoScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kMediumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: historyOf,
                          style: textTheme.bodySmall!.copyWith(
                            color: kBlack,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: systemsEngineering,
                              style: textTheme.bodySmall!.copyWith(
                                color: kPrimaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: kPadding + 2,
                      ),
                      Text(
                        subSystemsIntroOne,
                        style: textTheme.bodySmall!.copyWith(
                          color: kGry900,
                          fontSize: 12.8,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: kSmallPadding,
                  right: kMediumPadding,
                  top: kRegularPadding,
                  bottom: kRegularPadding,
                ),
                child: ImageNetwork(
                  image: accBackgroundthreeUrl,
                  height: 300,
                  width: 450,
                  duration: 500,
                  onPointer: true,
                  debugPrint: false,
                  backgroundColor: kPrimaryColor.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  fitAndroidIos: BoxFit.cover,
                  fitWeb: BoxFitWeb.fill,
                  onError: const Icon(Icons.error),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Text(
              subSystemsIntroTwo,
              style: textTheme.bodySmall!.copyWith(
                color: kGry900,
                fontSize: 12.8,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(
            height: kMacroPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kMediumPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pOE,
                  style: textTheme.bodySmall!.copyWith(
                    color: kBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: kSmallPadding,
                ),
                Text(
                  pOESub,
                  style: textTheme.bodySmall!.copyWith(
                    color: kGry900,
                    fontSize: 12.8,
                    height: 1.4,
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                Text(
                  pOESubPR,
                  style: textTheme.bodySmall!.copyWith(
                    color: kGry900,
                    fontSize: 12.8,
                    height: 1.4,
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                RichText(
                  text: TextSpan(
                    text: peo1,
                    style: textTheme.bodySmall!.copyWith(
                        color: kBlack,
                        fontSize: 12.8,
                        height: 1.4,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: peo1Sub,
                        style: textTheme.bodySmall!.copyWith(
                          color: kGry900,
                          fontSize: 12.8,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                RichText(
                  text: TextSpan(
                    text: peo2,
                    style: textTheme.bodySmall!.copyWith(
                        color: kBlack,
                        fontSize: 12.8,
                        height: 1.4,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: peo2Sub,
                        style: textTheme.bodySmall!.copyWith(
                          color: kGry900,
                          fontSize: 12.8,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                RichText(
                  text: TextSpan(
                    text: peo3,
                    style: textTheme.bodySmall!.copyWith(
                        color: kBlack,
                        fontSize: 12.8,
                        height: 1.4,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: peo3Sub,
                        style: textTheme.bodySmall!.copyWith(
                          color: kGry900,
                          fontSize: 12.8,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                RichText(
                  text: TextSpan(
                    text: peo4,
                    style: textTheme.bodySmall!.copyWith(
                        color: kBlack,
                        fontSize: 12.8,
                        height: 1.4,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: peo4Sub,
                        style: textTheme.bodySmall!.copyWith(
                          color: kGry900,
                          fontSize: 12.8,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kPadding,
                ),
                RichText(
                  text: TextSpan(
                    text: peo5,
                    style: textTheme.bodySmall!.copyWith(
                        color: kBlack,
                        fontSize: 12.8,
                        height: 1.4,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: peo5Sub,
                        style: textTheme.bodySmall!.copyWith(
                          color: kGry900,
                          fontSize: 12.8,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: kMacroPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kMediumPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pO,
                  style: textTheme.bodySmall!.copyWith(
                    color: kBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: kSmallPadding,
                ),
                Text(
                  pOSub,
                  style: textTheme.bodySmall!.copyWith(
                    color: kGry900,
                    fontSize: 12.8,
                    height: 1.4,
                  ),
                ),
                const SizedBox(
                  height: kSmallPadding,
                ),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FixedColumnWidth(60),
                    2: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    // Table Header
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(kSmallPadding),
                          child: Text(
                            'S/No.',
                            style: textTheme.bodySmall!.copyWith(
                              color: kBlack,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(kSmallPadding),
                          child: Text(
                            'Outcomes',
                            style: textTheme.bodySmall!.copyWith(
                              color: kBlack,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Table Rows
                    ...List.generate(poList.length, (index) {
                      final po = poList[index];
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${po["code"]}: ',
                              style: textTheme.bodySmall!.copyWith(
                                color: kBlack,
                                fontSize: 12.8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                style: textTheme.bodySmall!.copyWith(
                                  color: kBlack,
                                  fontSize: 12.8,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${po["title"]}: ',
                                    style: textTheme.bodySmall!.copyWith(
                                      color: kBlack,
                                      fontSize: 12.8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: po["description"],
                                    style: textTheme.bodySmall!.copyWith(
                                      color: kGry900,
                                      fontSize: 12.8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: kMacroPadding,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                    vertical: kRegularPadding,
                  ),
                  child: Image.asset(AssetPaths.accBackgroundFour),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kMediumPadding,
                          vertical: kRegularPadding + 3,
                        ),
                        decoration: const BoxDecoration(
                          color: kOrange400,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              15,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              visionDept,
                              style: textTheme.bodySmall!.copyWith(
                                color: kBlack,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: kSmallPadding,
                            ),
                            Text(
                              visionDeptSub,
                              style: textTheme.bodySmall!.copyWith(
                                color: kBlack,
                                fontSize: 12.8,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: kMediumPadding,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kMediumPadding,
                          vertical: kRegularPadding + 3,
                        ),
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              15,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              missionDept,
                              style: textTheme.bodySmall!.copyWith(
                                color: kPrimaryWhite,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: kSmallPadding,
                            ),
                            Text(
                              missionDeptSub,
                              style: textTheme.bodySmall!.copyWith(
                                color: kPrimaryWhite,
                                fontSize: 12.8,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: kMacroPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Text(
              headOfDept,
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
                      image: ogunwoluImageUrl,
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
                  width: kMacroPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: kMediumPadding,
                    ),
                    Text(
                      headOfDeptName,
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
                      hodQualification,
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 13,
                        color: kGry900,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(
                      height: kPadding,
                    ),
                    Text(
                      headOfDeptAreaOfSpecialization,
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 15,
                        color: kBlack,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: kMicroPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Text(
              professorsInTheDept,
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
          LecturerCard(
            name: professorOneName,
            qualification: professorOneQualification,
            specialization: professorOneAreaOfSpecialization,
            stackOnLeft: true,
            imageUrl: fakindeleImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: professorTwoName,
            qualification: professorTwoQualification,
            specialization: professorTwoAreaOfSpecialization,
            stackOnLeft: false,
            imageUrl: asaoluImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: professorThreeName,
            qualification: professorThreeQualification,
            specialization: professorThreeAreaOfSpecialization,
            stackOnLeft: true,
            imageUrl: fashanuImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: professorFourName,
            qualification: professorFourQualification,
            specialization: professorFourAreaOfSpecialization,
            stackOnLeft: false,
            imageUrl: ajibolaImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Text(
              seniorsInTheDept,
              style: textTheme.titleMedium!.copyWith(
                fontSize: 17,
                color: kBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: kRegularPadding),
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
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: seniorLecturerOneName,
            qualification: seniorLecturerOneQualification,
            specialization: seniorLecturerOneAreaOfSpecialization,
            stackOnLeft: true,
            imageUrl: ipinnimoImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: seniorLecturerTwoName,
            qualification: seniorLecturerTwoQualification,
            specialization: seniorLecturerTwoAreaOfSpecialization,
            stackOnLeft: false,
            imageUrl: oroluImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: seniorLecturerThreeName,
            qualification: seniorLecturerThreeQualification,
            specialization: seniorLecturerThreeAreaOfSpecialization,
            stackOnLeft: true,
            imageUrl: olayiwolaImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: seniorLecturerFourName,
            qualification: seniorLecturerFourQualification,
            specialization: seniorLecturerFourAreaOfSpecialization,
            stackOnLeft: false,
            imageUrl: georgeImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: seniorLecturerFiveName,
            qualification: seniorLecturerFiveQualification,
            specialization: seniorLecturerFiveAreaOfSpecialization,
            stackOnLeft: true,
            imageUrl: raheemImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: seniorLecturerSixName,
            qualification: seniorLecturerSixQualification,
            specialization: seniorLecturerSixAreaOfSpecialization,
            stackOnLeft: false,
            imageUrl: ogbemheImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: seniorLecturerSevenName,
            qualification: seniorLecturerSevenQualification,
            specialization: seniorLecturerSevenAreaOfSpecialization,
            stackOnLeft: true,
            imageUrl: folorusoImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: seniorLecturerEightName,
            qualification: seniorLecturerEightQualification,
            specialization: seniorLecturerEightAreaOfSpecialization,
            stackOnLeft: false,
            imageUrl: odeyinkaImageUrl,
          ),
          const SizedBox(height: kMicroPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Text(
              lecturersInTheDept,
              style: textTheme.titleMedium!.copyWith(
                fontSize: 17,
                color: kBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: kRegularPadding),
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
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: lecturerOneName,
            qualification: lecturerOneQualification,
            specialization: lecturerOneAreaOfSpecialization,
            stackOnLeft: true,
            imageUrl: ogunderoImageUrl,
          ),
          const SizedBox(height: kRegularPadding),
          LecturerCard(
            name: lecturerTwoName,
            qualification: lecturerTwoQualification,
            specialization: lecturerTwoAreaOfSpecialization,
            stackOnLeft: false,
            imageUrl: onyedikamImageUrl,
          ),
          const SizedBox(height: kMicroPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Text(
              technicalStaffList,
              style: textTheme.titleMedium!.copyWith(
                fontSize: 17,
                color: kBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: kRegularPadding),
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
          const SizedBox(height: kRegularPadding),
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
                        ImageNetwork(
                          image: rajiImageUrl,
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
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          technicalStaffOneName,
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
                          technicalStaffOneQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          technicalStaffOneDesignation,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
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
                        ImageNetwork(
                          image: odufuwaImageUrl,
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
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          technicalStaffTwoName,
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
                          technicalStaffTwoQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          technicalStaffTwoDesignation,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
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
          const SizedBox(height: kMicroPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            child: Text(
              adminStaffList,
              style: textTheme.titleMedium!.copyWith(
                fontSize: 17,
                color: kBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: kRegularPadding),
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
          const SizedBox(height: kRegularPadding),
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
                        ImageNetwork(
                          image: joshuaImageUrl,
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
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          adminStaffOneName,
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
                          adminStaffOneQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          adminStaffOneDesignation,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
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
                        ImageNetwork(
                          image: shonuyiImageUrl,
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
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          adminStaffTwoName,
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
                          adminStaffTwoQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          adminStaffTwoDesignation,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
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
                        ImageNetwork(
                          image: igbasanImageUrl,
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
                        const SizedBox(
                          height: kRegularPadding,
                        ),
                        Text(
                          adminStaffThreeName,
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
                          adminStaffThreeQualification,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 13,
                            color: kGry900,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          height: kPadding,
                        ),
                        Text(
                          adminStaffThreeDesignation,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            color: kBlack,
                            fontWeight: FontWeight.w600,
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
          const SizedBox(height: kMicroPadding),
          const SizedBox(height: kMicroPadding),
        ],
      ),
    );
  }
}
