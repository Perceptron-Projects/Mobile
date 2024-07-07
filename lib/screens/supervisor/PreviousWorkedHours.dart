import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ams/providers/InsightsController.dart';
import 'package:ams/components/CustomWidget.dart';

final insightsControllerProvider = Provider((ref) => InsightsController());

final workedHoursProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) async {
  final insightsController = ref.watch(insightsControllerProvider);
  return insightsController.fetchAttendanceDataForUser(params['startDate'], params['endDate'], params['userId']);
});



class PreviousWorkedHoursScreen extends HookConsumerWidget {
  final String userId;

  PreviousWorkedHoursScreen({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = useState(DateTime.now());
    final insightsController = ref.read(insightsControllerProvider);
    final workedHoursAsyncValue = useState<AsyncValue<Map<String, dynamic>>>(
        const AsyncLoading());
    DateTime nextWeekStart = insightsController.getStartOfWeek(currentDate.value).add(Duration(days: 7));


    void fetchWorkedHours(DateTime date) {
      final startDate = insightsController.getStartOfWeek(date);
      final endDate = startDate.add(Duration(days: 5));
      ref.read(workedHoursProvider(
          {'startDate': startDate, 'endDate': endDate, 'userId': userId})
          .future).then((value) {
        workedHoursAsyncValue.value = AsyncData(value);
      }).catchError((error, stackTrace) {
        workedHoursAsyncValue.value = AsyncError(error, stackTrace);
      });
    }

    useEffect(() {
      fetchWorkedHours(currentDate.value);
      return null;
    }, [currentDate.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Worked Hours', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: workedHoursAsyncValue.value.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (workedHours) {
          final processedData = insightsController.processAttendanceData(workedHours, []);

          return Padding(
            padding: const EdgeInsets.all(32.0),
            // Add padding around the entire content
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        currentDate.value = currentDate.value.subtract(Duration(days: 7));
                      },
                    ),
                    Text(
                      '${DateFormat('yyyy-MM-dd').format(insightsController.getStartOfWeek(currentDate.value))} - ${DateFormat('yyyy-MM-dd').format(insightsController.getStartOfWeek(currentDate.value).add(Duration(days: 4)))}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: nextWeekStart.isAfter(DateTime.now()) ? null : () {
                        currentDate.value = currentDate.value.add(Duration(days: 7));
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: buildBarChart(workedHours),
                  ),
                ),
                buildProcessedDataView(context,processedData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildProcessedDataView(BuildContext context,Map<String, dynamic> processedData) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            _buildTile('Planned Hours', '${InsightsController.plannedHours}'),
            _buildTile('Worked Hours', '${processedData['totalWorkedHours']}'),
            _buildTile('Overtime Hours', '${processedData['totalOvertimeHours']}'),
            _buildTile('Negative Hours', '${processedData['totalNegativeHours']}'),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.height * 0.12,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                const Color(0xff23b6e6),
                const Color(0xff02d39a),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Average',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2),
              Text(
                '${processedData['averageActivity']}%',
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2),
              Text(
                'Activity',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(String title, String value) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

}