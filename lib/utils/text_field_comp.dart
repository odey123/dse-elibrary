import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:systems_app/modules/reuseables/size_boxes.dart';
import 'package:systems_app/utils/constant.dart';

class CustomTextInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool enableSuggestions;
  final bool autocorrect;
  final double width;
  final double height;
  final bool isReadOnly;

  const CustomTextInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.isReadOnly = false,
    this.width = 350,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleMedium!.copyWith(
            fontSize: (!kIsWeb || isPhoneWeb) ? 16 : 13,
            fontWeight: FontWeight.w400,
            color: kBlack,
          ),
        ),
        YBox(kSmallPadding),
        SizedBox(
          height: height,
          width: width,
          child: TextField(
            readOnly: isReadOnly,
            controller: controller,
            keyboardType: keyboardType,
            enableSuggestions: enableSuggestions,
            autocorrect: autocorrect,
            style: textTheme.bodySmall!.copyWith(
              color: kBlack,
              fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 12,
              fontWeight: FontWeight.w400,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              hintText: hintText,
              hintStyle: textTheme.bodySmall!.copyWith(
                color: kGry600,
                fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: kGry450,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: kGry450,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: kGry450,
                ),
              ),
            ),
            cursorColor: kBlack,
            cursorWidth: 1.5,
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final TextEditingController controller;
  final double width;
  final double height;
  final Color dropdownColor;
  final IconData dropdownIcon;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.controller,
    this.width = 350,
    this.height = 35,
    this.dropdownColor = Colors.white,
    this.dropdownIcon = Icons.keyboard_arrow_down,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleMedium!.copyWith(
            fontSize: (!kIsWeb || isPhoneWeb) ? 16 : 13,
            fontWeight: FontWeight.w400,
            color: kBlack,
          ),
        ),
        YBox(kSmallPadding),
        SizedBox(
          height: height,
          width: width,
          child: DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: textTheme.bodySmall!.copyWith(
                          color: kBlack,
                          fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              controller.text = value!;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              hintText: hintText,
              hintStyle: textTheme.bodySmall!.copyWith(
                color: kGry600,
                fontSize: (!kIsWeb || isPhoneWeb) ? 15 : 12,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: kGry450,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: kGry450,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: kGry450,
                ),
              ),
            ),
            dropdownColor: dropdownColor,
            icon: Icon(
              dropdownIcon,
              color: kBlack,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
