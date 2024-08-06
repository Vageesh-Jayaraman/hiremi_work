import 'package:flutter/material.dart';
import 'package:hiremi_version_two/Custom_Widget/CustomContainer/OutlinedButton.dart';
import 'package:hiremi_version_two/Edit_Profile_Section/Experience/AddExperience.dart';
import 'package:hiremi_version_two/Utils/AppSizes.dart';
import 'package:hiremi_version_two/Utils/colors.dart';
import 'package:hiremi_version_two/API_Integration/Add%20Experience/apiServices.dart';

class Experience extends StatefulWidget {
  const Experience({Key? key}) : super(key: key);

  @override
  _ExperienceState createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  List<Map<String, String>> experiences = [];

  @override
  void initState() {
    super.initState();
    _loadExperienceDetails();
  }

  Future<void> _loadExperienceDetails() async {
    final service = AddExperienceService();
    final details = await service.getExperienceDetails();
    setState(() {
      experiences = details;
    });
  }

  bool isValid() {
    return experiences.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddExperience())),
      title: 'Experience',
      isTrue: isValid(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: experiences
            .map((exp) => ExperienceChild(
            title: exp['job_title'] ?? '',
            company: exp['company_name'] ?? '',
            jobType: exp['work_environment'] ?? '',
            timing: '${exp['start_date'] ?? ''} - ${exp['end_date'] ?? ''}'))
            .toList(),
      ),
    );
  }
}

class ExperienceChild extends StatelessWidget {
  const ExperienceChild({Key? key, required this.title, required this.jobType, required this.company, required this.timing}) : super(key: key);

  final String title, jobType, company, timing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: Sizes.responsiveXs(context),
        ),
        Text(
          jobType,
          style: const TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: Sizes.responsiveXxs(context),
        ),
        Text(
          company,
          style: const TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: Sizes.responsiveXxs(context),
        ),
        Text(
          timing,
          style: TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: Sizes.responsiveSm(context)),
        Divider(
          height: 0.25,
          thickness: 0.25,
          color: AppColors.secondaryText,
        ),
        SizedBox(height: Sizes.responsiveMd(context)),
      ],
    );
  }
}