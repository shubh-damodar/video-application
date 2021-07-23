import 'dart:async';
import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';

class CreateChannelBloc {
  int indexattachment;
  ListConnect _listConnect = ListConnect();
  List<Videos> relatedVideoList = List<Videos>();

  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;

  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  Future sendBodyMessage(
    String name,
    String description,
  ) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['name'] = name;
    mapBody['description'] = description;
    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailPost(mapBody, ListConnect.addChannelList);
    composeFinishedStreamSink.add(mapResponse);
  }

  void dispose() {
    _composeFinishedStreamController.close();
  }
}
