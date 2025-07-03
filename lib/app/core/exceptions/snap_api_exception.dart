class SnapApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errorData;

  SnapApiException(this.message, {this.statusCode, this.errorData});

  @override
  String toString() => 'SnapApiException: $message';
}
