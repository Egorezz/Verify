Future<T> retryWithExponentialBackoff<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
}) async {
  Duration delay = const Duration(milliseconds: 500);
  for (int attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await operation();
    } catch (e) {
      if (attempt == maxRetries) rethrow;
      await Future.delayed(delay);
      delay *= 2;
    }
  }
  throw Exception('Unreachable');
}
