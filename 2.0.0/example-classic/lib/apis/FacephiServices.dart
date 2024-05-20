import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

String BASEURL_PLATFORM = '';
int TIMEOUT             = 30;

class FacephiServices
{
  final client = http.Client();

  Future<dynamic> matchingFacialRequest({required String docTemplate, required String extraData, required String image}) async
  {
    dynamic response;

    try
    {
      final uri     = Uri.https(BASEURL_PLATFORM, "/v5/api/v1/selphid/authenticate-facial/document/face-image");
      final header  = <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        //'client-id': CLIENTEID,
        //'token-app': TOKENAPP,
        //'x-api-key': APIKEY,
        //'app-name': APPNAME,
      };

      if (docTemplate == "" || extraData == "" || image == "")
      {
        print("docTemplate or extraData or image are empty...");
        return;
      }

      final r = await client.post(uri, headers: header, body: jsonEncode({'documentTemplate': docTemplate, 'extraData': extraData, 'image1': image})).timeout(Duration(seconds: TIMEOUT));
      if (r.statusCode == 200)
      {
        response = jsonEncode(r.body);
      }
    }
    on TimeoutException catch (e) {
      print("error matchingFacialRequest: $e");
    } on Error catch (e) {
      print("error matchingFacialRequest: $e");
    } catch (e) {
      print("error matchingFacialRequest: $e");
    } finally {
      return response;
    }
  }


  Future<dynamic> livenessRequest({required String extraData, required String image}) async
  {
    dynamic response;

    try
    {
      final uri     = Uri.https(BASEURL_PLATFORM, "/v5/api/v1/selphid/passive-liveness/evaluate");
      final header  = <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        //'client-id': CLIENTEID,
        //'token-app': TOKENAPP,
        //'x-api-key': APIKEY,
        //'app-name': APPNAME,
      };

      if (extraData == "" || image == "")
      {
        print("extraData or image are empty...");
      }

      final r = await client.post(uri, headers: header, body: jsonEncode({'extraData': extraData, 'image': image})).timeout(Duration(seconds: TIMEOUT));
      if (r.statusCode == 200)
      {
        response = jsonEncode(r.body);
      }
    }
    on TimeoutException catch (e) {
      print("error livenessRequest: $e");
    } on Error catch (e) {
      print("error livenessRequest: $e");
    } catch (e) {
      print("error livenessRequest: $e");
    } finally {
      return response;
    }
  }
}