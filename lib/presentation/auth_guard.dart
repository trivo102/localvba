import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:vba/presentation/login/login.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Uninitialized) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Unauthenticated) {
          return const LoginPage();
        } else if (state is Authenticated) {
          return child;
        }

        return const Center(child: Text('Unhandled Authentication State'));
      },
    );
  }
}