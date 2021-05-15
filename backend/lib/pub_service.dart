import 'dart:convert';
import 'dart:math';

import 'package:common/common.dart';
import 'package:http/http.dart' as http;

class PubService {
  static const baseUrl = 'https://pub.dev';
  static final listPackagesEndpoint = Uri.parse('$baseUrl/api/package-names');
  static final packageInfoEndpoint = (String packageName) => Uri.parse('$baseUrl/api/packages/$packageName');
  static final packageMetricsEndpoint = (String packageName) => Uri.parse('$baseUrl/api/packages/$packageName/metrics');
  static final packagePublisherEndpoint =
      (String packageName) => Uri.parse('$baseUrl/api/packages/$packageName/publisher');

  List<String> _packageCache;

  final _client = http.Client();
  final _random = Random();

  Future<List<String>> _listPackages() async {
    if (_packageCache != null) {
      return _packageCache;
    }
    final response = await _client.get(listPackagesEndpoint);
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    return _packageCache = (result['packages'] as List).cast<String>();
  }

  Future<Package> getRandomPackage() async {
    // Get package info
    final packages = await _listPackages();
    PackageData package;
    do {
      final packageName = packages[_random.nextInt(packages.length)];
      final packageUrl = packageInfoEndpoint(packageName);
      final packageResponse = await _client.get(packageUrl);
      if (packageResponse.statusCode != 200) {
        throw ApiException.get(
          url: packageUrl,
          statusCode: packageResponse.statusCode,
          body: packageResponse.body,
        );
      }
      package = PackageData.fromJson(
        jsonDecode(packageResponse.body) as Map<String, dynamic>,
      );
    } while (package.isDiscontinued ?? false);

    final packageName = package.name;

    // Get score data and metrics
    final metricsUrl = packageMetricsEndpoint(packageName);
    final metricsResponse = await _client.get(metricsUrl);
    if (metricsResponse.statusCode != 200) {
      throw ApiException.get(
        url: metricsUrl,
        statusCode: metricsResponse.statusCode,
        body: metricsResponse.body,
      );
    }
    final metricsJson = jsonDecode(metricsResponse.body) as Map<String, dynamic>;
    final versionScore =
        metricsJson['score'] != null ? VersionScore.fromJson(metricsJson['score'] as Map<String, dynamic>) : null;
    final scoreCardData = metricsJson['scorecard'] != null
        ? ScoreCardData.fromJson(metricsJson['scorecard'] as Map<String, dynamic>)
        : null;

    // Get publisher
    final publisherUrl = packagePublisherEndpoint(packageName);
    final publisherResponse = await _client.get(publisherUrl);
    if (publisherResponse.statusCode != 200) {
      throw ApiException.get(
        url: publisherUrl,
        statusCode: publisherResponse.statusCode,
        body: publisherResponse.body,
      );
    }
    final publisherJson = jsonDecode(publisherResponse.body) as Map<String, dynamic>;
    final publisher = publisherJson['publisherId'];

    return Package(
      packageData: package,
      publisher: publisher,
      versionScore: versionScore,
      scoreCardData: scoreCardData,
    );
  }
}
