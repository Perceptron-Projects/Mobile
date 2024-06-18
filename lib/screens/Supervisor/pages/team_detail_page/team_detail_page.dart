import 'package:ams/screens/Common/employee_detail/employee_details_page.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class TeamDetailPage extends StatefulWidget {
  const TeamDetailPage({super.key});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  bool isEditMode = false;

  final TextEditingController projectNameController =
      TextEditingController(text: 'Maxton James');
  final TextEditingController teamMembersController =
      TextEditingController(text: '03');
  final TextEditingController supervisorController =
      TextEditingController(text: 'Andrew Maxwell');
  final TextEditingController startDateController =
      TextEditingController(text: '08/11/2023');

  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void saveData() {
    // Add functionality to save data to the backend
    print('Data saved');
    toggleEditMode();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy').parse(startDateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != DateFormat('dd/MM/yyyy').parse(startDateController.text)) {
      setState(() {
        startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Team 01'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print('Profile icon tapped');
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    print('Profile icon tapped');
                  },
                ),
              ),
            ),
          ),
        ],
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
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: const Center(
                      child: Text(
                        'Team 01',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Team 01'),
                      IconButton(
                        icon: Icon(isEditMode ? Icons.save : Icons.edit),
                        onPressed: () {
                          if (isEditMode) {
                            saveData();
                          } else {
                            toggleEditMode();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        isEditMode
                            ? EditableRoundedTextBox(
                                label: 'Project name',
                                controller: projectNameController,
                                inputType: TextInputType.text,
                              )
                            : RoundedTextBox(
                                label: 'Project name',
                                initialValue: projectNameController.text,
                              ),
                        const SizedBox(height: 10),
                        isEditMode
                            ? EditableRoundedTextBox(
                                label: 'Number of team members',
                                controller: teamMembersController,
                                inputType: TextInputType.number,
                              )
                            : RoundedTextBox(
                                label: 'Number of team members',
                                initialValue: teamMembersController.text,
                              ),
                        const SizedBox(height: 10),
                        isEditMode
                            ? EditableRoundedTextBox(
                                label: 'Supervisor',
                                controller: supervisorController,
                                inputType: TextInputType.text,
                              )
                            : RoundedTextBox(
                                label: 'Supervisor',
                                initialValue: supervisorController.text,
                              ),
                        const SizedBox(height: 10),
                        isEditMode
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Start date of the project',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  InkWell(
                                    onTap: () => _selectDate(context),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        startDateController.text,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : RoundedTextBox(
                                label: 'Start date of the project',
                                initialValue: startDateController.text,
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Member details button tapped');
                    },
                    child: const Text('View Member Details'),
                  ),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration.collapsed(
              hintText: label,
            ),
          ),
        ),
      ],
    );
  }
}
