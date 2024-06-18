import 'package:ams/Bloc/Auth_Bloc/auth_bloc.dart';
import 'package:ams/Bloc/Employee_Bloc/employee_bloc.dart';
import 'package:ams/Bloc/HR_Bloc/hr_bloc.dart';
import 'package:flutter/material.dart';


// InheritedWidget objects have the ability to be
// searched for anywhere 'below' them in the widget tree.
class Provider extends InheritedWidget {
  final AuthBloc authBloc;
  final EmployeeBloc employeeBloc;
  final HRBloc hrBloc;

  Provider({Key? key, required Widget child})
      : authBloc = AuthBloc(),
        employeeBloc = EmployeeBloc(),
        hrBloc = HRBloc(),
        super(key: key, child: child);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;

  // this method is used to access an instance of
  // an inherited widget from lower in the tree.
  // `BuildContext.dependOnInheritedWidgetOfExactType` is a built in
  // Flutter method that does the hard work of traversing the tree for you
  static Provider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!;
  }
}
