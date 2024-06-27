import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ams/providers/InsightsController.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends HookConsumerWidget {
  final insightsController = InsightsController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceData = useState<Map<String, dynamic>?>(null);
    final leaveData = useState<List<dynamic>?>(null);
    final isLoading = useState(true);
    final errorMessage = useState<String?>(null);
    final currentDate = useState(DateTime.now());

    Future<void> fetchData(DateTime startDate, DateTime endDate) async {
      isLoading.value = true;

      try {
        final attendance = await insightsController.fetchAttendanceData(startDate, endDate);
        final leave = await insightsController.fetchLeaveData();
        attendanceData.value = attendance;
        leaveData.value = leave;
        isLoading.value = false;
      } catch (error) {
        errorMessage.value = error.toString();
        isLoading.value = false;
      }
    }

    useEffect(() {
      final startDate = insightsController.getStartOfWeek(currentDate.value);
      final endDate = startDate.add(Duration(days: 4));
      fetchData(startDate, endDate);
    }, [currentDate.value]);

    if (isLoading.value) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Insights',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage.value != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Insights'),
        ),
        body: Center(
          child: Text(errorMessage.value!),
        ),
      );
    }

    final processedData = insightsController.processAttendanceData(attendanceData.value!, leaveData.value!);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Insights',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  onPressed: () {
                    currentDate.value = currentDate.value.add(Duration(days: 7));
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: MediaQuery.of(context).size.height * 0.3, // Adjust the height
              width: MediaQuery.of(context).size.width * 0.8, // Adjust the width
              child: LineChart(mainData(processedData)),
            ),
            SizedBox(height: 24),
            Stack(
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
            ),
          ],
        ),
      ),
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

  LineChartData mainData(Map<String, dynamic> processedData) {
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return LineChartData(
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          //tooltipBgColor: Colors.blueAccent,
        ),
      ),
      gridData: FlGridData(show: false),  // Hide the grid
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              );
              Widget text;
              switch (value.toInt()) {
                case 0:
                  text = const Text('Mon', style: style);
                  break;
                case 1:
                  text = const Text('Tue', style: style);
                  break;
                case 2:
                  text = const Text('Wed', style: style);
                  break;
                case 3:
                  text = const Text('Thu', style: style);
                  break;
                case 4:
                  text = const Text('Fri', style: style);
                  break;
                default:
                  text = const Text('', style: style);
                  break;
              }

              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: text,
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: 2,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              );
              return Text('${value.toInt()}hr', style: style, textAlign: TextAlign.left);
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 4,
      minY: 0,
      maxY: 14,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, processedData['workedHours']['mon']),
            FlSpot(1, processedData['workedHours']['tue']),
            FlSpot(2, processedData['workedHours']['wed']),
            FlSpot(3, processedData['workedHours']['thu']),
            FlSpot(4, processedData['workedHours']['fri']),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,  // Show data points
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
