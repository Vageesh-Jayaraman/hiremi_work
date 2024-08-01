import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPersonalLinksService {
  final String url = 'http://yourbackendurl.com/api/personal-links/';

  Future<bool> addPersonalLinks(Map<String, String> links) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(links),
      );

      if (response.statusCode == 201) {
        await _storePersonalLinksLocally(links);
        return true;
      } else {
        print('Failed to add links. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding links: $e');
      return false;
    }
  }

  Future<void> _storePersonalLinksLocally(Map<String, String> links) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('personalLinks', jsonEncode(links));
  }

  Future<Map<String, String>> getPersonalLinks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? links = prefs.getString('personalLinks');
    final int? profileId = prefs.getInt('profileId');

    if (links != null) {
      return Map<String, String>.from(jsonDecode(links));
    } else if (profileId != null) {
      final serverLinks = await getPersonalLinksFromServer(profileId);
      if (serverLinks != null) {
        await _storePersonalLinksLocally(serverLinks);
        return serverLinks;
      } else {
        return {};
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return {};
    }
  }

  Future<Map<String, String>?> getPersonalLinksFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse('$url?profile_id=$profileId'));

      if (response.statusCode == 200) {
        final List<dynamic> linksList = jsonDecode(response.body);

        for (var links in linksList) {
          final profile = links['profile'];
          final int profileIdFromLinks = profile is String
              ? int.tryParse(profile) ?? -1
              : profile is int
              ? profile
              : -1;

          if (profileIdFromLinks == profileId) {
            final Map<String, String> personalLinks = {};
            links.forEach((key, value) {
              personalLinks[key] = value.toString();
            });
            await _storePersonalLinksLocally(personalLinks);
            return personalLinks;
          }
        }
        return null; // No matching profileId found
      } else {
        print('Failed to fetch links. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching links: $e');
      return null;
    }
  }
}
