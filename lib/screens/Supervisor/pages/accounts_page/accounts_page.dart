import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final List<Map<String, String>> employees = [
    {
      'name': 'Maxton James',
      'eid': 'EID201',
      'image': 'assets/maxton.jpg',
    },
    {
      'name': 'Peter Park',
      'eid': 'EID202',
      'image': 'assets/peter.jpg',
    },
    {
      'name': 'Anne Amelia',
      'eid': 'EID203',
      'image': 'assets/anne.jpg',
    },
    {
      'name': 'Gabriel Scott',
      'eid': 'EID204',
      'image': 'assets/gabriel.jpg',
    },
    {
      'name': 'Aiden Thomas',
      'eid': 'EID205',
      'image': 'assets/aiden.jpg',
    },
    {
      'name': 'Daniel Tyler',
      'eid': 'EID206',
      'image': 'assets/daniel.jpg',
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredEmployees = employees
        .where((employee) =>
            employee['name']!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            employee['eid']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new employee action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0), // Space for the app bar
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              GridView.builder(
                padding: const EdgeInsets.all(16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: filteredEmployees.length,
                itemBuilder: (ctx, index) {
                  return GridTile(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundImage:
                              AssetImage(filteredEmployees[index]['image']!),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          filteredEmployees[index]['name']!,
                          style: const TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          filteredEmployees[index]['eid']!,
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
