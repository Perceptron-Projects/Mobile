import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/ProfileController.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends HookConsumerWidget {
  final Map<String, dynamic> profileData;

  EditProfileScreen({required this.profileData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: profileData['name']);
    final emailController = useTextEditingController(text: profileData['email']);
    final birthdayController = useTextEditingController(text: profileData['birthday']);
    final joinedDateController = useTextEditingController(text: profileData['joinday']);
    final profilePhotoUrl = useState<String?>(profileData['profilePhotoUrl']);
    final defaultProfileImageUrl = 'assets/images/defaultProfileImage.jpg';
    final picker = ImagePicker();

    Future<void> handleSave() async {
      final updatedProfile = {
        'name': nameController.text,
        'email': emailController.text,
        'birthday': birthdayController.text,
        'joinday': joinedDateController.text,
        'profilePhotoUrl': profilePhotoUrl.value,
      };

      await ref.read(profileControllerProvider).updateProfile(updatedProfile);
      Navigator.pop(context, updatedProfile);
    }

    Future<void> pickImage(ImageSource source) async {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        // Assuming you want to upload the image and get a URL back
        // For this example, we are using a local file path
        profilePhotoUrl.value = pickedFile.path;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final source = await showDialog<ImageSource>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Select Image Source'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, ImageSource.camera),
                            child: Text('Camera'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, ImageSource.gallery),
                            child: Text('Gallery'),
                          ),
                        ],
                      ),
                    );
                    if (source != null) {
                      pickImage(source);
                    }
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: profilePhotoUrl.value != null
                        ? FileImage(File(profilePhotoUrl.value!))
                        : AssetImage(defaultProfileImageUrl) as ImageProvider,
                  ),
                ),
                SizedBox(height: 16),
                ProfileInfoEditItem(
                  label: 'Name',
                  controller: nameController,
                ),
                ProfileInfoEditItem(
                  label: 'Email',
                  controller: emailController,
                ),
                ProfileDateEditItem(
                  label: 'Birthday',
                  controller: birthdayController,
                ),
                ProfileDateEditItem(
                  label: 'Joined Date',
                  controller: joinedDateController,
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: handleSave,
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                  ),
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileInfoEditItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const ProfileInfoEditItem({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 16), // Add spacing between label and text field
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right, // Align text to the right
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDateEditItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const ProfileDateEditItem({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      controller.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format date as YYYY-MM-DD
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 16), // Add spacing between label and text field
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right, // Align text to the right
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
              ),
              readOnly: true,
              onTap: () => _selectDate(context), // Show date picker when tapped
            ),
          ),
        ],
      ),
    );
  }
}
