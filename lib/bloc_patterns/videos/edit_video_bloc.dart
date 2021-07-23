import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/file_connect.dart';
import 'package:video/network/list_connect.dart';
import 'package:flutter/material.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/validators/edit_profile_validators.dart';
import 'package:video/validators/register_validators.dart';

class EditVideosBloc with RegisterValidators, EditProfileValidators {
  BuildContext buildContext;
  ListConnect _listConnect = ListConnect();

  List<Videos> relatedVideosList = List<Videos>();
  FileConnect _fileConnect = FileConnect();

  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;

  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  //-----------------------Edit Page Video----------------------------->>

  StreamController<String> _titleStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get titleStreamSink => _titleStreamController.sink;

  Stream<String> get titleStream => _titleStreamController.stream;

  StreamController<String> _descriptionStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get descriptionStreamSink =>
      _descriptionStreamController.sink;

  Stream<String> get descriptionStream => _descriptionStreamController.stream;

  StreamController<String> _tagsStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get tagsStreamSink => _tagsStreamController.sink;

  Stream<String> get tagsStream => _tagsStreamController.stream;

  StreamController<String> _thumbnailStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get thumbnailStreamSink => _thumbnailStreamController.sink;

  Stream<String> get thumbnailStream => _thumbnailStreamController.stream;

  StreamController<String> _nameChannelStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get nameChannelStreamSink =>
      _nameChannelStreamController.sink;

  Stream<String> get nameChannelStream => _nameChannelStreamController.stream;

  StreamController<List<dynamic>> _listVideoTagsStreamController =
      StreamController<List<dynamic>>.broadcast();

  StreamSink<List<dynamic>> get listVideoTagsStreamSink =>
      _listVideoTagsStreamController.sink;

  Stream<List<dynamic>> get listVideoTagsStream =>
      _listVideoTagsStreamController.stream;

  StreamController<String> _linkAddressStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get linkAddressStreamSink =>
      _linkAddressStreamController.sink;

  Stream<String> get linkAddressStream => _linkAddressStreamController.stream;

  final BehaviorSubject<String> _contentPolicyBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get contentPolicyStreamSink =>
      _contentPolicyBehaviorSubject.sink;

  Stream<String> get contentPolicyStream => _contentPolicyBehaviorSubject.stream
      .transform(contentPolicyStreamTransformer);

  final BehaviorSubject<String> _privacyPolicyBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get privacyPolicyStreamSink =>
      _privacyPolicyBehaviorSubject.sink;

  Stream<String> get privacyPolicyStream => _privacyPolicyBehaviorSubject.stream
      .transform(privacyPolicyStreamTransformer);

  final BehaviorSubject<String> _categoryBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get categoryStreamSink => _categoryBehaviorSubject.sink;

  Stream<String> get categoryStream =>
      _categoryBehaviorSubject.stream.transform(categoryStreamTransformer);

  Stream<bool> get editCheckStream => Observable.combineLatest3(
      contentPolicyStream,
      privacyPolicyStream,
      categoryStream,
      (contentPolicy, privacyPolicy, category) => true);


//----------------------- article--------------------->
  final BehaviorSubject<String> _articleImageAccessUrlBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get articleImageAccessUrlStreamSink =>
      _articleImageAccessUrlBehaviorSubject.sink;

  Stream<String> get articleImageAccessUrlStream =>
      _articleImageAccessUrlBehaviorSubject.stream;
//-------------
  StreamSink<String> get articleImageStreamSink =>
      _articleImageStreamController.sink;
  StreamController<String> _articleImageStreamController =
      StreamController<String>.broadcast();
  Stream<String> get articleImageStream => _articleImageStreamController.stream;

//------------------------- End ------------------------->

  void takePicture(img) async {
    File fileImage = img;
    String filePath = fileImage.path, fileName, fileExtension;
    fileName = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    fileExtension = filePath.substring(filePath.lastIndexOf('.') + 1);
    Map<String, dynamic> mapResponseGetDownloadUrl,
        mapResponseConfirm,
        updateMapResponse;
    mapResponseGetDownloadUrl = await _fileConnect.sendFileGet(
        '${FileConnect.uploadFileGetDownloadUrl}?type=general&fileName=$fileName&fileType=image/$fileExtension');

    int statusCode = await _fileConnect.uploadFile(
        mapResponseGetDownloadUrl['content']['signedUrl'],
        'image/$fileExtension',
        filePath);

    mapResponseConfirm = await _fileConnect.sendFileGet(
        '${FileConnect.uploadConfirmUploadToken}${mapResponseGetDownloadUrl['content']['uploadToken']}');

    articleImageStreamSink.add(
        '${Connect.filesUrl}${mapResponseConfirm['content']['accessUrl']}');

    articleImageAccessUrlStreamSink
        .add(mapResponseConfirm['content']['accessUrl']);
  }

  Future getVideoDetails(String userId, String id) async {
    await _listConnect
        .sendMailGet('${ListConnect.getvideodetail}$id&userId=$userId')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        titleStreamSink.add(mapResponse['content']['title']);
        nameChannelStreamSink.add(mapResponse['content']['channel']['name']);
        descriptionStreamSink.add(mapResponse['content']['description']);
        List<dynamic> tagsList =
            mapResponse['content']['tags'] as List<dynamic>;
        listVideoTagsStreamSink.add(tagsList);

        //-----------------------------tumbnail---------------------------->
        String image = mapResponse['content']['thumbnail'];
        thumbnailStreamSink.add(image);
        articleImageAccessUrlStreamSink.add(image);
        //-------------------------------End--------------------------->


        contentPolicyStreamSink.add(mapResponse['content']['contentPolicy']);

        privacyPolicyStreamSink
            .add(mapResponse['content']['privacy'].toString());

        // //---------------------------Tags----------------------------->
        // final dynamicList = mapResponse['content'];
        // VideosTags tags = new VideosTags.fromJson(dynamicList);
        // listVideoTagsStreamSink.add(tags.tags);
        // //----------------------------End--------------------------------->

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

  Future deleteVideo(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.deleteVideo}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        composeFinishedStreamSink.add(mapResponse);
        print("object");
      }
    });
  }

  void sendEditedArticale(
      String channelId,
      String description,
      String id,
      // String tags,
      String title) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['channelId'] = '$channelId';
    mapBody['contentPolicy'] = _contentPolicyBehaviorSubject.value;
    mapBody['description'] = '$description';
    mapBody['id'] = '$id';
    mapBody['privacy'] = _privacyPolicyBehaviorSubject.value;
    mapBody['tags'] = ['null'];
    mapBody['thumbnail'] = _articleImageAccessUrlBehaviorSubject.value;
    mapBody['title'] = '$title';
    // mapBody['logo'] = _logoChannelBehaviorSubject.value;

    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailPost(mapBody, ListConnect.videoUpdate);
    composeFinishedStreamSink.add(mapResponse);
  }

  Future deletChannel(String id) async {
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.deleteChannel}$id');
    composeFinishedStreamSink.add(mapResponse);
  }

  void dispose() {
    _composeFinishedStreamController.close();
    _titleStreamController.close();
    _nameChannelStreamController.close();
    _descriptionStreamController.close();
    _listVideoTagsStreamController.close();
    _categoryBehaviorSubject.close();
    _tagsStreamController.close();
    _thumbnailStreamController.close();
    _linkAddressStreamController.close();
    _privacyPolicyBehaviorSubject.close();
    _contentPolicyBehaviorSubject.close();
  }
}
