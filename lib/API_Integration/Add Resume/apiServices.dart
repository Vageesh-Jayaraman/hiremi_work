import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResumeApiService {
  final String url = 'http://13.127.81.177:8000/api/resumelink/';

  Future<bool> saveResumeLink(Map<String, dynamic> details) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storeResumeLinkLocally(details);
        return true;
      } else {
        print('Failed to save resume link: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while saving resume link: $e');
      return false;
    }
  }

  Future<void> _storeResumeLinkLocally(Map<String, dynamic> details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('resumeLink', jsonEncode(details));
  }

  Future<Map<String, String>> getResumeLink() async {
    final prefs = await SharedPreferences.getInstance();
    final String? details = prefs.getString('resumeLink');
    final int? profileId = prefs.getInt('profileId');

    if (details != null) {
      try {
        return Map<String, String>.from(jsonDecode(details));
      } catch (e) {
        print('Error occurred while decoding resume link details: $e');
        return {};
      }
    } else if (profileId != null) {
      final serverDetails = await getResumeLinkFromServer(profileId);
      if (serverDetails.isNotEmpty) {
        await _storeResumeLinkLocally(serverDetails);
        return serverDetails;
      } else {
        return {};
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return {};
    }
  }

  Future<Map<String, String>> getResumeLinkFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> detailsList = jsonDecode(response.body);

        final List<Map<String, String>> details = detailsList.map((detail) {
          final Map<String, dynamic> decodedDetail = detail as Map<String, dynamic>;
          return decodedDetail.map((key, value) => MapEntry(key, value.toString()));
        }).toList();

        final filteredDetails = _filterDetailsByProfileId(details, profileId);
        return filteredDetails.isNotEmpty ? filteredDetails.first : {};
      } else {
        print('Failed to fetch resume link. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error occurred while fetching resume link: $e');
      return {};
    }
  }

  List<Map<String, String>> _filterDetailsByProfileId(List<Map<String, String>> detailsList, int? profileId) {
    if (profileId == null) {
      print('Profile ID is null.');
      return [];
    }
    return detailsList.where((details) {
      final profile = details['profile'];
      final int profileIdFromDetails = profile != null ? int.tryParse(profile) ?? -1 : -1;
      return profileIdFromDetails == profileId;
    }).toList();
  }
}
