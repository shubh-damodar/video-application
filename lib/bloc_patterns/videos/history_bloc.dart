import 'dart:async';

import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';
import 'package:video/utils/navigation_actions.dart';

class HistoryBloc {
  ListConnect _listConnect = ListConnect();
  List<Videos> historyList = List<Videos>();
  StreamController<List<Videos>> _historyListStreamController =
      StreamController<List<Videos>>.broadcast();
  NavigationActions _navigationActions;

  StreamSink<List<Videos>> get historyListStreamSink =>
      _historyListStreamController.sink;

  Stream<List<Videos>> get historyListStream =>
      _historyListStreamController.stream;

  StreamController<String> _totalCountHistoryStreamController =
      StreamController<String>.broadcast();
  StreamSink<String> get totalCountHistoryStreamSink =>
      _totalCountHistoryStreamController.sink;
  Stream<String> get totalCountHistoryStream =>
      _totalCountHistoryStreamController.stream;

  StreamController<String> _thumbnailHistoryStreamController =
      StreamController<String>.broadcast();
  StreamSink<String> get thumbnailHistoryStreamSink =>
      _thumbnailHistoryStreamController.sink;
  Stream<String> get thumbnailHistoryStream =>
      _thumbnailHistoryStreamController.stream;

  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;

  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  void getWatchHistory(dynamic _jsonMap) async {
    historyList = List<Videos>();
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.listWatchLater}?type=$_jsonMap');
    if (mapResponse['code'] == 200) {
      List<dynamic> dynamicList =
          mapResponse['content']['videos'] as List<dynamic>;
      dynamicList
          .map((i) => historyList.add(Videos.fromJSONVideos(i)))
          .toList();
      historyListStreamSink.add(historyList);

      totalCountHistoryStreamSink
          .add(mapResponse['content']['totalCount'].toString());
      thumbnailHistoryStreamSink
          .add(mapResponse['content']['videos'][0]['thumbnail']);
    }
  }

  void removehistory(String markedMailId) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['videoIds'] = [markedMailId];
    mapBody['type'] = "watch-later";
    _listConnect
        .sendMailPost(mapBody, ListConnect.watchRemove)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  void deleteAllHistoryVideo(String id) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['videoIds'] = [id];
    mapBody['type'] = "history";
    _listConnect
        .sendMailPost(mapBody, ListConnect.watchRemove)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        composeFinishedStreamSink.add(mapResponse);
      }
    });
  }

  void deleteAllVideo() async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.historyDeleteVideo}')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  void dispose() {
    _historyListStreamController.close();
    _totalCountHistoryStreamController.close();
    _thumbnailHistoryStreamController.close();
    _composeFinishedStreamController.close();
  }
}
