import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String baseUrlPlatform  = '';
int timeout             = 30;

class FacephiServices
{
  final client = http.Client();

  Future<dynamic> matchingFacialRequest({required String docTemplate, required String extraData, required String image}) async
  {
    dynamic response;
    try
    {
      final uri     = Uri.https(baseUrlPlatform, "/");
      final header  = <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        //'client-id': CLIENTEID,
        //'token-app': TOKENAPP,
        //'x-api-key': APIKEY,
        //'app-name': APPNAME,
      };

      if (docTemplate == "" || extraData == "" || image == "") {
        if (kDebugMode) {
          print("docTemplate or extraData or image are empty...");
        }
        return;
      }

      final r = await client.post(uri, headers: header, body: jsonEncode({'documentTemplate': docTemplate, 'extraData': extraData, 'image1': image})).timeout(Duration(seconds: timeout));
      if (r.statusCode == 200)
      {
        response = jsonEncode(r.body);
      }
    }
    on TimeoutException catch (e) {
      if (kDebugMode) {
        print("error matchingFacialRequest: $e");
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print("error matchingFacialRequest: $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print("error matchingFacialRequest: $e");
      }
    }
    return response;
  }


  Future<dynamic> livenessRequest({required String extraData, required String image}) async
  {
    dynamic response;
    try
    {
      final uri     = Uri.https(baseUrlPlatform, "/");
      final header  = <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        //'client-id': CLIENTEID,
        //'token-app': TOKENAPP,
        //'x-api-key': APIKEY,
        //'app-name': APPNAME,
      };

      if (extraData == "" || image == "") {
        if (kDebugMode) {
          print("extraData or image are empty...");
        }
        return;
      }

      final r = await client.post(uri, headers: header, body: jsonEncode({'extraData': extraData, 'image': image})).timeout(Duration(seconds: timeout));
      if (r.statusCode == 200)
      {
        response = jsonEncode(r.body);
      }
    }
    on TimeoutException catch (e) {
      if (kDebugMode) {
        print("error livenessRequest: $e");
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print("error livenessRequest: $e");
      }
    } catch (e) {
      if (kDebugMode) {
        print("error livenessRequest: $e");
      }
    }
    return response;
  }
}