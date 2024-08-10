import 'package:flutter/material.dart';
import 'package:hiremi_version_two/Edit_Profile_Section/widgets/CustomTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API_Integration/Add Resume/apiServices.dart';
import '../Utils/AppSizes.dart';
import '../Utils/colors.dart';

class EditResumePage extends StatefulWidget {
  @override
  _EditResumePageState createState() => _EditResumePageState();
}

class _EditResumePageState extends State<EditResumePage> {
  final _formKey = GlobalKey<FormState>();
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
    _controller.text = resumeLink;
  }

  Future<void> _saveResumeLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final profileID = prefs.getInt('profileId')?.toString();

    if (profileID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final apiService = ResumeApiService();
    final details = {
      'url': _controller.text.trim(),
      'profile': profileID,
    };

    final success = await apiService.addOrUpdateResumeLink(details);

    if (success) {
      await prefs.setString('resumeLink', _controller.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume link saved successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save resume link.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Resume"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _controller,
                hintText: 'Paste Resume Link',
                prefix: const Icon(
                  Icons.link,
                  color: AppColors.black,
                  size: 15,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a resume link';
                  }
                  final urlPattern = r'^(https?:\/\/)';
                  final regExp = RegExp(urlPattern, caseSensitive: false);
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.radiusSm),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: Sizes.responsiveHorizontalSpace(context),
                    horizontal: Sizes.responsiveMdSm(context),
                  ),
                ),
                onPressed: _isLoading ? null : () async {
                  await _saveResumeLink();
                },
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
