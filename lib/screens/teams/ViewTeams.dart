import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/teamController.dart';
import 'package:ams/models/TeamModel.dart';
import 'package:ams/components/CustomWidget.dart';

class ViewTeamsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamController = ref.read(teamControllerProvider);
    final teams = useState<List<Team>>([]);
    final isLoading = useState<bool>(true);

    useEffect(() {
      Future<void> fetchTeams() async {
        final storage = FlutterSecureStorage();
        String? employeeId = await storage.read(key: 'userId');
        if (employeeId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User ID not found')),
          );
          isLoading.value = false;
          return;
        }

        try {
          teams.value = await teamController.getTeamsForEmployee(employeeId);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch teams')),
          );
        } finally {
          isLoading.value = false;
        }
      }

      fetchTeams();
      return;
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
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: teams.value.isNotEmpty
                ? teams.value.map((team) => TeamDetailsTile(team: team)).toList()
                : [Center(child: Text('No teams found'))],
          ),
        ),
      ),
    );
  }
}
