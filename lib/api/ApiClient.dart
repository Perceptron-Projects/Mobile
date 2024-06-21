import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://g1xd2072z3.execute-api.us-east-1.amazonaws.com';
  final http.Client httpClient;

  ApiClient({http.Client? client}) : httpClient = client ?? http.Client();

}
