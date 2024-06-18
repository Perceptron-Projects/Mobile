import 'package:ams/widgets/leave_type_widget/leave_type_widget.dart';
import 'package:ams/widgets/pdf_button_widget/p_d_f_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';


class RemainingLeavesWidget extends StatefulWidget {
  const RemainingLeavesWidget({super.key});

  @override
  RemainingLeavesWidgetState createState() => RemainingLeavesWidgetState();
}

class RemainingLeavesWidgetState extends State<RemainingLeavesWidget> {
  int _selectedToggle = 0; // 0 for "Week", 1 for "Month"

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remaining Leaves',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Center(
            child: ToggleSwitch(
              totalSwitches: 3,
              initialLabelIndex: _selectedToggle,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              activeBgColor: const [Colors.blue, Colors.blue],
              inactiveBgColor: Colors.grey.shade300,
              inactiveFgColor: Colors.black,
              labels: const ['Weekly', 'Monthly', 'Annually'],
              onToggle: (index) {
                setState(() {
                  _selectedToggle = index!;
                });
              },
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const LeaveTypeWidget(leaveType: 'Full Day', leaveCount: '02'),
              const LeaveTypeWidget(leaveType: 'Half Day', leaveCount: '03'),
              const LeaveTypeWidget(leaveType: 'Short Leave', leaveCount: '01'),
              PDFButtonWidget(
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
