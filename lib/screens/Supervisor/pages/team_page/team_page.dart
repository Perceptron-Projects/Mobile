import 'package:flutter/material.dart';


class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final Color customBlueColor = const Color(0xFF0077B6);
  final Color customGreyColor = Colors.grey.shade300;
  List<String> teams = ['Team 1', 'Team 2', 'Team 3', 'Team 4'];

  Widget buildTeamButton(
      String text, Color backgroundColor, VoidCallback onPressed,
      {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Teams'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                // Handle profile icon tap
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Added SizedBox for spacing
          Expanded(
            child: ListView.builder(
              itemCount: teams.length + 1, // +1 for "Add Team" button
              itemBuilder: (context, index) {
                if (index == teams.length) {
                  return Center(
                    child: buildTeamButton(
                      'Add Team',
                      customGreyColor,
                      () {
                        // Handle "Add Team" button press
                        setState(() {
                          teams.add('Team ${teams.length + 1}');
                        });
                      },
                      icon: Icons.add, // Adding the plus icon
                    ),
                  );
                } else {
                  return Center(
                    child: Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        // Remove the dismissed team from the list
                        setState(() {
                          teams.removeAt(index);
                        });
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      child: buildTeamButton(
                        teams[index],
                        customBlueColor,
                        () {
                          // Handle team button press
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
