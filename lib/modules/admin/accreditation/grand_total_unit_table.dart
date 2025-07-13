import 'package:flutter/material.dart';

class GrandTotalUnitsTable extends StatelessWidget {
  final TextTheme textTheme;

  const GrandTotalUnitsTable({super.key, required this.textTheme});

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Text(
          text,
          style: textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCell(String text,
      {bool isHeader = false, bool alignCenter = false}) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.3), // 🔽 Thin border
        ),
        alignment: alignCenter ? Alignment.center : Alignment.centerLeft,
        child: Text(
          text,
          textAlign: alignCenter ? TextAlign.center : TextAlign.left,
          style: textTheme.bodySmall!.copyWith(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> cells, {bool isHeader = false}) {
    return Row(
      children: [
        _buildCell(cells[0], isHeader: isHeader),
        _buildCell(cells[1], isHeader: isHeader, alignCenter: true),
        _buildCell(cells[2], isHeader: isHeader, alignCenter: true),
      ],
    );
  }

  Widget _buildFullRow(String text, {bool bold = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.3), // 🔽 Thin border
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textTheme.bodySmall!.copyWith(
          fontWeight: bold ? FontWeight.bold : FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [
      _buildHeader("GRAND TOTAL UNITS OF COMPULSORY AND ELECTIVE COURSES"),
      _buildRow(
          ['Level', 'Units of Compulsory Courses', 'Units of Elective Courses'],
          isHeader: true),
      _buildRow(['100', '33', '0']),
      _buildRow(['200', '39', '0']),
      _buildRow(['300', '41', '4']),
      _buildFullRow('400 Level', bold: true),
      _buildRow(['Multi-Physical Systems Option', '18', '18']),
      _buildRow(
          ['Artificial Intelligence and Machine Learning Option', '18', '17']),
      _buildRow(['Industrial Systems Option', '18', '17']),
      _buildRow(['Electronics and Control Option', '18', '18']),
      _buildRow(['Bio-Inspired and Energy Systems Option', '18', '14']),
      _buildFullRow('500 Level', bold: true),
      _buildRow(['Multi-Physical Systems Option', '15', '16']),
      _buildRow(
          ['Artificial Intelligence and Machine Learning Option', '15', '18']),
      _buildRow(['Industrial Systems Option', '15', '17']),
      _buildRow(['Electronics and Control Option', '15', '18']),
      _buildRow(['Bio-Inspired and Energy Systems Option', '15', '17']),
      _buildFullRow('Grand Totals', bold: true),
      _buildRow(['Multi-Physical Systems Option', '146', '38']),
      _buildRow(
          ['Artificial Intelligence and Machine Learning Option', '146', '39']),
      _buildRow(['Industrial Systems Option', '146', '38']),
      _buildRow(['Electronics and Control Option', '146', '40']),
      _buildRow(['Bio-Inspired and Energy Systems Option', '146', '35']),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
