import 'dart:async';

import 'package:video/models/videos.dart';
import 'package:video/network/action_connect.dart';
import 'package:video/network/list_connect.dart';


class TreandingBloc {
  ListConnect _listConnect = ListConnect();
  ActionConnect _actionConnect = ActionConnect();
  List<Videos> videosList = List<Videos>();
  int lastTimeStamp;
  StreamController<List<Videos>> _videosStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get videosStreamSink => _videosStreamController.sink;

  Stream<List<Videos>> get videosStream => _videosStreamController.stream;

  void getReceivedMessages(dynamic _jsonMap) async {
    videosList = List<Videos>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['filters'] = _jsonMap;
    mapBody['page'] = '0';
    _listConnect
        .sendMailPost(mapBody, ListConnect.listSearch)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList
            .map((i) => videosList.add(Videos.fromJSONVideos(i)))
            .toList();
        videosStreamSink.add(videosList);
        if (videosList.isNotEmpty) {}
      }
    });
  }

  void getFurtherMessages(String typeTimeStamp) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    List<Videos> newMessagesList = List<Videos>();
    _listConnect
        .sendMailPost(mapBody, ListConnect.listSearch)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList
            .map((i) => newMessagesList.add(Videos.fromJSONVideos(i)))
            .toList();
        videosList.addAll(newMessagesList);
        videosStreamSink.add(videosList);
      }
    });
  }

  void markUnmarkFavorite(
      String markedMailId, String type, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['mailId'] = [markedMailId];
    mapBody['type'] = type;
    mapBody['action'] = action;
    _actionConnect
        .sendActionPost(mapBody, ActionConnect.actionMarkFavourite)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

//----------------------------WATCH lATER------------------>
  Future favouritesAction(String id, String action) async {
    await _listConnect
        .sendMailGetWithHeaders(
            '${ListConnect.favouritesActionVideoId}$id&type=$action')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
      }
    });
  }
//--------------------------------End----------------------------->

//--------------------------add Watch Later ------------------------>
  Future addWatchLater(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.addwatchLaterVideo}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
      }
    });
  }
//------------------------------End ------------------------>

//-----------------------------Delete video from history-------------------->

//--------------------------------End------------------------------------>


  void dispose() {
    _videosStreamController.close();
  }
}
