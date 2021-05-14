import 'package:meta/meta.dart';

class ApiException implements Exception {
  final int statusCode;
  final String method;
  final Uri url;
  final String body;

  ApiException({
    @required this.statusCode,
    @required this.method,
    @required this.url,
    this.body,
  });

  ApiException.get({
    @required this.statusCode,
    @required this.url,
    this.body,
  }) : method = 'GET';

  @override
  String toString() {
    return '$method $url: $statusCode ${body != null ? "- $body" : ""}';
  }
}
