// resume_section.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiremi_version_two/Utils/AppSizes.dart';
import 'package:hiremi_version_two/Utils/colors.dart';

import '../API_Integration/Add Resume/apiServices.dart';

class ResumeSection extends StatefulWidget {
  const ResumeSection({Key? key}) : super(key: key);

  @override
  _ResumeSectionState createState() => _ResumeSectionState();
}

class _ResumeSectionState extends State<ResumeSection> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadResumeLink();
  }

  Future<void> _loadResumeLink() async {
    final prefs = await SharedPreferences.getInstance();
    final resumeLink = prefs.getString('resumeLink') ?? '';
    _controller.text = resumeLink; // Pre-fill TextField with the current resume link
  }

  Future<void> _saveResumeLink() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final profileID = prefs.getInt('profileId')?.toString(); // Get profileID from SharedPreferences

    if (profileID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile ID not found.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final apiService = ResumeApiService();
    final details = {
      'url': _controller.text.trim(),
      'profile': profileID, // Include profileID in the request
    };

    final success = await apiService.saveResumeLink(details);

    if (success) {
      await prefs.setString('resumeLink', _controller.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume link saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save resume link.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizes.responsiveDefaultSpace(context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.radiusSm),
        border: Border.all(width: 0.5, color: AppColors.secondaryText),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'images/icons/Resume.png',
                height: 40,
                width: 30,
              ),
              SizedBox(width: Sizes.responsiveSm(context)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Resume Url',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                        '(Google Drive Link)',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Note:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 8,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              TextSpan(
                                text:
                                'Try to upload pdf in your google drive if possible, ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 8,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Sizes.responsiveXxs(context)),
                      Text(
                        'Other formats are also accepted.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Sizes.responsiveMd(context)),
          SizedBox(
            height: Sizes.responsiveLg(context),
            child: TextField(
              controller: _controller,
              cursorColor: AppColors.black,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.attach_file,
                  size: 11,
                ),
                hintText: 'Paste Link',
                labelStyle: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Sizes.responsiveXs(context)),
                alignLabelWithHint: true,
                hintStyle: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryText,
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryText,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryText,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: Sizes.responsiveMd(context)),
          SizedBox(
            height: Sizes.responsiveLg(context) * 1.06,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.radiusXs),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: Sizes.responsiveHorizontalSpace(context),
                    horizontal: Sizes.responsiveMdSm(context)),
              ),
              onPressed: _isLoading ? null : _saveResumeLink,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Save Resume',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(width: Sizes.responsiveXs(context)),
                  const Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 8,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
