import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hiremi_version_two/Custom_Widget/CustomContainer/OutlinedButton.dart';
import 'package:hiremi_version_two/Custom_Widget/RoundedContainer/roundedContainer.dart';
import 'package:hiremi_version_two/Utils/AppSizes.dart';
import 'package:hiremi_version_two/Utils/colors.dart';

class PersonalLinks extends StatefulWidget {
  const PersonalLinks({Key? key}) : super(key: key);

  @override
  _PersonalLinksState createState() => _PersonalLinksState();
}

class _PersonalLinksState extends State<PersonalLinks> {
  final List<String> _platforms = [
    'Certificate',
    'LOR',
    'LinkedIn',
    'Portfolio',
    'GitHub',
    'Other'
  ];
  String _selectedPlatform = 'LinkedIn';
  final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      showEdit: false,
      title: 'Add Links',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PersonalLinksChild(
            platforms: _platforms,
            selectedPlatform: _selectedPlatform,
            onPlatformChanged: (String? newValue) {
              setState(() {
                _selectedPlatform = newValue!;
              });
            },
            linkController: _linkController,
          ),
          SizedBox(
            height: Sizes.responsiveMd(context),
          ),
          SizedBox(
            height: Sizes.responsiveLg(context) * 1.06,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.radiusXs),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: Sizes.responsiveVerticalSpace(context),
                        horizontal: Sizes.responsiveMdSm(context))),
                onPressed: () {
                  // Add your onPressed logic here
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Add Links ',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .apply(color: AppColors.white),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 8,
                      color: AppColors.white,
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class PersonalLinksChild extends StatelessWidget {
  const PersonalLinksChild({
    Key? key,
    required this.platforms,
    required this.selectedPlatform,
    required this.onPlatformChanged,
    required this.linkController,
  }) : super(key: key);

  final List<String> platforms;
  final String selectedPlatform;
  final ValueChanged<String?> onPlatformChanged;
  final TextEditingController linkController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: Sizes.responsiveSm(context) * 25,
            height: Sizes.responsiveSm(context)*5 ,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(width: 0.5, color: AppColors.secondaryText),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.responsiveSm(context) * 1.15,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPlatform,
                onChanged: onPlatformChanged,
                items: platforms.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.75),
                      ),
                    ),
                  );
                }).toList(),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: Sizes.responsiveSm(context),
        ),
        Container(
          width: Sizes.responsiveSm(context) * 25,
          height: Sizes.responsiveSm(context)*5 ,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                width: 0.5,
                color: linkController.text.isNotEmpty
                    ? AppColors.green
                    : AppColors.secondaryText,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.responsiveSm(context) * 1.15,
            ),
            child: TextField(
              controller: linkController,
              decoration: InputDecoration(
                hintText: 'Paste Link',
                hintStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.25),
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
