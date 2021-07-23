import 'dart:async';

import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';

class FavouritesBloc {
  ListConnect _listConnect = ListConnect();
  List<Videos> favouritesList = List<Videos>();
  StreamController<List<Videos>> _favouritesListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get favouritesListStreamSink =>
      _favouritesListStreamController.sink;

  Stream<List<Videos>> get favouritesListStream =>
      _favouritesListStreamController.stream;

  StreamController<String> _totalCountFevListStreamController =
      StreamController<String>.broadcast();
  StreamSink<String> get totalCountFevListStreamSink =>
      _totalCountFevListStreamController.sink;
  Stream<String> get totalCountFevListStream =>
      _totalCountFevListStreamController.stream;

  StreamController<String> _fevTumbnailListStreamController =
      StreamController<String>.broadcast();
  StreamSink<String> get fevTumbnailListStreamSink =>
      _fevTumbnailListStreamController.sink;
  Stream<String> get fevTumbnailListStream =>
      _fevTumbnailListStreamController.stream;

  void fevouritesVideoList() async {
    favouritesList = List<Videos>();
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.favouritesList}');
    if (mapResponse['code'] == 200) {
      List<dynamic> dynamicList =
          mapResponse['content']['videos'] as List<dynamic>;
      dynamicList
          .map((i) => favouritesList.add(Videos.fromJSONVideos(i)))
          .toList();
      favouritesListStreamSink.add(favouritesList);
      totalCountFevListStreamSink
          .add(mapResponse['content']['totalCount'].toString());
      fevTumbnailListStreamSink
          .add(mapResponse['content']['videos'][0]['thumbnail']);
    }
  }

  void removelike(String markedMailId) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['videoIds'] = [markedMailId];
    mapBody['type'] = "watch-later";
    _listConnect
        .sendMailPost(mapBody, ListConnect.watchRemove)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  Future favouritesAction(String id, String action) async {
    await _listConnect
        .sendMailGetWithHeaders(
            '${ListConnect.favouritesActionVideoId}$id&type=$action')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        fevouritesVideoList();
      }
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
    _favouritesListStreamController.close();
    _totalCountFevListStreamController.close();
    _fevTumbnailListStreamController.close();

  }
}
