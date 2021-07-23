import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video/models/user.dart';

class Connect {
  String _baseUrl = 'https://idm.simplifying.world/apis/v1.0.1/';
  // String _baseUrl = 'https://idm.mesbro.com/apis/v1.0.1/';
  static User currentUser = null;

  static String filesUrl = 'http://files.simplifying.world/',
      // static String filesUrl = 'http://files.mesbro.com/',
      userLogin = 'user/login',
      userPersonalProfileUsername = 'user/personal-profile?username=',
      forgotPassword = 'user/forgot-password?username=',
      otpValidate = 'otp/validate',
      otpGenerate = 'otp/generate',
      otpResend = 'otp/resend?otpToken=',
      otpVerification = 'otp-verification',
      resetPasswordVerification = 'user/reset-password',
      userSignUp = 'user/signup',
      userUpdate = 'user/update',
      locationAutocompleteCity = 'location/autocomplete?name=',
      locationAutocompleteCity1 = 'location/autocomplete?name=na&type=city',
      a = '';

  Future<Map<String, dynamic>> sendPost(
      Map<String, String> mapBody, String url) async {
    http.Response response = await http.post('$_baseUrl$url',
        body: json.encode(mapBody),
        headers: {"Content-Type": "application/json"});
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendHeadersPost(
      Map<String, dynamic> mapBody, String url) async {
    http.Response response =
        await http.post('$_baseUrl$url', body: json.encode(mapBody), headers: {
      "Content-Type": "application/json",
      'au': currentUser == null ? '' : currentUser.au,
      'ut-${currentUser.au}': '${currentUser.token}'
    });
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendPostWithHeaders(
      dynamic mapBody, String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse('$_baseUrl$url'));
    request.headers.add('au', currentUser.au);
    request.headers.add('ut-${currentUser.au}', '${currentUser.token}');
    request.add(utf8.encode(json.encode(mapBody)));
    HttpClientResponse httpClientResponse = await request.close();
    String response = await httpClientResponse.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(response);
    return map;
  }

  Future<Map<String, dynamic>> sendGet(String url) async {
    http.Response response = await http.get('$_baseUrl$url');
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  }
}
