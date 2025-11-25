import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WidgetBottomSignUp extends StatelessWidget {
  const WidgetBottomSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Don\'t have an account ?  '),
          Flexible(
            child: GestureDetector(
              onTap: () {
                context.go('/register');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Sign up',
                ),
              ),
            ),
          ),
          Flexible(child: Text('here.')),
        ],
      ),
    );
  }
}