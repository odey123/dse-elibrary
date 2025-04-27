import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:systems_app/services/cloud/database/cloud_profile.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';

class EmptyStateWidget extends StatefulWidget {
  final String namePlaceholder;
  final Widget actionButton;
  final CloudProfile? profile;

  const EmptyStateWidget({
    super.key,
    required this.namePlaceholder,
    required this.actionButton,
    this.profile,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final bool isPhoneWeb = screenSize.width < 600;

    return Column(
      children: [
        if (!isPhoneWeb)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kLargePadding,
              vertical: kPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 15,
                        child: SvgPicture.asset(AssetPaths.arrowBack),
                      ),
                      const SizedBox(width: kSmallPadding),
                      Transform.translate(
                        offset: const Offset(0, 1),
                        child: Text(
                          'Back',
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 13,
                            color: kGry800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.notifications_none, color: kBlack800),
                    const SizedBox(width: kRegularPadding),
                    const CircleAvatar(
                        backgroundColor: kOrange500, radius: 12.5),
                    const SizedBox(width: kRegularPadding),
                    CircleAvatar(
                      radius: 12.5,
                      backgroundImage: AssetImage(
                        AssetPaths.avatar,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        Expanded(
          child: Container(
            width: screenSize.width,
            decoration: const BoxDecoration(
              color: kGry400,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: kLargePadding * 2,
                horizontal: kFullPadding,
              ),
              child: Container(
                decoration: const BoxDecoration(color: kPrimaryWhite),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset(AssetPaths.emptyPage),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'You have not added any ${widget.namePlaceholder}',
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 12,
                        color: kGry600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    widget.actionButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EmptyStateWidgetTwo extends StatelessWidget {
  final String namePlaceholder;
  final Widget actionButton;

  const EmptyStateWidgetTwo({
    super.key,
    required this.namePlaceholder,
    required this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 700,
          decoration: BoxDecoration(
            color: kPrimaryWhite,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: kGry500),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: kLargePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 170,
                width: 170,
                child: Image.asset(AssetPaths.emptyPage),
              ),
              const SizedBox(height: 15),
              Text(
                'You have not added any $namePlaceholder',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  color: kGry600,
                ),
              ),
              const SizedBox(height: 25),
              actionButton,
            ],
          ),
        ),
      ],
    );
  }
}
