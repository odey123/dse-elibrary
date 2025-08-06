import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:systems_app/utils/constant.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String coverImagePath;
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
  final String bookUrl;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.coverImagePath,
    required this.bookUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: kTransparent,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: kGry500,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageNetwork(
              key: ValueKey(coverImagePath),
              image: coverImagePath,
              height: 220,
              width: 180,
              duration: 500,
              onPointer: true,
              debugPrint: false,
              backgroundColor: kPrimaryColor.withOpacity(0.3),
              fitAndroidIos: BoxFit.cover,
              fitWeb: BoxFitWeb.fill,
              onError: const Icon(Icons.error),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              onTap: () {},
            ),
            //   child: CachedNetworkImage(
            //     imageUrl: coverImagePath,
            //     fit: BoxFit.cover,
            //     width: double.infinity,
            //     placeholder: (context, url) => const Center(
            //       child: CircularProgressIndicator(
            //         strokeWidth: 1.5,
            //         color: kPrimaryColor,
            //       ),
            //     ),
            //     errorWidget: (context, url, error) => const Icon(
            //       Icons.error,
            //       color: Colors.red,
            //     ),
            //   ),
            const SizedBox(height: kMacroPadding),
            const SizedBox(height: kRegularPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kRegularPadding),
              child: SizedBox(
                height: 45,
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall!.copyWith(
                    fontSize: 13,
                    color: kBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kRegularPadding),
            Padding(
              padding: const EdgeInsets.only(
                left: kRegularPadding,
                right: kRegularPadding,
                bottom: kMediumPadding,
              ),
              child: Text(
                author,
                style: textTheme.titleSmall!.copyWith(
                  fontSize: 11,
                  color: kBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
