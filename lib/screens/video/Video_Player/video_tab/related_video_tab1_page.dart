import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_page.dart';
import 'package:video/utils/navigation_actions.dart';

class RelatedVideoPage extends StatefulWidget {
  final String id;
  RelatedVideoPage({this.id});
  _RelatedVideoPageState createState() => _RelatedVideoPageState();
}

class _RelatedVideoPageState extends State<RelatedVideoPage>
    with AutomaticKeepAliveClientMixin {
  VideoPage videoPage = VideoPage();

  final ScrollController _scrollController = ScrollController();
  NavigationActions _navigationActions;

  final VideoBloc _videoBloc = VideoBloc();
  TabController _tab3Controller;
  double _screenWidth, _screenHeight;

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _videoBloc.getRelatedVideo(widget.id);
  }

  void dispose() {
    super.dispose();
    // _videoBloc.dispose();
    // _scrollController.dispose();
    // _tab3Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: _videoBloc.relatedVideoListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Videos>> asyncSnapshot) {
          return asyncSnapshot.data == null
              ? Container(
                  child: Center(child: Text("Loading Videos.........")),
                )
              : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: asyncSnapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return asyncSnapshot.data.length == null
                        ? Container(
                            child: Center(
                                child: Text("No Video To Show.............")),
                          )
                        : GestureDetector(
                            onTap: () {
                              _navigationActions.navigateToScreenWidget(
                                  VideoPage(
                                      id: asyncSnapshot.data[index].id,
                                      previousScreen: 'explore_page'));
                            },
                            child: SizedBox(
                              height: 110,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      AspectRatio(
                                        aspectRatio: 1.5,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              "${Connect.filesUrl}${asyncSnapshot.data[index].thumbnail}",
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: Card(
                                          color: Colors.black.withOpacity(0.4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                    "View ${asyncSnapshot.data[index].views.toString()}",
                                                    style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.white)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Card(
                                          color: Colors.black.withOpacity(0.4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                    "${asyncSnapshot.data[index].durationParsed}",
                                                    style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.white)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10.0, 0.0, 2.0, 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    ' ${asyncSnapshot.data[index].title}',
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 2.0)),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    '${asyncSnapshot.data[index].name}',
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${asyncSnapshot.data[index].addedAt}',
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                          );
                  });
        });
  }

  @override
  bool get wantKeepAlive => true;
}
