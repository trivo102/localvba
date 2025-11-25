import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/presentation/login/bloc/login_bloc.dart';
import 'package:vba/presentation/login/widgets/signin_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => LoginBloc(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                       "SIGN IN",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const WidgetSignInForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
