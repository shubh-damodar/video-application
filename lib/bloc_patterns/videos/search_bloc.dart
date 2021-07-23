import 'dart:async';

import 'package:video/models/email.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';
import 'package:video/utils/mail_subject_short_text_list_details.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  MailSubjectShortTextListDetails _mailSubjectShortTextListDetails;
  List<Videos> videoList = List<Videos>();
  ListConnect _listConnect = ListConnect();
  List<Videos> searchList = List<Videos>();
  int lastTimeStamp;
  SearchBloc({this.videoList}) {
    emailsFoundStreamSink.add(videoList);
    _mailSubjectShortTextListDetails =
        MailSubjectShortTextListDetails(videoList: videoList);
  }
  final BehaviorSubject<String> _mailSubjectShortTextBehaviorSubject =
      BehaviorSubject<String>();
  final StreamController<List<Videos>> _emailsFoundStreamController =
      StreamController<List<Videos>>();

  StreamSink<String> get mailSubjectShortTextStreamSink =>
      _mailSubjectShortTextBehaviorSubject.sink;
  StreamSink<List<Videos>> get emailsFoundStreamSink =>
      _emailsFoundStreamController.sink;

  Stream<String> get mailSubjectShortTextStream =>
      _mailSubjectShortTextBehaviorSubject.stream;
  Stream<List<Videos>> get emailsFoundStream =>
      _emailsFoundStreamController.stream;

  // void searchMailSubjectShortText(String mailSubjectShortTextLetter) async {
  //   videoList = List<Videos>();
  //   videoList = await _mailSubjectShortTextListDetails
  //       .getSuggestions(mailSubjectShortTextLetter);
  //   emailsFoundStreamSink.add(videoList);
  // }


//----------------------------Search List------------------------------>
  void searchBox(String query, dynamic _jsonMap) async {
    searchList = List<Videos>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['query'] = query;
    mapBody['filters'] = _jsonMap;
    mapBody['page'] = '0';
    print(_jsonMap);
    _listConnect
        .sendMailPost(mapBody, ListConnect.videosSearch)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList =
            mapResponse['content']['results'] as List<dynamic>;
        dynamicList.map((i) => searchList.add(Videos.fromJSON(i))).toList();
        emailsFoundStreamSink.add(searchList);
      }
    });
  }
//----------------------------End------------------------------------>

  void dispose() {
    _mailSubjectShortTextBehaviorSubject.close();
    _emailsFoundStreamController.close();
  }
}
