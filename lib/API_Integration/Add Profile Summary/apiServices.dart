import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddProfileSummaryService {
  final String url = 'http://13.127.81.177:8000/api/profile-summaries/';

  Future<bool> addProfileSummary(Map<String, String> details) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storeProfileSummaryLocally(details['summary']!);
        return true;
      } else {
        print('Failed to add profile summary. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding profile summary: $e');
      return false;
    }
  }

  Future<void> _storeProfileSummaryLocally(String summary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileSummary', summary);
  }

  Future<String> getProfileSummary() async {
    final prefs = await SharedPreferences.getInstance();
    final String? summary = prefs.getString('profileSummary');
    final int? profileId = prefs.getInt('profileId');

    if (summary != null) {
      return summary;
    } else if (profileId != null) {
      final serverSummary = await getProfileSummaryFromServer(profileId);
      if (serverSummary.isNotEmpty) {
        await _storeProfileSummaryLocally(serverSummary);
        return serverSummary;
      } else {
        return '';
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return '';
    }
  }

  Future<String> getProfileSummaryFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> summariesList = jsonDecode(response.body);

        for (var summaryDetails in summariesList) {
          final profile = summaryDetails['profile'];
          final int profileIdFromDetails = profile is String
              ? int.tryParse(profile) ?? -1
              : profile is int
              ? profile
              : -1;

          if (profileIdFromDetails == profileId) {
            return summaryDetails['summary'] as String? ?? '';
          }
        }
        print('No matching profile ID found.');
        return '';
      } else {
        print('Failed to fetch profile summary. Status code: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error occurred while fetching profile summary: $e');
      return '';
    }
  }
}
