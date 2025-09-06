import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/services/cloud/database/cloud_profile.dart';
import 'package:systems_app/utils/constant.dart';

class CourseCoordinatorListView extends StatefulWidget {
  final List<CloudProfile> profiles;
  const CourseCoordinatorListView({
    super.key,
    required this.profiles,
  });

  @override
  State<CourseCoordinatorListView> createState() => _WeekTopicListViewState();
}

class _WeekTopicListViewState extends State<CourseCoordinatorListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.profiles.map(
        (profile) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kPadding - 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: (!kIsWeb || isPhoneWeb) ? 20 : 18,
                  width: (!kIsWeb || isPhoneWeb) ? 20 : 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ProfileImage(
                    imageUrl: profile.profileImageUrl,
                    radius: (!kIsWeb || isPhoneWeb) ? 10 : 9,
                  ),
                ),
                const SizedBox(width: kPadding),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    profile.preferredAcademicName,
                    style: textTheme.titleSmall!.copyWith(
                      fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 13,
                      color: kBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
