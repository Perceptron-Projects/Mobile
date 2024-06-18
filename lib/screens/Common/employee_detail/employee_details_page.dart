import 'package:flutter/material.dart';
import 'package:ams/Model/user_modle.dart';
import 'package:ams/screens/Common/user_details_page/user_details_page.dart';

class EmployeeDetailsPage extends StatelessWidget {
  final User user;
  const EmployeeDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Employee Details'),
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
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  onPressed: () {},
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
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      RoundedTextBox(
                        label: 'Name',
                        initialValue: user.username,
                      ),
                      const SizedBox(height: 10),
                      RoundedTextBox(
                        label: 'Employee ID',
                        initialValue: user.userId,
                      ),
                      const SizedBox(height: 10),
                      RoundedTextBox(
                        label: 'Joined Date',
                        initialValue: user.joiningDate,
                      ),
                      const SizedBox(height: 10),
                      RoundedTextBox(
                        label: 'Birthday',
                        initialValue: user.dateOfBirth,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserDetailsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      child: const Text('Advanced Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedTextBox extends StatelessWidget {
  final String label;
  final String initialValue;

  const RoundedTextBox({
    Key? key,
    required this.label,
    required this.initialValue,
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
          child: Text(
            initialValue,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
