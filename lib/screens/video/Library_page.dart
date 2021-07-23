import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/fevourites_videos_bloc.dart';
import 'package:video/bloc_patterns/videos/history_bloc.dart';
import 'package:video/bloc_patterns/videos/library_bloc.dart';
import 'package:video/bloc_patterns/videos/liked_video_bloc.dart';
import 'package:video/bloc_patterns/videos/watch_later_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Channel_Details/video_channel_page.dart';
import 'package:video/screens/video/History_page.dart';
import 'package:video/screens/video/Liked_Video_page.dart';
import 'package:video/screens/video/compose_page.dart';
import 'package:video/screens/video/create_channeL.dart';
import 'package:video/screens/video/edit_channel_page.dart';
import 'package:video/screens/video/favourite_video_page.dart';
import 'package:video/screens/video/watch_later_page.dart';
import 'package:video/utils/navigation_actions.dart';

class LibraryPage extends StatefulWidget {
  LibraryPage({this.userId, this.previousScreen});

  final String userId, previousScreen;

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String userId;

  FavouritesBloc _favouritesBloc = FavouritesBloc();
  String _history = 'history';
  HistoryBloc _historyBloc = HistoryBloc();
  final LibraryBloc _libraryBloc = LibraryBloc();
  String _likedVideo = 'likes';
  LikedVideoBloc _likedVideoBloc = LikedVideoBloc();
  NavigationActions _navigationActions;
  double _screenWidth, _screenHeight;
  String _watchLater = "watch-later";
  WatchLater _watchLaterBloc = WatchLater();

