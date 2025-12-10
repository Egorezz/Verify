import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_app/features/auth/bloc/auth_bloc.dart';
import 'package:verify_app/features/auth/bloc/auth_event.dart';
import 'package:verify_app/features/auth/bloc/auth_state.dart';
import 'package:verify_app/routes/app_router.gr.dart';

@RoutePage()
class SetNewPinScreen extends StatefulWidget {
  const SetNewPinScreen({super.key});

  @override
  State<SetNewPinScreen> createState() => _SetNewPinScreenState();
}

class _SetNewPinScreenState extends State<SetNewPinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;

  void _addNumber(String number) {
    if (!_isConfirming && _pin.length < 4) {
      setState(() {
        _pin += number;
        if (_pin.length == 4) {
          _isConfirming = true;
        }
      });
    } else if (_isConfirming && _confirmPin.length < 4) {
      setState(() {
        _confirmPin += number;
        if (_confirmPin.length == 4) {
          _checkPins();
        }
      });
    }
  }

  void _deleteNumber() {
    if (_isConfirming && _confirmPin.isNotEmpty) {
      setState(() {
        _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
      });
    } else if (!_isConfirming && _pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    } else if (_isConfirming && _confirmPin.isEmpty) {
      setState(() {
        _isConfirming = false;
      });
    }
  }

  void _checkPins() {
    if (_pin == _confirmPin) {
      context.read<AuthBloc>().add(SetNewPinEvent(_pin));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('PIN-коды не совпадают'),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      setState(() {
        _pin = '';
        _confirmPin = '';
        _isConfirming = false;
      });
    }
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () => _addNumber(number),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Text(
        number,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: _deleteNumber,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade100,
        foregroundColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: const Icon(Icons.backspace_outlined, size: 24),
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
                    context.router.replaceAll([const WelcomeRoute()]);
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ошибка: ${state.message}'),
                        backgroundColor: Colors.red.shade600,
                      ),
                    );
                  }
                },

                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_reset,
                          size: 80,
                          color: Color(0xFF6C5CE7),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _isConfirming ? 'Подтвердите PIN' : 'Новый PIN',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isConfirming
                              ? 'Повторите PIN-код'
                              : 'Введите новый 4-значный PIN',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // PIN display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            final currentPin = _isConfirming
                                ? _confirmPin
                                : _pin;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade50,
                              ),
                              child: Center(
                                child: Text(
                                  index < currentPin.length ? '●' : '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        // Number pad
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            if (index == 9) {
                              return const SizedBox();
                            } else if (index == 10) {
                              return _buildNumberButton('0');
                            } else if (index == 11) {
                              return _buildDeleteButton();
                            } else {
                              return _buildNumberButton('${index + 1}');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
