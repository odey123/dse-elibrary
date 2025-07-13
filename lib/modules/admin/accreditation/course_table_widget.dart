import 'package:flutter/material.dart';
import 'package:systems_app/utils/constant.dart';

class CourseTableWidget extends StatelessWidget {
  final String semesterTitle;
  final List<List<String>> rows;
  final TextTheme textTheme;

  const CourseTableWidget({
    super.key,
    required this.semesterTitle,
    required this.rows,
    required this.textTheme,
  });

  static const double cellWidth = 110;

  Widget _buildHeaderCell(
    String text,
    bool isFirst,
    bool alignLeft,
  ) {
    return Container(
      width: cellWidth,
      alignment: alignLeft ? null : Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: const BorderSide(color: Colors.grey),
          right: const BorderSide(color: Colors.grey),
          left: isFirst
              ? const BorderSide(
                  color: Colors.grey,
                )
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style: textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: kBlack,
        ),
      ),
    );
  }

  Widget buildCourseRow(List<String> data, TextTheme textTheme,
      {bool isTotal = false, bool isBold = false, bool isOption = false}) {
    if (isTotal) {
      return Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                  left: BorderSide(color: Colors.grey),
                  right: BorderSide(color: Colors.grey),
                ),
              ),
              child: Text(
                data[0],
                style: textTheme.bodySmall!.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            width: cellWidth,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              data[2], // total unit
              style: textTheme.bodySmall!.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          for (int i = 3; i < 6; i++)
            Container(
              width: cellWidth,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                  right: BorderSide(color: Colors.grey),
                ),
              ),
              child: Text(
                data[i],
                style: textTheme.bodySmall!.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
        ],
      );
    }
    if (isOption) {
      return Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                  left: BorderSide(color: Colors.grey),
                  right: BorderSide(color: Colors.grey),
                ),
              ),
              child: Text(
                data[0],
                style: textTheme.bodySmall!.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Container(
          width: cellWidth,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
              left: BorderSide(color: Colors.grey),
              right: BorderSide(color: Colors.grey),
            ),
          ),
          child: Text(
            data[0],
            style: textTheme.bodySmall!.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              data[1],
              style: textTheme.bodySmall!.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
        for (int i = 2; i < data.length; i++)
          Container(
            width: cellWidth,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              data[i],
              style: textTheme.bodySmall!.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Text(
                semesterTitle.toUpperCase(),
                style: textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildHeaderCell('Course Code', true, true),
            Expanded(
              child: _buildHeaderCell('Course Title', false, true),
            ),
            _buildHeaderCell('Units', false, false),
            _buildHeaderCell('Status', false, false),
            _buildHeaderCell('LH', false, false),
            _buildHeaderCell('PH', false, false),
          ],
        ),
        ...rows.map((row) {
          final isTotal = row[0].toLowerCase().contains('total');
          final isOption = row[0].toLowerCase().contains('option');
          return buildCourseRow(row, textTheme,
              isTotal: isTotal, isOption: isOption);
        }),
      ],
    );
  }
}
