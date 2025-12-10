import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_app/features/auth/bloc/auth_bloc.dart';
import 'package:verify_app/features/auth/bloc/auth_event.dart';
import 'package:verify_app/features/auth/bloc/auth_state.dart';
import 'package:verify_app/routes/app_router.gr.dart';

@RoutePage()
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _loginCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _pinRepeatCtrl = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Данные не валидны',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 6,
      ),
    );
  }

  void _register(AuthBloc bloc) {
    if (!_formKey.currentState!.validate() ||
        _pinCtrl.text != _pinRepeatCtrl.text ||
        !_isValidEmail(_loginCtrl.text) ||
        _passwordCtrl.text.length < 6) {
      _showValidationError();
      return;
    }

    bloc.add(
      RegisterEvent(
        _nameCtrl.text,
        _loginCtrl.text,
        _passwordCtrl.text,
        _pinCtrl.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C5CE7), Color(0xFFA45CE7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    context.router.push(const LoginRoute());
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
                        padding: const EdgeInsets.all(32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person_add_rounded,
                                size: 64,
                                color: Color(0xFF6C5CE7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Регистрация',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 32),
                              TextFormField(
                                controller: _nameCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Имя',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (v) =>
                                    v!.isEmpty ? 'Обязательно' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _loginCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(
                                    Icons.account_circle_outlined,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (v) {
                                  if (v!.isEmpty) return 'Обязательно';
                                  if (!_isValidEmail(v)) {
                                    return 'Неверный формат email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Пароль',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                obscureText: true,
                                validator: (v) {
                                  if (v!.isEmpty) return 'Обязательно';
                                  if (v.length < 6) return 'Минимум 6 символов';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _pinCtrl,
                                decoration: InputDecoration(
                                  labelText: 'PIN (4 цифры)',
                                  prefixIcon: const Icon(Icons.pin_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                maxLength: 4,
                                validator: (v) =>
                                    v!.length != 4 ? 'Введите 4 цифры' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _pinRepeatCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Повторите PIN',
                                  prefixIcon: const Icon(Icons.pin_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                maxLength: 4,
                              ),
                              const SizedBox(height: 32),
                              if (state is AuthLoading)
                                const CircularProgressIndicator()
                              else
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _register(context.read<AuthBloc>()),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6C5CE7),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: const Text(
                                      'Зарегистрироваться',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
