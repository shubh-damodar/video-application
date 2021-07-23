import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/playlist_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Playlist_Videos_Player/play_list_page.dart';
import 'package:video/utils/navigation_actions.dart';

class PlayListPage extends StatefulWidget {
  final String userId;
  PlayListPage({this.userId});
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage>
    with AutomaticKeepAliveClientMixin {
  _PlayListPageState({this.userId});
  NavigationActions _navigationActions;
  final Map<String, dynamic> userId;
  Map _jsonMap = {"type": "playlist"};
  PlayListBloc _playListBloc = PlayListBloc();
  final ScrollController _scrollController = ScrollController();

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _playListBloc.getPlayListVideos(_jsonMap);
  }

  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Playlist',
            style: TextStyle(color: Colors.black, fontSize: 14)),
      ),
      body: StreamBuilder(
          stream: _playListBloc.playLIstVideosStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<Videos>> asyncSnapshot) {
            return asyncSnapshot.data == null
                ? Container(
                    width: 0,
                    height: 0,
                  )
                : ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    padding: const EdgeInsets.all(8.0),
                    // itemExtent: 106.0,
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: asyncSnapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return asyncSnapshot.data.length == 0
                          ? Container(
                              child:
                                  Center(child: Text("No Playlist.........!")),
                            )
                          : GestureDetector(
                              onTap: () {
                                _navigationActions.navigateToScreenWidget(
                                  PlayListVideoPage(
                                    id: asyncSnapshot.data[index].id,
                                    userId: asyncSnapshot.data[index].data[0]['id'],
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 3,
                                        child: asyncSnapshot
                                                    .data[index].videosCount ==
                                                0
                                            ? Image.asset(
                                                'assets/images/cover.png',
                                                fit: BoxFit.fill,
                                                width: _width,
                                                height: 100,
                                              )
                                            : CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                width: _width,
                                                height: 100,
                                                imageUrl:
                                                    '${Connect.filesUrl}${asyncSnapshot.data[index].data[0]['thumbnail']}',
                                              )),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              asyncSnapshot.data[index].name ==
                                                      null
                                                  ? ''
                                                  : "${asyncSnapshot.data[index].name}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0)),
                                            Text(
                                              asyncSnapshot.data[index]
                                                          .videoCount ==
                                                      null
                                                  ? ''
                                                  : "${asyncSnapshot.data[index].videoCount}",
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    });
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
