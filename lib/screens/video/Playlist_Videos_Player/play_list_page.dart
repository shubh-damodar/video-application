import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video/bloc_patterns/videos/playlist_bloc.dart';
import 'package:video/bloc_patterns/videos/video_bloc.dart';
import 'package:video/models/user.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Channel_Details/video_channel_page.dart';
import 'package:video/screens/video/Playlist_Videos_Player/play_list_player.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/network_connectivity.dart';
import 'package:video/utils/shared_pref_manager.dart';
import 'package:share/share.dart';
import 'package:video/utils/widgets_collection.dart';

class PlayListVideoPage extends StatefulWidget {
  PlayListVideoPage({this.id, this.previousScreen, this.userId});

  final String id, previousScreen, userId;

  _PlayListVideoPageState createState() => _PlayListVideoPageState();
}

class _PlayListVideoPageState extends State<PlayListVideoPage>
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
  final PlayListBloc _playListBloc = PlayListBloc();
  WidgetsCollection _widgetsCollection;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      NetworkConnectivity.of(context).checkNetworkConnection();
    });

    // print("${Connect.currentUser.userId}```````````${widget.id}`````````````$channelId````````````````${widget.userId}");
    _getAllUsers();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _playListBloc.getVideoDetails(widget.id, widget.userId);
    // _playListBloc.getVideoLink(widget.id);
    // _videoBloc.getVideoDetails(widget.id);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _playListVideoScaffoldKey =
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
          key: _playListVideoScaffoldKey,
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
                  // StreamBuilder(
                  //   stream: _playListBloc.linkAddressStream,
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<String> asyncSnapshot) {
                  //     return asyncSnapshot.data == null
                  //         ? Container(
                  //             height: 200,
                  //             child: Center(
                  //               child: CircularProgressIndicator(),
                  //             ))
                  //         : PlayListVideoPlayerPage(
                  //             urlLink: asyncSnapshot.data);
                  //   },
                  // ),
                  StreamBuilder(
                      stream: _playListBloc.channelIdStream,
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
                            stream: _playListBloc.titleStream,
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
                            stream: _playListBloc.watchLaterStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> asyncSnapshot) {
                              return IconButton(
                                icon: asyncSnapshot.data == !_watchlater
                                    ? Icon(Icons.access_time,
                                        color: Colors.deepOrange, size: 20.0)
                                    : Icon(Icons.access_time,
                                        color: Colors.grey, size: 20.0),
                                onPressed: () {},
                                // onPressed: () {
                                //   _watchlater = !_watchlater;
                                //   setState(() {
                                //     asyncSnapshot.data == !_watchlater
                                //         ? _playListBloc.addWatchLater(widget.id)
                                //         : _playListBloc
                                //             .watchLaterMarkRemove(widget.id);
                                //     asyncSnapshot.data == !_watchlater
                                //         ? _widgetsCollection.showToastMessage(
                                //             "Added To Watch Later")
                                //         : _widgetsCollection.showToastMessage(
                                //             "Removed From Watch Later");
                                //   });
                                // },
                              );
                            }),
                        StreamBuilder(
                            stream: _playListBloc.favouriteStatusStream,
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
                                  // setState(() {
                                  //   asyncSnapshot.data == !fev
                                  //       ? _playListBloc.favouritesAction(
                                  //           widget.id, 'add')
                                  //       : _playListBloc.favouritesAction(
                                  //           widget.id, "remove");
                                  //   asyncSnapshot.data == !fev
                                  //       ? _widgetsCollection.showToastMessage(
                                  //           "Added to Fevourites")
                                  //       : _widgetsCollection.showToastMessage(
                                  //           "Removed From Fevourites");
                                  // });
                                },
                              );
                            }),
                        StreamBuilder(
                            stream: _playListBloc.likeStatusStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> asyncSnapshot) {
                              return IconButton(
                                icon: asyncSnapshot.data == !_tumbsUp
                                    ? Icon(Icons.thumb_up,
                                        color: Colors.deepOrange, size: 20.0)
                                    : Icon(Icons.thumb_up,
                                        color: Colors.grey, size: 20.0),
                                onPressed: () {
                                  _tumbsUp = !_tumbsUp;
                                  // setState(() {
                                  //   asyncSnapshot.data == !_tumbsUp
                                  //       ? _playListBloc.likeVideo(
                                  //           widget.id, "likes")
                                  //       : _playListBloc.dislikeVideo(
                                  //           widget.id, "likes");

                                  //   asyncSnapshot.data == !_tumbsUp
                                  //       ? _widgetsCollection
                                  //           .showToastMessage("Like")
                                  //       : _widgetsCollection
                                  //           .showToastMessage("Removed Like");
                                  // });
                                },
                              );
                            }),
                        StreamBuilder(
                            stream: _playListBloc.unlikeStatusStream,
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
                                  // setState(() {
                                  //   asyncSnapshot.data == !tumbsDown
                                  //       ? _playListBloc.likeVideo(
                                  //           widget.id, "unlikes")
                                  //       : _playListBloc.dislikeVideo(
                                  //           widget.id, "unlikes");
                                  //   asyncSnapshot.data == !tumbsDown
                                  //       ? _widgetsCollection
                                  //           .showToastMessage("Dislike")
                                  //       : _widgetsCollection.showToastMessage(
                                  //           "Removed Dislike");
                                  // });
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
                      stream: _playListBloc.channelIdStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> asyncSnapshot) {
                        return GestureDetector(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: StreamBuilder(
                                  stream: _playListBloc.coverPictureStream,
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
                                      stream: _playListBloc.nameStream,
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
                                stream:
                                    _playListBloc.subscribersofChannelStream,
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
                                  stream:
                                      _playListBloc.subscriptionStatusStream,
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
                                              // setState(() {
                                              //   _playListBloc
                                              //       .subscribeAndUnsubscribe(
                                              //           'unsubscribe',
                                              //           channelId,
                                              //           widget.id);
                                              // });
                                            },
                                          )
                                        : RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            color: Colors.deepOrange,
                                            child: Text("Subscribe",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () {
                                              _widgetsCollection
                                                  .showToastMessage(
                                                      "Subscribed");
                                              // setState(() {
                                              //   _playListBloc
                                              //       .subscribeAndUnsubscribe(
                                              //           'subscribe',
                                              //           channelId,
                                              //           widget.id);
                                              // });
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
                  // Container(
                  //     height: MediaQuery.of(context).size.height / 1.70,
                  //     child: Column(children: <Widget>[
                  //       TabBar(
                  //           indicatorColor: Colors.deepOrange,
                  //           labelColor: Colors.deepOrange,
                  //           unselectedLabelColor: Colors.grey,
                  //           controller: _tabController,
                  //           isScrollable: false,
                  //           tabs: <Widget>[
                  //             Tab(text: 'Related Video'),
                  //             Tab(text: 'Comments'),
                  //             Tab(text: 'Channel Details'),
                  //           ]),
                  //       Expanded(
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(top: 0.0),
                  //           child: TabBarView(
                  //             controller: _tabController,
                  //             children: <Widget>[
                  //               RelatedPlayListVideoPage(id: widget.id),
                  //               CommentPlayListVideoPage(id: widget.id),
                  //               VideoDetailsPage(id: widget.id),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ])),
                ],
              ),
            ),
          )),
    );
  }
}
