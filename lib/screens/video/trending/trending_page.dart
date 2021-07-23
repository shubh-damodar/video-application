import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video/bloc_patterns/videos/videos_bloc.dart';
import 'package:video/models/user.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_page.dart';
import 'package:video/screens/video/trending/widget_drawer.dart';
import 'package:video/screens/video/video_search_page.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/network_connectivity.dart';
import 'package:video/utils/shared_pref_manager.dart';
import 'package:video/utils/widgets_collection.dart';

class TrendingPage extends StatefulWidget {
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  DateTime currentBackPressDateTime;

  DateCategory _dateCategory = DateCategory();
  Map _jsonMap = {"type": "video"};
  NavigationActions _navigationActions;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double _screenWidth, _screenHeight;
  final ScrollController _scrollController = ScrollController();
  TreandingBloc _trendingBloc = TreandingBloc();
  List<User> _usersList = List<User>();
  WidgetsCollection _widgetsCollection;

  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _trendingBloc.getReceivedMessages(_jsonMap);
  }

  void dispose() {
    _trendingBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAllUsers() async {
    await SharedPrefManager.getAllUsers().then((List<User> user) {
      setState(() {
        _usersList = user;
      });
    });
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressDateTime == null ||
        now.difference(currentBackPressDateTime) > Duration(seconds: 2)) {
      currentBackPressDateTime = now;
      _widgetsCollection.showToastMessage('Press once again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Trending',
              style: TextStyle(color: Colors.black, fontSize: 14)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _navigationActions.navigateToScreenWidget(
                    SearchPage(
                      videoList: _trendingBloc.videosList,
                      videoType: 'input',
                      jsonMap: _jsonMap,
                    ),
                  );
                });
              },
            ),
          ],
        ),
        drawer: DrawerCustom(
          screenWidth: _screenWidth,
          usersList: _usersList,
          widgetsCollection: _widgetsCollection,
          navigationActions: _navigationActions,
        ),
        body: StreamBuilder(
          stream: _trendingBloc.videosStream,
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
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      Divider(),
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: asyncSnapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: new Container(
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
                                                              .withOpacity(0.4),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: new Text(
                                                                  "Views ${asyncSnapshot.data[index].views.toString()}",
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        10.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
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
                                                              .withOpacity(0.4),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: new Text(
                                                                  "${asyncSnapshot.data[index].durationParsed}",
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        10.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
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
                                                                : "${asyncSnapshot.data[index].title}",
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      51,
                                                                      51,
                                                                      51),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            new Padding(
                                                              padding:
                                                                  new EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      bottom:
                                                                          7.0),
                                                              child: new Text(
                                                                "${asyncSnapshot.data[index].name}",
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      13.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          51,
                                                                          51,
                                                                          51),
                                                                ),
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
                                            .navigateToScreenWidget(
                                          VideoPage(
                                            id: "${asyncSnapshot.data[index].id}",
                                            previousScreen: 'explore_page',
                                          ),
                                        );
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
                                          color:
                                              Color.fromARGB(255, 51, 51, 51),
                                        ),
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
                                                  _trendingBloc.favouritesAction(
                                                      "${asyncSnapshot.data[index].id}",
                                                      "add");
                                                  _widgetsCollection
                                                      .showToastMessage(
                                                          "Added to Favoutites");
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
                                                  _trendingBloc.addWatchLater(
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
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
