import 'dart:async';

import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';

class MyVideoBloc {
  ListConnect _listConnect = ListConnect();
  List<Videos> myVideoList = List<Videos>();
  StreamController<List<Videos>> _myVideoListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get myVideoListStreamSink =>
      _myVideoListStreamController.sink;

  Stream<List<Videos>> get myVideoListStream =>
      _myVideoListStreamController.stream;

  void getReceivedMessages() async {
    myVideoList = List<Videos>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['filters'] = {};
    _listConnect
        .sendMailPostWithHeaders(mapBody, ListConnect.myVideos)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;

        dynamicList
            .map((i) => myVideoList.add(Videos.fromJSONVideos(i)))
            .toList();
        // videosList.sort((a, b) => b.date.compareTo(a.date));
        myVideoListStreamSink.add(myVideoList);
        if (myVideoList.isNotEmpty) {}
      }
    });
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

  void dispose() {
    _myVideoListStreamController.close();
  }
}
