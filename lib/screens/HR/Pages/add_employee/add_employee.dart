import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController joinedDateController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();


  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }


  void _saveDetails() {
    // Add functionality to save data to the backend
    print('Name: ${nameController.text}');
    print('Employee ID: ${employeeIdController.text}');
    print('Designation: ${designationController.text}');
    print('Joined Date: ${joinedDateController.text}');
    print('Birthday: ${birthdayController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            Text('Enter User Details', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: Center(
                      child: Text(
                        'Add a Photo',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        EditableRoundedTextBox(
                          label: 'Name',
                          controller: nameController,
                          inputType: TextInputType.text,
                        ),
                        SizedBox(height: 10),
                        EditableRoundedTextBox(
                          label: 'Employee ID',
                          controller: employeeIdController,
                          inputType: TextInputType.text,
                        ),
                        SizedBox(height: 10),
                        EditableRoundedTextBox(
                          label: 'Designation',
                          controller: designationController,
                          inputType: TextInputType.text,
                        ),
                        SizedBox(height: 10),
                        DateInputField(
                          label: 'Joined Date',
                          controller: joinedDateController,
                          selectDate: _selectDate,
                        ),
                        SizedBox(height: 10),
                        DateInputField(
                          label: 'Birthday',
                          controller: birthdayController,
                          selectDate: _selectDate,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveDetails,
                    child: Text('Create'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditableRoundedTextBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;

  const EditableRoundedTextBox({
    Key? key,
    required this.label,
    required this.controller,
    required this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration.collapsed(
              hintText: 'Input ${label.toLowerCase()} here..',
            ),
          ),
        ),
      ],
    );
  }
}

class DateInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(BuildContext, TextEditingController) selectDate;

  const DateInputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.selectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: () => selectDate(context, controller),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              controller.text.isEmpty ? 'Select' : controller.text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
