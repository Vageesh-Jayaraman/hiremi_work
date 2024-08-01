import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPersonalDetailsService {
  final String url = 'http://13.127.81.177:8000/api/personal-details/';

  Future<bool> addPersonalDetails(Map<String, dynamic> details) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storePersonalDetailsLocally(details);
        return true;
      } else {
        print('Failed to add personal details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding personal details: $e');
      return false;
    }
  }

  Future<void> _storePersonalDetailsLocally(Map<String, dynamic> details) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingDetails = prefs.getStringList('personalDetails') ?? [];
    existingDetails.add(jsonEncode(details));
    await prefs.setStringList('personalDetails', existingDetails);
  }

  Future<Map<String, String>> getPersonalDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? details = prefs.getStringList('personalDetails');
    final int? profileId = prefs.getInt('profileId');

    if (details != null) {
      try {
        final decodedDetails = details.map((detail) {
          final Map<String, dynamic> decodedDetail = jsonDecode(detail);
          return decodedDetail.map((key, value) => MapEntry(key, value.toString()));
        }).toList();
        final filteredDetails = _filterDetailsByProfileId(decodedDetails, profileId);
        return filteredDetails.isNotEmpty ? filteredDetails.first : {};
      } catch (e) {
        print('Error occurred while decoding personal details: $e');
        return {};
      }
    } else if (profileId != null) {
      final serverDetails = await getPersonalDetailsFromServer(profileId);
      if (serverDetails.isNotEmpty) {
        await _storePersonalDetailsLocally(serverDetails);
        return serverDetails;
      } else {
        return {};
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return {};
    }
  }

  Future<Map<String, String>> getPersonalDetailsFromServer(int profileId) async {
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
        print('Failed to fetch personal details. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error occurred while fetching personal details: $e');
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
