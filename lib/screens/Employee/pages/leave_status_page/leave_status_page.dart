import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ams/Model/leave_status_model.dart';
import 'package:ams/Model/ui_state.dart';
import 'package:ams/constants/leave_status.dart';
import 'package:ams/resource/Provider/provider.dart';
import 'package:ams/screens/login/login.dart';
import 'package:ams/widgets/custom_error.dart';
import 'package:ams/widgets/form_widget/form_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaveStatusPage extends StatelessWidget {
  const LeaveStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeBloc = Provider.of(context).employeeBloc;
    final authBloc = Provider.of(context).authBloc;
    employeeBloc.getAttendanceHistory(
        authBloc.getSavedUserToken(), authBloc.getUserId(),
        isStatus: true);

    Widget buildTextField(String label, String hintText,
        {bool readOnly = false, int maxLines = 1}) {
      return Column(
        children: [
          if (label.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 5.0),
          TextField(
            readOnly: readOnly,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
    }

    void showLeaveDetailsOverlay(LeaveStatusModel leaveStatusModel) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.only(top: 60.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Leave Details',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                buildTextField('Name', leaveStatusModel.name, readOnly: true),
                const SizedBox(height: 10.0),
                buildTextField('EID ID', leaveStatusModel.employeeId,
                    readOnly: true),
                const SizedBox(height: 10.0),
                buildTextField('Leave Type', leaveStatusModel.leaveType,
                    readOnly: true),
                const SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: buildTextField(
                            'Date', leaveStatusModel.startDate,
                            readOnly: true)),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: buildTextField('', leaveStatusModel.endDate,
                            readOnly: true)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: buildTextField(
                            'Time', leaveStatusModel.startTime,
                            readOnly: true)),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: buildTextField('', leaveStatusModel.endTime,
                            readOnly: true)),
                  ],
                ),
                const SizedBox(height: 10.0),
                buildTextField('Reason', leaveStatusModel.reason,
                    readOnly: true, maxLines: 3),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Status',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.px,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: StreamBuilder<UIState>(
          stream: employeeBloc.attendanceHistory,
          builder: (BuildContext context, AsyncSnapshot<UIState> snapshot) {
            if (snapshot.hasData) {
              UIState uiState = snapshot.data!;
              if (uiState is LoadingUIState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (uiState is ResultUIState) {
                var data = uiState.result as List<LeaveStatusModel>;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LeaveStatusCard(
                      leaveStatus: data[index].status == 'pending'
                          ? LeaveStatus.Pending
                          : data[index].status == 'approved'
                              ? LeaveStatus.Approved
                              : LeaveStatus.Rejected,
                      leaveStatusModel: data[index],
                      onMorePressed: () => showLeaveDetailsOverlay(data[index]),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                );
              } else if (uiState is UnAuthenticatedUIState) {
                logout(context);
                return const SizedBox.shrink();
              } else if (uiState is NoResultUIState) {
                return const Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(fontSize: 14),
                  ),
                );
              } else if (uiState is ErrorUIState) {
                return Column(
                  children: [
                    CustomError(
                      errorMsg: uiState.message,
                      callBack: () => employeeBloc.getAttendanceHistory(
                          authBloc.getSavedUserToken(), authBloc.getUserId()),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
