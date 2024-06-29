import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ams/api/ApiClient.dart';
import 'package:ams/models/Team.dart';
import 'package:ams/models/TeamMember.dart';
import 'package:ams/models/User.dart';

final teamControllerProvider = Provider((ref) => TeamController());

class TeamController {
  final storage = FlutterSecureStorage();

  Future<String?> getAuthToken() async {
    return await storage.read(key: 'token');
  }

  Future<List<Team>> getAllTeams() async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/teams/all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch teams');
    }

    final data = json.decode(response.body) as List;
    return data.map((team) => Team.fromJson(team)).toList();
  }

  Future<void> createTeam(Team team) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/api/users/teams'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'teamName': team.teamName,
        'projectName': team.projectName,
        'supervisor': team.supervisor,
        'startDate': team.startDate,
        'teamsImage': "data:image/png;base64,"+team.teamsImage,
        'teamMembers': team.teamMembers,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create team');
    }
  }

  Future<void> updateTeam(String teamId, Team team) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('${ApiClient.baseUrl}/api/users/team/$teamId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'teamName': team.teamName,
        'projectName': team.projectName,
        'supervisor': team.supervisor,
        'startDate': team.startDate,
        'teamsImage': team.teamsImage,
        'teamMembers': team.teamMembers,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update team');
    }
  }

  Future<void> deleteTeam(String teamId) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('${ApiClient.baseUrl}/api/users/team/$teamId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete team');
    }
  }


  // Future<List<String>> searchTeamMembersByEmail(String emailPattern) async {
  //   final token = await getAuthToken();
  //   if (token == null) {
  //     throw Exception('Token not found');
  //   }
  //
  //   final response = await http.get(
  //     Uri.parse('${ApiClient.baseUrl}/api/users/employees/search?email=$emailPattern'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //
  //   if (response.statusCode != 200) {
  //     final errorData = json.decode(response.body);
  //     throw Exception('Failed to search team members: ${errorData['message']}');
  //   }
  //
  //   final data = json.decode(response.body) as List;
  //   return data.map((member) => member['email'] as String).toList();
  // }

  Future<List<TeamMember>> searchTeamMembersByEmail(String emailPattern) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/employees/search?email=$emailPattern'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search team members');
    }

    final data = json.decode(response.body) as List;
    return data.map((member) => TeamMember(
      name: member['firstName'],
      email: member['email'],
      userId: member['userId'],  // Add this line
    )).toList();
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user details: ${response.body}');
    }

    return json.decode(response.body);
  }

  Future<Team> getTeamDetails(String teamId) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/team/$teamId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch team details');
    }

    final data = json.decode(response.body);
    return Team.fromJson(data);
  }

  Future<List<Team>> getTeamsForEmployee(String employeeId) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/teams/getAllTeamsBy/$employeeId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch teams');
    }

    final List data = json.decode(response.body);
    return data.map((json) => Team.fromJson(json)).toList();
  }


  Future<Map<String, dynamic>> getSupervisorDetails() async {
    String? token = await storage.read(key: 'token');
    String? userId = await storage.read(key: 'userId');
    if (token == null || userId == null) {
      throw Exception('Token or user ID not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user details: ${response.body}');
    }

    return json.decode(response.body);
  }

}
