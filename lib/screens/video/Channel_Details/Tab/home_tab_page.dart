import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_channel_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_page.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';

class HomeTabPage extends StatefulWidget {
  final String userId;
  HomeTabPage({this.userId});
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  _HomeTabPageState({this.userId});
  NavigationActions _navigationActions;
  final Map<String, dynamic> userId;

  DateCategory _dateCategory = DateCategory();
  final ScrollController _scrollController = ScrollController();

  VideoChannelDetailsList _videoChannelDetailsListBloc =
      VideoChannelDetailsList();

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _videoChannelDetailsListBloc.getchannelInfoDetails(widget.userId);
    _videoChannelDetailsListBloc.getChannelVideoList(widget.userId);
  }

  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 290.0,
            child: Stack(
              children: <Widget>[
                StreamBuilder(
                    stream: _videoChannelDetailsListBloc.coverPictureStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<String> asyncSnapshot) {
                      return asyncSnapshot.data == null
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : CachedNetworkImage(
                              height: 250.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${Connect.filesUrl}${asyncSnapshot.data}",
                              placeholder: (BuildContext context, String url) {
                                return Image.asset(
                                  'assets/images/cover.png',
                                  width: double.infinity,
                                  height: 250.0,
                                  fit: BoxFit.cover,
                                );
                              },
                            );
                    }),
                Positioned(
                  top: 160.0,
                  left: MediaQuery.of(context).size.width / 2 - 130 / 2,
                  child: PhysicalModel(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 5,
                    child: StreamBuilder(
                        stream: _videoChannelDetailsListBloc.logoStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> asyncSnapshot) {
                          return asyncSnapshot.data == null
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Connect.filesUrl}${asyncSnapshot.data}",
                                        fit: BoxFit.cover,
                                        width: 130.0,
                                        height: 130.0,
                                      ),
                                    ),
                                    // Image.network(src)
                                  ],
                                );
                        }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: StreamBuilder(
                stream: _videoChannelDetailsListBloc.nameStream,
                builder: (BuildContext context,
                    AsyncSnapshot<String> asyncSnapshot) {
                  return asyncSnapshot.data == null
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Text(
                          "${asyncSnapshot.data}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        );
                }),
          ),
          Divider(),
          Container(
            height: 635,
            child: StreamBuilder(
                stream: _videoChannelDetailsListBloc.videosListStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Videos>> asyncSnapshot) {
                  return asyncSnapshot.data == null
                      ? Container(
                          child: Center(child: Text("Loading data.....")),
                        )
                      : Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                  // physics: NeverScrollableScrollPhysics(),
                                  // primary: false,
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  itemCount: asyncSnapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return asyncSnapshot.data.length == 0
                                        ? Container(
                                            child: Center(
                                                child: Text(
                                                    "No Video To Show.....")),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: Stack(
                                              children: <Widget>[
                                                GestureDetector(
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 200.0,
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width:
                                                                        _width,
                                                                    imageUrl:
                                                                        "${Connect.filesUrl}${asyncSnapshot.data[index].thumbnail}",
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 5,
                                                                    left: 5,
                                                                    child: Card(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.4),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3.0),
                                                                            child:
                                                                                Text(
                                                                              "Views ${asyncSnapshot.data[index].views.toString()}",
                                                                              style: TextStyle(fontSize: 10.0, color: Colors.white),
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
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.4),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3.0),
                                                                            child:
                                                                                Text(
                                                                              "${asyncSnapshot.data[index].durationParsed}",
                                                                              style: TextStyle(fontSize: 10.0, color: Colors.white),
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
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 8.0),
                                                                        child:
                                                                            Text(
                                                                          asyncSnapshot.data[index].title.length > 90
                                                                              ? "${asyncSnapshot.data[index].title.substring(0, 90)}...."
                                                                              : "${asyncSnapshot.data[index].title}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                51,
                                                                                51,
                                                                                51),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 6.0, bottom: 7.0),
                                                                            child:
                                                                                Text(
                                                                              "${asyncSnapshot.data[index].name}",
                                                                              style: TextStyle(
                                                                                fontSize: 13.0,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Color.fromARGB(255, 51, 51, 51),
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
                                                  ),
                                                  onTap: () {
                                                    _navigationActions
                                                        .navigateToScreenWidget(
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
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child:
                                                              GestureDetector(
                                                            child: Icon(
                                                              Icons.star,
                                                              size: 17,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onTap: () {
                                                              print(
                                                                  "click on star");
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child:
                                                              GestureDetector(
                                                            child: Icon(
                                                                Icons
                                                                    .watch_later,
                                                                size: 17,
                                                                color: Colors
                                                                    .white),
                                                            onTap: () {
                                                              print(
                                                                  "Watch leter");
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
          ),
        ],
      ),
      // padding: EdgeInsets.only(bottom: 10),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
