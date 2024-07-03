import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/appColors.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:intl/intl.dart';
import 'package:ams/providers/attendanceController.dart';

class ViewAttendanceForParticularUser extends HookConsumerWidget {
  final String employeeId;

  ViewAttendanceForParticularUser({
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceController = ref.read(attendanceControllerProvider);
    final attendanceRecords = useState<List<Map<String, dynamic>>>([]);
    final startDate = useState<DateTime>(DateTime.now().subtract(Duration(days: 30)));
    final endDate = useState<DateTime>(DateTime.now());
    final isLoading = useState<bool>(true);

    Future<void> fetchAttendanceRecords() async {
      try {
        attendanceRecords.value = await attendanceController.getAttendanceForAParticularUser(
          startDate.value,
          endDate.value,
          employeeId,
        );
      } catch (e) {
        // Handle the error
        print(e);
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchAttendanceRecords();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Attendance History',
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
                        lastDate: DateTime.now(),
                        initialDateRange: DateTimeRange(
                          start: startDate.value,
                          end: endDate.value,
                        ),
                      );
                      if (picked != null) {
                        isLoading.value = true;
                        startDate.value = picked.start;
                        endDate.value = picked.end;
                        await fetchAttendanceRecords(); // Fetch records for the new date range
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
              ...attendanceRecords.value.map((record) {
                return AttendanceRecordWidget(record: record);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
