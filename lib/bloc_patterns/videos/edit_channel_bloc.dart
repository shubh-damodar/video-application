import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:video/models/taglist.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/file_connect.dart';
import 'package:video/network/list_connect.dart';
import 'package:flutter/material.dart';
import 'package:video/validators/register_validators.dart';

class EditChannelBloc with RegisterValidators {
  BuildContext buildContext;
  ListConnect _listConnect = ListConnect();

  List<String> appelationList = ['Mr', 'Mrs', 'Miss', 'Mx'];

  List<Videos> relatedVideosList = List<Videos>();
  FileConnect _fileConnect = FileConnect();
  List<dynamic> tagsList = List<dynamic>();

  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;

  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  //-----------------------Edit Page Video----------------------------->>

  StreamController<String> _nameStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get nameStreamSink => _nameStreamController.sink;

  Stream<String> get nameStream => _nameStreamController.stream;

  // StreamController<String> _categoryStreamController =
  //     StreamController<String>.broadcast();

  // StreamSink<String> get categoryStreamSink => _categoryStreamController.sink;

  // Stream<String> get categoryStream => _categoryStreamController.stream;

  StreamController<String> _emailStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get emailStreamSink => _emailStreamController.sink;

  Stream<String> get emailStream => _emailStreamController.stream;

  StreamController<String> _tagsStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get tagsStreamSink => _tagsStreamController.sink;

  Stream<String> get tagsStream => _tagsStreamController.stream;

  StreamController<String> _mobileStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get mobileStreamSink => _mobileStreamController.sink;

  Stream<String> get mobileStream => _mobileStreamController.stream;

  StreamController<String> _countryStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get countryStreamSink => _countryStreamController.sink;

  Stream<String> get countryStream => _countryStreamController.stream;

  StreamController<String> _descriptionStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get descriptionStreamSink =>
      _descriptionStreamController.sink;

  Stream<String> get descriptionStream => _descriptionStreamController.stream;

  StreamController<String> _facebookStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get facebookStreamSink => _facebookStreamController.sink;

  Stream<String> get facebookStream => _facebookStreamController.stream;

  StreamController<String> _instagramStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get instagramStreamSink => _instagramStreamController.sink;

  Stream<String> get instagramStream => _instagramStreamController.stream;

  StreamController<String> _twitterStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get twitterStreamSink => _twitterStreamController.sink;

  Stream<String> get twitterStream => _twitterStreamController.stream;

  StreamController<String> _linkDinStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get linkDinStreamSink => _linkDinStreamController.sink;

  Stream<String> get linkDinStream => _linkDinStreamController.stream;

  StreamController<String> _youTubeStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get youTubeStreamSink => _youTubeStreamController.sink;

  Stream<String> get youTubeStream => _youTubeStreamController.stream;

  StreamController<String> _webSiteStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get webSiteStreamSink => _webSiteStreamController.sink;

  Stream<String> get webSiteStream => _webSiteStreamController.stream;

  StreamController<String> _logoStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get logoStreamSink => _logoStreamController.sink;

  Stream<String> get logoStream => _logoStreamController.stream;

  StreamController<String> _coverPictureStreamController =
      StreamController<String>.broadcast();

  StreamSink<String> get coverPictureStreamSink =>
      _coverPictureStreamController.sink;

  Stream<String> get coverPictureStream => _coverPictureStreamController.stream;

  StreamController<List<dynamic>> _listVideoTagsStreamController =
      StreamController<List<dynamic>>.broadcast();

  StreamSink<List<dynamic>> get listVideoTagsStreamSink =>
      _listVideoTagsStreamController.sink;

  Stream<List<dynamic>> get listVideoTagsStream =>
      _listVideoTagsStreamController.stream;

  //-----------------------End----------------------------->>

  //------------------------ Logo Images--------------------------->>
  final BehaviorSubject<String> _logoChannelBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get logoChannelStreamSink =>
      _logoChannelBehaviorSubject.sink;

  Stream<String> get logoChannelStream => _logoChannelBehaviorSubject.stream;
  //------------------------End----------------------------------->>

  //--------------------------Cover Picture----------------------->>
  final BehaviorSubject<String> _coverChannelBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get coverChannelStreamSink =>
      _coverChannelBehaviorSubject.sink;

  Stream<String> get coverChannelStream => _coverChannelBehaviorSubject.stream;
  //-----------------------------End------------------------------->>

//-----------------------------Catogary Drop Down ------------------------>

  final BehaviorSubject<String> _categoryBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get categoryStreamSink => _categoryBehaviorSubject.sink;

  Stream<String> get categoryStream =>
      _categoryBehaviorSubject.stream.transform(categoryStreamTransformer);

  // Stream<bool> get editCheckStream => Observable.combineLatest3(
  //     contentPolicyStream,
  //     privacyPolicyStream,
  //     categoryStream,
  //     (contentPolicy, privacyPolicy, category) => true);
//---------------------------------End----------------------------------->

  void takelogo(img, String id) async {
    File fileImage = img;
    String filePath = fileImage.path, fileName, fileExtension;
    fileName = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    fileExtension = filePath.substring(filePath.lastIndexOf('.') + 1);
    Map<String, dynamic> mapResponseGetDownloadUrl,
        mapResponseConfirm,
        updateMapResponse;
    mapResponseGetDownloadUrl = await _fileConnect.sendFileGet(
        '${FileConnect.uploadFileGetDownloadUrl}?type=image&fileName=$fileName.$fileExtension&fileType=image/$fileExtension');

    int statusCode = await _fileConnect.uploadFile(
        mapResponseGetDownloadUrl['content']['signedUrl'],
        'image/$fileExtension',
        filePath);

    mapResponseConfirm = await _fileConnect.sendFileGet(
        '${FileConnect.uploadConfirmUploadToken}${mapResponseGetDownloadUrl['content']['uploadToken']}');

    logoStreamSink.add('${mapResponseConfirm['content']['accessUrl']}');

    logoChannelStreamSink.add(mapResponseConfirm['content']['accessUrl']);

    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['id'] = "$id";
    mapBody['logo'] = "${mapResponseConfirm['content']['accessUrl']}";
    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailPost(mapBody, ListConnect.channelUpdate);
  }

