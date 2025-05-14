import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String units;
  final String coordinatorName;
  final String avatarPath;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.units,
    required this.coordinatorName,
    required this.avatarPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      child: Container(
        width: 270,
        height: (!kIsWeb || isPhoneWeb) ? 170 : 160,
        padding: const EdgeInsets.symmetric(
          horizontal: kSmallPadding,
          vertical: kRegularPadding,
        ),
        decoration: BoxDecoration(
          color: kTransparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(
            color: kGry500,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleSmall!.copyWith(
                fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 13,
                color: kBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: kRegularPadding),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: (!kIsWeb || isPhoneWeb) ? 15 : 14,
                  height: (!kIsWeb || isPhoneWeb) ? 17 : 16,
                  child: SvgPicture.asset(
                    AssetPaths.paperIcon,
                  ),
                ),
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    '$units Units',
                    style: textTheme.titleSmall!.copyWith(
                      fontSize: (!kIsWeb || isPhoneWeb) ? 13 : 11,
                      color: kGry800,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kMicroPadding),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course co-ordinator',
                      style: textTheme.titleSmall!.copyWith(
                        fontSize: (!kIsWeb || isPhoneWeb) ? 13 : 11,
                        color: kGry800,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: kSmallPadding),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: (!kIsWeb || isPhoneWeb) ? 20 : 18,
                          width: (!kIsWeb || isPhoneWeb) ? 20 : 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ProfileImage(
                            imageUrl: avatarPath,
                            radius: (!kIsWeb || isPhoneWeb) ? 10 : 9,
                          ),
                        ),
                        const SizedBox(width: kPadding),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            coordinatorName,
                            style: textTheme.titleSmall!.copyWith(
                              fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 13,
                              color: kBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: (!kIsWeb || isPhoneWeb) ? 28 : 23,
                  height: (!kIsWeb || isPhoneWeb) ? 28 : 23,
                  decoration: const BoxDecoration(
                    color: kDarkYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: kPrimaryWhite,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
