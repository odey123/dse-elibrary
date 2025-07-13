import 'package:flutter/material.dart';

class GraduationRequirementTable extends StatelessWidget {
  final TextTheme textTheme;

  const GraduationRequirementTable({super.key, required this.textTheme});

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
      {bool isHeader = false, bool alignRight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.3),
        ),
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          style: textTheme.bodySmall!.copyWith(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildRow(String left, String right, {bool isHeader = false}) {
    return Row(
      children: [
        _buildCell(left, isHeader: isHeader),
        _buildCell(right, isHeader: isHeader, alignRight: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader("GRADUATION REQUIREMENT BY MODE OF ENTRY"),
        _buildRow("Mode of Entry", "Minimum No of Units Required",
            isHeader: true),
        _buildRow("UTME", "175"),
        _buildRow("Direct Entry (200 Level Entrants)", "155"),
        _buildRow("Direct Entry (300 Level Entrants)", "120"),
      ],
    );
  }
}
