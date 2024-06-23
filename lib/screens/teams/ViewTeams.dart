import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/teamController.dart';
import 'package:ams/models/Team.dart';
import 'package:ams/screens/teams/TeamDetails.dart';

class ViewTeamsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamController = ref.read(teamControllerProvider);
    final teams = useState<List<Team>>([]);
    final isLoading = useState<bool>(true);

    useEffect(() {
      Future<void> fetchTeams() async {
        try {
          teams.value = await teamController.getAllTeams();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch teams')),
          );
        } finally {
          isLoading.value = false;
        }
      }

      fetchTeams();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'View Teams',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(36.0),
        itemCount: teams.value.length,
        itemBuilder: (context, index) {
          final team = teams.value[index];
          return Card(
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
              title: Text(
                team.teamName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project: ${team.projectName}'),
                  Text('Supervisor: ${team.supervisor}'),
                  Text('Start Date: ${team.startDate}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeamDetailsScreen(teamId: team.teamId)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
