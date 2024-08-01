import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddProjectsService {
  final String url = 'http://13.127.81.177:8000/api/projects/';

  Future<bool> addProject(Map<String, dynamic> details) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(details),
      );

      if (response.statusCode == 201) {
        await _storeProjectLocally(details);
        return true;
      } else {
        print('Failed to add project: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while adding project: $e');
      return false;
    }
  }

  Future<void> _storeProjectLocally(Map<String, dynamic> project) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingProjects = prefs.getStringList('projects') ?? [];
    existingProjects.add(jsonEncode(project));
    await prefs.setStringList('projects', existingProjects);
  }

  Future<List<Map<String, dynamic>>> getProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? projects = prefs.getStringList('projects');
    final int? profileId = prefs.getInt('profileId');

    if (projects != null) {
      try {
        final decodedProjects = projects.map((project) {
          final Map<String, dynamic> decodedProject = jsonDecode(project);
          return decodedProject;
        }).toList();
        return _filterProjectsByProfileId(decodedProjects, profileId);
      } catch (e) {
        print('Error occurred while decoding projects: $e');
        return [];
      }
    } else if (profileId != null) {
      final serverProjects = await getProjectsFromServer(profileId);
      if (serverProjects.isNotEmpty) {
        await _storeProjectsListLocally(serverProjects);
        return serverProjects;
      } else {
        return [];
      }
    } else {
      print('Profile ID not found in SharedPreferences.');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProjectsFromServer(int profileId) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> projectsList = jsonDecode(response.body);

        final List<Map<String, dynamic>> projects = projectsList.map((project) {
          return Map<String, dynamic>.from(project);
        }).toList();

        return _filterProjectsByProfileId(projects, profileId);
      } else {
        print('Failed to fetch projects. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching projects: $e');
      return [];
    }
  }

  Future<void> _storeProjectsListLocally(List<Map<String, dynamic>> projectsList) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedProjectsList = projectsList.map((project) => jsonEncode(project)).toList();
    await prefs.setStringList('projects', encodedProjectsList);
  }

  List<Map<String, dynamic>> _filterProjectsByProfileId(List<Map<String, dynamic>> projectsList, int? profileId) {
    if (profileId == null) {
      print('Profile ID is null.');
      return [];
    }
    return projectsList.where((project) {
      final profile = project['profile'];
      final int profileIdFromProject = profile != null ? int.tryParse(profile.toString()) ?? -1 : -1;
      return profileIdFromProject == profileId;
    }).toList();
  }
}
