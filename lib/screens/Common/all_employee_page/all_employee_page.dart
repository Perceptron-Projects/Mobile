import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ams/Model/ui_state.dart';
import 'package:ams/Model/user_modle.dart';
import 'package:ams/resource/Provider/provider.dart';
import 'package:ams/screens/Common/employee_detail/employee_details_page.dart';
import 'package:ams/screens/login/login.dart';
import 'package:ams/widgets/custom_error.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hrBloc = Provider.of(context).hrBloc;
    final authBloc = Provider.of(context).authBloc;
    hrBloc.getAllUsers(authBloc.getSavedUserToken(), authBloc.getCompanyId());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Employee List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<UIState>(
          stream: hrBloc.allUser,
          builder: (BuildContext context, AsyncSnapshot<UIState> snapshot) {
            if (snapshot.hasData) {
              UIState uiState = snapshot.data!;
              if (uiState is LoadingUIState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (uiState is ResultUIState) {
                var data = uiState.result as List<User>;
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ProfileWidget(
                      user: data[index],
                      onMorePressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmployeeDetailsPage(
                              user: data[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (uiState is UnAuthenticatedUIState) {
                logout(context);
                return const SizedBox.shrink();
              } else if (uiState is NoResultUIState) {
                return const Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(fontSize: 14),
                  ),
                );
              } else if (uiState is ErrorUIState) {
                return Column(
                  children: [
                    CustomError(
                      errorMsg: uiState.message,
                      callBack: () => hrBloc.getAllUsers(
                          authBloc.getSavedUserToken(),
                          authBloc.getCompanyId()),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final User user;
  final VoidCallback? onMorePressed;

  const ProfileWidget({
    super.key,
    required this.user,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMorePressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.imageUrl),
          ),
          const SizedBox(height: 10),
          Text(
            user.username,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'EID - ${user.userId}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
