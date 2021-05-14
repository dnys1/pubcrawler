import 'dart:convert';

import 'package:common/common.dart';
import 'package:http/http.dart' as http;
import 'package:pubcrawler/env.dart';

class PubService {
  static final packageUrl = (String packageName) => Uri.parse('https://pub.dev/packages/$packageName');
  static final publisherUrl = (String publisherName) => Uri.parse('https://pub.dev/publishers/$publisherName/packages');

  final _client = http.Client();

  Future<Package> getRandomPackage() async {
    final response = await _client.get(BuildEnv.randomPackageUrl);
    if (response.statusCode != 200) {
      throw ApiException.get(
        statusCode: response.statusCode,
        body: response.body,
        url: BuildEnv.randomPackageUrl,
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return Package.fromJson(body);
  }
}
