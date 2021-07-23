import 'dart:async';

import 'package:video/models/videos.dart';
import 'package:video/network/action_connect.dart';
import 'package:video/network/list_connect.dart';

class VideoBloc {
  ListConnect _listConnect = ListConnect();
  ActionConnect _actionConnect = ActionConnect();
  List<Videos> relatedVideoList = List<Videos>();
  List<Videos> channelDetails = List<Videos>();

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

//-------------------------End---------------------------------->>

//----------------------nastedArticle-------------------------------->>
  StreamController<Map<String, dynamic>>
      _nastedCommentFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSink<Map<String, dynamic>> get nastedCommentFinishedStreamSink =>
      _nastedCommentFinishedStreamController.sink;
  Stream<Map<String, dynamic>> get nastedCommentFinishedStream =>
      _nastedCommentFinishedStreamController.stream;
//-------------------------End---------------------------------------->>

  Future getVideoDetails(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.getvideodetail}$id')
        .then((Map<String, dynamic> mapResponse) {
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

  Future getVideoLink(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.getVideoUrl}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        linkAddressStreamSink.add(mapResponse['content']['streamLink']);
      }
    });
  }

  Future getchannelVideoDetails(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.getvideodetail}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        idVideos = mapResponse['content']['id'];
        channelId = mapResponse['content']['channel']['id'];
        _listConnect
            .sendMailGet('${ListConnect.channelGetDetails}$channelId')
            .then((Map<String, dynamic> mapResponse) {
          if (mapResponse['code'] == 200) {
            Map<String, dynamic> userMap = mapResponse['content'];
            profileDetailsDataStreamSink.add(userMap);
          }
        });
      }
    });
  }

  Future getRelatedVideo(String id) async {
    await _listConnect
        .sendMailGet('${ListConnect.getRelateVideo}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList
            .map((i) => relatedVideoList.add(Videos.fromJSONVideos(i)))
            .toList();
        relatedVideoListStreamSink.add(relatedVideoList);
      }
    });
  }

  Future getChannelDetails(String id, String userId) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.videoDetails}$id&userId=$userId')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  //-----------------Streaming Url---------------------->

  // Future getVideoUrl(String id) async {
  //   await _listConnect
  //       .sendMailGet('${ListConnect.getVideoUrl}$id')
  //       .then((Map<String, dynamic> mapResponse) {
  //     if (mapResponse['code'] == 200) {
  //       url = mapResponse['content']['streamLink'];
  //       linkAddressStreamSink.add(url);
  //     }
  //   });
  // }

//--------------------End Streaming url------------------->

//--------------------watch later in Video_page-------------------->

  Future addWatchLater(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.addwatchLaterVideo}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  void watchLaterMarkRemove(String videoId) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['videoIds'] = [videoId];
    mapBody['type'] = "watch-later";
    _listConnect
        .sendMailPost(mapBody, ListConnect.watchRemoveVideo)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        return;
      }
    });
  }
//-----------------------------End-------------------------------------->

//--------------------Fev add and remove action --------------------->
  Future favouritesAction(String id, String action) async {
    await _listConnect
        .sendMailGetWithHeaders(
            '${ListConnect.favouritesActionVideoId}$id&type=$action')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }
  //------------------------End fev-------------------------------->

//------------------Like & dislike toggel --------------------->
  Future likeVideo(String id, String action) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.likeVideo}$id&type=$action')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        // getVideoDetails(id);
      }
    });
  }

  void dislikeVideo(String videoId, String action) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['videoIds'] = [videoId];
    mapBody['type'] = "$action";
    _listConnect
        .sendMailPost(mapBody, ListConnect.dislikeVideo)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        // getVideoDetails(videoId);
      }
    });
  }

//----------------------------End--------------------------------prin---->

