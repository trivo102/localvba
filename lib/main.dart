import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:vba/presentation/router.dart';
import 'package:vba/service_locator.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDependencies();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
       providers: [
        BlocProvider(
          create: (context) {
            return AuthenticationBloc()..add(AppStarted());
          }),
      ],
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(builder:(context, state) {
         return MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      title: '',
                      routerConfig: appRouter,
                    );
      },),
    );
  }
}