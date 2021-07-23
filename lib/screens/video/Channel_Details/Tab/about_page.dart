import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_channel_bloc.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';

class AboutPage extends StatefulWidget {
  final String userId;
  AboutPage({this.userId});
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with AutomaticKeepAliveClientMixin {
  _AboutPageState({this.userId});
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
  }

  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: _videoChannelDetailsListBloc.profileDetailsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
                  return asyncSnapshot.data == null
                      ? Container(
                          child: Text("No Data Is Available"),
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              child: ListTile(
                                title: Text("Description"),
                                subtitle: Text(
                                    "${asyncSnapshot.data['description']}"),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
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
                                          'Joined ${_dateCategory.EEEEMMMMDateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data['addedAt']))}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            '${asyncSnapshot.data['totalPlays']} Videos Plays',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Last Update ${_dateCategory.EEEEMMMMDateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data['updatedAt']))}',
                                            style:
                                                TextStyle(color: Colors.grey),
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
                                            style:
                                                TextStyle(color: Colors.grey),
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
                                        child: Text(
                                            " ${asyncSnapshot.data['email']}"),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.only(top: 10, left: 20),
                                        child: Text("Location :"),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(top: 10, left: 5),
                                        child: Text(
                                            " ${asyncSnapshot.data['country']}"),
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
                        );
                }),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
