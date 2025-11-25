
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vba/presentation/auth_guard.dart';
import 'package:vba/presentation/home/home_screen.dart';

final GoRouter appRouter = GoRouter(
  routerNeglect: false,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthGuard(child: Scaffold(
      body: HomeScreen(),
    ))),
    GoRoute(path: '/home', builder: (context, state) => const Scaffold(
      body: HomeScreen(),
    )),
  ]
);