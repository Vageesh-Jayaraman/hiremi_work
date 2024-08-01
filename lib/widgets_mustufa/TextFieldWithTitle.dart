import 'package:flutter/material.dart';
import 'package:hiremi_version_two/Edit_Profile_Section/widgets/CustomTextField.dart';
import 'package:hiremi_version_two/Utils/AppSizes.dart';
import 'package:hiremi_version_two/Utils/colors.dart';


class TextFieldWithTitle extends StatelessWidget {
  const TextFieldWithTitle({Key? key, 
    required this.controller,
    required this.title,
    required this.hintText,
    this.starNeeded = true,
    this.prefix,
    this.suffix,
    this.spaceBtwTextField,
    this.maxLines,
  }) : super(key: key);

  final TextEditingController controller;
  final String title, hintText;
  final bool starNeeded;
  final Widget? prefix, suffix;
  final double? spaceBtwTextField;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (starNeeded)
              Text(
                '*',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
        SizedBox(
          height: spaceBtwTextField ?? Sizes.responsiveSm(context),
        ),
        CustomTextField(
            controller: controller,
            hintText: hintText,
            prefix: prefix,
            suffix: suffix,
            maxLines: maxLines),
      ],
    );
  }
}
