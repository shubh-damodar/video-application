import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video/network/user_connect.dart';

class MerbroConnectVideo  {
 String _videoBaseUrl = 'https://business.simplifying.world/apis/v1.0.1/';
  // String _videoBaseUrl = 'https://www.mesbro.com/apis/v1.0.1/';

  static String 
      profileGetDetailsVideo = 'profile/get?userId=',
      a = '';

  Future<Map<String, dynamic>> sendMailPost(
      Map<String, dynamic> mapBody, String url) async {
    //print(
   //     '~~~ sendMailPost: $_videoBaseUrl$url ${Connect.currentUser.au} ${Connect.currentUser.token} $mapBody');
    http.Response response = await http
        .post('$_videoBaseUrl$url', body: json.encode(mapBody), headers: {
      'au': Connect.currentUser == null ? '' : Connect.currentUser.au,
      'ut-${Connect.currentUser.au}': '${Connect.currentUser.token}',
      "Content-Type": "application/json"
    });
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }
  
  Future<Map<String, dynamic>> sendMailPostWithHeaders(
      dynamic mapBody, String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse('$_videoBaseUrl$url'));
    request.headers.add('au', Connect.currentUser.au);
    request.headers.add('ut-${Connect.currentUser.au}', '${Connect.currentUser.token}');
    request.add(utf8.encode(json.encode(mapBody)));
    HttpClientResponse httpClientResponse = await request.close();
    String response = await httpClientResponse.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(response);
    return map;
  }

  Future<Map<String, dynamic>> sendMailGet(String url) async {
    http.Response response = await http.get('$_videoBaseUrl$url');
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  }


  Future<Map<String, dynamic>> sendMailGetWithHeaders(
      String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse('$_videoBaseUrl$url'));
    request.headers.add('au', Connect.currentUser.au);
    request.headers.add('ut-${Connect.currentUser.au}', '${Connect.currentUser.token}');
    HttpClientResponse httpClientResponse = await request.close();
    String response = await httpClientResponse.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(response);
    return map;
  }
}