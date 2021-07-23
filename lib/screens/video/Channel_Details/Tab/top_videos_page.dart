import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_channel_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_page.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';

class TopVideoPage extends StatefulWidget {
  final String userId;
  TopVideoPage({this.userId});
  _TopVideoPageState createState() => _TopVideoPageState();
}

class _TopVideoPageState extends State<TopVideoPage>
    with AutomaticKeepAliveClientMixin {
  _TopVideoPageState({this.userId});
  NavigationActions _navigationActions;
  final Map<String, dynamic> userId;

  DateCategory _dateCategory = DateCategory();
  final ScrollController _scrollController = ScrollController();

  VideoChannelDetailsList _videoChannelDetailsListBloc =
      VideoChannelDetailsList();

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _videoChannelDetailsListBloc.getChannelVideoList(widget.userId);
  }

  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _videoChannelDetailsListBloc.videosListStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<Videos>> asyncSnapshot) {
            return asyncSnapshot.data == null
                ? Container(
                    child: Center(child: Text("Loading Videos.........")),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: asyncSnapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return asyncSnapshot.data.length == null
                          ? Container(
                              child: Center(
                                  child: Text("No Video To Show.............")),
                            )
                          : Stack(
                              children: <Widget>[
                                GestureDetector(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 200.0,
                                        child: Stack(
                                          children: <Widget>[
                                            CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              width: _width,
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
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        "Views ${asyncSnapshot.data[index].views.toString()}",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            color:
                                                                Colors.white),
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
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        "${asyncSnapshot.data[index].durationParsed}",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 8.0),
                                                      child: Text(
                                                        asyncSnapshot
                                                                    .data[index]
                                                                    .title
                                                                    .length >
                                                                90
                                                            ? "${asyncSnapshot.data[index].title.substring(0, 90)}...."
                                                            : "${asyncSnapshot.data[index].title}",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color.fromARGB(
                                                              255, 51, 51, 51),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 6.0,
                                                                  bottom: 7.0),
                                                          child: Text(
                                                            "${asyncSnapshot.data[index].name}",
                                                            style: TextStyle(
                                                              fontSize: 13.0,
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
                                              onTap: () {},
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    _navigationActions.navigateToScreenWidget(
                                        VideoPage(
                                            id: "${asyncSnapshot.data[index].id}"));
                                  },
                                ),
                                Positioned(
                                    bottom: 8,
                                    right: 15,
                                    child: Text(
                                        "${asyncSnapshot.data[index].addedAt}",
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                            255,
                                            51,
                                            51,
                                            51,
                                          ),
                                        ))),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Card(
                                    margin: EdgeInsets.all(5),
                                    color: Colors.black.withOpacity(0.4),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.star,
                                              size: 17,
                                              color: Colors.white,
                                            ),
                                            onTap: () {
                                              print("click on star");
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: GestureDetector(
                                            child: Icon(Icons.watch_later,
                                                size: 17, color: Colors.white),
                                            onTap: () {
                                              print("Watch leter");
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                    });
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
