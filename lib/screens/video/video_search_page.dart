import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video/bloc_patterns/videos/search_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_page.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';

class SearchPage extends StatefulWidget {
  List<Videos> videoList = List<Videos>();
  String videoType;
  Map jsonMap;

  SearchPage({this.videoList, this.videoType, this.jsonMap});

  _SearchPageState createState() => _SearchPageState(jsonMap: this.jsonMap);
}

class _SearchPageState extends State<SearchPage> {
  final Map jsonMap;
  _SearchPageState({this.jsonMap});
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  DateCategory _dateCategory = DateCategory();
  SearchBloc _searchBloc;
  final ScrollController _scrollController = ScrollController();
  bool _isMessageRead;

  double _screenWidth, _screenHeight;
  void _onWillPop() async {
    _navigationActions.closeDialog();
  }

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _searchBloc = SearchBloc(videoList: widget.videoList);
    // _searchBloc = SearchBloc(mailsList: widget.emailsList);
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //           _scrollController.position.maxScrollExtent &&
    //       _searchBloc.articleList.length % 20 == 0) {
    //     //print('~~~ _scrollController');
    //   }
    // });
  }

  void dispose() {
    super.dispose();
    _searchBloc.dispose();
    _scrollController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: StreamBuilder(
            stream: _searchBloc.mailSubjectShortTextStream,
            builder:
                (BuildContext context, AsyncSnapshot<String> asyncSnapshot) {
              return Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: TextField(
                    autofocus: true,
                    onChanged: (String value) {
                      _searchBloc.searchBox(value, jsonMap);
                    },
                    decoration: InputDecoration(
                      hoverColor: Colors.black,
                      focusColor: Colors.black,
                      prefix: Container(
                          // color: Colors.black,
                          transform: Matrix4.translationValues(0.0, 10.0, 1.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: _onWillPop,
                          )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.black,
                      )),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.15),
                      hintText: 'Search....',
                    ),
                  ));
            }),
      ),
      body: Container(
        // margin: EdgeInsets.only(top: 1.0),
        child: StreamBuilder(
            stream: _searchBloc.emailsFoundStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<Videos>> asyncSnapshot) {
              return new Column(
                children: <Widget>[
                  new Expanded(
                    child: asyncSnapshot.data == null
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Column(
                                children: [0, 1, 2, 3]
                                    .map((_) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
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
                                child: Text('No Videos.....'),
                              ))
                            : ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(),
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: asyncSnapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Container(
                                      // elevation: 0.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Container(
                                                child: Row(
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      height: 100,
                                                      width: 170,
                                                      imageUrl:
                                                          "${Connect.filesUrl}${asyncSnapshot.data[index].thumbnail}",
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      child: Card(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: new Text(
                                                                "Views ${asyncSnapshot.data[index].views.toString()}",
                                                                style: new TextStyle(
                                                                    fontSize:
                                                                        8.0,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Card(
                                                        color: Colors.black87
                                                            .withOpacity(0.8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: new Text(
                                                                "${asyncSnapshot.data[index].durationParsed}",
                                                                style: new TextStyle(
                                                                    fontSize:
                                                                        8.0,
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
                                                Expanded(
                                                  child: new Container(
                                                    height: 180.0,
                                                    width: _screenWidth,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: new Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        new Text(
                                                          '${asyncSnapshot.data[index].title}',
                                                          maxLines: 3,

                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 13),
                                                          // style: titleStyle,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        new Text(
                                                          asyncSnapshot
                                                              .data[index].name,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                        ),
                                                        new Text(
                                                          '${asyncSnapshot.data[index].addedAt}',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                          // style: titleStyle,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))),
                                      ),
                                    ),
                                    onTap: () {
                                      print("object");
                                      _navigationActions.navigateToScreenWidget(
                                          VideoPage(
                                              id: asyncSnapshot.data[index].id,
                                              previousScreen: 'explore_page'));
                                    },
                                  );
                                }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
