import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/teamController.dart';
import 'package:ams/models/Team.dart';
import 'package:ams/models/User.dart';

class TeamDetailsScreen extends HookConsumerWidget {
  final String teamId;

  TeamDetailsScreen({required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamController = ref.read(teamControllerProvider);
    final team = useState<Team?>(null);
    final isLoading = useState<bool>(true);
    final userDetails = useState<Map<String, User>>({});

    useEffect(() {
      Future<void> fetchTeamDetails() async {
        try {
          final fetchedTeam = await teamController.getTeamDetails(teamId);
          team.value = fetchedTeam;

          final userDetailsMap = <String, User>{};
          print(fetchedTeam.teamMembers);
          for (var memberId in fetchedTeam.teamMembers) {

            final userJson = await teamController.getUserDetails(memberId);
            userDetailsMap[memberId] = User.fromJson(userJson as Map<String, dynamic>);
          }
          userDetails.value = userDetailsMap;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch team details')),
          );
        } finally {
          isLoading.value = false;
        }
      }

      fetchTeamDetails();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Team Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              team.value!.teamsImage.isNotEmpty
                  ? Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(team.value!.teamsImage),
                  radius: 80,
                ),
              )
                  : Center(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.group, color: Colors.white, size: 80),
                  radius: 80,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.value!.teamName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Supervisor: ${team.value!.supervisor}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Project: ${team.value!.projectName}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start Date: ${team.value!.startDate}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Members',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: team.value!.teamMembers.length,
                      itemBuilder: (context, index) {
                        final memberId = team.value!.teamMembers[index];
                        final user = userDetails.value[memberId];
                        return user != null
                            ? Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(user.profileImage),
                              backgroundColor: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${user.firstName} ${user.lastName}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                            : CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
