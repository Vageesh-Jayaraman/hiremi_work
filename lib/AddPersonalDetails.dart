import 'package:flutter/material.dart';
import 'package:hiremi_version_two/Profile_Screen.dart';
import 'package:hiremi_version_two/Utils/AppSizes.dart';
import 'package:hiremi_version_two/Utils/colors.dart';
import 'package:hiremi_version_two/widgets_mustufa/AddLanguages.dart';
import 'package:hiremi_version_two/widgets_mustufa/TextFieldWithTitle.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'API_Integration/Add Personal Details/apiServices.dart';

class AddPersonalDetails extends StatefulWidget {
  const AddPersonalDetails({Key? key}) : super(key: key);

  @override
  State<AddPersonalDetails> createState() => _AddPersonalDetailsState();
}

class _AddPersonalDetailsState extends State<AddPersonalDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedGender = '';
  String selectedMaritalStatus = '';
  String differentlyAbled = '';
  TextEditingController homeController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController localAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  final AddPersonalDetailsService _apiService = AddPersonalDetailsService();

  @override
  void initState() {
    super.initState();
    _loadPersonalDetails();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _loadPersonalDetails() async {
    final service = AddPersonalDetailsService();
    final details = await service.getPersonalDetails();
    if (details.isNotEmpty) {
      setState(() {
        dobController.text = details['date_of_birth'] ?? '';
        selectedGender = details['gender'] ?? '';
        selectedMaritalStatus = details['marital_status'] ?? '';
        nationalityController.text = details['nationality'] ?? '';
        homeController.text = details['home_town'] ?? '';
        pinCodeController.text = details['pincode'] ?? '';
        localAddressController.text = details['local_address'] ?? '';
        permanentAddressController.text = details['permanent_address'] ?? '';
        differentlyAbled = details['ability'] ?? '';
        categoryController.text = details['category'] ?? '';
      });
    }
  }

  Future<void> _savePersonalDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileId = prefs.getInt('profileId').toString();
      print('Profile ID: $profileId');

      if (profileId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile ID not found')),
        );
        return;
      }

      final details = {
        "date_of_birth": dobController.text,
        "gender": selectedGender,
        "marital_status": selectedMaritalStatus,
        "nationality": nationalityController.text,
        "home_town": homeController.text,
        "pincode": pinCodeController.text,
        "local_address": localAddressController.text,
        "permanent_address": permanentAddressController.text,
        "ability": differentlyAbled,
        "category": categoryController.text,
        "profile": profileId,
      };
      print(details);

      final success = await _apiService.addOrUpdatePersonalDetails(details);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personal details saved successfully')),
        );
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ProfileScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save personal details')),
        );
      }
    }
  }

  Future<void> _saveAndNext() async {
    if (_formKey.currentState?.validate() ?? false) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileId = prefs.getInt('profileId').toString();
      print('Profile ID: $profileId');

      if (profileId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile ID not found')),
        );
        return;
      }

      final details = {
        "date_of_birth": dobController.text,
        "gender": selectedGender,
        "marital_status": selectedMaritalStatus,
        "nationality": nationalityController.text,
        "home_town": homeController.text,
        "pincode": pinCodeController.text,
        "local_address": localAddressController.text,
        "permanent_address": permanentAddressController.text,
        "ability": differentlyAbled,
        "category": categoryController.text,
        "profile": profileId,
      };
      print(details);

      final success = await _apiService.addOrUpdatePersonalDetails(details);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personal details saved successfully')),
        );
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const AddLanguages()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save personal details')),
        );
      }
    }
  }

  Widget buildRadioButtonGroup(String title, List<String> options, String groupValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
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
        SizedBox(height: Sizes.responsiveXxs(context)),
        Row(
          children: options.map((option) {
            return Row(
              children: [
                Radio(
                  activeColor: Colors.blue,
                  value: option,
                  groupValue: groupValue,
                  onChanged: onChanged,
                ),
                Text(
                  option,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: groupValue == option ? Colors.black : AppColors.secondaryText,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: Sizes.responsiveXl(context),
                right: Sizes.responsiveDefaultSpace(context),
                bottom: Sizes.responsiveXxl(context) * 2.4,
                left: Sizes.responsiveDefaultSpace(context)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: Sizes.responsiveMd(context)),
                  buildRadioButtonGroup(
                    'Gender',
                    ['Male', 'Female', 'Other'],
                    selectedGender,
                        (value) => setState(() {
                      selectedGender = value!;
                    }),
                  ),
                  SizedBox(height: 10),
                  buildRadioButtonGroup(
                    'Marital Status',
                    ['Married', 'Single'],
                    selectedMaritalStatus,
                        (value) => setState(() {
                      selectedMaritalStatus = value!;
                    }),
                  ),
                  SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Nationality',
                    controller: nationalityController,
                    hintText: 'Nationality',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your nationality';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Home Town',
                    controller: homeController,
                    hintText: 'Home Town',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your home town';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Pincode',
                    controller: pinCodeController,
                    hintText: 'Pincode',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your pincode';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Local Address',
                    controller: localAddressController,
                    hintText: 'Local Address',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your local address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Permanent Address',
                    controller: permanentAddressController,
                    hintText: 'Permanent Address',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your permanent address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  buildRadioButtonGroup(
                    'Differently Abled',
                    ['Yes', 'No'],
                    differentlyAbled,
                        (value) => setState(() {
                      differentlyAbled = value!;
                    }),
                  ),
                  SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Category',
                    controller: categoryController,
                    hintText: 'Category',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFieldWithTitle(
                    title: 'Date of Birth',
                    controller: dobController,
                    hintText: 'Date of Birth',
                    suffix: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your date of birth';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Sizes.responsiveSm(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Sizes.radiusSm)),
                            padding: EdgeInsets.symmetric(
                                vertical: Sizes.responsiveHorizontalSpace(context),
                                horizontal: Sizes.responsiveMdSm(context)),
                          ),
                          onPressed: _savePersonalDetails,
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          )),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary, width: 0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(Sizes.radiusSm)),
                          padding: EdgeInsets.symmetric(
                              vertical: Sizes.responsiveHorizontalSpace(context),
                              horizontal: Sizes.responsiveMdSm(context)),
                        ),
                        onPressed: _saveAndNext,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Save & Next',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(
                              width: Sizes.responsiveXs(context),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 11,
                              color: AppColors.primary,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