  void initState() {
    super.initState();
    _watchLaterBloc.getWatchLater(_watchLater);
    _historyBloc.getWatchHistory(_history);
    _likedVideoBloc.likedVideosList(_likedVideo);
    _favouritesBloc.fevouritesVideoList();
    _navigationActions = NavigationActions(context);
    _libraryBloc.getProfileDetails(widget.userId);
    _libraryBloc.getChannnelList();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                "Library",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: _height / 30,
                  ),
                  StreamBuilder(
                      stream: _libraryBloc.videoLibProfileImageStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> asyncSnapshot) {
                        return Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: asyncSnapshot.data == null
                                  ? ExactAssetImage(
                                      'assets/images/male-avatar.png')
                                  : CachedNetworkImageProvider(
                                      '${Connect.filesUrl}${asyncSnapshot.data}'),
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    height: _height / 45.0,
                  ),
                  StreamBuilder(
                      stream: _libraryBloc.nameStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> asyncSnapshot) {
                        return Text(
                          asyncSnapshot.data == null
                              ? ''
                              : asyncSnapshot.data.length > 20
                                  ? '${asyncSnapshot.data.substring(0, 20)}...'
                                  : asyncSnapshot.data,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _height / 100,
                        left: _width / 8,
                        right: _width / 8),
                    child: StreamBuilder(
                        stream: _libraryBloc.mailAdressStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> asyncSnapshot) {
                          return Text(
                            asyncSnapshot.data == null
                                ? ''
                                : '${asyncSnapshot.data}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          );
                        }),
                  ),
                  Divider(height: _height / 30, color: Colors.grey),
                  ListTile(
                      leading: Text(
                        "Your Channel List",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      trailing: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.deepOrange,
                        child: Text(
                          "Create Channel",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _navigationActions
                              .navigateToScreenWidget(CreateChannelPage(
                            id: userId,
                          ));
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2, top: 10),
                    child: Card(
                        // color: Colors.deepOrange.withOpacity(0.1),
                        // margin: EdgeInsets.only(top: 10),
                        elevation: 4,
                        // color: Colors.white.withOpacity(0.1),
                        child: SizedBox(
                          height: 300,
                          child: StreamBuilder(
                              stream: _libraryBloc.channelListStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Videos>> asyncSnapshot) {
                                return asyncSnapshot.data == null
                                    ? Container(
                                        child:
                                            Center(child: Text("Loading....")),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.only(top: 10),
                                        itemCount: asyncSnapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return asyncSnapshot.data.length ==
                                                  null
                                              ? Container(
                                                  child: Center(
                                                    child: Text("No Channel"),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    _navigationActions
                                                        .navigateToScreenWidget(
                                                            VideoChannelPage(
                                                      userId: widget.userId,
                                                    ));
                                                  },
                                                  child: ListTile(
                                                    leading: Container(
                                                      width: 40.0,
                                                      height: 40.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: asyncSnapshot
                                                                      .data[
                                                                          index]
                                                                      .logo ==
                                                                  null
                                                              ? ExactAssetImage(
                                                                  'assets/images/male-avatar.png')
                                                              : CachedNetworkImageProvider(
                                                                  '${Connect.filesUrl}${asyncSnapshot.data[index].logo}',
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                    title: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Text(
                                                            asyncSnapshot
                                                                        .data[
                                                                            index]
                                                                        .name
                                                                        .length >
                                                                    12
                                                                ? '${asyncSnapshot.data[index].name.substring(0, 12)}...'
                                                                : "${asyncSnapshot.data[index].name}",
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    subtitle: Text(
                                                        "${asyncSnapshot.data[index].subscribers} Subscribers"),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.settings,
                                                            color: Colors
                                                                .deepOrange,
                                                          ),
                                                          onPressed: () {
                                                            _navigationActions
                                                                .navigateToScreenWidget(
                                                                    EditChannelPage(
                                                              userId:
                                                                  "${asyncSnapshot.data[index].id}",
                                                            ));
                                                          },
                                                        ),
                                                        RaisedButton(
                                                          color:
                                                              Colors.deepOrange,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          child: Text(
                                                            "Upload Video",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          onPressed: () {
                                                            _navigationActions
                                                                .navigateToScreenWidget(
                                                                    ComposeVideoPage(
                                                                        id: "${asyncSnapshot.data[index].id}"));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                        },
                                      );
                              }),
                        )),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2, top: 5),
                      child: Card(
                        elevation: 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Watch Later",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    AspectRatio(
                                      aspectRatio: 1.6,
                                      child: Container(
                                        child: StreamBuilder(
                                            stream: _watchLaterBloc
                                                .thumbnailWatchLaterStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    asyncSnapshot) {
                                              return asyncSnapshot.data == null
                                                  ? Center(
                                                      child: Text(
                                                          "No Watch Later VIdeo......"),
                                                    )
                                                  : Stack(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            width: _width,
                                                            imageUrl:
                                                                "${Connect.filesUrl}${asyncSnapshot.data}"),
                                                        Center(
                                                          child: Icon(
                                                            Icons
                                                                .play_circle_filled,
                                                            color: Colors.white,
                                                            size: 50,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                            }),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25, top: 40),
                                      child: StreamBuilder(
                                          stream: _watchLaterBloc
                                              .totalCountWatchLaterStream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String>
                                                  asyncSnapshot) {
                                            return asyncSnapshot.data == null
                                                ? Container(
                                                    width: 0,
                                                    height: 0,
                                                  )
                                                : Center(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(Icons
                                                                .playlist_play),
                                                            Text(
                                                              '${asyncSnapshot.data}',
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text("Videos")
                                                      ],
                                                    ),
                                                  );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _navigationActions
                          .navigateToScreenWidget(WatchLaterPage());
                    },
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2, top: 5),
                      child: Card(
                        elevation: 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Liked Videos",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    AspectRatio(
                                      aspectRatio: 1.6,
                                      child: Container(
                                        child: StreamBuilder(
                                            stream: _likedVideoBloc
                                                .thumbnailListStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    asyncSnapshot) {
                                              return asyncSnapshot.data == null
                                                  ? Center(
                                                      child: Text(
                                                          "No Liked Video......"),
                                                    )
                                                  : Stack(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            width: _width,
                                                            imageUrl:
                                                                "${Connect.filesUrl}${asyncSnapshot.data}"),
                                                        Center(
                                                          child: Icon(
                                                            Icons
                                                                .play_circle_filled,
                                                            color: Colors.white,
                                                            size: 50,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                            }),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25, top: 40),
                                      child: StreamBuilder(
                                          stream: _likedVideoBloc
                                              .totalCountListStream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String>
                                                  asyncSnapshot) {
                                            return asyncSnapshot.data == null
                                                ? Container(
                                                    width: 0,
                                                    height: 0,
                                                  )
                                                : Center(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(Icons
                                                                .playlist_play),
                                                            Text(
                                                              '${asyncSnapshot.data}',
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text("Videos")
                                                      ],
                                                    ),
                                                  );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _navigationActions
                          .navigateToScreenWidget(LikedVideoPage());
                    },
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2, top: 5),
                      child: Card(
                        elevation: 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Favourite Videos",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    AspectRatio(
                                      aspectRatio: 1.6,
                                      child: Container(
                                        child: StreamBuilder(
                                            stream: _favouritesBloc
                                                .fevTumbnailListStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    asyncSnapshot) {
                                              return asyncSnapshot.data == null
                                                  ? Center(
                                                      child: Text(
                                                          "No Favourites Video......"),
                                                    )
                                                  : Stack(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            width: _width,
                                                            imageUrl:
                                                                "${Connect.filesUrl}${asyncSnapshot.data}"),
                                                        Center(
                                                          child: Icon(
                                                            Icons
                                                                .play_circle_filled,
                                                            color: Colors.white,
                                                            size: 50,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                            }),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25, top: 40),
                                      child: StreamBuilder(
                                          stream: _favouritesBloc
                                              .totalCountFevListStream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String>
                                                  asyncSnapshot) {
                                            return asyncSnapshot.data == null
                                                ? Container(
                                                    width: 0,
                                                    height: 0,
                                                  )
                                                : Center(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(Icons
                                                                .playlist_play),
                                                            Text(
                                                              '${asyncSnapshot.data}',
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text("Videos")
                                                      ],
                                                    ),
                                                  );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _navigationActions
                          .navigateToScreenWidget(FevouritVideoPage());
                    },
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2, top: 5),
                      child: Card(
                        elevation: 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "History",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    AspectRatio(
                                      aspectRatio: 1.6,
                                      child: Container(
                                        child: StreamBuilder(
                                            stream: _historyBloc
                                                .thumbnailHistoryStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    asyncSnapshot) {
                                              return asyncSnapshot.data == null
                                                  ? Center(
                                                      child: Text(
                                                          "No Watch History Video......"),
                                                    )
                                                  : Stack(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            width: _width,
                                                            imageUrl:
                                                                "${Connect.filesUrl}${asyncSnapshot.data}"),
                                                        Center(
                                                          child: Icon(
                                                            Icons
                                                                .play_circle_filled,
                                                            color: Colors.white,
                                                            size: 50,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                            }),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25, top: 40),
                                      child: StreamBuilder(
                                          stream: _historyBloc
                                              .totalCountHistoryStream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String>
                                                  asyncSnapshot) {
                                            return asyncSnapshot.data == null
                                                ? Container(
                                                    width: 0,
                                                    height: 0,
                                                  )
                                                : Center(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(Icons
                                                                .playlist_play),
                                                            Text(
                                                              '${asyncSnapshot.data}',
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text("Videos")
                                                      ],
                                                    ),
                                                  );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _navigationActions.navigateToScreenWidget(HistoryPage());
                    },
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
