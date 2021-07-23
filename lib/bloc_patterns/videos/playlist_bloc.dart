import 'dart:async';
import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';
import 'package:video/network/mesbro_connect.dart';

class PlayListBloc {
  MerbroConnectVideo _merbroConnectVideo = MerbroConnectVideo();
  ListConnect _listConnect = ListConnect();
  List<Videos> relatedVideoList = List<Videos>();
  List<Videos> videosList = List<Videos>();

  List<Videos> nastedCommentVideo = List<Videos>();

  int lastTimeStamp, viewsVideos, dislikes, likes, subscribersofChannel;
  String titleVideos,
      idVideos,
      linkAddressVideos,
      name,
      subscribers,
      url,
      channelId,
      coverPicture;
  bool watchLaterVideos,
      favouriteStatusVideos,
      likeStatusVideos,
      unlikeStatusVideos,
      viewLaterVideos,
      subscriptionStatusVideos;

  StreamController<String> _titleStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get titleStreamSink => _titleStreamController.sink;

  Stream<String> get titleStream => _titleStreamController.stream;

  StreamController<String> _viewsStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get viewsStreamSink => _viewsStreamController.sink;

  Stream<String> get viewsStream => _viewsStreamController.stream;

  StreamController<String> _idStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get idStreamSink => _idStreamController.sink;

  Stream<String> get idStream => _idStreamController.stream;

  StreamController<String> _linkAddressStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get linkAddressStreamSink =>
      _linkAddressStreamController.sink;

  Stream<String> get linkAddressStream => _linkAddressStreamController.stream;

  StreamController<String> _likesStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get likesStreamSink => _likesStreamController.sink;

  Stream<String> get likesStream => _likesStreamController.stream;

  StreamController<String> _dislikesStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get dislikesStreamSink => _dislikesStreamController.sink;

  Stream<String> get dislikesStream => _dislikesStreamController.stream;

  // related video list in video
  StreamController<List<Videos>> _relatedVideoListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get relatedVideoListStreamSink =>
      _relatedVideoListStreamController.sink;

  Stream<List<Videos>> get relatedVideoListStream =>
      _relatedVideoListStreamController.stream;

  // Comment List on Video
  StreamController<List<Videos>> _commentListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get commentListStreamSink =>
      _commentListStreamController.sink;

  Stream<List<Videos>> get commentListStream =>
      _commentListStreamController.stream;

//nasted Comment List
  StreamController<List<Videos>> _nastedcommentListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get nastedcommentListStreamSink =>
      _nastedcommentListStreamController.sink;

  Stream<List<Videos>> get nastedcommentListStream =>
      _nastedcommentListStreamController.stream;

  //channel details from video
  StreamController<String> _nameStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get nameStreamSink => _nameStreamController.sink;

  Stream<String> get nameStream => _nameStreamController.stream;

  StreamController<String> _channelIdStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get channelIdStreamSink => _channelIdStreamController.sink;

  Stream<String> get channelIdStream => _channelIdStreamController.stream;

  StreamController<String> _subscribersofChannelStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get subscribersofChannelStreamSink =>
      _subscribersofChannelStreamController.sink;

  Stream<String> get subscribersofChannelStream =>
      _subscribersofChannelStreamController.stream;

  StreamController<String> _coverPictureStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get coverPictureStreamSink =>
      _coverPictureStreamController.sink;

  Stream<String> get coverPictureStream => _coverPictureStreamController.stream;

  //buttons bool values

  StreamController<bool> _watchLaterStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get watchLaterStreamSink => _watchLaterStreamController.sink;

  Stream<bool> get watchLaterStream => _watchLaterStreamController.stream;

  StreamController<bool> _favouriteStatusStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get favouriteStatusStreamSink =>
      _favouriteStatusStreamController.sink;

  Stream<bool> get favouriteStatusStream =>
      _favouriteStatusStreamController.stream;

  StreamController<bool> _likeStatusStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get likeStatusStreamSink => _likeStatusStreamController.sink;

  Stream<bool> get likeStatusStream => _likeStatusStreamController.stream;

  StreamController<bool> _unlikeStatusStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get unlikeStatusStreamSink =>
      _unlikeStatusStreamController.sink;

  Stream<bool> get unlikeStatusStream => _unlikeStatusStreamController.stream;

  StreamController<bool> _viewLaterStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get viewLaterStreamSink => _viewLaterStreamController.sink;

