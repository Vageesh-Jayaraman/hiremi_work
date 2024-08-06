import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPersonalLinksService {
  final String url = 'http://13.127.81.177:8000/api/links/';

  Future<bool> addPersonalLinks(Map<String, dynamic> links) async {
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

  Future<void> _storePersonalLinksLocally(Map<String, dynamic> links) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingLinks = prefs.getStringList('personalLinks') ?? [];
    existingLinks.add(jsonEncode(links));
    await prefs.setStringList('personalLinks', existingLinks);
  }

  Future<List<Map<String, String>>> getPersonalLinks() async {
    final prefs = await SharedPreferences.getInstance();
    final links = prefs.getStringList('personalLinks');
    final int? profileId = prefs.getInt('profileId');

    if (links != null) {
      try {
        final decodedLinks = links.map((link) {
          final Map<String, dynamic> decodedLink = jsonDecode(link);
          return decodedLink.map((key, value) => MapEntry(key, value.toString()));
        }).toList();
        return _filterLinksByProfileId(decodedLinks, profileId);
      } catch (e) {
        print('Error occurred while decoding personal links: $e');
        return [];
      }
    } else if (profileId != null) {
      final serverLinks = await getPersonalLinksFromServer(profileId);
      if (serverLinks.isNotEmpty) {
        await _storePersonalLinksListLocally(serverLinks);
        return serverLinks;
      } else {
        return [];
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return [];
    }
  }

  Future<void> _storePersonalLinksListLocally(List<Map<String, String>> linksList) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedLinksList = linksList.map((links) => jsonEncode(links)).toList();
    await prefs.setStringList('personalLinks', encodedLinksList);
  }

  Future<List<Map<String, String>>> getPersonalLinksFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse('$url?profile_id=$profileId'));

      if (response.statusCode == 200) {
        final List<dynamic> linksList = jsonDecode(response.body);

        final List<Map<String, String>> personalLinksList = linksList.map((links) {
          final Map<String, String> personalLinks = {};
          links.forEach((key, value) {
            personalLinks[key] = value.toString();
          });
          return personalLinks;
        }).toList();

        return _filterLinksByProfileId(personalLinksList, profileId);
      } else {
        print('Failed to fetch links. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching links: $e');
      return [];
    }
  }

  List<Map<String, String>> _filterLinksByProfileId(List<Map<String, String>> linksList, int? profileId) {
    if (profileId == null) {
      print('Profile ID is null.');
      return [];
    }
    return linksList.where((links) {
      final profile = links['profile'];
      final int profileIdFromLinks = profile != null ? int.tryParse(profile) ?? -1 : -1;
      return profileIdFromLinks == profileId;
    }).toList();
  }
}
