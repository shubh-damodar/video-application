import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video/bloc_patterns/videos/subscription_bloc.dart';
import 'package:video/bloc_patterns/videos/videos_bloc.dart';
import 'package:video/models/user.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/messages_actions.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/network_connectivity.dart';
import 'package:video/utils/shared_pref_manager.dart';
import 'package:video/utils/widgets_collection.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionPage extends StatefulWidget {
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  SubscriptionBloc _subscriptionBloc = SubscriptionBloc();
  double _screenWidth, _screenHeight;
  DateTime currentBackPressDateTime;
  List<User> _usersList = List<User>();
  List<String> _selectedConversationIdsList = List<String>();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  final ScrollController _scrollController = ScrollController();
  bool subcribe = false;
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _subscriptionBloc.subScriptionList();
  }

  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _getAllUsers() async {
    await SharedPrefManager.getAllUsers().then((List<User> user) {
      setState(() {
        _usersList = user;
      });
    });
  }

  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Subscriptions',
            style: TextStyle(color: Colors.black, fontSize: 14)),
      ),
      body: StreamBuilder(
          stream: _subscriptionBloc.subscriptionListStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<Videos>> asyncSnapshot) {
            return new Column(
              children: <Widget>[
                new Expanded(
                  child: asyncSnapshot.data == null
                      ? Container(
                          width: double.infinity,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Column(
                              children: [0, 1, 2]
                                  .map((_) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: _screenWidth,
                                              height: 150.0,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        )
                      : asyncSnapshot.data.length == 0
                          ? Container(
                              child: Center(
                              child: Text('No messages yet...'),
                            ))
                          : ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      Divider(),
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: asyncSnapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: ListTile(
                                      leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          child:
                                              asyncSnapshot.data.length == null
                                                  ? Container(
                                                      child: Image.asset(
                                                        'assets/images/male-avatar.png',
                                                        fit: BoxFit.contain,
                                                        height: 45,
                                                        width: 45,
                                                      ),
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          "${Connect.filesUrl}${asyncSnapshot.data[index].logo}",
                                                      fit: BoxFit.contain,
                                                      height: 45,
                                                      width: 45,
                                                      placeholder:
                                                          (BuildContext context,
                                                              String url) {
                                                        return Image.asset(
                                                          'assets/images/male-avatar.png',
                                                          fit: BoxFit.contain,
                                                          height: 45,
                                                          width: 45,
                                                        );
                                                      },
                                                    )),
                                      title: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Container(
                                            width: 5,
                                            child: asyncSnapshot.data == null
                                                ? Container(
                                                    child: Text("loading.."),
                                                  )
                                                : Text(
                                                    "${asyncSnapshot.data[index].name}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 3,
                                                  ),
                                          )),
                                        ],
                                      ),
                                      subtitle: asyncSnapshot.data == null
                                          ? Container(
                                              child: Text("loading.."),
                                            )
                                          : Text(
                                              "${asyncSnapshot.data[index].subscribers} Subscribers",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                      trailing: SizedBox(
                                          width: 120,
                                          child: asyncSnapshot.data == null
                                              ? Container()
                                              : RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  child: Text(
                                                    "Unsubscribe",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color: Colors.grey,
                                                  onPressed: () {
                                                    setState(() {
                                                      _subscriptionBloc
                                                          .subscribeAndUnsubscribe(
                                                              asyncSnapshot
                                                                  .data[index]
                                                                  .id);
                                                    });
                                                  },
                                                )),
                                    ));
                              }),
                ),
              ],
            );
          }),
    );
  }
}
