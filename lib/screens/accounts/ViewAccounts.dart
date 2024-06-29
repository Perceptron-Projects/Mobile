import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/providers/ProfileController.dart';
import 'package:ams/screens/userDetails/AdvancedUserDetails.dart';
import 'package:ams/screens/userDetails/GeneralUserDetails.dart';
import 'package:ams/providers/AuthController.dart';

class ViewAccountScreen extends HookConsumerWidget {
  final String companyId;

  ViewAccountScreen({required this.companyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileController = ref.read(profileControllerProvider);
    final authController = AuthController(); // Assume authController is properly initialized
    final employees = useState<List<Map<String, dynamic>>>([]);
    final filteredEmployees = useState<List<Map<String, dynamic>>>([]);
    final isLoading = useState<bool>(true);
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final userRoles = useState<List<String>>([]);

    useEffect(() {
      Future<void> fetchEmployees() async {
        try {
          final fetchedEmployees = await profileController.fetchEmployeesByCompany(companyId);
          employees.value = fetchedEmployees;
          filteredEmployees.value = fetchedEmployees;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch employees')),
          );
        } finally {
          isLoading.value = false;
        }
      }

      Future<void> fetchUserRoles() async {
        try {
          userRoles.value = await authController.getRoles() ?? [];
        } catch (e) {
          print("Error fetching user roles: $e");
        }
      }

      fetchEmployees();
      fetchUserRoles();
      return null;
    }, []);

    useEffect(() {
      if (searchQuery.value.isEmpty) {
        filteredEmployees.value = employees.value;
      } else {
        filteredEmployees.value = employees.value.where((employee) {
          final fullName = '${employee['firstName']} ${employee['lastName']}'.toLowerCase();
          return fullName.contains(searchQuery.value.toLowerCase());
        }).toList();
      }
      return null;
    }, [searchQuery.value, employees.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Employees', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Employees',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onChanged: (value) {
                searchQuery.value = value;
              },
            ),
            SizedBox(height: 48),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.99,
              ),
              itemCount: filteredEmployees.value.length,
              itemBuilder: (context, index) {
                final employee = filteredEmployees.value[index];
                final profileImage = employee['imageUrl'] ?? 'https://via.placeholder.com/150'; // Default image
                final firstName = employee['firstName'] ?? 'N/A';
                final lastName = employee['lastName'] ?? 'N/A';
                final userId = employee['userId'];

                return GestureDetector(
                  onTap: () {
                    if (userId != null) {
                      if (userRoles.value.contains('hr') && userRoles.value.contains('supervisor')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdvancedUserDetailsScreen(userId: userId),
                          ),
                        );
                      } else if (userRoles.value.contains('hr')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdvancedUserDetailsScreen(userId: userId),
                          ),
                        );
                      }else if (userRoles.value.contains('supervisor')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeneralUserDetailsScreen(userId: userId),
                          ),
                        );
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('You do not have the necessary permissions to view details.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User ID is missing')),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profileImage),
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$firstName $lastName',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
