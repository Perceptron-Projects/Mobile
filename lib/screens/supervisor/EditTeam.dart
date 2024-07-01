import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/teamController.dart';
import 'package:ams/models/Team.dart';
import 'package:ams/models/TeamMember.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:http/http.dart' as http;// Import the custom form field widget

class EditTeamScreen extends HookConsumerWidget {
  final Team team;

  EditTeamScreen({required this.team});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePicker = ImagePicker();
    final teamNameController = useTextEditingController(text: team.teamName);
    final projectNameController = useTextEditingController(text: team.projectName);
    final supervisorController = useTextEditingController(text: team.supervisor);
    final startDateController = useTextEditingController(text: team.startDate);
    final teamMembersController = useTextEditingController();
    final teamMembers = useState<List<TeamMember>>(
      team.teamMembers.map((e) => TeamMember(name: e, email: e,userId: e)).toList(),
    );
    final selectedImage = useState<File?>(null);
    final teamController = ref.read(teamControllerProvider);

    Future<String> downloadImageAsBase64(String imageUrl) async {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return 'data:image/png;base64,${base64Encode(response.bodyBytes)}';
      } else {
        throw Exception('Failed to download image');
      }
    }

    Future<void> updateTeam() async {
      if (_formKey.currentState!.validate()) {

        String teamsImageBase64;
        if (selectedImage.value != null) {
          // A new image is selected
          teamsImageBase64 = 'data:image/png;base64,${base64Encode(await selectedImage.value!.readAsBytes())}';
        } else {
          // No new image selected, download the existing image and convert to base64
          teamsImageBase64 = await downloadImageAsBase64(team.teamsImage);
        }

        final updatedTeam = Team(
          teamId: team.teamId, // Use the existing team ID
          teamName: teamNameController.text,
          projectName: projectNameController.text,
          supervisor: supervisorController.text,
          startDate: startDateController.text,
          teamsImage: teamsImageBase64,
          teamMembers: teamMembers.value.map((member) => member.userId).toList(),
        );

        try {
          await teamController.updateTeam(team.teamId, updatedTeam);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Team updated successfully')),
          );
          Navigator.pop(context); // Go back to the previous screen
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update team')),
          );
        }
      }
    }

    Future<void> pickImage() async {
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Team',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: ClipOval(
                    child: Container(
                      color: Color(0x3DFF8383),
                      height: 200,
                      width: 200, // Ensure the width and height are equal to make it circular
                      child: selectedImage.value != null
                          ? Image.file(
                        selectedImage.value!,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      )
                          : team.teamsImage.isNotEmpty
                          ? Image.network(
                        team.teamsImage,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      )
                          : Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                        size: 50,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CustomFormField(
                  controller: teamNameController,
                  labelText: 'Team Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a team name';
                    }
                    return null;
                  },
                ),
                CustomFormField(
                  controller: projectNameController,
                  labelText: 'Project Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project name';
                    }
                    return null;
                  },
                ),
                CustomFormField(
                  controller: supervisorController,
                  labelText: 'Supervisor',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a supervisor name';
                    }
                    return null;
                  },
                ),
                CustomFormField(
                  controller: startDateController,
                  labelText: 'Start Date',
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  suffixIcon: Icon(Icons.calendar_today),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a start date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TypeAheadField<TeamMember>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: teamMembersController,
                    decoration: InputDecoration(
                      labelText: 'Add Team Member (Email)',
                      filled: true,
                      fillColor: Color(0x3DFF8383),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(48.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await teamController.searchTeamMembersByEmail(pattern);
                  },
                  itemBuilder: (context, TeamMember suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                      subtitle: Text(suggestion.email),
                    );
                  },
                  onSuggestionSelected: (TeamMember suggestion) {
                    teamMembers.value = List.from(teamMembers.value)..add(suggestion);
                    teamMembersController.clear();
                    FocusScope.of(context).unfocus(); // Hide the keyboard
                  },
                ),
                Wrap(
                  children: teamMembers.value.map((member) {
                    return Chip(
                      label: Text(member.name),
                      onDeleted: () {
                        teamMembers.value = List.from(teamMembers.value)..remove(member);
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: updateTeam,
                  child: Text(
                    'Update Team',
                    style: TextStyle(color: Colors.white), // Set the text color to white
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.buttonColor, // Button background color
                    minimumSize: Size(150, 50), // Adjust the button size
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Adjust the padding
                    textStyle: TextStyle(fontSize: 16), // Adjust the font size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0), // Adjust the border radius
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
