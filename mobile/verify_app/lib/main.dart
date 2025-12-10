import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_app/di/di.dart';
import 'package:verify_app/features/auth/bloc/auth_bloc.dart';
import 'package:verify_app/features/verification/bloc/verification_bloc.dart';
import 'package:verify_app/routes/app_router.dart';
import 'package:verify_app/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: verificationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepository)),
          BlocProvider(create: (_) => VerificationBloc(verificationRepository)),
        ],
        child: const VerifyApp(),
      ),
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
