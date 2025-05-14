import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/modules/shared/profile_image.dart';
import 'package:systems_app/services/cloud/database/cloud_profile.dart';
import 'package:systems_app/utils/assets_path.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';
import 'package:systems_app/utils/text_button_comp.dart';
import 'package:systems_app/utils/text_field_comp.dart';

class ProfileDrawer extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController? prefixController;
  final TextEditingController? preferredAcademicNameController;
  final TextEditingController? levelController;
  final bool isLecturer;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onImageTap;
  final Stream<CloudProfile?> profileStream;

  const ProfileDrawer({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.profileStream,
    required this.onSubmit,
    required this.onImageTap,
    required this.isLecturer,
    required this.isLoading,
    this.prefixController,
    this.preferredAcademicNameController,
    this.levelController,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kRegularPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (!kIsWeb || isPhoneWeb) ? YBox(kRegularPadding) : Container(),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: kRegularPadding),
                      child: SizedBox(
                        width: 94,
                        height: 94,
                        child: StreamBuilder<CloudProfile?>(
                          stream: profileStream,
                          builder: (context, snapshot) {
                            final profile = snapshot.data;
                            return ProfileImage(
                              imageUrl: profile?.profileImageUrl ?? '',
                              radius: 47,
                              onTap: onImageTap,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: kRegularPadding + 64, left: 50),
                        child: SvgPicture.asset(AssetPaths.profileEditIcon),
                      ),
                    ),
                  ),
                ],
              ),
              (!kIsWeb || isPhoneWeb)
                  ? YBox(kRegularPadding)
                  : YBox(kSmallPadding),
              CustomTextInputField(
                label: firstName,
                hintText: enterFirstName,
                controller: firstNameController,
              ),
              (!kIsWeb || isPhoneWeb)
                  ? YBox(kRegularPadding)
                  : YBox(kSmallPadding),
              CustomTextInputField(
                label: lastName,
                hintText: enterLastName,
                controller: lastNameController,
              ),
              (!kIsWeb || isPhoneWeb)
                  ? YBox(kRegularPadding)
                  : YBox(kSmallPadding),
              if (isLecturer)
                CustomTextInputField(
                  label: preferredAcademicName,
                  hintText: enterPreferredAcademicName,
                  controller: preferredAcademicNameController!,
                ),
              (!kIsWeb || isPhoneWeb)
                  ? YBox(kRegularPadding)
                  : YBox(kSmallPadding),
              CustomTextInputField(
                label: isLecturer ? lecturerEmailAddress : studentEmailAddress,
                hintText: isLecturer
                    ? enterLecturerEmailAddress
                    : enterStudentEmailAddress,
                controller: emailController,
                isReadOnly: true,
                textColor: kGry600,
                keyboardType: TextInputType.emailAddress,
              ),
              (!kIsWeb || isPhoneWeb)
                  ? YBox(kRegularPadding)
                  : YBox(kSmallPadding),
              if (isLecturer)
                CustomDropdownField(
                  label: levelCourseAdvisor,
                  hintText: selectLevel,
                  items: levels,
                  controller: levelController!,
                  isReadOnly: true,
                  textColor: kGry600,
                  iconColor: kGry600,
                  dropdownColor: kPrimaryWhite,
                  dropdownIcon: Icons.keyboard_arrow_down,
                )
              else
                CustomDropdownField(
                  label: currentLevel,
                  hintText: selectLevel,
                  items: levels,
                  controller: levelController!,
                  isReadOnly: true,
                  textColor: kGry600,
                  iconColor: kGry600,
                  dropdownColor: kPrimaryWhite,
                  dropdownIcon: Icons.keyboard_arrow_down,
                ),
              (!kIsWeb || isPhoneWeb)
                  ? YBox(kRegularPadding)
                  : YBox(kSmallPadding),
              if (isLecturer)
                CustomDropdownField(
                  label: prefix,
                  hintText: selectPrefix,
                  items: prefixs,
                  controller: prefixController!,
                  dropdownColor: kPrimaryWhite,
                  dropdownIcon: Icons.keyboard_arrow_down,
                ),
              (!kIsWeb || isPhoneWeb)
                  ? YBox(kRegularPadding)
                  : YBox(kSmallPadding),
              CustomTextButton(
                text: submit,
                onPressed: onSubmit,
                isLoading: isLoading,
                backgroundColor: kDarkYellow,
                textColor: kPrimaryWhite,
                borderColor: kTransparent,
                padding: EdgeInsets.only(
                  left: kMacroPadding - 3,
                  right: kMacroPadding,
                  top: (!kIsWeb || isPhoneWeb)
                      ? kSmallPadding + 4
                      : kRegularPadding + 4,
                  bottom: (!kIsWeb || isPhoneWeb)
                      ? kSmallPadding + 1
                      : kRegularPadding + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
