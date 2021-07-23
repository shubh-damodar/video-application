import 'dart:async';

import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';

class LikedVideoBloc {
  ListConnect _listConnect = ListConnect();
  List<Videos> likeList = List<Videos>();
  StreamController<List<Videos>> _likeListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get likeListStreamSink =>
      _likeListStreamController.sink;

  Stream<List<Videos>> get likeListStream => _likeListStreamController.stream;

  StreamController<String> _totalCountListStreamController =
      StreamController<String>.broadcast();
  StreamSink<String> get totalCountListStreamSink =>
      _totalCountListStreamController.sink;
  Stream<String> get totalCountListStream =>
      _totalCountListStreamController.stream;

  StreamController<String> _thumbnailListStreamController =
      StreamController<String>.broadcast();
  StreamSink<String> get thumbnailListStreamSink =>
      _thumbnailListStreamController.sink;
  Stream<String> get thumbnailListStream =>
      _thumbnailListStreamController.stream;

  void likedVideosList(dynamic _jsonMap) async {
    likeList = List<Videos>();
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.listLikes}?type=$_jsonMap');
    if (mapResponse['code'] == 200) {
      List<dynamic> dynamicList =
          mapResponse['content']['videos'] as List<dynamic>;
      dynamicList.map((i) => likeList.add(Videos.fromJSONVideos(i))).toList();
      likeListStreamSink.add(likeList);
      totalCountListStreamSink
          .add(mapResponse['content']['totalCount'].toString());
      thumbnailListStreamSink
          .add(mapResponse['content']['videos'][0]['thumbnail']);
    }
  }
  

  // void removelike(String markedMailId) async {
  //   Map<String, dynamic> mapBody = Map<String, dynamic>();
  //   mapBody['videoIds'] = [markedMailId];
  //   mapBody['type'] = "watch-later";
  //   _listConnect
  //       .sendMailPost(mapBody, ListConnect.watchRemove)
  //       .then((Map<String, dynamic> mapResponse) {
  //     if (mapResponse['code'] == 200) {
  //       print(mapResponse);
  //     }
  //   });
  // }

  Future favouritesAction(String id, String action) async {
    await _listConnect
        .sendMailGetWithHeaders(
            '${ListConnect.favouritesActionVideoId}$id&type=$action')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  Future addWatchLater(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.addwatchLaterVideo}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  void dispose() {
    _likeListStreamController.close();
    _totalCountListStreamController.close();
    _thumbnailListStreamController.close();
  }
}
