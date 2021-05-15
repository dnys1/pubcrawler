import 'dart:convert';

import 'package:common/src/api_exception.dart';
import 'package:backend/pub_service.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';

final _pubService = PubService();

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
};

@CloudFunction()
Future<Response> random(Request request, RequestLogger logger) async {
  try {
    final randomPackage = await _pubService.getRandomPackage();
    return Response.ok(
      jsonEncode(randomPackage.toJson()),
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json',
      },
    );
  } on ApiException catch (e) {
    logger.error(e.toString());
    return Response(e.statusCode, body: e.body, headers: corsHeaders);
  } catch (e) {
    logger.critical(e.toString());
    return Response.internalServerError(
      body: e.toString(),
      headers: corsHeaders,
    );
  }
}
