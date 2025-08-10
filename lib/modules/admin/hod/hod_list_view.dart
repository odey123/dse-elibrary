import 'package:flutter/material.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/services/cloud/model/hod.dart';
import 'package:systems_app/utils/constant.dart';

class HODListView extends StatelessWidget {
  final List<HOD> hods;
  const HODListView({
    super.key,
    required this.hods,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeaderRow(),
        ...hods.map((hod) => _buildHODRow(hod)),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kSmallPadding + 2,
        horizontal: kSmallPadding,
      ),
      decoration: const BoxDecoration(
        color: kGry550,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderColumn('Name'),
          _buildHeaderColumn('Email Address'),
          _buildHeaderColumn('Gender'),
        ],
      ),
    );
  }

  Widget _buildHODRow(HOD hod) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: kSmallPadding,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kGry400,
            width: 2,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataColumn(hod.preferredAcademicname),
          _buildDataColumn(hod.email),
          _buildDataColumn(hod.gender),
        ],
      ),
    );
  }

  Widget _buildHeaderColumn(String title) {
    return Expanded(
      child: Text(
        title,
        style: textTheme.bodySmall!.copyWith(
          fontSize: 12,
          color: kBlack,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDataColumn(String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YBox(kPadding),
          Text(
            value,
            style: textTheme.bodySmall!.copyWith(
              fontSize: 12,
              color: kGry600,
              fontWeight: FontWeight.w400,
            ),
          ),
          YBox(kPadding),
        ],
      ),
    );
  }
}
