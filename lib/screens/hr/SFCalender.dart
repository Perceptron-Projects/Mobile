// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:ams/constants/AppColors.dart';
// import 'package:ams/providers/HolidayController.dart';
// import 'package:ams/providers/AuthController.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
//
// import '../../components/CustomWidget.dart';
// import '../../providers/ProfileController.dart';
// import '../home/Home.dart';
// import '../insightPanel/InsightPanel.dart';
// import '../profile/Profile.dart';
// import '../welcome/Welcome.dart';
//
// final holidayControllerProvider = Provider((ref) => HolidayController());
// final authControllerProvider = Provider((ref) => AuthController());
//
// class SFCalendarScreen extends HookConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final holidayController = ref.read(holidayControllerProvider);
//     final authController = ref.read(authControllerProvider);
//     final selectedDate = useState<DateTime?>(null);
//     final holidays = useState<List<Appointment>>([]);
//     final isLoading = useState<bool>(false);
//     final userId = useState<String?>(null);
//     final userRoles = useState<List<String>>([]);
//
//     Future<void> fetchHolidays() async {
//       try {
//         final holidayList = await holidayController.getHolidays();
//         final List<Appointment> holidayAppointments = holidayList.map((holiday) {
//           return Appointment(
//             startTime: DateTime.parse(holiday['start']),
//             endTime: DateTime.parse(holiday['end']),
//             subject: holiday['title'],
//             color: Colors.blue,
//             notes: holiday['type'],
//           );
//         }).toList();
//         holidays.value = holidayAppointments;
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch holidays')),
//         );
//       }
//     }
//
//     useEffect(() {
//       fetchHolidays();
//       return null;
//     }, []);
//
//     useEffect(() {
//       Future<void> fetchUserId() async {
//         final id = await authController.getUserId();
//         userId.value = id;
//       }
//       fetchUserId();
//       return null;
//     }, []);
//
//     useEffect(() {
//       Future<void> fetchUserRoles() async {
//         try {
//           userRoles.value = await authController.getRoles() ?? [];
//         } catch (e) {
//           print("Error fetching user roles: $e");
//         }
//       }
//
//       fetchUserRoles();
//       return null;
//     }, []);
//
//     bool isHr = userRoles.value.contains('hr');
//
//     Future<void> addHoliday(Map<String, dynamic> holidayData) async {
//       try {
//         isLoading.value = true;
//         await holidayController.createHoliday(holidayData);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Holiday added successfully')),
//         );
//         await fetchHolidays();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add holiday')),
//         );
//       } finally {
//         isLoading.value = false;
//       }
//     }
//
//     Future<void> editHoliday(String day, Map<String, dynamic> holidayData) async {
//       try {
//         isLoading.value = true;
//         await holidayController.editHoliday(day, holidayData);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Holiday updated successfully')),
//         );
//         await fetchHolidays();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update holiday')),
//         );
//       } finally {
//         isLoading.value = false;
//       }
//     }
//
//     Future<void> deleteHoliday(String day) async {
//       try {
//         isLoading.value = true;
//         await holidayController.deleteHoliday(day);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Holiday deleted successfully')),
//         );
//         await fetchHolidays();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to delete holiday')),
//         );
//       } finally {
//         isLoading.value = false;
//       }
//     }
//
//     void _showAddHolidayDialog() {
//       showDialog(
//         context: context,
//         builder: (context) {
//           final startController = TextEditingController();
//           final endController = TextEditingController();
//           final titleController = TextEditingController();
//           final typeController = TextEditingController();
//
//           return StatefulBuilder(
//             builder: (context, setState) {
//               bool isAdding = false;
//
//               return AlertDialog(
//                 title: Text('Add Holiday'),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextField(
//                         controller: startController,
//                         decoration: InputDecoration(labelText: 'Start Date'),
//                         readOnly: true,
//                         onTap: () async {
//                           DateTimeRange? pickedRange = await showDateRangePicker(
//                             context: context,
//                             firstDate: DateTime(2020),
//                             lastDate: DateTime(2030),
//                           );
//                           if (pickedRange != null) {
//                             setState(() {
//                               startController.text =
//                                   pickedRange.start.toIso8601String().substring(0, 10);
//                               endController.text =
//                                   pickedRange.end.toIso8601String().substring(0, 10);
//                             });
//                           }
//                         },
//                       ),
//                       TextField(
//                         controller: endController,
//                         decoration: InputDecoration(labelText: 'End Date'),
//                         readOnly: true,
//                       ),
//                       TextField(
//                         controller: typeController,
//                         decoration: InputDecoration(labelText: 'Holiday Type'),
//                       ),
//                       TextField(
//                         controller: titleController,
//                         decoration: InputDecoration(labelText: 'Title'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Cancel'),
//                   ),
//                   ElevatedButton(
//                     onPressed: isAdding
//                         ? null
//                         : () async {
//                       if (startController.text.isNotEmpty && endController.text.isNotEmpty && userId.value != null) {
//                         setState(() {
//                           isAdding = true;
//                         });
//                         final holidayData = {
//                           "start": startController.text,
//                           "end": endController.text,
//                           "title": titleController.text,
//                           "type": typeController.text,
//                           "markedBy": userId.value,
//                         };
//                         await addHoliday(holidayData);
//                         setState(() {
//                           isAdding = false;
//                         });
//                         Navigator.of(context).pop();
//                       }
//                     },
//                     child: isAdding
//                         ? SizedBox(
//                       height: 16,
//                       width: 16,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                         : Text('Add'),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );
//     }
//
//     void _showDeleteConfirmationDialog(String day, BuildContext context, StateSetter parentSetState) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(
//             builder: (context, setState) {
//               bool isDeleting = false;
//
//               return AlertDialog(
//                 title: Text('Confirm Deletion'),
//                 content: Text('Are you sure you want to delete this holiday?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: Text('Cancel'),
//                   ),
//                   ElevatedButton(
//                     onPressed: isDeleting
//                         ? null
//                         : () async {
//                       setState(() {
//                         isDeleting = true;
//                       });
//                       await deleteHoliday(day);
//                       setState(() {
//                         isDeleting = false;
//                       });
//                       parentSetState(() {}); // Ensure parent dialog state is updated
//                       Navigator.of(context).pop(); // Close the confirmation dialog
//                       Navigator.of(context).pop(); // Close the edit dialog
//                     },
//                     child: isDeleting
//                         ? SizedBox(
//                       height: 16,
//                       width: 16,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                         : Text('Delete', style: TextStyle(color: Colors.red)),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );
//     }
//
//     void _showEditHolidayDialog(Map<String, dynamic> holiday) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           final startController = TextEditingController(text: holiday['start'].substring(0, 10));
//           final endController = TextEditingController(text: holiday['end'].substring(0, 10));
//           final titleController = TextEditingController(text: holiday['title']);
//           final typeController = TextEditingController(text: holiday['type']);
//
//           return StatefulBuilder(
//             builder: (context, setState) {
//               bool isUpdating = false;
//               bool isDeleting = false;
//
//               return AlertDialog(
//                 title: Text('Edit Holiday'),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextField(
//                         controller: startController,
//                         decoration: InputDecoration(labelText: 'Start Date'),
//                         readOnly: true,
//                         onTap: () async {
//                           DateTimeRange? pickedRange = await showDateRangePicker(
//                             context: context,
//                             firstDate: DateTime(2020),
//                             lastDate: DateTime(2030),
//                             initialDateRange: DateTimeRange(
//                               start: DateTime.parse(holiday['start']),
//                               end: DateTime.parse(holiday['end']),
//                             ),
//                           );
//                           if (pickedRange != null) {
//                             setState(() {
//                               startController.text = pickedRange.start.toIso8601String().substring(0, 10);
//                               endController.text = pickedRange.end.toIso8601String().substring(0, 10);
//                             });
//                           }
//                         },
//                       ),
//                       TextField(
//                         controller: endController,
//                         decoration: InputDecoration(labelText: 'End Date'),
//                         readOnly: true,
//                       ),
//                       TextField(
//                         controller: titleController,
//                         decoration: InputDecoration(labelText: 'Title'),
//                       ),
//                       TextField(
//                         controller: typeController,
//                         decoration: InputDecoration(labelText: 'Holiday Type'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: Text('Cancel'),
//                   ),
//                   ElevatedButton(
//                     onPressed: isUpdating
//                         ? null
//                         : () async {
//                       if (startController.text.isNotEmpty && endController.text.isNotEmpty && userId.value != null) {
//                         setState(() {
//                           isUpdating = true;
//                         });
//                         final holidayData = {
//                           "start": startController.text,
//                           "end": endController.text,
//                           "title": titleController.text,
//                           "type": typeController.text,
//                           "markedBy": holiday['markedBy'], // Keep the original marker
//                         };
//                         await editHoliday(holiday['start'], holidayData);
//                         setState(() {
//                           isUpdating = false;
//                         });
//                         Navigator.of(context).pop();
//                       }
//                     },
//                     child: isUpdating
//                         ? SizedBox(
//                       height: 16,
//                       width: 16,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                         : Text('Update'),
//                   ),
//                   TextButton(
//                     onPressed: isDeleting
//                         ? null
//                         : () => _showDeleteConfirmationDialog(holiday['start'], context, setState),
//                     child: isDeleting
//                         ? SizedBox(
//                       height: 16,
//                       width: 16,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                         : Text('Delete', style: TextStyle(color: Colors.red)),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: false,
//         title: Text(
//           'Company Calendar',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(32.0),
//           child: Center(
//             child: Container(
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height * 0.65,
//               decoration: BoxDecoration(
//                 color: Colors.indigoAccent.withOpacity(0.25),
//                 borderRadius: BorderRadius.circular(32),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: SfCalendar(
//                             view: CalendarView.month,
//                             dataSource: HolidayDataSource(holidays.value),
//                             monthViewSettings: MonthViewSettings(
//                               appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
//                             ),
//                             onTap: (calendarTapDetails) {
//                               if (calendarTapDetails.targetElement == CalendarElement.appointment) {
//                                 selectedDate.value = calendarTapDetails.date;
//                                 final dynamic appointment = calendarTapDetails.appointments![0];
//                                 if (isHr) {
//                                   _showEditHolidayDialog({
//                                     'start': appointment.startTime.toIso8601String(),
//                                     'end': appointment.endTime.toIso8601String(),
//                                     'title': appointment.subject,
//                                     'type': appointment.notes,
//                                     'markedBy': userId.value,
//                                   });
//                                 }
//                               }
//                             },
//                           ),
//                         ),
//                         if (selectedDate.value != null)
//                           ...holidays.value.where((appointment) {
//                             return appointment.startTime.isAtSameMomentAs(selectedDate.value!);
//                           }).map((event) => ListTile(
//                             title: Text(
//                               event.subject,
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.buttonColor,
//                               ),
//                             ),
//                             subtitle: Text(
//                               event.notes ?? '',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             trailing: Icon(
//                               Icons.event,
//                               color: AppColors.primaryColor,
//                             ),
//                             onTap: isHr ? () => _showEditHolidayDialog({
//                               'start': event.startTime.toIso8601String(),
//                               'end': event.endTime.toIso8601String(),
//                               'title': event.subject,
//                               'type': event.notes,
//                               'markedBy': userId.value,
//                             }) : null,
//                           )),
//                       ],
//                     ),
//                   ),
//                   if (isLoading.value)
//                     Center(child: CircularProgressIndicator()),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: isHr
//           ? Padding(
//         padding: const EdgeInsets.all(36.0), // Adjust the padding as needed
//         child: FloatingActionButton(
//           onPressed: _showAddHolidayDialog,
//           child: Icon(Icons.add),
//           backgroundColor: AppColors.buttonColor,
//           foregroundColor: Colors.white, // Set the color of the + icon
//         ),
//       )
//           : null,
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: 2,
//         onTap: (index) async {
//           if (index == 0) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => HomePageScreen()),
//             );
//           } else if (index == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ProfileScreen()),
//             );
//           } else if (index == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SFCalendarScreen()),
//             );
//           }
//           else if (index == 3) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => InsightsScreen()),
//             );
//           }
//           else if (index == 4) {
//             // Handle logout
//             await ref.read(profileControllerProvider).logout();
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => WelcomeScreen()),
//                   (Route<dynamic> route) => false,
//             );
//           }
//         },
//         selectedItemColor: AppColors.buttonColor,
//         unselectedItemColor: Colors.grey,
//       ),
//     );
//   }
// }
//
// class HolidayDataSource extends CalendarDataSource {
//   HolidayDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }
