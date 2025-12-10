import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:verify_app/features/verification/data/repositories/verification_repository.dart';
import 'package:verify_app/features/verification/domain/entities/document_history_item.dart';

@RoutePage()
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DocumentHistoryItem> _history = [];
  bool _isLoading = true;
  bool _isAuthenticated = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _authenticateWithBiometrics();
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      
      print('Можно проверить биометрию: $canCheckBiometrics');
      print('Доступные методы: $availableBiometrics');
      
      if (!canCheckBiometrics || availableBiometrics.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Row(
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Биометрия не настроена',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Настройте отпечаток пальца в настройках',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.settings,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.orange.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              elevation: 8,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        setState(() => _isAuthenticated = true);
        _loadHistory();
        return;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Подтвердите личность для доступа к истории',
      );

      if (didAuthenticate) {
        setState(() => _isAuthenticated = true);
        _loadHistory();
      } else {
        if (mounted) {
          context.router.pop();
        }
      }
    } catch (e) {
      print('Ошибка биометрии: $e');
      setState(() => _isAuthenticated = true);
      _loadHistory();
    }
  }

  Future<void> _loadHistory() async {
    try {
      final repository = context.read<VerificationRepository>();
      final history = await repository.getHistory();
      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Ошибка загрузки истории: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6C5CE7), Color(0xFFA45CE7)],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fingerprint,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'Аутентификация...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
          child: Column(
            children: [
              // Back button and title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.router.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'История сканирований',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: _isLoading ? null : () {
                        setState(() => _isLoading = true);
                        _loadHistory();
                      },
                      icon: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 24,
                          ),
                    ),
                  ],
                ),
              ),
              // History list
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _history.isEmpty
                    ? const Center(
                        child: Text(
                          'История пуста',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getStatusColor(item.status),
                                child: Icon(
                                  _getStatusIcon(item.status),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text('ID: ${item.id}'),
                              subtitle: Text(item.docName),
                              trailing: Text(
                                _getStatusText(item.status),
                                style: TextStyle(
                                  color: _getStatusColor(item.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'valid':
        return Colors.green;
      case 'expiring_soon':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'valid':
        return Icons.check_circle;
      case 'expiring_soon':
        return Icons.warning;
      default:
        return Icons.error;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'VALID':
        return 'Действителен';
      case 'EXPIRING_SOON':
        return 'Истекает';
      case 'INVALID':
        return 'Недействителен';
      default:
        return status;
    }
  }
}
