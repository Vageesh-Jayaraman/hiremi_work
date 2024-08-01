import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddEducationService {
  final String url = 'http://13.127.81.177:8000/api/education/';

  Future<bool> addEducation(Map<String, dynamic> details) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storeEducationDetailsLocally(details);
        return true;
      } else {
        print('Failed to add education details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding education details: $e');
      return false;
    }
  }

  Future<void> _storeEducationDetailsLocally(Map<String, dynamic> details) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingDetails = prefs.getStringList('educationDetails') ?? [];
    existingDetails.add(jsonEncode(details));
    await prefs.setStringList('educationDetails', existingDetails);
  }

  Future<List<Map<String, String>>> getEducationDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final details = prefs.getStringList('educationDetails');
    final int? profileId = prefs.getInt('profileId');

    if (details != null) {
      try {
        final decodedDetails = details.map((detail) {
          final Map<String, dynamic> decodedDetail = jsonDecode(detail);
          return decodedDetail.map((key, value) => MapEntry(key, value.toString()));
        }).toList();
        return _filterDetailsByProfileId(decodedDetails, profileId);
      } catch (e) {
        print('Error occurred while decoding education details: $e');
        return [];
      }
    } else if (profileId != null) {
      final serverDetails = await getEducationDetailsFromServer(profileId);
      if (serverDetails.isNotEmpty) {
        await _storeEducationDetailsListLocally(serverDetails);
        return serverDetails;
      } else {
        return [];
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return [];
    }
  }

  Future<void> _storeEducationDetailsListLocally(List<Map<String, String>> detailsList) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedDetailsList = detailsList.map((details) => jsonEncode(details)).toList();
    await prefs.setStringList('educationDetails', encodedDetailsList);
  }

  Future<List<Map<String, String>>> getEducationDetailsFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> detailsList = jsonDecode(response.body);

        final List<Map<String, String>> educationDetailsList = detailsList.map((details) {
          final Map<String, String> educationDetails = {};
          details.forEach((key, value) {
            educationDetails[key] = value.toString();
          });
          return educationDetails;
        }).toList();

        return _filterDetailsByProfileId(educationDetailsList, profileId);
      } else {
        print('Failed to fetch education details. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching education details: $e');
      return [];
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
