import 'package:auto_route/auto_route.dart';
import 'package:verify_app/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_app/features/auth/bloc/auth_bloc.dart';
import 'package:verify_app/features/auth/bloc/auth_event.dart';
import 'package:verify_app/features/auth/bloc/auth_state.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pinCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade400, Colors.purple.shade300],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    context.router.push(const ScanRoute());
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red.shade400,
                      ),
                    );
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_rounded,
                              size: 80,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Вход',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Введите PIN',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 40),
                            TextField(
                              controller: _pinCtrl,
                              decoration: InputDecoration(
                                labelText: 'PIN',
                                prefixIcon: const Icon(Icons.pin_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                letterSpacing: 8,
                              ),
                              onSubmitted: (_) {
                                context.read<AuthBloc>().add(
                                  LoginEvent(_pinCtrl.text),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            if (state is AuthLoading)
                              const CircularProgressIndicator()
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                      LoginEvent(_pinCtrl.text),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Войти',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(ForgotPinEvent());
                              },
                              child: Text(
                                'Забыли PIN?',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
