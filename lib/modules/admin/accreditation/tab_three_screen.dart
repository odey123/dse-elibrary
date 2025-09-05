import 'package:flutter/material.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class TabThreeScreen extends StatefulWidget {
  const TabThreeScreen({super.key});

  @override
  State<TabThreeScreen> createState() => _TabThreeScreenState();
}

class _TabThreeScreenState extends State<TabThreeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bmas,
              style: textTheme.bodySmall!.copyWith(
                color: kBlack,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: kSmallPadding,
            ),
            Text(
              bmasSub,
              style: textTheme.bodySmall!.copyWith(
                color: kGry900,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
            const SizedBox(
              height: kMediumPadding,
            ),
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: kMediumPadding),
                      child: SizedBox(
                        height: 400,
                        width: 250,
                        child: Image.asset(
                          AssetPaths.ccmasImageOne,
                          height: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kMediumPadding,
                          vertical: kMacroPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 250,
                              width: 250,
                              child: Image.asset(AssetPaths.ccmasImageTwo),
                            ),
                            const SizedBox(
                              height: kMediumPadding,
                            ),
                            Text(
                              ccmas,
                              style: textTheme.bodySmall!.copyWith(
                                color: kBlack,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: kSmallPadding,
                            ),
                            Text(
                              ccmasSub,
                              style: textTheme.bodySmall!.copyWith(
                                color: kGry900,
                                fontSize: 12.5,
                                height: 1.4,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: kMacroPadding,
                    right: kFullPadding,
                    top: kMacroPadding,
                    bottom: kMacroPadding,
                  ),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About the Department',
                        style: textTheme.bodyMedium!.copyWith(
                          color: kPrimaryWhite,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: kSmallPadding,
                      ),
                      Text(
                        'Learning objectives',
                        style: textTheme.bodyMedium!.copyWith(
                          color: kPrimaryWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
