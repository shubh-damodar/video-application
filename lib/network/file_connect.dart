import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video/network/user_connect.dart';

class FileConnect {
 String _fileBaseUrl =
     'http://file-manager.simplifying.world/apis/v1.0.1/upload/';

  // String _fileBaseUrl = 'https://file-manager.mesbro.com/apis/v1.0.1/upload/';
// 
  static String uploadFileGetDownloadUrl = 'get-signed-url',
      uploadConfirmUploadToken = 'confirm?uploadToken=',
      uploadGetDetails = 'get-details',
      upload = 'sent',
      a = '';

  Future<int> uploadFile(
      String url, String contentType, String filePath) async  {

  File file=File(filePath);
    http.Response httpResponse = await http.put(url, body: file.readAsBytesSync(), headers: {"Content-Type": contentType});

    return httpResponse.statusCode;
  }

  Future<Map<String, dynamic>> sendFilePost(
      Map<String, dynamic> mapBody, String url) async {

    http.Response response = await http
        .post('$_fileBaseUrl$url', body: json.encode(mapBody), headers: {
      'au': Connect.currentUser == null ? '' : Connect.currentUser.au,
      'ut-${Connect.currentUser.au}': '${Connect.currentUser.token}',
      "Content-Type": "application/json"
    });
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendFilePostWithHeaders(
      dynamic mapBody, String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse('$_fileBaseUrl$url'));
    request.headers.add('au', Connect.currentUser.au);
    request.headers
        .add('ut-${Connect.currentUser.au}', '${Connect.currentUser.token}');
    request.add(utf8.encode(json.encode(mapBody)));
    HttpClientResponse httpClientResponse = await request.close();
    String response = await httpClientResponse.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(response);
    return map;
  }

  Future<Map<String, dynamic>> sendFileGet(String url) async {
    http.Response response = await http.get('$_fileBaseUrl$url', headers: {
      'au': Connect.currentUser == null ? '' : Connect.currentUser.au,
      'ut-${Connect.currentUser.au}': '${Connect.currentUser.token}',
      "Content-Type": "application/json"
    });
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendFileGetWithHeaders(String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse('$_fileBaseUrl$url'));
    request.headers.add('au', Connect.currentUser.au);
    request.headers
        .add('ut-${Connect.currentUser.au}', '${Connect.currentUser.token}');
    HttpClientResponse httpClientResponse = await request.close();
    String response = await httpClientResponse.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(response);
    return map;
  }
}
