import 'package:flutter/material.dart';

class AddMemberCard extends StatefulWidget {
  const AddMemberCard({Key? key}) : super(key: key);

  @override
  _AddMemberCardState createState() => _AddMemberCardState();
}

class _AddMemberCardState extends State<AddMemberCard> {
  List<TextEditingController> controllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add new member',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: controllers.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          hintText: 'Enter employee name or ID',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          controllers.add(TextEditingController());
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logic to handle saving members
                // You can access values from controllers and process them
                for (var controller in controllers) {
                  print(controller.text);
                  // Process each controller.text (employee name or ID)
                }
                // Clear controllers or reset state as needed
                controllers.clear();
                controllers.add(TextEditingController());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
            ),
            ),
            ],
        ),
      ),
    );
  }
}
