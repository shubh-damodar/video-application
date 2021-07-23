import 'dart:async';
import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';
import 'package:video/network/mesbro_connect.dart';

class LibraryBloc {
  MerbroConnectVideo _merbroConnectVideo = MerbroConnectVideo();
  ListConnect _listConnect = ListConnect();
  List<Videos> relatedVideoList = List<Videos>();

  final StreamController<String> _videoLibProfileImageStreamController =
          StreamController<String>.broadcast(),
      _mailAdressStreamController = StreamController<String>.broadcast(),
      _nameStreamController = StreamController<String>.broadcast();

  StreamSink<String> get videoLibProfileImageStreamSink =>
      _videoLibProfileImageStreamController.sink;

  StreamSink<String> get mailAdressStreamSink =>
      _mailAdressStreamController.sink;

  StreamSink<String> get nameStreamSink => _nameStreamController.sink;

  Stream<String> get nameStream => _nameStreamController.stream;

  Stream<String> get videoLibProfileImageStream =>
      _videoLibProfileImageStreamController.stream;

  Stream<String> get mailAdressStream => _mailAdressStreamController.stream;

  StreamController<List<Videos>> _channelListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get channelListStreamSink =>
      _channelListStreamController.sink;

  Stream<List<Videos>> get channelListStream =>
      _channelListStreamController.stream;

// -----------------channel person details ------------------>
  Future getProfileDetails(String id) async {
    await _merbroConnectVideo
        .sendMailGet('${MerbroConnectVideo.profileGetDetailsVideo}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        videoLibProfileImageStreamSink
            .add(mapResponse['content']['personalInfo']['profileImage']);
        mailAdressStreamSink
            .add(mapResponse['content']['personalInfo']['email']);
        nameStreamSink.add(
            '${mapResponse['content']['personalInfo']['firstName']} ${mapResponse['content']['personalInfo']['lastName']}');
      }
    });
  }
//--------------------------End------------------------------------>

//----------------------channel lisst library-------------------->
  Future getChannnelList() async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.listOfChannel}')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;
        dynamicList
            .map((i) => relatedVideoList.add(Videos.fromChannelList(i)))
            .toList();
        channelListStreamSink.add(relatedVideoList);
      }
    });
  }
//-----------------------End------------------------------------->

//--------------------------Watch Later Details--------------------->

//----------------------------End---------------------------------->

  void dispose() {
    _mailAdressStreamController.close();
    _nameStreamController.close();
    _videoLibProfileImageStreamController.close();
    _channelListStreamController.close();
  }
}
