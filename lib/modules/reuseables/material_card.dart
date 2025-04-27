import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class MaterialCard extends StatelessWidget {
  final String title;
  final String url;
  final String coordinatorName;
  final String avatarPath;
  final VoidCallback? onTap;
  const MaterialCard({
    super.key,
    required this.title,
    required this.url,
    required this.coordinatorName,
    required this.avatarPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        child: Container(
          height: 160,
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
                  fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 13,
                  color: kBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: kRegularPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 16,
                    child: SvgPicture.asset(
                      AssetPaths.paperIcon,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      courseMaterial,
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
                          fontSize: (!kIsWeb || isPhoneWeb) ? 12 : 11,
                          color: kGry800,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: kSmallPadding),
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              avatarPath,
                            ),
                          ),
                          const SizedBox(width: kPadding),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              coordinatorName,
                              style: textTheme.titleSmall!.copyWith(
                                fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 13,
                                color: kBlack,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kRegularPadding,
                      vertical: kPadding,
                    ),
                    child: Container(
                      width: (!kIsWeb || isPhoneWeb) ? 28 : 23,
                      height: (!kIsWeb || isPhoneWeb) ? 28 : 23,
                      padding: const EdgeInsets.only(
                        bottom: kPadding + 2,
                        top: kPadding - 2,
                      ),
                      decoration: const BoxDecoration(
                        color: kDarkYellow,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        AssetPaths.arrowDownward,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
