class UnAuthenticatedErrorResponse implements Exception {
  final String message;

  UnAuthenticatedErrorResponse({required this.message});

  factory UnAuthenticatedErrorResponse.fromJson(Map<String, dynamic> json) {
    return UnAuthenticatedErrorResponse(
      message: json['message'] ?? 'Unknown error',
    );
  }

  @override
  String toString() => message;
}
