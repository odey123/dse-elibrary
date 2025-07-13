import 'package:flutter/material.dart';
import 'package:systems_app/modules/admin/accreditation/course_table_widget.dart';
import 'package:systems_app/modules/admin/accreditation/course_summary_table.dart';
import 'package:systems_app/modules/admin/accreditation/graduation_requirement_table.dart';
import 'package:systems_app/modules/admin/accreditation/grand_total_unit_table.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class TabFiveScreen extends StatefulWidget {
  const TabFiveScreen({super.key});

  @override
  State<TabFiveScreen> createState() => _TabFiveScreenState();
}

class _TabFiveScreenState extends State<TabFiveScreen> {
  bool isHundredLevelOpen = false;
  bool isTwoHundredLevelOpen = false;
  bool isThreeHundredLevelOpen = false;
  bool isFourHundredLevelOpen = false;
  bool isFiveHundredLevelOpen = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kRegularPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              globalCourseStructure,
              style: textTheme.bodySmall!.copyWith(
                color: kBlack,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: kRegularPadding,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isHundredLevelOpen = !isHundredLevelOpen;
                });
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                  vertical: kRegularPadding - 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kGry500,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hundredLevel,
                      style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      isHundredLevelOpen
                          ? Icons.expand_more
                          : Icons.expand_less,
                      color: kBlack,
                      size: 17,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: kPadding,
            ),
            isHundredLevelOpen
                ? Column(
                    children: [
                      const SizedBox(
                        height: kPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'First Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: hundredLevelFirstSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kSmallPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'Second Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: hundredLevelSecondSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kPadding,
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: kPadding,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isTwoHundredLevelOpen = !isTwoHundredLevelOpen;
                });
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                  vertical: kRegularPadding - 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kGry500,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      twoHundredLevel,
                      style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      isTwoHundredLevelOpen
                          ? Icons.expand_more
                          : Icons.expand_less,
                      color: kBlack,
                      size: 17,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: kPadding,
            ),
            isTwoHundredLevelOpen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: kPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'First Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: twoHundredLevelFirstSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kSmallPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'Second Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: twoHundredLevelSecondSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kPadding - 3,
                      ),
                      Text(
                        '* GET 299 to be credited in 2ND Semester, 400 Level',
                        style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: kPadding,
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: kPadding,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isThreeHundredLevelOpen = !isThreeHundredLevelOpen;
                });
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                  vertical: kRegularPadding - 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kGry500,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      threeHundredLevel,
                      style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      isThreeHundredLevelOpen
                          ? Icons.expand_more
                          : Icons.expand_less,
                      color: kBlack,
                      size: 17,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: kPadding,
            ),
            isThreeHundredLevelOpen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: kPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'First Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: threeHundredLevelFirstSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kSmallPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'Second Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: threeHundredLevelSecondSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kPadding - 3,
                      ),
                      Text(
                        '* GET 399 to be credited in 2ND Semester, 400 Level',
                        style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: kPadding,
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: kPadding,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isFourHundredLevelOpen = !isFourHundredLevelOpen;
                });
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                  vertical: kRegularPadding - 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kGry500,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fourHundredLevel,
                      style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      isFourHundredLevelOpen
                          ? Icons.expand_more
                          : Icons.expand_less,
                      color: kBlack,
                      size: 17,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: kPadding,
            ),
            isFourHundredLevelOpen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: kPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'First Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: fourHundredLevelFirstSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kSmallPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'Second Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: fourHundredLevelSecondSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kPadding - 3,
                      ),
                      Text(
                        '* All Credited in the 2nd Semester, 400 Level',
                        style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: kPadding,
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: kPadding,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isFiveHundredLevelOpen = !isFiveHundredLevelOpen;
                });
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                  vertical: kRegularPadding - 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kGry500,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fiveHundredLevel,
                      style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      isFiveHundredLevelOpen
                          ? Icons.expand_more
                          : Icons.expand_less,
                      color: kBlack,
                      size: 17,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: kPadding,
            ),
            isFiveHundredLevelOpen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: kPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'First Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: fiveHundredLevelFirstSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kSmallPadding,
                      ),
                      CourseTableWidget(
                        semesterTitle: 'Second Semester',
                        textTheme: Theme.of(context).textTheme,
                        rows: fiveHundredLevelSecondSemesterCourseStructure,
                      ),
                      const SizedBox(
                        height: kPadding,
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: kMacroPadding,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                semesterBySemesterSummary.toUpperCase(),
                style: textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(
              height: kMicroPadding,
            ),
            CourseSummaryTable(textTheme: textTheme),
            const SizedBox(
              height: kMicroPadding,
            ),
            GrandTotalUnitsTable(
              textTheme: textTheme,
            ),
            const SizedBox(
              height: kMicroPadding,
            ),
            GraduationRequirementTable(
              textTheme: textTheme,
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
