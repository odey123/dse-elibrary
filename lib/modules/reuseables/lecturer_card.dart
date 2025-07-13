import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:systems_app/utils/constant.dart';

class LecturerCard extends StatelessWidget {
  final String name;
  final String qualification;
  final String specialization;
  final bool stackOnLeft;
  final String imageUrl;

  const LecturerCard({
    super.key,
    required this.name,
    required this.qualification,
    required this.specialization,
    required this.stackOnLeft,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final imageStack = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: kRegularPadding,
            top: kRegularPadding,
          ),
          child: Container(
            height: 190,
            width: 200,
            decoration: const BoxDecoration(
              color: kPrimaryColor,
            ),
          ),
        ),
        ImageNetwork(
          image: imageUrl,
          height: 190,
          width: 200,
          duration: 500,
          onPointer: true,
          debugPrint: false,
          backgroundColor: kPrimaryColor.withOpacity(0.3),
          fitAndroidIos: BoxFit.cover,
          fitWeb: BoxFitWeb.fill,
          onError: const Icon(Icons.error),
        ),
      ],
    );

    final textContent = Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kMediumPadding),
          Text(
            name,
            style: textTheme.titleMedium!.copyWith(
              fontSize: 15,
              color: kBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: kPadding),
          Text(
            qualification,
            style: textTheme.titleMedium!.copyWith(
              fontSize: 13,
              color: kGry900,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: kPadding),
          Text(
            specialization,
            style: textTheme.titleMedium!.copyWith(
              fontSize: 15,
              color: kBlack,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kRegularPadding + kMediumPadding,
        vertical: kRegularPadding,
      ),
      child: Row(
        mainAxisAlignment:
            stackOnLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: stackOnLeft
            ? [
                imageStack,
                const SizedBox(width: kMacroPadding),
                textContent,
                const SizedBox(width: kSupremePadding),
              ]
            : [
                const SizedBox(width: kSupremePadding),
                textContent,
                const SizedBox(width: kMacroPadding),
                imageStack,
              ],
      ),
    );
  }
}
