import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:systems_app/utils/constant.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String coverImagePath;
  final String tag;
  final String bookUrl;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.coverImagePath,
    required this.tag,
    required this.bookUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        width: 190,
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
            Container(
                height: 170,
                decoration: const BoxDecoration(),
                child: Image.network(
                  coverImagePath,
                  fit: BoxFit.cover,
                )
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
                ),
            const SizedBox(height: kMacroPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kRegularPadding),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: kSmallPadding,
                  vertical: kSmallPadding,
                ),
                child: Text(
                  tag,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall!.copyWith(
                    fontSize: 13,
                    color: kBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
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
                    fontWeight: FontWeight.w400,
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
                  fontSize: 15,
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