  Stream<bool> get viewLaterStream => _viewLaterStreamController.stream;

  StreamController<bool> _subscriptionStatusStreamController =
      StreamController<bool>.broadcast();

  StreamSink<bool> get subscriptionStatusStreamSink =>
      _subscriptionStatusStreamController.sink;

  Stream<bool> get subscriptionStatusStream =>
      _subscriptionStatusStreamController.stream;

//----------------------profil Details-------------------------->
  StreamSink<Map<String, dynamic>> get profileDetailsStreamSink =>
      _profileDetailsStreamController.sink;

  final StreamController<Map<String, dynamic>> _profileDetailsStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get profileDetailsStream =>
      _profileDetailsStreamController.stream;
//----------------------End--------------------------------->>

//---------------------Single Details------------------------->>

  final StreamController<Map<String, dynamic>>
      _profileDetailsDataStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  StreamSink<Map<String, dynamic>> get profileDetailsDataStreamSink =>
      _profileDetailsDataStreamController.sink;

  Stream<Map<String, dynamic>> get profileDetailsDataStream =>
      _profileDetailsDataStreamController.stream;

//------------------------PlayList ListVIew--------------------------->
  StreamController<List<Videos>> _playLIstVideosStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get playLIstVideosStreamSink =>
      _playLIstVideosStreamController.sink;

  Stream<List<Videos>> get playLIstVideosStream =>
      _playLIstVideosStreamController.stream;

  Future getPlayListVideos(dynamic _jsonMap) async {
    videosList = List<Videos>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['filters'] = _jsonMap;
    mapBody['page'] = '0';
    mapBody['query'] = "";
    _listConnect
        .sendMailPost(mapBody, ListConnect.listSearch)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList
            .map((i) => videosList.add(Videos.fromJSONplayListVideos(i)))
            .toList();
        playLIstVideosStreamSink.add(videosList);
        if (videosList.isNotEmpty) {}
      }
    });
  }
//----------------------------------End------------------------>

//----------------------Play List ------------------------------->

  Future getVideoDetails(String id, String userId) async {
    print("$id-----------------$userId");

    await _listConnect
        .sendMailGet('${ListConnect.getvideodetail}$userId&userId=$id')
        .then((Map<String, dynamic> mapResponse) {
      print(mapResponse);
      if (mapResponse['code'] == 200) {
        titleStreamSink.add(mapResponse['content']['title']);

        idVideos = mapResponse['content']['id'];
        idStreamSink.add(idVideos);

        viewsVideos = mapResponse['content']['totalPlays'];
        viewsStreamSink.add(viewsVideos.toString());

        likes = mapResponse['content']['likes'];
        likesStreamSink.add(likes.toString());

        dislikes = mapResponse['content']['dislikes'];
        dislikesStreamSink.add(dislikes.toString());

        //channel details
        name = mapResponse['content']['channel']['name'];
        nameStreamSink.add(name);

        channelId = mapResponse['content']['channel']['id'];
        channelIdStreamSink.add(channelId);

        subscribersofChannel = mapResponse['content']['channel']['subscribers'];
        subscribersofChannelStreamSink.add(subscribersofChannel.toString());

        coverPicture = mapResponse['content']['channel']['logo'];
        coverPictureStreamSink.add(coverPicture);

        //button on video_page
        watchLaterVideos = mapResponse['content']['watchLater'];
        watchLaterStreamSink.add(watchLaterVideos);

        favouriteStatusVideos = mapResponse['content']['favouriteStatus'];
        favouriteStatusStreamSink.add(favouriteStatusVideos);

        likeStatusVideos = mapResponse['content']['likeStatus'];
        likeStatusStreamSink.add(likeStatusVideos);

        unlikeStatusVideos = mapResponse['content']['unlikeStatus'];
        unlikeStatusStreamSink.add(unlikeStatusVideos);

        viewLaterVideos = mapResponse['content']['viewLater'];
        viewLaterStreamSink.add(viewLaterVideos);

        subscriptionStatusVideos = mapResponse['content']['subscriptionStatus'];
        subscriptionStatusStreamSink.add(subscriptionStatusVideos);
      }
    });
  }

  //-------------------------------End---------------------------------------------->

//--------------------------Watch Later Details--------------------->

//----------------------------End---------------------------------->

// -----------------channel person details ------------------>

//--------------------------End------------------------------------>

  void dispose() {
    _playLIstVideosStreamController.close();
  }
}
