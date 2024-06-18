import 'package:flutter/material.dart';
import 'package:ams/Bloc/Auth_Bloc/auth_bloc.dart';
import 'package:ams/Bloc/Employee_Bloc/employee_bloc.dart';
import 'package:ams/resource/Provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class TimeOffRequestPage extends StatefulWidget {
  const TimeOffRequestPage({super.key});

  @override
  State<TimeOffRequestPage> createState() => _TimeOffRequestPageState();
}

class _TimeOffRequestPageState extends State<TimeOffRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _eidController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  late AuthBloc authBloc;
  late EmployeeBloc employeeBloc;

  bool isLoading = false;

  String _selectedLeaveType = 'Casual';
  final List<String> _leaveTypes = [
    'Casual',
    'Full Day',
    'Half Day',
    'Medical'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authBloc = Provider.of(context).authBloc;
      _eidController.text = authBloc.getUserId();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _eidController.dispose();
    _reasonController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  clear() {
    _nameController.clear();
    _reasonController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _startTimeController.clear();
    _endTimeController.clear();
  }

  void submit() {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      Map<String, String> formData = {
        "name": _nameController.text,
        "employeeId": _eidController.text,
        "companyId": authBloc.getCompanyId(),
        "leaveType": _selectedLeaveType,
        "startDate": DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd/MM/yyyy').parse(_startDateController.text)),
        "endDate": DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd/MM/yyyy').parse(_endDateController.text)),
        "startTime": _startTimeController.text,
        "endTime": _endTimeController.text,
        "reason": _reasonController.text
      };
      employeeBloc
          .timeofRequest(authBloc.getSavedUserToken(), formData)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        _formKey.currentState!.reset();
        clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(value['message'])),
        );
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${error.message}')),
        );
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    employeeBloc = Provider.of(context).employeeBloc;
    authBloc = Provider.of(context).authBloc;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Off Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _eidController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'EID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your EID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedLeaveType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLeaveType = newValue!;
                  });
                },
                items: _leaveTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Leave Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _startDateController,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    setState(() {
                      _startDateController.text =
                          DateFormat('dd/MM/yyyy').format(picked);
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _endDateController,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    setState(() {
                      _endDateController.text =
                          DateFormat('dd/MM/yyyy').format(picked);
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'End Date',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter end date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _startTimeController,
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _startTimeController.text = picked.format(context);
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Start Time',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _endTimeController,
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _endTimeController.text = picked.format(context);
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'End Time',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter end time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason for the time off request';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: submit,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Send Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
