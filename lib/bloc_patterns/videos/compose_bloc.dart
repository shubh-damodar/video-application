import 'dart:async';
import 'dart:io';
import 'package:video/models/attachment.dart';
import 'package:video/models/user.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/file_connect.dart';
import 'package:video/network/list_connect.dart';
import 'package:video/network/user_connect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';

class ComposeBloc {
  List<User> toUsersList = List<User>(),
      ccUsersList = List<User>(),
      bccUsersList = List<User>(),
      toUsersSuggestionsList = List<User>(),
      ccUsersSuggestionsList = List<User>(),
      bccUsersSuggestionsList = List<User>();
  List<Attachment> attachmentList = List<Attachment>();

  Function modifyJSFunction;
  BuildContext buildContext;
  String conversationId, type, title = '', htmlCode, draftId, previousAction;
  bool isCCBCCOpen = false,
      areToVisible = false,
      areCCVisible = false,
      areBCCVisible = false;

  int indexattachment;
  FileConnect _fileConnect = FileConnect();
  ListConnect _listConnect = ListConnect();
  List<Videos> relatedVideoList = List<Videos>();

  StreamController<List<Attachment>> _attachmentListStreamController =
      StreamController<List<Attachment>>.broadcast();

  StreamController<List<User>> _toUsersListStreamController =
          StreamController<List<User>>.broadcast(),
      _ccUsersListStreamController = StreamController<List<User>>.broadcast(),
      _bccUsersListStreamController = StreamController<List<User>>.broadcast(),
      _toUsersSuggestionsListStreamController =
          StreamController<List<User>>.broadcast(),
      _ccUsersSuggestionsListStreamController =
          StreamController<List<User>>.broadcast(),
      _bccUsersSuggestionsListStreamController =
          StreamController<List<User>>.broadcast();

  StreamController<String> _titleStreamController =
          StreamController<String>.broadcast(),
      _bodyStreamController = StreamController<String>.broadcast();
  StreamController<Map<String, dynamic>> _composeFinishedStreamController =
          StreamController<Map<String, dynamic>>.broadcast(),
      _draftSentFinishedStreamController =
          StreamController<Map<String, dynamic>>.broadcast(),
      _replyForwardFinishedStreamController =
          StreamController<Map<String, dynamic>>.broadcast();

  StreamSink<List<Attachment>> get attachmentStreamSink =>
      _attachmentListStreamController.sink;

  StreamSink<List<User>> get toUsersListStreamSink =>
      _toUsersListStreamController.sink;

  StreamSink<List<User>> get ccUsersListStreamSink =>
      _ccUsersListStreamController.sink;

  StreamSink<List<User>> get bccUsersListStreamSink =>
      _bccUsersListStreamController.sink;

  StreamSink<List<User>> get toUsersSuggestionsListStreamSink =>
      _toUsersSuggestionsListStreamController.sink;

  StreamSink<List<User>> get ccUsersSuggestionsListStreamSink =>
      _ccUsersSuggestionsListStreamController.sink;

  StreamSink<List<User>> get bccUsersSuggestionsListStreamSink =>
      _bccUsersSuggestionsListStreamController.sink;

  StreamSink<String> get titleStreamSink => _titleStreamController.sink;

  StreamSink<String> get bodyStreamSink => _bodyStreamController.sink;

  StreamSink<Map<String, dynamic>> get composeFinishedStreamSink =>
      _composeFinishedStreamController.sink;

  StreamSink<Map<String, dynamic>> get draftSentFinishedStreamSink =>
      _draftSentFinishedStreamController.sink;

  StreamSink<Map<String, dynamic>> get replyForwardFinishedStreamSink =>
      _replyForwardFinishedStreamController.sink;

  Stream<List<Attachment>> get attachmentListStream =>
      _attachmentListStreamController.stream;

  Stream<List<User>> get toUsersListStream =>
      _toUsersListStreamController.stream;

  Stream<List<User>> get ccUsersListStream =>
      _ccUsersListStreamController.stream;

  Stream<List<User>> get bccUsersListStream =>
      _bccUsersListStreamController.stream;

  Stream<List<User>> get toUsersSuggestionsListStream =>
      _toUsersSuggestionsListStreamController.stream;

  Stream<List<User>> get ccUsersSuggestionsListStream =>
      _ccUsersSuggestionsListStreamController.stream;

  Stream<List<User>> get bccUsersSuggestionsListStream =>
      _bccUsersSuggestionsListStreamController.stream;

  Stream<String> get titleStream => _titleStreamController.stream;

  Stream<String> get bodyStream => _bodyStreamController.stream;

  Stream<Map<String, dynamic>> get composeFinishedStream =>
      _composeFinishedStreamController.stream;

  Stream<Map<String, dynamic>> get draftSentFinishedStream =>
      _draftSentFinishedStreamController.stream;

  Stream<Map<String, dynamic>> get replyForwardFinishedStream =>
      _replyForwardFinishedStreamController.stream;

  StreamSink<String> get thumbnailStreamSink => _thumbnailStreamController.sink;
  StreamController<String> _thumbnailStreamController =
      StreamController<String>.broadcast();
  Stream<String> get thumbnailStream => _thumbnailStreamController.stream;

//-----------------------------uploadToken------------------------------->
  final BehaviorSubject<String> _thumbnailAccessUrlBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get thumbnailAccessUrlStreamSink =>
      _thumbnailAccessUrlBehaviorSubject.sink;

  Stream<String> get thumbnailAccessUrlStream =>
      _thumbnailAccessUrlBehaviorSubject.stream;
//----------------------------------End---------------------------------->

