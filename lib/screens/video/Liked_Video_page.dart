import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video/bloc_patterns/videos/liked_video_bloc.dart';
import 'package:video/models/user.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_page.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/network_connectivity.dart';
import 'package:video/utils/shared_pref_manager.dart';
import 'package:video/utils/widgets_collection.dart';
import 'package:shimmer/shimmer.dart';

class LikedVideoPage extends StatefulWidget {
  _LikedVideoPageState createState() => _LikedVideoPageState();
}

class _LikedVideoPageState extends State<LikedVideoPage> {
  LikedVideoBloc _likedVideoBloc = LikedVideoBloc();
  DateCategory _dateCategory = DateCategory();
  double _screenWidth, _screenHeight;
  List<User> _usersList = List<User>();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  final ScrollController _scrollController = ScrollController();
  String _jsonMap = "likes";

  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _likedVideoBloc.likedVideosList(_jsonMap);
  }

  void dispose() {
    super.dispose();
    // _likedVideoBloc.dispose();
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
        title: Text('Liked Videos',
            style: TextStyle(color: Colors.black, fontSize: 14)),
      ),
      body: StreamBuilder(
          stream: _likedVideoBloc.likeListStream,
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
                              child: Text('No Videos...'),
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
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Stack(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: new Container(
                                          // elevation: 1.7,
                                          child: new Column(
                                            children: [
                                              new Column(
                                                children: <Widget>[
                                                  new SizedBox(
                                                    height: 200.0,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          width: _screenWidth,
                                                          imageUrl:
                                                              "${Connect.filesUrl}${asyncSnapshot.data[index].thumbnail}",
                                                        ),
                                                        Positioned(
                                                          bottom: 5,
                                                          left: 5,
                                                          child: Card(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  child:
                                                                      new Text(
                                                                    "Views ${asyncSnapshot.data[index].views.toString()}",
                                                                    style: new TextStyle(
                                                                        fontSize:
                                                                            10.0,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 5,
                                                          right: 5,
                                                          child: Card(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  child:
                                                                      new Text(
                                                                    asyncSnapshot
                                                                        .data[
                                                                            index]
                                                                        .durationParsed,
                                                                    style: new TextStyle(
                                                                        fontSize:
                                                                            10.0,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                children: [
                                                  new Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: new Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          new Padding(
                                                            padding:
                                                                new EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: new Text(
                                                              asyncSnapshot
                                                                          .data[
                                                                              index]
                                                                          .title
                                                                          .length >
                                                                      90
                                                                  ? "${asyncSnapshot.data[index].title.substring(0, 90)}...."
                                                                  : asyncSnapshot
                                                                      .data[
                                                                          index]
                                                                      .title,
                                                              style: new TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          51,
                                                                          51,
                                                                          51)),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              new Padding(
                                                                padding:
                                                                    new EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            6.0,
                                                                        bottom:
                                                                            7.0),
                                                                child: new Text(
                                                                  "${asyncSnapshot.data[index].name}",
                                                                  style: new TextStyle(
                                                                      fontSize:
                                                                          13.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          51,
                                                                          51,
                                                                          51)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          _navigationActions
                                              .navigateToScreenWidget(VideoPage(
                                                  id: asyncSnapshot
                                                      .data[index].id,
                                                  previousScreen:
                                                      'explore_page'));
                                        },
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 15,
                                        child: new Text(
                                          "${asyncSnapshot.data[index].addedAt}",
                                          style: new TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 51, 51, 51)),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Card(
                                          margin: EdgeInsets.all(5),
                                          color: Colors.black.withOpacity(0.4),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: GestureDetector(
                                                  child: Icon(
                                                    Icons.star,
                                                    size: 17,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () {
                                                    _widgetsCollection
                                                        .showToastMessage(
                                                            "Added To Watch Later");
                                                    _likedVideoBloc
                                                        .favouritesAction(
                                                            asyncSnapshot
                                                                .data[index].id,
                                                            "add");
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: GestureDetector(
                                                  child: Icon(
                                                    Icons.watch_later,
                                                    size: 17,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () {
                                                    _likedVideoBloc
                                                        .addWatchLater(
                                                      "${asyncSnapshot.data[index].id}",
                                                    );
                                                    _widgetsCollection
                                                        .showToastMessage(
                                                            "Added to Watch Later");
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                ),
              ],
            );
          }),
    );
  }
}
