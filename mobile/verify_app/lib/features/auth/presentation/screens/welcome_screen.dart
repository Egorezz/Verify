import 'package:auto_route/auto_route.dart';
import 'package:verify_app/routes/app_router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/man.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: SafeArea(
          child: Column(
            children: [
              // Иллюстрация сверху
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.white.withOpacity(
                      0.9,
                    ), // полупрозрачный фон для иллюстрации
                  ),
                  // child: Center(
                  //   child: Image.asset(
                  //     'assets/images/man.png',
                  //     height: 240,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                ),
              ),

              // Основной контент: текст + кнопки
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Добро Пожаловать',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Проверяйте подлинность документов\nв один клик',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // Кнопка "Авторизация"
                      ElevatedButton(
                        onPressed: () =>
                            context.router.push(const LoginRoute()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Авторизация',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Кнопка "Регистрация"
                      OutlinedButton(
                        onPressed: () =>
                            context.router.push(const RegistrationRoute()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(
                            255,
                            164,
                            92,
                            231,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 164, 92, 231),
                            width: 2,
                          ),
                        ),
                        child: const Text(
                          'Регистрация',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