  //----------------------Video url link ------------------------------------->
  StreamSink<String> get videoTokenStreamSink =>
      _videoTokenStreamController.sink;
  StreamController<String> _videoTokenStreamController =
      StreamController<String>.broadcast();
  Stream<String> get videoTokenStream => _videoTokenStreamController.stream;

  final BehaviorSubject<String> _videoTokenAccessUrlBehaviorSubject =
      BehaviorSubject<String>();

  StreamSink<String> get videoTokenAccessUrlStreamSink =>
      _videoTokenAccessUrlBehaviorSubject.sink;

  Stream<String> get videoTokenAccessUrlStream =>
      _videoTokenAccessUrlBehaviorSubject.stream;
//-----------------------------End------------------------------------->

//-----------------------------channelList------------------------------>
  StreamController<List<Videos>> _channelListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get channelListStreamSink =>
      _channelListStreamController.sink;

  Stream<List<Videos>> get channelListStream =>
      _channelListStreamController.stream;
//--------------------------End--------------------------------------->

//-------------------------List of Channels---------------------->
  // final BehaviorSubject<String> _genderBehaviorSubject =
  //     BehaviorSubject<String>();

  // StreamSink<String> get genderStreamSink => _genderBehaviorSubject.sink;

  // Stream<String> get genderStream =>
  //     _genderBehaviorSubject.stream.transform(genderStreamTransformer);
//----------------------------End------------------------------>

  void takeVideo(video) async {
    File fileImage = await video;
    String filePath = fileImage.path, fileName, fileExtension;

    fileName = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    fileExtension = filePath.substring(filePath.lastIndexOf('.') + 1);

    Map<String, dynamic> mapResponseGetDownloadUrl,
        mapResponseConfirm,
        updateMapResponse;
    mapResponseGetDownloadUrl = await _fileConnect.sendFileGet(
        '${FileConnect.uploadFileGetDownloadUrl}?type=video&fileName=$fileName.$fileExtension&fileType=video/$fileExtension');

    int statusCode = await _fileConnect.uploadFile(
        mapResponseGetDownloadUrl['content']['signedUrl'],
        'image/$fileExtension',
        filePath);

    mapResponseConfirm = await _fileConnect.sendFileGet(
        '${FileConnect.uploadConfirmUploadToken}${mapResponseGetDownloadUrl['content']['uploadToken']}');

    videoTokenStreamSink.add(
        '${Connect.filesUrl}${mapResponseGetDownloadUrl['content']['uploadToken']}');

    videoTokenAccessUrlStreamSink
        .add("${mapResponseGetDownloadUrl['content']['uploadToken']}");
  }

  void takePicture(img) async {
    File fileImage = await img;

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

    thumbnailStreamSink.add(
        '${Connect.filesUrl}${mapResponseConfirm['content']['accessUrl']}');

    thumbnailAccessUrlStreamSink
        .add("${mapResponseConfirm['content']['accessUrl']}");
  }

  Future sendBodyMessage(
    String channelId,
    String contentPolicy,
    String description,
    String privacy,
    String tags,
    String title,
  ) async {
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['channelId'] = channelId;
    mapBody['contentPolicy'] = contentPolicy;
    mapBody['description'] = description;
    mapBody['privacy'] = privacy;
    mapBody['tags'] = [tags];
    mapBody['thumbnail'] = _thumbnailAccessUrlBehaviorSubject.value;
    mapBody['title'] = title;
    mapBody['uploadToken'] = _videoTokenAccessUrlBehaviorSubject.value;
    Map<String, dynamic> mapResponse =
        await _listConnect.sendMailPost(mapBody, ListConnect.addVideo);
    composeFinishedStreamSink.add(mapResponse);
  }

  Future<String> appendImage() async {
    File fileImage = await FilePicker.getFile(type: FileType.IMAGE);
    String filePath = fileImage.path, fileName, fileExtension;
    fileName = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    fileExtension = filePath.substring(filePath.lastIndexOf('.') + 1);
    Map<String, dynamic> mapResponseGetDownloadUrl, mapResponseConfirm;
    mapResponseGetDownloadUrl = await _fileConnect.sendFileGet(
        '${FileConnect.uploadFileGetDownloadUrl}?type=general&fileName=$fileName&fileType=image/$fileExtension');

    int statusCode = await _fileConnect.uploadFile(
        mapResponseGetDownloadUrl['content']['signedUrl'],
        'image/$fileExtension',
        filePath);

    mapResponseConfirm = await _fileConnect.sendFileGet(
        '${FileConnect.uploadConfirmUploadToken}${mapResponseGetDownloadUrl['content']['uploadToken']}');

    String accessUrl = '';
    if (mapResponseConfirm['code'] == 200) {
      accessUrl =
          '${Connect.filesUrl}${mapResponseConfirm['content']['accessUrl']}';
    }
    return accessUrl;
  }

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

  void dispose() {
    _attachmentListStreamController.close();
    _toUsersListStreamController.close();
    _ccUsersListStreamController.close();
    _bccUsersListStreamController.close();
    _titleStreamController.close();
    _bodyStreamController.close();
    _composeFinishedStreamController.close();
    _draftSentFinishedStreamController.close();
    _replyForwardFinishedStreamController.close();
    _toUsersSuggestionsListStreamController.close();
    _ccUsersSuggestionsListStreamController.close();
    _bccUsersSuggestionsListStreamController.close();
    _thumbnailStreamController.close();
    _thumbnailAccessUrlBehaviorSubject.close();
    _videoTokenStreamController.close();
    _videoTokenAccessUrlBehaviorSubject.close();
    _channelListStreamController.close();
  }
}
