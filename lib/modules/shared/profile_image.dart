import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final void Function()? onTap;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = radius * 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageUrl.isEmpty
          ? InkWell(
              onTap: onTap,
              overlayColor: const WidgetStatePropertyAll(kTransparent),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: Image.asset(
                  AssetPaths.avatar,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : ImageNetwork(
              key: ValueKey(imageUrl),
              image: imageUrl,
              height: imageSize,
              width: imageSize,
              duration: 500,
              onPointer: true,
              debugPrint: false,
              backgroundColor: kPrimaryColor,
              fitAndroidIos: BoxFit.cover,
              fitWeb: BoxFitWeb.cover,
              onLoading: Image.asset(
                AssetPaths.avatar,
                fit: BoxFit.cover,
              ),
              onError: const Icon(Icons.error),
              borderRadius: BorderRadius.circular(radius),
              onTap: onTap,
            ),
    );
  }
}
