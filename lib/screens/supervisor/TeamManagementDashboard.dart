import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/appColors.dart';
import 'package:ams/providers/teamController.dart';
import 'package:ams/models/Team.dart';
import 'package:ams/screens/supervisor/CreateTeam.dart';
import 'package:ams/screens/supervisor/EditTeam.dart';

class TeamManagementDashboardScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamController = ref.read(teamControllerProvider);
    final teams = useState<List<Team>>([]);
    final isLoading = useState<bool>(true);
    final userId = useState<String?>('');

    final storage = FlutterSecureStorage();

    Future<void> fetchTeams() async {
      try {
        userId.value = await storage.read(key: 'userId');
        teams.value = await teamController.getTeamsForEmployee(userId.value ?? '');
      } catch (e) {
        print('Error fetching teams: $e');
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchTeams();
      return null;
    }, []);

    void confirmDelete(BuildContext context, Team team) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete the team "${team.teamName}"?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await teamController.deleteTeam(team.teamId);
                  fetchTeams();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Team Management',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: teams.value.map((team) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: team.teamsImage.isNotEmpty
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(team.teamsImage),
                    radius: 30,
                  )
                      : CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.group, color: Colors.white),
                    radius: 30,
                  ),
                  title: Text(team.teamName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Project: ${team.projectName}'),
                      Text('Supervisor: ${team.supervisor}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditTeamScreen(team: team)),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          confirmDelete(context, team);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(36.0), // Adjust the padding as needed
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateTeamScreen()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: AppColors.buttonColor,
          foregroundColor: Colors.white, // Set the color of the + icon
        ),
      ),
    );
  }
}
