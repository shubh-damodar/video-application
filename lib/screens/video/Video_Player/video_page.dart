import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video/bloc_patterns/videos/video_bloc.dart';
import 'package:video/models/user.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Channel_Details/video_channel_page.dart';
import 'package:video/screens/video/Video_Player/video_player.dart';
import 'package:video/screens/video/Video_Player/video_tab/channel_details_video_tab3_page.dart';
import 'package:video/screens/video/Video_Player/video_tab/comment/comment_video_tab2_page.dart';
import 'package:video/screens/video/Video_Player/video_tab/related_video_tab1_page.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/network_connectivity.dart';
import 'package:video/utils/shared_pref_manager.dart';
import 'package:share/share.dart';
import 'package:video/utils/widgets_collection.dart';

class VideoPage extends StatefulWidget {
  VideoPage({this.id, this.previousScreen});

  final String id, previousScreen;

  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin {
  String channelId;
  bool fev = false,
      _watchlater = false,
      _tumbsUp = false,
      subcribe = false,
      tumbsDown = false,
      viewlater = false;

  NavigationActions _navigationActions;
  double _screenWidth, _screenHeight;
  final ScrollController _scrollController = ScrollController();
  TabController _tabController;
  final VideoBloc _videoBloc = VideoBloc();
  WidgetsCollection _widgetsCollection;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _videoBloc.getVideoDetails(widget.id);
    _videoBloc.getVideoLink(widget.id);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _videoScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

//------------------------User Connection----------------------------->
  List<User> _usersList = List<User>();
  Future<void> _getAllUsers() async {
    await SharedPrefManager.getAllUsers().then((List<User> user) {
      setState(() {
        _usersList = user;
      });
    });
  }
  //---------------------------End------------------------------------>

  Future<bool> _onWillPop() async {
    _navigationActions.previousScreenUpdate();
  }

  Widget _getChannelId(String data) {
    channelId = data;
    return Container(
      width: 0,
      height: 0,
    );
  }

  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _videoScaffoldKey,
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Video',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  // StreamBuilder(
                  //   stream: _videoBloc.linkAddressStream,
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<String> asyncSnapshot) {
                  //     return asyncSnapshot.data == null
                  //         ? Container(
                  //             height: 200,
                  //             child: Center(
                  //               child: CircularProgressIndicator(),
                  //             ))
                  //         : VideoPlayerPage(urlLink: asyncSnapshot.data);
                  //   },
                  // ),
                  StreamBuilder(
                      stream: _videoBloc.channelIdStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> asyncSnapshot) {
                        return asyncSnapshot.data == null
                            ? Container(width: 0.0, height: 0.0)
                            : _getChannelId(asyncSnapshot.data);
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                            stream: _videoBloc.titleStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              return Expanded(
                                child: Text(
                                  asyncSnapshot.data == null
                                      ? ''
                                      : asyncSnapshot.data,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        StreamBuilder(
                            stream: _videoBloc.watchLaterStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> asyncSnapshot) {
                              return IconButton(
                                icon: asyncSnapshot.data == !_watchlater
                                    ? Icon(Icons.access_time,
                                        color: Colors.deepOrange, size: 20.0)
                                    : Icon(Icons.access_time,
                                        color: Colors.grey, size: 20.0),
                                onPressed: () {
                                  _watchlater = !_watchlater;
                                  setState(() {
                                    asyncSnapshot.data == !_watchlater
                                        ? _videoBloc.addWatchLater(widget.id)
                                        : _videoBloc
                                            .watchLaterMarkRemove(widget.id);
                                    asyncSnapshot.data == !_watchlater
                                        ? _widgetsCollection.showToastMessage(
                                            "Added To Watch Later")
                                        : _widgetsCollection.showToastMessage(
                                            "Removed From Watch Later");
                                  });
                                },
                              );
                            }),
                        StreamBuilder(
                            stream: _videoBloc.favouriteStatusStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> asyncSnapshot) {
                              return IconButton(
                                icon: asyncSnapshot.data == !fev
                                    ? Icon(Icons.star,
                                        color: Colors.deepOrange, size: 20.0)
                                    : Icon(Icons.star,
                                        color: Colors.grey, size: 20.0),
                                onPressed: () {
                                  fev = !fev;
                                  setState(() {
                                    asyncSnapshot.data == !fev
                                        ? _videoBloc.favouritesAction(
                                            widget.id, 'add')
                                        : _videoBloc.favouritesAction(
                                            widget.id, "remove");
                                    asyncSnapshot.data == !fev
                                        ? _widgetsCollection.showToastMessage(
                                            "Added to Fevourites")
                                        : _widgetsCollection.showToastMessage(
                                            "Removed From Fevourites");
                                  });
                                },
                              );
                            }),
                        StreamBuilder(
                            stream: _videoBloc.likeStatusStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> asyncSnapshot) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 1.5),
                                child: IconButton(
                                  icon: asyncSnapshot.data == !_tumbsUp
                                      ? Icon(Icons.thumb_up,
                                          color: Colors.deepOrange, size: 20.0)
                                      : Icon(Icons.thumb_up,
                                          color: Colors.grey, size: 20.0),
                                  onPressed: () {
                                    _tumbsUp = !_tumbsUp;
                                    setState(() {
                                      asyncSnapshot.data == !_tumbsUp
                                          ? _videoBloc.likeVideo(
                                              widget.id, "likes")
                                          : _videoBloc.dislikeVideo(
                                              widget.id, "likes");

                                      asyncSnapshot.data == !_tumbsUp
                                          ? _widgetsCollection
                                              .showToastMessage("Like")
                                          : _widgetsCollection
                                              .showToastMessage("Removed Like");
                                    });
                                  },
                                ),
                              );
                            }),
                        StreamBuilder(
                            stream: _videoBloc.unlikeStatusStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> asyncSnapshot) {
                              return IconButton(
                                icon: asyncSnapshot.data == !tumbsDown
                                    ? Icon(Icons.thumb_down,
                                        color: Colors.deepOrange, size: 20.0)
                                    : Icon(Icons.thumb_down,
                                        color: Colors.grey, size: 20.0),
                                onPressed: () {
                                  tumbsDown = !tumbsDown;
                                  setState(() {
                                    asyncSnapshot.data == !tumbsDown
                                        ? _videoBloc.likeVideo(
                                            widget.id, "unlikes")
                                        : _videoBloc.dislikeVideo(
                                            widget.id, "unlikes");
                                    asyncSnapshot.data == !tumbsDown
                                        ? _widgetsCollection
                                            .showToastMessage("Dislike")
                                        : _widgetsCollection.showToastMessage(
                                            "Removed Dislike");
                                  });
                                },
                              );
                            }),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            size: 20,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Share.share(
                                'https://www.mesbro.com/1/videos/watch/${widget.id}');
                          },
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  StreamBuilder(
                      stream: _videoBloc.channelIdStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> asyncSnapshot) {
                        return GestureDetector(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: StreamBuilder(
                                  stream: _videoBloc.coverPictureStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> asyncSnapshot) {
                                    return asyncSnapshot.data == null
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
                                                "${Connect.filesUrl}${asyncSnapshot.data}",
                                            fit: BoxFit.contain,
                                            height: 45,
                                            width: 45,
                                            placeholder: (BuildContext context,
                                                String url) {
                                              return Image.asset(
                                                'assets/images/male-avatar.png',
                                                fit: BoxFit.contain,
                                                height: 45,
                                                width: 45,
                                              );
                                            },
                                          );
                                  }),
                            ),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  child: StreamBuilder(
                                      stream: _videoBloc.nameStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> asyncSnapshot) {
                                        return Container(
                                          width: 5,
                                          child: asyncSnapshot.data == null
                                              ? Container(
                                                  child: Text("loading.."),
                                                )
                                              : Text(
                                                  "${asyncSnapshot.data}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 3,
                                                ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                            subtitle: StreamBuilder(
                                stream: _videoBloc.subscribersofChannelStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> asyncSnapshot) {
                                  return Text(
                                    asyncSnapshot.data == null
                                        ? "Subscribers"
                                        : "${asyncSnapshot.data} Subscribers",
                                    style: TextStyle(fontSize: 11),
                                  );
                                }),
                            trailing: SizedBox(
                              width: 120,
                              child: StreamBuilder(
                                  stream: _videoBloc.subscriptionStatusStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> asyncSnapshot) {
                                    return asyncSnapshot.data == !subcribe
                                        ? RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            color: Colors.grey,
                                            child: Text(
                                              "Unubscribe",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              _widgetsCollection
                                                  .showToastMessage(
                                                      "Unsubscribed");
                                              setState(() {
                                                _videoBloc
                                                    .subscribeAndUnsubscribe(
                                                        'unsubscribe',
                                                        channelId,
                                                        widget.id);
                                              });
                                            },
                                          )
                                        : RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            color: Colors.deepOrange,
                                            child: Text(
                                              "Subscribe",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              _widgetsCollection
                                                  .showToastMessage(
                                                      "Subscribed");
                                              setState(() {
                                                _videoBloc
                                                    .subscribeAndUnsubscribe(
                                                  'subscribe',
                                                  channelId,
                                                  widget.id,
                                                );
                                              });
                                            },
                                          );
                                  }),
                            ),
                          ),
                          onTap: () {
                            _navigationActions.navigateToScreenWidget(
                                VideoChannelPage(userId: asyncSnapshot.data));
                          },
                        );
                      }),
                  Divider(),
                  Container(
                      height: MediaQuery.of(context).size.height / 1.70,
                      child: Column(children: <Widget>[
                        TabBar(
                            indicatorColor: Colors.deepOrange,
                            labelColor: Colors.deepOrange,
                            unselectedLabelColor: Colors.grey,
                            controller: _tabController,
                            isScrollable: false,
                            tabs: <Widget>[
                              Tab(text: 'Related Video'),
                              Tab(text: 'Comments'),
                              Tab(text: 'Channel Details'),
                            ]),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              RelatedVideoPage(id: widget.id),
                              CommentVideoPage(id: widget.id),
                              VideoDetailsPage(id: widget.id),
                            ],
                          ),
                        ),
                      ])),
                ],
              ),
            ),
          )),
    );
  }
}
