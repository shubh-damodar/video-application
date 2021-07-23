import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_bloc.dart';
import 'package:video/bloc_patterns/videos/video_channel_bloc.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';

class VideoDetailsPage extends StatefulWidget {
  final String id;
  VideoDetailsPage({this.id});
  _VideoDetailsPageState createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage>
    with AutomaticKeepAliveClientMixin {
  NavigationActions _navigationActions;

  DateCategory _dateCategory = DateCategory();
  final ScrollController _scrollController = ScrollController();

  VideoChannelDetailsList _videoChannelDetailsListBloc =
      VideoChannelDetailsList();
  final VideoBloc _videoBloc = VideoBloc();
  TabController _tab3Controller;
  TextEditingController _commentArticleTextEditingController =
      TextEditingController();
  WidgetsCollection _widgetsCollection;

  void initState() {
    _navigationActions = NavigationActions(context);
    _videoBloc.getchannelVideoDetails(widget.id);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: _videoBloc.profileDetailsDataStream,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
          return asyncSnapshot.data == null
              ? Container(
                  width: 0,
                  height: 0,
                )
              : SingleChildScrollView(
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Container(
                        child: ListTile(
                          title: Text("Description"),
                          subtitle: Text(
                            "${asyncSnapshot.data['description']}",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Stats",
                                    style: TextStyle(fontSize: 17),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Joined ${_dateCategory.EEEEMMMMdDateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data['addedAt']))}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${asyncSnapshot.data['totalPlays']} Videos Plays',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Last Update ${_dateCategory.EEEEMMMMdDateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data['updatedAt']))}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${asyncSnapshot.data['subscribers']} Subscribers',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text("Details"),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text("For business inquiries :"),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 2),
                                  child:
                                      Text(" ${asyncSnapshot.data['email']}"),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10, left: 20),
                                  child: Text("Location :"),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10, left: 5),
                                  child:
                                      Text(" ${asyncSnapshot.data['country']}"),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //     margin: EdgeInsets.only(top: 20),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(0.0),
                      //       child: Column(
                      //         children: <Widget>[
                      //           ListTile(
                      //             title: Text("links"),
                      //           ),
                      //           Row(
                      //             children: <Widget>[
                      //               IconButton(
                      //                 icon: Icon(Icons.email),
                      //                 onPressed: () {
                      //                   print("object");
                      //                 },
                      //               ),
                      //               IconButton(
                      //                 icon: Icon(Icons.adb),
                      //                 onPressed: () {},
                      //               ),
                      //               IconButton(
                      //                 icon: Icon(Icons.adb),
                      //                 onPressed: () {},
                      //               ),
                      //               IconButton(
                      //                 icon: Icon(Icons.adb),
                      //                 onPressed: () {},
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     )),
                    ],
                  )),
                  padding: EdgeInsets.only(bottom: 20),
                );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
