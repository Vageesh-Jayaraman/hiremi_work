import 'package:flutter/material.dart';
import 'package:hiremi_version_two/Custom_Widget/CustomContainer/OutlinedButton.dart';
import 'package:hiremi_version_two/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Edit_Profile_Section/ProfileSummary/ProfileSummary.dart';

class ProfileSummary extends StatefulWidget {
  const ProfileSummary({Key? key}) : super(key: key);

  @override
  _ProfileSummaryState createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
  late Future<String?> _profileSummaryFuture;

  @override
  void initState() {
    super.initState();
    _profileSummaryFuture = _fetchProfileSummary();
  }

  Future<String?> _fetchProfileSummary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileSummary');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _profileSummaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return OutlinedContainer(
            onTap: () =>
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddProfileSummary())),
            title: 'Profile Summary',
            isTrue: false,
            child: const Text(
              'No profile summary available. Tap to add.',
              style: TextStyle(
                fontSize: 9.0,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          );
        } else {
          final summary = snapshot.data!;
          return OutlinedContainer(
            onTap: () =>
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddProfileSummary())),
            title: 'Profile Summary',
            isTrue: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary,
                  style: const TextStyle(
                    fontSize: 9.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}