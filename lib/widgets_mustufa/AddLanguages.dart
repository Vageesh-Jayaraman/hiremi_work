import 'package:flutter/material.dart';
import 'package:hiremi_version_two/Profile_Screen.dart';
import 'package:hiremi_version_two/Utils/AppSizes.dart';
import 'package:hiremi_version_two/Utils/colors.dart';
import 'package:hiremi_version_two/widgets_mustufa/TextFieldWithTitle.dart';


class AddLanguages extends StatefulWidget {
  const AddLanguages({Key? key, }) : super(key: key);

  @override
  State<AddLanguages> createState() => _AddLanguagesState();
}

class _AddLanguagesState extends State<AddLanguages> {
  TextEditingController languageController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar:  AppBar(
          title: const Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(
              top: Sizes.responsiveXl(context),
              right: Sizes.responsiveDefaultSpace(context),
              bottom: kToolbarHeight,
              left: Sizes.responsiveDefaultSpace(context)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Languages',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Sizes.responsiveMd(context),
            ),
                TextFieldWithTitle(controller: languageController, title: 'Add Language', hintText: 'eg: Hindi, English etc.'),
         SizedBox(height: Sizes.responsiveMd(context) * 2,),
                Center(child:
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Sizes.radiusSm)),
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.responsiveHorizontalSpace(context),
                          horizontal: Sizes.responsiveMdSm(context)),
                    ),
                    onPressed: () {
                      if (languageController.text.isNotEmpty) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) =>  ProfileScreen()));
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    )),
                ),
          ]),
        )));
  }
}
