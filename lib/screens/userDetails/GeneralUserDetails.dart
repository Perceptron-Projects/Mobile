import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/providers/teamController.dart';

final userDetailsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final teamController = ref.watch(teamControllerProvider);
  return teamController.getUserDetails(userId);
});

class GeneralUserDetailsScreen extends HookConsumerWidget {
  final String userId;

  GeneralUserDetailsScreen({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        data: (userDetails) => SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
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
                      SizedBox(height: 8),
                      Text(
                        'Employee ID: ${userDetails['userId']}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              buildDetailBox('Contact Number', userDetails['contactNo'], Icons.phone, Colors.blue),
              SizedBox(height: 8),
              buildDetailBox('Email', userDetails['email'], Icons.email, Colors.red),
              SizedBox(height: 8),
              buildDetailBox('Joined Date', userDetails['joinday'], Icons.calendar_today, Colors.green),
              SizedBox(height: 8),
              buildDetailBox('Roles', (userDetails['role'] as List).join(', '), Icons.work, Colors.orange),
              SizedBox(height: 8),
              buildDetailBox('Birthday', userDetails['birthday'], Icons.cake, Colors.purple),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailBox(String title, String value, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(48.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
