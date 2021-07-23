import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video/network/user_connect.dart';

class ActionConnect {
//  String _actionBaseUrl = 'http://mail.simplifying.world/apis/v1.0.1/action/';

  // String _actionBaseUrl = 'https://services.mesbro.com/apis/v1.0.1/';
  String _actionBaseUrl = 'https://services.simplifying.world/apis/v1.0.1/';

  static String actionMarkFavourite = 'mark-favourite',
      actionArchive = 'archive',
      actionDelete = 'delete',
      actionMoveToTrash = 'move-to-trash',
      actionSpam = 'spam',
      actionRecoverFromArchive = 'recover-from-archive',
      actionRecoverFromTrash = 'recover-from-trash',
      actionMarkNotSpam = 'mark-not-spam',
      actionCompose = 'compose',
      actionReply = 'reply',
      actionForward = 'forward',
      actionDraft = 'draft',
      actionBulkMarkAsRead = 'bulk-mark-read',

      //Video Comment action
      commentsAdd = 'comments/add',
      commentsReplyAdd = 'comments/reply/add',
      commentsReplyDelete = 'comments/reply/delete',

      commentsGetList = 'comments/get-list?parentId=',
      nestedcommentsGetList = 'comments/get-list?parentId=',
      deleteComment = "comments/delete?parentId=",
      a = '';

  Future<Map<String, dynamic>> sendActionPost(
      Map<String, dynamic> mapBody, String url) async {
    //print(
    //      '~~~ sendActionPost: $_actionBaseUrl$url ${Connect.currentUser.au} ${Connect.currentUser.token} $mapBody');
    http.Response response = await http
        .post('$_actionBaseUrl$url', body: json.encode(mapBody), headers: {
      'au': Connect.currentUser == null ? '' : Connect.currentUser.au,
      'ut-${Connect.currentUser.au}': '${Connect.currentUser.token}',
      "Content-Type": "application/json"
    });
    //print('~~~ sendActionPost: ${response.body}');
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendActionPostWithHeaders(
      dynamic mapBody, String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse('$_actionBaseUrl$url'));
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

  Future<Map<String, dynamic>> sendActionGet(String url) async {
    http.Response response = await http.get('$_actionBaseUrl$url');
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendActionGetWithHeaders(String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse('$_actionBaseUrl$url'));
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
