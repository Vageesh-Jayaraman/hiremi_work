import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPersonalDetailsService {
  final String baseUrl = 'http://13.127.81.177:8000/api/personal-details/';

  Future<bool> addOrUpdatePersonalDetails(Map<String, String> details) async {
    final int? profileId = await _getProfileId();
    if (profileId != null) {
      final int? detailId = await _getDetailId(profileId);
      if (detailId != null) {
        return await updatePersonalDetails(detailId, details);
      } else {
        return await addPersonalDetails(details);
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return false;
    }
  }

  Future<bool> addPersonalDetails(Map<String, String> details) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storePersonalDetailsLocally(details);
        return true;
      } else {
        print('Failed to add details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding details: $e');
      return false;
    }
  }

  Future<bool> updatePersonalDetails(int detailId, Map<String, String> details) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$detailId/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 200) {
        await _storePersonalDetailsLocally(details);
        return true;
      } else {
        print('Failed to update details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while updating details: $e');
      return false;
    }
  }

  Future<void> _storePersonalDetailsLocally(Map<String, String> details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('personalDetails', jsonEncode(details));
    print('Personal details stored locally: ${jsonEncode(details)}');
  }

  Future<Map<String, String>> getPersonalDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final String? details = prefs.getString('personalDetails');
    final int? profileId = prefs.getInt('profileId');

    if (details != null) {
      print('Retrieved personal details from local storage: $details');
      return Map<String, String>.from(jsonDecode(details));
    } else if (profileId != null) {
      final serverDetails = await getPersonalDetailsFromServer(profileId);
      if (serverDetails != null) {
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

  Future<Map<String, String>?> getPersonalDetailsFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> detailsList = jsonDecode(response.body);

        for (var details in detailsList) {
          final profile = details['profile'];
          final int profileIdFromDetails = profile is String
              ? int.tryParse(profile) ?? -1
              : profile is int
              ? profile
              : -1;

          if (profileIdFromDetails == profileId) {
            final Map<String, String> personalDetails = {};
            details.forEach((key, value) {
              personalDetails[key] = value.toString();
            });
            print('Fetched personal details from server: ${jsonEncode(personalDetails)}');
            return personalDetails;
          }
        }
        return null; // No matching profileId found
      } else {
        print('Failed to fetch details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching details: $e');
      return null;
    }
  }

  Future<int?> _getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('profileId');
  }

  Future<int?> _getDetailId(int profileId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> detailsList = jsonDecode(response.body);

      for (var details in detailsList) {
        final profile = details['profile'];
        final int profileIdFromDetails = profile is String
            ? int.tryParse(profile) ?? -1
            : profile is int
            ? profile
            : -1;

        if (profileIdFromDetails == profileId) {
          return details['id'];
        }
      }
      return null; // No matching profileId found
    } else {
      print('Failed to fetch details. Status code: ${response.statusCode}');
      return null;
    }
  }
}
