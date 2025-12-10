import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:verify_app/features/verification/bloc/verification_bloc.dart';
import 'package:verify_app/features/verification/bloc/verification_event.dart';
import 'package:verify_app/features/verification/bloc/verification_state.dart';
import 'package:verify_app/features/verification/data/repositories/verification_repository.dart';
import 'package:verify_app/features/verification/domain/enums/verification_status.dart';
import 'package:verify_app/routes/app_router.gr.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _openHistory(BuildContext context) {
    context.router.push(const HistoryRoute());
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'VALID':
        return 'Действителен';
      case 'EXPIRING_SOON':
        return 'Срок истекает';
      case 'INVALID':
        return 'Недействителен';
      default:
        return status;
    }
  }

  Widget _getStatusIcon2(String status) {
    switch (status) {
      case 'VALID':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'EXPIRING_SOON':
        return const Icon(Icons.schedule, color: Colors.orange);
      case 'INVALID':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  void _showRecentDocuments(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Последние документы',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: context.read<VerificationRepository>().getHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Ошибка: ${snapshot.error}'),
                  );
                }
                final history = snapshot.data ?? [];
                if (history.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Нет истории'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      leading: Icon(Icons.description, color: Colors.grey[600]),
                      title: Text(item.docName),
                      subtitle: Text('Статус: ${_getStatusText(item.status)}'),
                      trailing: _getStatusIcon2(item.status),
                      onTap: () {
                        Navigator.pop(context);
                        // Можно добавить логику повторной проверки
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null && context.mounted) {
      context.read<VerificationBloc>().add(
        VerifyImageEvent(imagePath: result.files.single.path!),
      );
    }
  }

  List<Color> _getStatusGradient(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.valid:
        return [const Color(0xFF4CAF50), const Color(0xFF8BC34A)];
      case VerificationStatus.expiringSoon:
        return [const Color(0xFFFF9800), const Color(0xFFFFB74D)];
      case VerificationStatus.invalid:
        return [const Color(0xFFF44336), const Color(0xFFE57373)];
    }
  }

  Color _getStatusColor(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.valid:
        return const Color(0xFF4CAF50);
      case VerificationStatus.expiringSoon:
        return const Color(0xFFFF9800);
      case VerificationStatus.invalid:
        return const Color(0xFFF44336);
    }
  }

  IconData _getStatusIcon(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.valid:
        return Icons.verified;
      case VerificationStatus.expiringSoon:
        return Icons.schedule;
      case VerificationStatus.invalid:
        return Icons.cancel;
    }
  }

  String _getStatusTitle(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.valid:
        return 'Документ действителен';
      case VerificationStatus.expiringSoon:
        return 'Внимание! Срок истекает';
      case VerificationStatus.invalid:
        return 'Недействительный';
    }
  }

  String _getStatusDescription(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.valid:
        return 'Документ прошел проверку\nи является подлинным';
      case VerificationStatus.expiringSoon:
        return 'Документ действителен, но\nсрок действия скоро истекает.\nОбновите документ!';
      case VerificationStatus.invalid:
        return 'Документ не прошел проверку\nили является поддельным';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.router.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _openHistory(context),
                      icon: const Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: BlocBuilder<VerificationBloc, VerificationState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_user,
                              size: 100,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Проверка документов',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 48),
                            if (state is VerificationLoading)
                              const Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Обработка изображения...',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            else if (state is VerificationSuccess)
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _getStatusGradient(state.status),
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getStatusColor(
                                        state.status,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _getStatusIcon(state.status),
                                        size: 64,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      _getStatusTitle(state.status),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _getStatusDescription(state.status),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (state is VerificationFailure)
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE53E3E),
                                      Color(0xFFFC8181),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFE53E3E,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.error_outline,
                                        size: 64,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Ошибка проверки',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      state.error,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Text(
                                'Выберите изображение\nс QR-кодом для проверки',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            const SizedBox(height: 48),
                            ElevatedButton.icon(
                              onPressed: state is VerificationLoading
                                  ? null
                                  : () => _pickFile(context),
                              icon: const Icon(
                                Icons.document_scanner_rounded,
                                size: 25,
                              ),
                              label: const Text(
                                'Выбрать документ',
                                style: TextStyle(fontSize: 15),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF6C5CE7),
                                disabledBackgroundColor: Colors.white54,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 8,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => _showRecentDocuments(context),
                              icon: const Icon(
                                Icons.history,
                                color: Colors.white70,
                              ),
                              label: const Text(
                                'Последние документы',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            if (state is VerificationSuccess ||
                                state is VerificationFailure) ...[
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  context.read<VerificationBloc>().add(
                                    ResetVerificationEvent(),
                                  );
                                },
                                child: const Text(
                                  'Проверить другой документ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
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
