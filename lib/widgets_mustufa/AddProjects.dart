import 'package:flutter/material.dart';
import 'package:hiremi_version_two/API_Integration/Add%20Projects/apiServices.dart';
import 'package:hiremi_version_two/AddPersonalDetails.dart';
import 'package:hiremi_version_two/Utils/AppSizes.dart';
import 'package:hiremi_version_two/Utils/colors.dart';
import 'package:hiremi_version_two/widgets_mustufa/TextFieldWithTitle.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProjects extends StatefulWidget {
  const AddProjects({Key? key}) : super(key: key);

  @override
  State<AddProjects> createState() => _AddProjectsState();
}

class _AddProjectsState extends State<AddProjects> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController projectLinkController = TextEditingController();
  TextEditingController startingDateController = TextEditingController();
  TextEditingController completionDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String projectStatus = '';
  final AddProjectsService _apiService = AddProjectsService();
  DateTime? _startingDate;
  DateTime? _completionDate;

  Future<void> _selectDate(BuildContext context, bool isStartingDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartingDate) {
          _startingDate = pickedDate;
          startingDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        } else {
          _completionDate = pickedDate;
          completionDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      });
    }
  }

  Future<void> _saveProject() async {
    if (_formKey.currentState?.validate() ?? false) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileId = prefs.getInt('profileId')?.toString();
      print('Profile ID: $profileId');

      if (profileId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile ID not found')),
        );
        return;
      }

      // Ensure the link includes 'http://'
      String link = projectLinkController.text;
      if (!link.startsWith('http://') && !link.startsWith('https://')) {
        link = 'http://' + link;
      }

      final details = {
        "project_title": titleController.text,
        "client": clientController.text,
        "link": link,
        "start_date": startingDateController.text,
        "status": projectStatus,
        "end_date": projectStatus == 'Completed' ? completionDateController.text : null,
        "description": descriptionController.text,
        "profile": profileId,
      };
      print(details);

      final success = await _apiService.addProject(details);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project details added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add project details')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: Sizes.responsiveXl(context),
              right: Sizes.responsiveDefaultSpace(context),
              bottom: kToolbarHeight,
              left: Sizes.responsiveDefaultSpace(context)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Projects',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: Sizes.responsiveMd(context)),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWithTitle(
                        controller: titleController,
                        title: 'Project Title',
                        hintText: 'eg: Project Title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Project Title is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: Sizes.responsiveMd(context)),
                    Expanded(
                      child: TextFieldWithTitle(
                        controller: clientController,
                        title: 'Client',
                        hintText: 'eg: Organisation or Client etc.',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Client is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Sizes.responsiveMd(context)),
                TextFieldWithTitle(
                  controller: projectLinkController,
                  title: 'Add Project Link',
                  hintText: 'eg: paste project link here.',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Project Link is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Sizes.responsiveMd(context)),
                GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: AbsorbPointer(
                    child: TextFieldWithTitle(
                      title: 'Starting Date',
                      hintText: 'YYYY-MM-DD',
                      spaceBtwTextField: Sizes.responsiveMd(context),
                      controller: startingDateController,
                      prefix: Icon(
                        Icons.calendar_month_sharp,
                        size: 16,
                        color: AppColors.secondaryText,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Starting Date is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: Sizes.responsiveMd(context)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Project Status',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: 'Completed',
                              groupValue: projectStatus,
                              onChanged: (value) => setState(() {
                                projectStatus = value as String;
                              }),
                            ),
                            Text(
                              'Completed',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: projectStatus == 'Completed'
                                      ? Colors.black
                                      : AppColors.secondaryText),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: 'On-Going',
                              groupValue: projectStatus,
                              onChanged: (value) {
                                setState(() {
                                  projectStatus = value as String;
                                });
                              },
                            ),
                            Text(
                              'On-Going',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: projectStatus == 'On-Going'
                                      ? Colors.black
                                      : AppColors.secondaryText),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: projectStatus == 'Completed'
                      ? () => _selectDate(context, false)
                      : null,
                  child: AbsorbPointer(
                    absorbing: projectStatus != 'Completed',
                    child: TextFieldWithTitle(
                      title: 'Completion Date, if “Completed” selected above.',
                      starNeeded: false,
                      hintText: 'YYYY-MM-DD',
                      controller: completionDateController,
                      spaceBtwTextField: Sizes.responsiveMd(context),
                      prefix: Icon(
                        Icons.calendar_month_sharp,
                        size: 16,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Sizes.responsiveMd(context)),
                TextFieldWithTitle(
                  title: 'Project Description',
                  hintText: 'Tell us about your project...',
                  controller: descriptionController,
                  spaceBtwTextField: Sizes.responsiveMd(context),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Project Description is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Sizes.responsiveMd(context) * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.radiusSm)),
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.responsiveHorizontalSpace(context),
                            horizontal: Sizes.responsiveMdSm(context)),
                      ),
                      onPressed: _saveProject,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary, width: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.radiusSm)),
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.responsiveSm(context),
                            horizontal: Sizes.responsiveMdSm(context)),
                      ),
                      onPressed: () {
                        _saveProject().then((_) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const AddPersonalDetails()));
                        });
                      },
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
      ),
    );
  }
}
