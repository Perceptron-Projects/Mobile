import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/ProfileController.dart';

class EditProfileScreen extends HookConsumerWidget {
  final Map<String, dynamic> profileData;

  EditProfileScreen({required this.profileData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstNameController = useTextEditingController(text: profileData['firstName']);
    final lastNameController = useTextEditingController(text: profileData['lastName']);
    final emailController = useTextEditingController(text: profileData['email']);
    final contactNoController = useTextEditingController(text: profileData['contactNo']);
    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController(); // Added for confirm password
    final picker = ImagePicker();
    final selectedImage = useState<File?>(null);
    final formKey = useState(GlobalKey<FormState>());
    final isLoading = useState(false); // State for loading indicator

    Future<void> handleSave() async {
      if (!formKey.value.currentState!.validate()) {
        return;
      }

      isLoading.value = true; // Show loading indicator

      String? base64Image;
      if (selectedImage.value != null) {
        try {
          final bytes = await selectedImage.value!.readAsBytes();
          base64Image = "data:image/jpeg;base64," + base64Encode(bytes);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to encode image: ${e.toString()}'),
          ));
          isLoading.value = false; // Hide loading indicator
          return;
        }
      } else {
        base64Image = ''; // Send an empty string if the image is not changed
      }

      final updatedProfile = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'contactNo': contactNoController.text,
        'currentPassword': currentPasswordController.text,
        'newPassword': newPasswordController.text,
        'image': base64Image,
      };

      try {
        await ref.read(profileControllerProvider).updateProfile(updatedProfile);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully'),
        ));
        Navigator.pop(context, updatedProfile);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update profile: ${error.toString()}'),
        ));
      } finally {
        isLoading.value = false; // Hide loading indicator
      }
    }

    Future<void> pickImage(ImageSource source) async {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: formKey.value,
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
                      await pickImage(source);
                    }
                  },
                  child: ClipOval(
                    child: Container(
                      color: Color(0x3DFF8383),
                      height: 200,
                      width: 200,
                      child: selectedImage.value != null
                          ? Image.file(
                        selectedImage.value!,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      )
                          : (profileData['imageUrl'] != null && profileData['imageUrl'].isNotEmpty
                          ? Image.network(
                        profileData['imageUrl'],
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      )
                          : Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                        size: 50,
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ProfileInfoEditItem(
                  label: 'First Name',
                  controller: firstNameController,
                ),
                ProfileInfoEditItem(
                  label: 'Last Name',
                  controller: lastNameController,
                ),
                ProfileInfoEditItem(
                  label: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                ProfileInfoEditItem(
                  label: 'Contact No',
                  controller: contactNoController,
                  validator: (value) {
                    if (value == null || value.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid contact number';
                    }
                    return null;
                  },
                ),
                ProfileInfoEditItem(
                  label: 'Current Password',
                  controller: currentPasswordController,
                  obscureText: true,
                ),
                ProfileInfoEditItem(
                  label: 'New Password',
                  controller: newPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password should be at least 6 characters';
                    }
                    return null;
                  },
                ),
                ProfileInfoEditItem(
                  label: 'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                isLoading.value // Display loading indicator if isLoading is true
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: handleSave,
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.buttonColor,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white, // Set the text color to white
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

class ProfileInfoEditItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  const ProfileInfoEditItem({
    Key? key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(54.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
