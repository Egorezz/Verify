import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_app/di/di.dart';
import 'package:verify_app/features/auth/bloc/auth_bloc.dart';
import 'package:verify_app/routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: const VerifyApp(),
    ),
  );
}

class VerifyApp extends StatelessWidget {
  const VerifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Verify',
      theme: ThemeData(),
      routerConfig: AppRouter().config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
