import 'package:flutter/material.dart';

class CourseSummaryTable extends StatelessWidget {
  final TextTheme textTheme;

  const CourseSummaryTable({super.key, required this.textTheme});

  Widget _buildSpanRow(String text, {bool center = false, bool bold = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey, width: 0.5),
          right: BorderSide(color: Colors.grey, width: 0.5),
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: textTheme.bodySmall!.copyWith(
          fontWeight: bold ? FontWeight.bold : FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
            left: BorderSide(color: Colors.grey, width: 0.5),
            right: BorderSide(color: Colors.grey, width: 0.5),
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, int flex, {bool firstColumn = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.grey,
              width: firstColumn ? 0.5 : 0,
            ),
            right: const BorderSide(color: Colors.grey, width: 0.5),
            bottom: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Text(
          text,
          style: textTheme.bodySmall!.copyWith(fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildDataRow(List<String> row, List<int> flexes) {
    return Row(
      children: [
        for (int i = 0; i < row.length; i++)
          _buildDataCell(row[i], flexes[i], firstColumn: i == 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final flexes = [1, 2, 2, 2];

    final rows = <Widget>[
      Row(
        children: [
          _buildHeaderCell('Level', flexes[0]),
          _buildHeaderCell('Semester', flexes[1]),
          _buildHeaderCell('Units of compulsory courses', flexes[2]),
          _buildHeaderCell('Units of Elective courses', flexes[3]),
        ],
      ),
      _buildDataRow(['100', 'First', '15', '0'], flexes),
      _buildDataRow(['', 'Second', '18', '0'], flexes),
      _buildDataRow(['200', 'First', '21', '0'], flexes),
      _buildDataRow(['', 'Second', '18', '0'], flexes),
      _buildDataRow(['300', 'First', '22', '2'], flexes),
      _buildDataRow(['', 'Second', '19', '2'], flexes),
      _buildSpanRow('400 Level', center: true, bold: true),
      _buildSpanRow('Multi– Physical Systems Option',
          center: false, bold: true),
      _buildDataRow(['400', 'First', '3', '18'], flexes),
      _buildDataRow(['', 'Second', '15', '0'], flexes),
      _buildSpanRow('Artificial Intelligence and Machine Learning Option',
          center: false, bold: true),
      _buildDataRow(['400', 'First', '3', '17'], flexes),
      _buildDataRow(['', 'Second', '15', '0'], flexes),
      _buildSpanRow('Industrial Systems Option', center: false, bold: true),
      _buildDataRow(['400', 'First', '3', '17'], flexes),
      _buildDataRow(['', 'Second', '15', '0'], flexes),
      _buildSpanRow('Electronics and Control Option',
          center: false, bold: true),
      _buildDataRow(['400', 'First', '3', '18'], flexes),
      _buildDataRow(['', 'Second', '15', '0'], flexes),
      _buildSpanRow('Bio– inspired and Energy Systems Option',
          center: false, bold: true),
      _buildDataRow(['400', 'First', '3', '14'], flexes),
      _buildDataRow(['', 'Second', '15', '0'], flexes),
      _buildSpanRow('500 Level', center: true, bold: true),
      _buildSpanRow('Multi– Physical Systems Option',
          center: false, bold: true),
      _buildDataRow(['500', 'First', '8', '9'], flexes),
      _buildDataRow(['', 'Second', '7', '9'], flexes),
      _buildSpanRow('Artificial Intelligence and Machine Learning Option',
          center: false, bold: true),
      _buildDataRow(['500', 'First', '8', '9'], flexes),
      _buildDataRow(['', 'Second', '7', '9'], flexes),
      _buildSpanRow('Industrial Systems Option', center: false, bold: true),
      _buildDataRow(['500', 'First', '8', '7'], flexes),
      _buildDataRow(['', 'Second', '6', '11'], flexes),
      _buildSpanRow('Electronics and Control Option',
          center: false, bold: true),
      _buildDataRow(['500', 'First', '8', '7'], flexes),
      _buildDataRow(['', 'Second', '8', '10'], flexes),
      _buildSpanRow('Bio-Inspired and Energy Systems Option',
          center: false, bold: true),
      _buildDataRow(['500', 'First', '8', '7'], flexes),
      _buildDataRow(['', 'Second', '6', '11'], flexes),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
