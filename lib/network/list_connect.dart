import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video/network/user_connect.dart';

class ListConnect {
  // String _listBaseUrl = 'https://video.mesbro.com/apis/v1.0.1/';

  String _listBaseUrl = 'http://video.simplifying.world/apis/v1.0.1/';

  static String listSearch = 'search',
      getvideodetail = 'channel/get-video-detail?videoId=',
      getRelateVideo = 'search/related?videoId=',
      getVideoUrl = 'list/get-playback-url?id=',
      listContacts = 'list/contacts',
      listWatchLater = 'watch/get-videos',
      listLikes = 'likes/get-videos',
      watchRemove = 'watch/remove',
      favouritesList = 'favourites/get-videos',
      myVideos = 'list/get',
      videosSearch = 'search',
      addVideo = 'list/add',

      //add and remove video from video_Page
      addwatchLaterVideo = 'watch/add-watch-later?videoId=',
      watchRemoveVideo = 'watch/remove',
      //end

      //favourites in video from video_page
      favouritesActionVideoId = 'favourites/action?videoId=',
      //end

      //Action like and disklike video
      likeVideo = 'likes/action?videoId=',
      dislikeVideo = 'likes/remove',
      //end

      channelSubAndUnsub = 'channel/',
      commentsAdd = 'comments/add',
      listOfChannel = 'channel/get-list',
      channelInfoDetails = 'channel/get-info',
      channelVideoList = 'channel/get-videos',
      subscriptionList = 'subscription/list',
      channelUnsubscribe = "channel/unsubscribe?id=",
      addChannelList = "channel/create",
      channelGetDetails = 'channel/get-info?channelId=',
      deleteChannel = 'channel/delete?channelId=',
      channelUpdate = 'channel/update',
      historyDeleteVideo = "watch/clear-list?type=history",
      videoDetails = 'channel/get-video-detail?videoId=',
      channelListInChannel = 'channel/get-related-channels?channelId=',
      getPlatListChannel = 'channel/get-playlist?channelId=',
      deleteVideo = 'list/remove?id=',
      videoUpdate = 'list/update',
      a = '';

  Future<Map<String, dynamic>> sendMailPost(
      Map<String, dynamic> mapBody, String url) async {
    http.Response response = await http
        .post('$_listBaseUrl$url', body: json.encode(mapBody), headers: {
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
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse('$_listBaseUrl$url'));
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

  Future<Map<String, dynamic>> sendMailGet(String url) async {
    http.Response response = await http.get('$_listBaseUrl$url');
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  }

  Future<Map<String, dynamic>> sendMailGetWithHeaders(String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse('$_listBaseUrl$url'));
    request.headers.add('au', Connect.currentUser.au);
    request.headers
        .add('ut-${Connect.currentUser.au}', '${Connect.currentUser.token}');
    HttpClientResponse httpClientResponse = await request.close();
    String response = await httpClientResponse.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(response);
    return map;
  }

  Future<Map<String, dynamic>> sendMailGetWithHeadersWithMap(
      dynamic mapBody, String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse('$_listBaseUrl$url'));
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
