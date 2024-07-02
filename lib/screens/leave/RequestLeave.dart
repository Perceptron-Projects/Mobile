import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/LeaveController.dart';
import 'package:ams/components/CustomWidget.dart';
import 'dart:ui' as ui;

class RequestLeaveScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveController = ref.read(leaveControllerProvider);
    final isLoading = useState(false);
    final leaveType = useState<String>('casual');
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);
    final reasonController = useTextEditingController();
    ui.Size size = MediaQuery.of(context).size;

    Future<void> requestLeave() async {
      if (startDate.value == null || endDate.value == null || reasonController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      isLoading.value = true;

      try {
        await leaveController.requestLeave(
          leaveType.value,
          startDate.value!,
          endDate.value!,
          reasonController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave request submitted successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RequestLeaveScreen()), // Navigate to the same screen
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit leave request')),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Request Leave'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FormElementContainer(
                  child: DropdownButtonFormField<String>(
                    value: leaveType.value,
                    onChanged: (String? newValue) {
                      leaveType.value = newValue!;
                    },
                    items: <String>['casual', 'liue', 'annual', 'medical']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Leave Type',
                      prefixIcon: Icon(Icons.list),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                FormElementContainer(
                  child: ListTile(
                    title: Text('Start Date: ${startDate.value != null ? DateFormat('yyyy-MM-dd').format(startDate.value!) : 'Select Start Date'}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        startDate.value = selectedDate;
                      }
                    },
                  ),
                ),
                FormElementContainer(
                  child: ListTile(
                    title: Text('End Date: ${endDate.value != null ? DateFormat('yyyy-MM-dd').format(endDate.value!) : 'Select End Date'}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        endDate.value = selectedDate;
                      }
                    },
                  ),
                ),
                FormElementContainer(
                  child: TextField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      labelText: 'Reason',
                      prefixIcon: Icon(Icons.notes),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: requestLeave,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    backgroundColor: AppColors.buttonColor,
                    fixedSize:
                    ui.Size(size.width * 0.3, size.width * 0.125),
                  ),
                  child: isLoading.value ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColor),
                    ),
                  )
                      : const Text(
                    'Request',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColors.textColor,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
