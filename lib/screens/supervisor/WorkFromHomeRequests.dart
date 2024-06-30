import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/AttendanceController.dart';

class SupervisorWFHDashboardScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final workFromHomeRequests = useState<List<Map<String, dynamic>>>([]);

    Future<void> fetchRequests() async {
      isLoading.value = true;
      try {
        final requests = await ref.read(attendanceControllerProvider).getAllWorkFromHomeRequests();
        // Sort requests by date in descending order
        requests.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        });
        workFromHomeRequests.value = requests;
      } catch (e) {
        print('Error fetching work from home requests: $e');
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchRequests();
      return null;  // Clean up
    }, []);

    Future<void> updateRequestStatus(String employeeId, String companyId, DateTime date, String status) async {
      try {
        await ref.read(attendanceControllerProvider).updateWorkFromHomeStatus(employeeId, companyId, date, status);
        fetchRequests(); // Refresh the requests after updating
      } catch (e) {
        print('Error updating work from home request status: $e');
      }
    }

    Icon _getStatusIcon(String status) {
      switch (status) {
        case 'approved':
          return Icon(Icons.check_circle, color: Colors.green);
        case 'rejected':
          return Icon(Icons.cancel, color: Colors.red);
        default:
          return Icon(Icons.access_time, color: Colors.orange);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Work From Home Requests',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: workFromHomeRequests.value.map((request) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: ListTile(
                leading: _getStatusIcon(request['status']),
                title: Text('Employee Name: ${request['employeeName']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Employee ID: ${request['employeeId']}'),
                    Text('Date: ${request['date']}'),
                    Text('Status: ${request['status']}'),
                    Text('Reason: ${request['reason'] ?? 'No reason provided'}')
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green, // Background color for approve button
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.check, color: Colors.white),
                        onPressed: () {
                          updateRequestStatus(
                              request['employeeId'],
                              request['companyId'],
                              DateTime.parse(request['date']),
                              'approved');
                        },
                      ),
                    ),
                    SizedBox(width: 8), // Add some space between buttons
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red, // Background color for reject button
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.white),
                        onPressed: () {
                          updateRequestStatus(
                              request['employeeId'],
                              request['companyId'],
                              DateTime.parse(request['date']),
                              'rejected');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