  void takecoverPicture(img, String id) async {
    File fileImage = img;
    String filePath = fileImage.path, fileName, fileExtension;
    fileName = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    fileExtension = filePath.substring(filePath.lastIndexOf('.') + 1);
    Map<String, dynamic> mapResponseGetDownloadUrl,
        mapResponseConfirm,
        updateMapResponse;
    mapResponseGetDownloadUrl = await _fileConnect.sendFileGet(
        '${FileConnect.uploadFileGetDownloadUrl}?type=image&fileName=$fileName.$fileExtension&fileType=image/$fileExtension');

    int statusCode = await _fileConnect.uploadFile(
        mapResponseGetDownloadUrl['content']['signedUrl'],
        'image/$fileExtension',
        filePath);

    mapResponseConfirm = await _fileConnect.sendFileGet(
        '${FileConnect.uploadConfirmUploadToken}${mapResponseGetDownloadUrl['content']['uploadToken']}');

    coverPictureStreamSink.add('${mapResponseConfirm['content']['accessUrl']}');

    logoChannelStreamSink.add(mapResponseConfirm['content']['accessUrl']);

    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['id'] = "$id";
    mapBody['coverPicture'] = "${mapResponseConfirm['content']['accessUrl']}";
    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailPost(mapBody, ListConnect.channelUpdate);
  }

  Future getChannelDetails(String id) async {
    relatedVideosList = List<Videos>();
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.channelGetDetails}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        nameStreamSink.add(mapResponse['content']['name']);

        descriptionStreamSink.add(mapResponse['content']['description']);

        emailStreamSink.add(mapResponse['content']['email']);

        mobileStreamSink.add(mapResponse['content']['mobile']);

        categoryStreamSink.add(mapResponse['content']['category']);

        countryStreamSink.add(mapResponse['content']['country']);

        facebookStreamSink
            .add(mapResponse['content']['socialMediaLinks']['facebook']);

        instagramStreamSink
            .add(mapResponse['content']['socialMediaLinks']['instagram']);

        linkDinStreamSink
            .add(mapResponse['content']['socialMediaLinks']['linkedin']);

        twitterStreamSink
            .add(mapResponse['content']['socialMediaLinks']['twitter']);

        youTubeStreamSink
            .add(mapResponse['content']['socialMediaLinks']['youtube']);

        webSiteStreamSink.add(mapResponse['content']['website']);

        logoStreamSink.add(mapResponse['content']['logo']);

        coverPictureStreamSink.add(mapResponse['content']['coverPicture']);

        //---------------------------Tags----------------------------->
        List<dynamic> tagsList =
            mapResponse['content']['tags'] as List<dynamic>;
        // VideosTags tags = new VideosTags.fromJson(dynamicList);
        listVideoTagsStreamSink.add(tagsList);
        //----------------------------End--------------------------------->

      }
    });
  }

  void sendEditedArticale(
    // String tags,
    String name,
    String description,
    String email,
    String mobile,
    String country,
    String facebook,
    String instagram,
    String twitter,
    String linkedin,
    String youtube,
    String website,
    String category,
    String id,
  ) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['id'] = "$id";
    mapBody['category'] = _categoryBehaviorSubject.value;
    mapBody['country'] = "$country";
    mapBody['description'] = "$description";
    mapBody['email'] = "$email";
    mapBody['mobile'] = "$mobile";
    mapBody['name'] = "$name";
    mapBody["socialMediaLinks"] = {
      "facebook": "$facebook",
      "instagram": "$instagram",
      "linkedin": "$linkedin",
      "twitter": "$twitter",
      "youtube": "$youtube",
    };

    // List<dynamic> _editedTagList;
    // _editedTagList.add(tagsList);
    // print("---------bloc----------$tagsList");
    // print("---------bloc---------$_editedTagList");

    mapBody['tags'] = ["null"];
    mapBody['website'] = "$website";
    mapBody['setAsDefault'] = false;
    // mapBody['logo'] = _logoChannelBehaviorSubject.value;

    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailPost(mapBody, ListConnect.channelUpdate);
    composeFinishedStreamSink.add(mapResponse);
  }

  Future deletChannel(String id) async {
    Map<String, dynamic> mapResponse = await _listConnect
        .sendMailGetWithHeaders('${ListConnect.deleteChannel}$id');
    composeFinishedStreamSink.add(mapResponse);
  }

  void dispose() {
    _composeFinishedStreamController.close();
    _nameStreamController.close();
    _emailStreamController.close();
    _tagsStreamController.close();
    _mobileStreamController.close();
    _countryStreamController.close();
    _facebookStreamController.close();
    _instagramStreamController.close();
    _descriptionStreamController.close();
    _twitterStreamController.close();
    _linkDinStreamController.close();
    _youTubeStreamController.close();
    _webSiteStreamController.close();
    _logoStreamController.close();
    _coverPictureStreamController.close();
    _listVideoTagsStreamController.close();
    _logoChannelBehaviorSubject.close();
    _coverChannelBehaviorSubject.close();
    _categoryBehaviorSubject.close();
  }
}
