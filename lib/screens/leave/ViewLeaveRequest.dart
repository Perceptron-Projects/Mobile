import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/appColors.dart';
import 'package:intl/intl.dart';
import 'package:ams/providers/leaveController.dart';
import 'package:ams/components/CustomWidget.dart';

class ViewLeaveRequestsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveController = ref.read(leaveControllerProvider);
    final leaveRequests = useState<List<Map<String, dynamic>>>([]);
    final startDate = useState<DateTime>(DateTime.now().subtract(Duration(days: 30)));
    final endDate = useState<DateTime>(DateTime.now());
    final isLoading = useState<bool>(true);

    Future<void> fetchLeaveRequests() async {
      final storage = FlutterSecureStorage();
      String? userId = await storage.read(key: 'userId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID not found')),
        );
        isLoading.value = false;
        return;
      }

      try {
        leaveRequests.value = await leaveController.getLeaveRequests(userId);
      } catch (e) {
        // Handle the error
        print(e);
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchLeaveRequests();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'View My Leave Requests',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading.value
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: isLoading.value
                        ? null
                        : () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: DateTimeRange(
                          start: startDate.value,
                          end: endDate.value,
                        ),
                      );
                      if (picked != null) {
                        isLoading.value = true;
                        startDate.value = picked.start;
                        endDate.value = picked.end;
                        await fetchLeaveRequests(); // Fetch records for the new date range
                        isLoading.value = false;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: isLoading.value
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColor),
                      ),
                    )
                        : Text(
                      'Select Date Range',
                      style: TextStyle(
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  Text(
                    'From: ${DateFormat('yyyy-MM-dd').format(startDate.value)}\nTo: ${DateFormat('yyyy-MM-dd').format(endDate.value)}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ...leaveRequests.value.map((leaveRequest) {
                return LeaveRequestTile(leaveRequest: leaveRequest);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
