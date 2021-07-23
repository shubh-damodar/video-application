import 'dart:async';

import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';


class VideoChannelDetailsList {
  ListConnect _listConnect = ListConnect();
  List<Videos> videosList = List<Videos>();
  List<Videos> channeListList = List<Videos>();
  List<Videos> playListChannel = List<Videos>();

  int lastTimeStamp;
  StreamController<List<Videos>> _videosListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get videosListStreamSink =>
      _videosListStreamController.sink;

  Stream<List<Videos>> get videosListStream =>
      _videosListStreamController.stream;

  // -------------Details page of channel------------------------>
  StreamController<String> _logoStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get logoStreamSink => _logoStreamController.sink;

  Stream<String> get logoStream => _logoStreamController.stream;

  //---------------------------------------------------------->
  StreamController<String> _nameStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get nameStreamSink => _nameStreamController.sink;

  Stream<String> get nameStream => _nameStreamController.stream;

  //------------------------------------------------------------>
  StreamController<String> _coverPictureStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get coverPictureStreamSink =>
      _coverPictureStreamController.sink;

  Stream<String> get coverPictureStream => _coverPictureStreamController.stream;

// ----------------------End------------------------------------->

//----------------------profil Details-------------------------->
  StreamSink<Map<String, dynamic>> get profileDetailsStreamSink =>
      _profileDetailsStreamController.sink;

  final StreamController<Map<String, dynamic>> _profileDetailsStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get profileDetailsStream =>
      _profileDetailsStreamController.stream;
//----------------------End--------------------------------->>

//--------------------------Video Channel List ----------------------->
  StreamController<List<Videos>> _channeListListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get channeListListStreamSink =>
      _channeListListStreamController.sink;

  Stream<List<Videos>> get channeListListStream =>
      _channeListListStreamController.stream;
//-----------------------------End------------------------------------>

//--------------------------PlayListVideos--------------------------->

  StreamController<List<Videos>> _playListChannelStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get playListChannelStreamSink =>
      _playListChannelStreamController.sink;

  Stream<List<Videos>> get playListChannelStream =>
      _playListChannelStreamController.stream;
//----------------------------End--------------------------------------->

  void getChannelVideoList(String id) async {
    videosList = List<Videos>();
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGet('${ListConnect.channelVideoList}?channelId=$id');
    if (mapResponse['code'] == 200) {
      List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;
      dynamicList
          .map((i) => videosList.add(Videos.fromChannelVideoList(i)))
          .toList();
      videosListStreamSink.add(videosList);
    }
  }

  // void getChannelList(String userId, String videoId) async {
  //   print("$userId   $videoId");
  //   videosList = List<Videos>();
  //   Map<String, dynamic> mapResponse =
  //       await _listConnect.sendMailGetWithHeaders(
  //           '${ListConnect.getvideodetail}?channelId=$id');

  //   if (mapResponse['code'] == 200) {
  //     List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;
  //     dynamicList
  //         .map((i) => videosList.add(Videos.fromChannelVideoList(i)))
  //         .toList();
  //     videosListStreamSink.add(videosList);
  //   }
  // }

  void getchannelInfoDetails(String id) async {
    videosList = List<Videos>();
    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailGetWithHeaders(
            '${ListConnect.channelInfoDetails}?channelId=$id');
    if (mapResponse['code'] == 200) {
      logoStreamSink.add(mapResponse['content']['logo']);
      nameStreamSink.add(mapResponse['content']['name']);
      coverPictureStreamSink.add(mapResponse['content']['coverPicture']);
      Map<String, dynamic> userMap = mapResponse['content'];
      profileDetailsStreamSink.add(userMap);
    }
  }

  void getChannelListInChannel(String id) async {
    channeListList = List<Videos>();
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.channelListInChannel}$id');
    if (mapResponse['code'] == 200) {
      List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;
      dynamicList
          .map((i) => channeListList.add(Videos.fromSubscriptionList(i)))
          .toList();
      channeListListStreamSink.add(channeListList);
    }
  }


  void getPlayListChannel(String id) async {
    playListChannel = List<Videos>();
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.getPlatListChannel}$id');
    if (mapResponse['code'] == 200) {
      List<dynamic> dynamicList =
          mapResponse['content']['playlists'] as List<dynamic>;
      dynamicList
          .map((i) => playListChannel.add(Videos.playListChannel(i)))
          .toList();
      playListChannelStreamSink.add(playListChannel);
    }
  }

  void dispose() {
    _videosListStreamController.close();
    _logoStreamController.close();
    _coverPictureStreamController.close();
    _nameStreamController.close();
    _channeListListStreamController.close();
    _profileDetailsStreamController.close();
    _playListChannelStreamController.close();
  }
}
