class CommonErrorResponse implements Exception {
  final String message;

  CommonErrorResponse({required this.message});

  factory CommonErrorResponse.fromJson(Map<String, dynamic> json) {
    dynamic messageJson = json['message'];

    if (messageJson is String) {
      return CommonErrorResponse(message: messageJson);
    } else if (messageJson is List<dynamic>) {
      return CommonErrorResponse(
          message: messageJson.isNotEmpty ? messageJson[0] : 'Unknown error');
    } else if (messageJson is Map<String, dynamic>) {
      var firstKey = messageJson.keys.first;
      return CommonErrorResponse(message: messageJson[firstKey].toString());
    } else {
      return CommonErrorResponse(message: 'Unknown error');
    }
  }

  @override
  String toString() => message;
}
