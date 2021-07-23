import 'dart:async';
import 'package:video/models/videos.dart';
import 'package:video/network/list_connect.dart';

class SubscriptionBloc {
  ListConnect _listConnect = ListConnect();
  List<Videos> subscriptionList = List<Videos>();
  StreamController<List<Videos>> _subscriptionListStreamController =
      StreamController<List<Videos>>.broadcast();

  StreamSink<List<Videos>> get subscriptionListStreamSink =>
      _subscriptionListStreamController.sink;

  Stream<List<Videos>> get subscriptionListStream =>
      _subscriptionListStreamController.stream;

  void subScriptionList() async {
    subscriptionList = List<Videos>();
    Map<String, dynamic> mapBody = Map<String, dynamic>();
    mapBody['filters'] = {};
    mapBody['page'] = '0';
    _listConnect
        .sendMailPostWithHeaders(mapBody, ListConnect.subscriptionList)
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        List<dynamic> dynamicList = mapResponse['content'] as List<dynamic>;
        dynamicList
            .map((i) => subscriptionList.add(Videos.fromSubscriptionList(i)))
            .toList();
        subscriptionListStreamSink.add(subscriptionList);
      }
    });
  }

  Future subscribeAndUnsubscribe(String id) async {
    await _listConnect
        .sendMailGetWithHeaders('${ListConnect.channelUnsubscribe}$id')
        .then((Map<String, dynamic> mapResponse) {
      if (mapResponse['code'] == 200) {
        subScriptionList();
      }
    });
  }

  void dispose() {
    _subscriptionListStreamController.close();
  }
}