// --------------------video Subscribe & Unsubscrbe------------------->
  Future subscribeAndUnsubscribe(
      String subStatus, String videoId, String id) async {
    await _listConnect
        .sendMailGetWithHeaders(
            '${ListConnect.channelSubAndUnsub}$subStatus?id=$videoId')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        Future.delayed(Duration.zero, () {
          getVideoDetails(id);
        });
      }
    });
  }
// -----------------------------End---------------------------------->

//-------------------------Comment video-------------------------->
  void commentVideo(String id, String comment) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['comment'] = comment;
    mapBody['parentId'] = id;
    _actionConnect
        .sendActionPost(mapBody, ActionConnect.commentsAdd)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }
//----------------------------End------------------------------->

//---------------------------Add CommentNasted------------------>
  void addNastedComment(
      String parentId, String commentid, String comment) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['parentId'] = commentid;
    mapBody['commentId'] = parentId;
    mapBody['reply'] = comment;
    _actionConnect
        .sendActionPost(mapBody, ActionConnect.commentsReplyAdd)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        nastedCommentFinishedStreamSink.add(mapResponse);
      }
    });
  }
//------------------------------End----------------------------->

// -------------------------- Delete nasted Comment---------------------->
  void deleteNastedComment(
      String parentId, String commentid, String replyId) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['parentId'] = commentid;
    mapBody['commentId'] = parentId;
    mapBody['replyId'] = replyId;
    print(commentid);
    print("~~~~~~~~~~~parantId~~~~~~~~~~~~~~~~~~~");
    print(parentId);
    print("~~~~~~~~~~replyId~~~~~~~~~~~~~~~~~~~~");
    print(replyId);
    // mapBody['reply'] = comment;
    _actionConnect
        .sendActionPost(mapBody, ActionConnect.commentsReplyDelete)
        .then((Map<String, dynamic> mapResponse) {
      print(mapResponse);
      if (mapResponse['code'] == 200) {
        // nastedCommentFinishedStreamSink.add(mapResponse);
        print(mapResponse);
      }
    });
  }
  //-------------------------End--------------------------------------------->

//--------------------------Comment List----------------------------->
  Future getCommentList(String id) async {
    await _actionConnect
        .sendActionGet('${ActionConnect.commentsGetList}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;
        dynamicList
            .map((i) => relatedVideoList.add(Videos.fromCommentList(i)))
            .toList();
        commentListStreamSink.add(relatedVideoList);
      }
    });
  }
  //----------------------------End----------------------------------->

  //---------------------------Nested Comment List--------------------->
  Future getNastedCommentList(String id) async {
    await _actionConnect
        .sendActionGet('${ActionConnect.nestedcommentsGetList}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> natedCommentList =
            mapResponse['content'] as List<dynamic>;
        natedCommentList
            .map((i) => nastedCommentVideo.add(Videos.fromNastedCommentList(i)))
            .toList();
        nastedcommentListStreamSink.add(nastedCommentVideo);
      }
    });
  }

  //-------------------------------End---------------------------------->

  Future deleteComment(String parantId, String commentId) async {
    await _actionConnect
        .sendActionGetWithHeaders(
            '${ActionConnect.deleteComment}$parantId&commentId=$commentId')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {}
    });
  }

  dispose() {
    _titleStreamController.close();
    _viewsStreamController.close();
    _idStreamController.close();
    _linkAddressStreamController.close();
    _likesStreamController.close();
    _dislikesStreamController.close();
    _relatedVideoListStreamController.close();
    _coverPictureStreamController.close();
    _subscribersofChannelStreamController.close();
    _nameStreamController.close();
    _watchLaterStreamController.close();
    _favouriteStatusStreamController.close();
    _likeStatusStreamController.close();
    _unlikeStatusStreamController.close();
    _viewLaterStreamController.close();
    _subscriptionStatusStreamController.close();
    _channelIdStreamController..close();
    _commentListStreamController.close();
    _profileDetailsStreamController.close();
    _profileDetailsDataStreamController.close();
    _nastedcommentListStreamController.close();
    _nastedCommentFinishedStreamController.close();
    dispose();
  }
}
