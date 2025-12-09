import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 120,
                    color: Colors.blue.shade600,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Сканирование QR',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'Наведите камеру на QR-код для сканирования',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Начать сканирование'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
