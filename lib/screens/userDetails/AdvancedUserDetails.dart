import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:ams/providers/leaveController.dart';
import 'package:ams/providers/InsightsController.dart';
import 'package:ams/providers/teamController.dart';
import 'package:ams/screens/supervisor/PreviousWorkedHours.dart';
import 'package:ams/components/CustomWidget.dart';

final insightsControllerProvider = Provider((ref) => InsightsController());

final workedHoursProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final insightsController = ref.watch(insightsControllerProvider);
  DateTime startDate = insightsController.getStartOfWeek(DateTime.now());
  DateTime endDate = startDate.add(Duration(days: 5));
  return insightsController.fetchAttendanceData(startDate, endDate);
});

final leaveDataProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final leaveController = ref.watch(leaveControllerProvider);
  return leaveController.getLeaveCounts(userId);
});

final userDetailsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final teamController = ref.watch(teamControllerProvider);
  return teamController.getUserDetails(userId);
});

class AdvancedUserDetailsScreen extends HookConsumerWidget {
  final String userId;

  AdvancedUserDetailsScreen({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workedHoursAsyncValue = ref.watch(workedHoursProvider(userId));
    final leaveDataAsyncValue = ref.watch(leaveDataProvider(userId));
    final userDetailsAsyncValue = ref.watch(userDetailsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: userDetailsAsyncValue.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (userDetails) => workedHoursAsyncValue.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (workedHours) => leaveDataAsyncValue.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (leaveData) => SingleChildScrollView(
              padding: EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userDetails['imageUrl'] ?? 'https://example.com/profile.jpg'),
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userDetails['firstName']} ${userDetails['lastName']}',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(Icons.perm_identity, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                userDetails['userId'],
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                userDetails['contactNo'],
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                userDetails['email'],
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.cake, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                userDetails['bithday']??'N/A',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                userDetails['joinday']??'N/A',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text('Leaves Taken', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  buildGeneralInfo(workedHours, leaveData),
                  SizedBox(height: 24),
                  Text('Worked Hours - Weekly Basis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 24),
                  buildBarChart(workedHours),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreviousWorkedHoursScreen(userId: userId)),
                      );
                    },
                    child: Text('View Previous Worked Hours'),
                  ),
                  Text('Remaining Leaves', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  buildRemainingLeaves(leaveData),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGeneralInfo(Map<String, dynamic> workedHours, Map<String, dynamic> leaveData) {
    return Column(
      children: [
        buildInfoRow(
          'Casual Leaves',
          Icons.beach_access,
          leaveData.containsKey('leaveTypes') && leaveData['leaveTypes'].containsKey('casual')
              ? leaveData['leaveTypes']['casual'].toString()
              : '0',
        ),
        buildInfoRow(
          'Medical Leaves',
          Icons.local_hospital,
          leaveData.containsKey('leaveTypes') && leaveData['leaveTypes'].containsKey('medical')
              ? leaveData['leaveTypes']['medical'].toString()
              : '0',
        ),
        buildInfoRow(
          'Annual Leaves',
          Icons.work,
          leaveData.containsKey('leaveTypes') && leaveData['leaveTypes'].containsKey('annual')
              ? leaveData['leaveTypes']['annual'].toString()
              : '0',
        ),
        buildInfoRow(
          'Liue Leaves',
          Icons.access_time,
          leaveData.containsKey('leaveTypes') && leaveData['leaveTypes'].containsKey('liue')
              ? leaveData['leaveTypes']['liue'].toString()
              : '0',
        ),
      ],
    );
  }

  Widget buildInfoRow(String title, IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 16)),
            ],
          ),
          Container(
            width: 50,
            padding: EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }









  Widget buildRemainingLeaves(Map<String, dynamic> leaveData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLeaveInfoRow(
          'Casual',
          Icons.beach_access,
          leaveData['remainingLeaves'] != null ? leaveData['remainingLeaves']['casual'].toString() : '0',
        ),
        buildLeaveInfoRow(
          'Medical',
          Icons.local_hospital,
          leaveData['remainingLeaves'] != null ? leaveData['remainingLeaves']['medical'].toString() : '0',
        ),
        buildLeaveInfoRow(
          'Annual',
          Icons.calendar_today,
          leaveData['remainingLeaves'] != null ? leaveData['remainingLeaves']['annual'].toString() : '0',
        ),
        buildLeaveInfoRow(
          'Liue',
          Icons.access_time,
          leaveData['remainingLeaves'] != null ? leaveData['remainingLeaves']['liue'].toString() : '0',
        )
      ],
    );
  }

  Widget buildLeaveInfoRow(String title, IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 16)),
            ],
          ),
          Container(
            width: 50,
            padding: EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }
}
