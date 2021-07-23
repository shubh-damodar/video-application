import 'dart:async';

import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';

class WatchLater {
  ListConnect _listConnect = ListConnect();
  List<Videos> watchLaterList = List<Videos>();
  StreamController<List<Videos>> _watchLaterListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get watchLaterListStreamSink =>
      _watchLaterListStreamController.sink;

  Stream<List<Videos>> get watchLaterListStream =>
      _watchLaterListStreamController.stream;

  StreamController<String> _totalCountWatchLaterStreamController =
      StreamController<String>.broadcast();
  StreamSink<String> get totalCountWatchLaterStreamSink =>
      _totalCountWatchLaterStreamController.sink;
  Stream<String> get totalCountWatchLaterStream =>
      _totalCountWatchLaterStreamController.stream;

  StreamController<String> _thumbnailWatchLaterStreamController =
      StreamController<String>.broadcast();
  StreamSink<String> get thumbnailWatchLaterStreamSink =>
      _thumbnailWatchLaterStreamController.sink;
  Stream<String> get thumbnailWatchLaterStream =>
      _thumbnailWatchLaterStreamController.stream;

  void getWatchLater(dynamic _jsonMap) async {
    watchLaterList = List<Videos>();
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.listWatchLater}?type=$_jsonMap');
    if (mapResponse['code'] == 200) {
      // print("watch Later");
      List<dynamic> dynamicList =
          mapResponse['content']['videos'] as List<dynamic>;
      dynamicList
          .map((i) => watchLaterList.add(Videos.fromJSONVideos(i)))
          .toList();
      watchLaterListStreamSink.add(watchLaterList);

      totalCountWatchLaterStreamSink
          .add(mapResponse['content']['totalCount'].toString());
      thumbnailWatchLaterStreamSink
          .add(mapResponse['content']['videos'][0]['thumbnail']);
    }
  }

  void removeWatchLater(String markedMailId) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['videoIds'] = [markedMailId];
    mapBody['type'] = "watch-later";
    _listConnect
        .sendMailPost(mapBody, ListConnect.watchRemove)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  //------------------------fev------------------------->
  Future favouritesAction(String id, String action) async {
    await _listConnect
        .sendMailGetWithHeaders(
            '${ListConnect.favouritesActionVideoId}$id&type=$action')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        // print(mapResponse['message']);
      }
    });
  }
  //------------------------fev------------------------->

  void dispose() {
    _watchLaterListStreamController.close();
    _totalCountWatchLaterStreamController.close();
    _thumbnailWatchLaterStreamController.close();
  }
}
