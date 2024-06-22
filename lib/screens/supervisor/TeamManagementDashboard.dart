import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/appColors.dart';
import 'package:ams/providers/teamController.dart';
import 'package:ams/models/TeamModel.dart';
import 'package:ams/screens/supervisor/CreateTeam.dart';

class TeamManagementDashboardScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamController = ref.read(teamControllerProvider);
    final teams = useState<List<Team>>([]);
    final isLoading = useState<bool>(true);

    Future<void> fetchTeams() async {
      try {
        teams.value = await teamController.getAllTeams();
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
                          // Navigate to the team editing screen
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await teamController.deleteTeam(team.teamId);
                          fetchTeams();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTeamScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.buttonColor,
      ),
    );
  }
}
