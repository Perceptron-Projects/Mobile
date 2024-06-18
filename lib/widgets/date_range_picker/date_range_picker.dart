import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DateRangePickerWidget extends StatefulWidget {
  final Function(DateTime? start, DateTime? end)? onDateSelected;

  const DateRangePickerWidget({super.key, this.onDateSelected});

  @override
  DateRangePickerWidgetState createState() => DateRangePickerWidgetState();
}

class DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _onDateSelected();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _onDateSelected();
      });
    }
  }

  void _onDateSelected() {
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(0.0),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade200),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: () => _selectStartDate(context),
          child: _startDate == null
              ? Row(
                  children: [
                    Text(
                      'Start',
                      // : '${_startDate!.toLocal()}'.split(' ')[0],
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                      size: 18.px,
                    ),
                  ],
                )
              : Text(
                  '${_startDate!.toLocal()}'.split(' ')[0],
                  style: TextStyle(
                    fontSize: 14.px,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          'To',
          style: TextStyle(
            fontSize: 16.px,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(0.0),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade200),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: () => _selectEndDate(context),
          child: _endDate == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'End',
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                      size: 18.px,
                    ),
                  ],
                )
              : Text(
                  '${_endDate!.toLocal()}'.split(' ')[0],
                  style: TextStyle(
                    fontSize: 14.px,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
        ),
      ],
    );
  }
}
