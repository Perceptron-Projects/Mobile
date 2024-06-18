class RequestError implements Exception {
  final String message;

  RequestError(this.message);

  @override
  String toString() => 'RequestError: $message';
}
