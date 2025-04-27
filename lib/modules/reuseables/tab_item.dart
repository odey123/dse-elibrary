import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/utils/constant.dart';

class TabItem extends StatelessWidget {
  final String label;
  final String iconPath;
  final String selectedTab;
  final String currentTab;
  final Function(String) onTap;
  final Color unselectedtextColor;

  const TabItem({
    super.key,
    required this.label,
    required this.iconPath,
    required this.selectedTab,
    required this.currentTab,
    required this.onTap,
    required this.unselectedtextColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (!kIsWeb || isPhoneWeb) ? kMicroPadding : kMediumPadding,
        vertical: kSmallPadding + 3,
      ),
      child: InkWell(
        onTap: () {
          (!kIsWeb || isPhoneWeb) ? Scaffold.of(context).closeDrawer() : null;
          onTap(currentTab);
        },
        borderRadius: BorderRadius.all(
          Radius.circular((!kIsWeb || isPhoneWeb) ? 8 : 6),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal:
                (!kIsWeb || isPhoneWeb) ? kMicroPadding : kMediumPadding,
            vertical: (!kIsWeb || isPhoneWeb) ? kSmallPadding : kPadding + 2,
          ),
          decoration: BoxDecoration(
            color:
                (selectedTab == currentTab) ? kDarkYellow : Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular((!kIsWeb || isPhoneWeb) ? 8 : 6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 14,
                width: 14,
                decoration: const BoxDecoration(),
                child: SvgPicture.asset(
                  iconPath,
                ),
              ),
              XBox(kSmallPadding),
              Transform.translate(
                offset: const Offset(0, 2),
                child: Text(
                  label,
                  style: textTheme.titleMedium!.copyWith(
                    fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                    color: (selectedTab == currentTab)
                        ? kPrimaryWhite
                        : unselectedtextColor,
                  ),
                ),
              ),
              XBox(kPadding),
              (selectedTab == currentTab)
                  ? Transform.translate(
                      offset: const Offset(0, 1),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: kPrimaryWhite,
                        size: (!kIsWeb || isPhoneWeb) ? 19 : 16,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
