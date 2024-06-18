import 'dart:developer';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WeeklyEventCalendar extends StatefulWidget {
  const WeeklyEventCalendar({super.key});

  @override
  WeeklyEventCalendarState createState() => WeeklyEventCalendarState();
}

class WeeklyEventCalendarState extends State<WeeklyEventCalendar> {
  late final EventController<CalendarEventData> _eventController;

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
    _addSampleEvents();
  }

  String _formatWeekRange(DateTime startDate, DateTime endDate) {
    final formatter = DateFormat('MMM d');
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }

  void _addSampleEvents() {
    final now = DateTime.now();
    _eventController.addAll([
      CalendarEventData(
        date: now,
        title: "Team Meeting",
        description: "Discussing the project's next phases.",
        startTime: DateTime(now.year, now.month, now.day, 9, 0),
        endTime: DateTime(now.year, now.month, now.day, 10, 0),
        color: Colors.blue,
      ),
      CalendarEventData(
        date: now.add(Duration(days: 1)),
        title: "Client Call",
        description: "Quarterly review with the client.",
        startTime: DateTime(now.year, now.month, now.day + 1, 11, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 12, 0),
        color: Colors.green,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Calendar View',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.px,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: WeekView<CalendarEventData>(
        controller: _eventController,
        eventTileBuilder: (date, events, boundary, start, end) {
          if (events.isEmpty) return Container();
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: 0.2.w,
            ),
            padding: EdgeInsets.all(
              0.5.w,
            ),
            decoration: BoxDecoration(
              color: events.first.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              events.first.title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
        fullDayEventBuilder: (events, date) {
          return Container(
            color: Colors.orange,
            child: ListView(
              children: events
                  .map((event) => ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.description!),
                      ))
                  .toList(),
            ),
          );
        },
        showLiveTimeLineInAllDays: true,
        width: MediaQuery.of(context).size.width,
        heightPerMinute: 0.8,
        minDay: DateTime(1990),
        maxDay: DateTime(2050),
        eventArranger: const SideEventArranger(includeEdges: false),
        onEventTap: (events, date) =>
            log("Tapped on event: ${events.first.title}"),
        onDateLongPress: (date) => log("Long pressed date: $date"),
        startDay: WeekDays.sunday,
        startHour: 5,
        showVerticalLines: true,
        weekPageHeaderBuilder: (startDate, endDate) => Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatWeekRange(startDate, endDate),
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 1.w),
              Icon(
                Icons.calendar_month,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
