// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:video/bloc_patterns/videos/video_bloc.dart';
// import 'package:video/models/user.dart';
// import 'package:video/models/videos.dart';
// import 'package:video/network/user_connect.dart';
// import 'package:video/screens/video/video_channel_page.dart';
// import 'package:video/utils/date_category.dart';
// import 'package:video/utils/messages_actions.dart';
// import 'package:video/utils/navigation_actions.dart';
// import 'package:video/utils/network_connectivity.dart';
// import 'package:video/utils/shared_pref_manager.dart';
// import 'package:share/share.dart';

// import 'package:video/utils/widgets_collection.dart';
// import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

// class VideoPage extends StatefulWidget {
//   final String id, previousScreen;
//   VideoPage({this.id, this.previousScreen});
//   _VideoPageState createState() => _VideoPageState();
// }

// class _VideoPageState extends State<VideoPage>
//     with SingleTickerProviderStateMixin {
//   final VideoBloc _videoBloc = VideoBloc();
//   IjkMediaController controller = IjkMediaController();
//   DateCategory _dateCategory = DateCategory();
//   double _screenWidth, _screenHeight;
//   DateTime currentBackPressDateTime;
//   List<User> _usersList = List<User>();
//   NavigationActions _navigationActions;
//   WidgetsCollection _widgetsCollection;
//   final ScrollController _scrollController = ScrollController();
//   TabController _tab3Controller;

//   TextEditingController _commentArticleTextEditingController =
//       TextEditingController();

//   bool fev = false,
//       _watchlater = false,
//       _tumbsUp = false,
//       subcribe = false,
//       tumbsDown = false,
//       viewlater = false;

//   Orientation get orientation => MediaQuery.of(context).orientation;

//   void initState() {
//     super.initState();
//     _tab3Controller = TabController(length: 3, vsync: this, initialIndex: 0);
//     SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
//       NetworkConnectivity.of(context).checkNetworkConnection();
//     });
//     _getAllUsers();
//     _navigationActions = NavigationActions(context);
//     _widgetsCollection = WidgetsCollection(context);
//     _videoBloc.getVideoDetails(widget.id);
//     _videoBloc.getRelatedVideo(widget.id);
//     _videoBloc.getVideoLink(widget.id);
//     _videoBloc.getCommentList(widget.id);
//   }

//   Widget _getLinkadress(String urlLink) {
//     controller.setDataSource(
//         DataSource.network(
//           "$urlLink",
//         ),
//         autoPlay: true);
//     return Container(
//       height: 200,
//       child: IjkPlayer(
//         mediaController: controller,
//       ),
//     );
//   }

//   // Widget _buildControllerWidget(IjkMediaController controller) {
//   //   return DefaultIJKControllerWidget(
//   //     controller: controller,
//   //     verticalGesture: false,
//   //   );
//   // }
//   // _refresh() async {
//   //   await Future.delayed(Duration.zero, () {
//   //     setState(() {
//   //       // super.initState();
//   //       // _videoBloc.getVideoList(widget.id);
//   //       // _videoBloc.getRelatedVideo(widget.id);
//   //     });
//   //   });
//   // }

//   void dispose() {
//     super.dispose();
//     controller.getVideoInfo();
//     _videoBloc.dispose();
//     _scrollController.dispose();
//     controller.dispose();
//     _tab3Controller.dispose();
//   }

//   Future<void> _getAllUsers() async {
//     await SharedPrefManager.getAllUsers().then((List<User> user) {
//       setState(() {
//         _usersList = user;
//       });
//     });
//   }

//   Future<bool> _onWillPop() async {
//     _navigationActions.previousScreen();
//   }

//   String channelId;

//   Widget _getChannelId(String data) {
//     channelId = data;

//     return Container(
//       width: 0,
//       height: 0,
//     );
//   }

//   // _buildPlayerItem() {
//   //   return Container(
//   //     height: 200,
//   //     child: IjkPlayer(
//   //       mediaController: controller,
//   //     ),
//   //   );
//   // }

//   Widget build(BuildContext context) {
//     _screenWidth = MediaQuery.of(context).size.width;
//     _screenHeight = MediaQuery.of(context).size.height;
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//           appBar: AppBar(
//             iconTheme: new IconThemeData(color: Colors.black),
//             backgroundColor: Colors.white,
//             centerTitle: true,
//             title: Text(
//               'Video',
//               style: TextStyle(color: Colors.black, fontSize: 14),
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Container(
//               child: Column(
//                 children: <Widget>[
//                   // StreamBuilder(
//                   //   stream: _videoBloc.linkAddressStream,
//                   //   builder: (BuildContext context,
//                   //       AsyncSnapshot<String> asyncSnapshot) {
//                   //     return _getLinkadress(asyncSnapshot.data);
//                   //   },
//                   // ),
//                   StreamBuilder(
//                       stream: _videoBloc.channelIdStream,
//                       builder: (BuildContext context,
//                           AsyncSnapshot<String> asyncSnapshot) {
//                         return asyncSnapshot.data == null
//                             ? Container(width: 0.0, height: 0.0)
//                             : _getChannelId(asyncSnapshot.data);
//                       }),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15.0, left: 15.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         StreamBuilder(
//                             stream: _videoBloc.titleStream,
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<String> asyncSnapshot) {
//                               return Expanded(
//                                 child: Text(
//                                   asyncSnapshot.data == null
//                                       ? ''
//                                       : asyncSnapshot.data,
//                                   overflow: TextOverflow.fade,
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               );
//                             }),
//                       ],
//                     ),
//                   ),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         StreamBuilder(
//                             stream: _videoBloc.watchLaterStream,
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<bool> asyncSnapshot) {
//                               return asyncSnapshot.data == null
//                                   ? Container()
//                                   : IconButton(
//                                       icon: asyncSnapshot.data == !_watchlater
//                                           ? Icon(Icons.access_time,
//                                               color: Colors.deepOrange,
//                                               size: 20.0)
//                                           : Icon(Icons.access_time,
//                                               color: Colors.grey, size: 20.0),
//                                       onPressed: () {
//                                         _watchlater = !_watchlater;
//                                         setState(() {
//                                           asyncSnapshot.data == !_watchlater
//                                               ? _videoBloc
//                                                   .addWatchLater(widget.id)
//                                               : _videoBloc.watchLaterMarkRemove(
//                                                   widget.id);
//                                         });
//                                       },
//                                     );
//                             }),
//                         StreamBuilder(
//                             stream: _videoBloc.favouriteStatusStream,
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<bool> asyncSnapshot) {
//                               return asyncSnapshot.data == null
//                                   ? Container()
//                                   : IconButton(
//                                       icon: asyncSnapshot.data == !fev
//                                           ? Icon(Icons.star,
//                                               color: Colors.deepOrange,
//                                               size: 20.0)
//                                           : Icon(Icons.star,
//                                               color: Colors.grey, size: 20.0),
//                                       onPressed: () {
//                                         fev = !fev;
//                                         setState(() {
//                                           asyncSnapshot.data == !fev
//                                               ? _videoBloc.favouritesAction(
//                                                   widget.id, 'add')
//                                               : _videoBloc.favouritesAction(
//                                                   widget.id, "remove");
//                                         });
//                                       },
//                                     );
//                             }),
//                         StreamBuilder(
//                             stream: _videoBloc.likeStatusStream,
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<bool> asyncSnapshot) {
//                               return asyncSnapshot.data == null
//                                   ? Container(
//                                       width: 0,
//                                       height: 0,
//                                     )
//                                   : IconButton(
//                                       icon: asyncSnapshot.data == !_tumbsUp
//                                           ? Icon(Icons.thumb_up,
//                                               color: Colors.red, size: 20.0)
//                                           : Icon(Icons.thumb_up,
//                                               color: Colors.grey, size: 20.0),
//                                       onPressed: () {
//                                         // asyncSnapshot.data == !_tumbsUp
//                                         //     ? _widgetsCollection
//                                         //         .showToastMessage(
//                                         //             "Removed from Favourite ")
//                                         //     : _widgetsCollection
//                                         //         .showToastMessage(
//                                         //             "Added to Favourite");
//                                         _tumbsUp = !_tumbsUp;
//                                         setState(() {
//                                           asyncSnapshot.data == !_tumbsUp
//                                               ? _videoBloc.likeVideo(
//                                                   widget.id, "likes")
//                                               : _videoBloc.dislikeVideo(
//                                                   widget.id, "likes");
//                                         });
//                                       },
//                                     );
//                             }),
//                         StreamBuilder(
//                             stream: _videoBloc.unlikeStatusStream,
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<bool> asyncSnapshot) {
//                               return asyncSnapshot.data == null
//                                   ? Container(
//                                       width: 0,
//                                       height: 0,
//                                     )
//                                   : IconButton(
//                                       icon: asyncSnapshot.data == !tumbsDown
//                                           ? Icon(Icons.thumb_down,
//                                               color: Colors.red, size: 20.0)
//                                           : Icon(Icons.thumb_down,
//                                               color: Colors.grey, size: 20.0),
//                                       onPressed: () {
//                                         // asyncSnapshot.data == !tumbsDown
//                                         //     ? _widgetsCollection
//                                         //         .showToastMessage(
//                                         //             "Removed from Favourite ")
//                                         //     : _widgetsCollection
//                                         //         .showToastMessage(
//                                         //             "Added to Favourite");
//                                         tumbsDown = !tumbsDown;
//                                         setState(() {
//                                           asyncSnapshot.data == !tumbsDown
//                                               ? _videoBloc.likeVideo(
//                                                   widget.id, "unlikes")
//                                               : _videoBloc.dislikeVideo(
//                                                   widget.id, "unlikes");
//                                         });
//                                       },
//                                     );
//                             }),
//                         InkWell(
//                           child: Icon(
//                             Icons.share,
//                             size: 20,
//                           ),
//                           onTap: () {
//                             Share.share(
//                                 'https://www.mesbro.com/1/videos/watch/${widget.id}');
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(),
//                   Padding(
//                       padding: const EdgeInsets.all(0.0),
//                       child: StreamBuilder(
//                           stream: _videoBloc.channelIdStream,
//                           builder: (BuildContext context,
//                               AsyncSnapshot<String> asyncSnapshot) {
//                             return GestureDetector(
//                               onTap: () {
//                                 _navigationActions.navigateToScreenWidget(
//                                     VideoChannelPage(
//                                         userId: asyncSnapshot.data));
//                               },
//                               child: ListTile(
//                                 leading: ClipRRect(
//                                   borderRadius: BorderRadius.circular(4.0),
//                                   child: StreamBuilder(
//                                       stream: _videoBloc.coverPictureStream,
//                                       builder: (BuildContext context,
//                                           AsyncSnapshot<String> asyncSnapshot) {
//                                         return asyncSnapshot.data == null
//                                             ? Container(
//                                                 child: Image.asset(
//                                                   'assets/images/male-avatar.png',
//                                                   fit: BoxFit.contain,
//                                                   height: 45,
//                                                   width: 45,
//                                                 ),
//                                               )
//                                             : CachedNetworkImage(
//                                                 imageUrl:
//                                                     "${Connect.filesUrl}${asyncSnapshot.data}",
//                                                 fit: BoxFit.contain,
//                                                 height: 45,
//                                                 width: 45,
//                                                 placeholder:
//                                                     (BuildContext context,
//                                                         String url) {
//                                                   return Image.asset(
//                                                     'assets/images/male-avatar.png',
//                                                     fit: BoxFit.contain,
//                                                     height: 45,
//                                                     width: 45,
//                                                   );
//                                                 },
//                                               );
//                                       }),
//                                 ),
//                                 title: Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                       child: StreamBuilder(
//                                           stream: _videoBloc.nameStream,
//                                           builder: (BuildContext context,
//                                               AsyncSnapshot<String>
//                                                   asyncSnapshot) {
//                                             return Container(
//                                               width: 5,
//                                               child: asyncSnapshot.data == null
//                                                   ? Container(
//                                                       child: Text("loading.."),
//                                                     )
//                                                   : Text(
//                                                       "${asyncSnapshot.data}",
//                                                       style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w600),
//                                                       overflow:
//                                                           TextOverflow.fade,
//                                                       maxLines: 3,
//                                                     ),
//                                             );
//                                           }),
//                                     ),
//                                   ],
//                                 ),
//                                 subtitle: StreamBuilder(
//                                     stream:
//                                         _videoBloc.subscribersofChannelStream,
//                                     builder: (BuildContext context,
//                                         AsyncSnapshot<String> asyncSnapshot) {
//                                       return asyncSnapshot.data == null
//                                           ? Container(
//                                               child: Text("loading.."),
//                                             )
//                                           : Text(
//                                               "${asyncSnapshot.data} Subscribers",
//                                               style: TextStyle(fontSize: 11),
//                                             );
//                                     }),
//                                 trailing: SizedBox(
//                                   width: 120,
//                                   child: StreamBuilder(
//                                       stream:
//                                           _videoBloc.subscriptionStatusStream,
//                                       builder: (BuildContext context,
//                                           AsyncSnapshot<bool> asyncSnapshot) {
//                                         return asyncSnapshot.data == !subcribe
//                                             ? RaisedButton(
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5.0)),
//                                                 color: Colors.grey,
//                                                 child: Text(
//                                                   "Unubscribe",
//                                                   style: TextStyle(
//                                                       color: Colors.white),
//                                                 ),
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _videoBloc
//                                                         .subscribeAndUnsubscribe(
//                                                             'unsubscribe',
//                                                             channelId,
//                                                             widget.id);
//                                                   });
//                                                 },
//                                               )
//                                             : RaisedButton(
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5.0)),
//                                                 color: Colors.deepOrange,
//                                                 child: Text("Subscribe",
//                                                     style: TextStyle(
//                                                         color: Colors.white)),
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _videoBloc
//                                                         .subscribeAndUnsubscribe(
//                                                             'subscribe',
//                                                             channelId,
//                                                             widget.id);
//                                                   });
//                                                 },
//                                               );
//                                       }),
//                                 ),
//                               ),
//                             );
//                           })),
//                   Divider(),
//                   Container(
//                       height: MediaQuery.of(context).size.height / 1.70,
//                       child: Column(children: <Widget>[
//                         TabBar(
//                             labelStyle: TextStyle(
//                                 fontWeight: FontWeight.w500, fontSize: 14.0),
//                             indicatorColor: Colors.deepOrange,
//                             labelColor: Colors.deepOrange,
//                             unselectedLabelColor: Colors.grey,
//                             controller: _tab3Controller,
//                             tabs: <Widget>[
//                               Tab(text: 'Related Video'),
//                               Tab(text: 'Comments'),
//                               Tab(text: 'Channel Details'),
//                             ]),
//                         Expanded(
//                             child: StreamBuilder(
//                                 stream: _videoBloc.relatedVideoListStream,
//                                 builder: (BuildContext context,
//                                     AsyncSnapshot<List<Videos>> asyncSnapshot) {
//                                   return asyncSnapshot.data == null
//                                       ? Container(
//                                           child: Center(child: Text("Loading")),
//                                         )
//                                       : TabBarView(
//                                           controller: _tab3Controller,
//                                           children: <Widget>[
//                                             ListView.builder(
//                                                 padding:
//                                                     const EdgeInsets.all(10.0),
//                                                 scrollDirection: Axis.vertical,
//                                                 shrinkWrap: true,
//                                                 physics:
//                                                     ClampingScrollPhysics(),
//                                                 itemCount:
//                                                     asyncSnapshot.data.length,
//                                                 itemBuilder:
//                                                     (BuildContext context,
//                                                         int index) {
//                                                   return asyncSnapshot
//                                                               .data.length ==
//                                                           null
//                                                       ? Container(
//                                                           height: 0,
//                                                           width: 0,
//                                                         )
//                                                       : Container();
//                                                 }),
//                                             Container(
//                                                 child: Stack(
//                                               children: <Widget>[
//                                                 Container(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 20),
//                                                   child: Column(
//                                                     children: <Widget>[
//                                                       Container(
//                                                         height: 200,
//                                                         child: Stack(
//                                                           children: <Widget>[
//                                                             TextField(
//                                                               maxLines: 4,
//                                                               decoration: InputDecoration(
//                                                                   focusColor: Colors
//                                                                       .deepOrange,
//                                                                   fillColor: Colors
//                                                                       .deepOrange,
//                                                                   hoverColor: Colors
//                                                                       .deepOrange,
//                                                                   border:
//                                                                       OutlineInputBorder(),
//                                                                   hintText:
//                                                                       'Your Comment here',
//                                                                   hintStyle: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w400,
//                                                                       fontSize:
//                                                                           14.0,
//                                                                       fontFamily:
//                                                                           'Poppins')),
//                                                               controller:
//                                                                   _commentArticleTextEditingController,
//                                                             ),
//                                                             Positioned(
//                                                               bottom: 0,
//                                                               right: 5,
//                                                               child:
//                                                                   RaisedButton(
//                                                                 shape: RoundedRectangleBorder(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             5.0)),
//                                                                 color: Colors
//                                                                     .deepOrange,
//                                                                 onPressed: () {
//                                                                   _videoBloc.commentVideo(
//                                                                       widget.id,
//                                                                       _commentArticleTextEditingController
//                                                                           .text);
//                                                                   _commentArticleTextEditingController
//                                                                       .clear();
//                                                                   _widgetsCollection
//                                                                       .showToastMessage(
//                                                                           "Commented");
//                                                                 },
//                                                                 child: Text(
//                                                                   "Comment",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .white),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             )),
//                                             Container(
//                                                 margin:
//                                                     EdgeInsets.only(top: 20),
//                                                 child: Stack(
//                                                   children: <Widget>[
//                                                     Column(
//                                                       children: <Widget>[
//                                                         Container(
//                                                           child: ListTile(
//                                                             title: Text(
//                                                                 "Published On 29 Mar, 2019"),
//                                                             subtitle: Text(
//                                                                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, rum."),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                                   top: 20),
//                                                           child: Column(
//                                                             children: <Widget>[
//                                                               ListTile(
//                                                                 title: Text(
//                                                                     "Details"),
//                                                               ),
//                                                               Row(
//                                                                 children: <
//                                                                     Widget>[
//                                                                   Container(
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                             left:
//                                                                                 20),
//                                                                     child: Text(
//                                                                         "For business inquiries :  "),
//                                                                   ),
//                                                                   Container(
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                             left:
//                                                                                 2),
//                                                                     child: Text(
//                                                                         "ajsndkja@mail.com"),
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                               Row(
//                                                                 children: <
//                                                                     Widget>[
//                                                                   Container(
//                                                                     padding: EdgeInsets.only(
//                                                                         top: 10,
//                                                                         left:
//                                                                             20),
//                                                                     child: Text(
//                                                                         "Location :"),
//                                                                   ),
//                                                                   Container(
//                                                                     padding: EdgeInsets.only(
//                                                                         top: 10,
//                                                                         left:
//                                                                             5),
//                                                                     child: Text(
//                                                                         "India"),
//                                                                   )
//                                                                 ],
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                                   top: 20),
//                                                           child: ListTile(
//                                                             title:
//                                                                 Text("Links"),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 )),
//                                           ],
//                                         );
//                                 }))
//                       ])),
//                   Container(
//                     child: Row(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(left: 20, top: 20),
//                           child: Text(
//                             "Comments",
//                             style: TextStyle(fontWeight: FontWeight.w700),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                       height: 200,
//                       margin: EdgeInsets.only(top: 0),
//                       child: StreamBuilder(
//                           stream: _videoBloc.commentListStream,
//                           builder: (BuildContext context,
//                               AsyncSnapshot<List<Videos>> asyncSnapshot) {
//                             return asyncSnapshot.data == null
//                                 ? Text("No Comments on this Video")
//                                 : ListView.builder(
//                                     padding: EdgeInsets.only(top: 10),
//                                     itemCount: asyncSnapshot.data.length,
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       return asyncSnapshot.data.length == 0
//                                           ? Text("No Comments on this Video")
//                                           : Container(
//                                               child: ListTile(
//                                                 leading: CachedNetworkImage(
//                                                   fit: BoxFit.cover,
//                                                   height: 50,
//                                                   width: 50,
//                                                   imageUrl:
//                                                       "${Connect.filesUrl}${asyncSnapshot.data[index].profileImage}",
//                                                 ),
//                                                 title: Row(
//                                                   children: <Widget>[
//                                                     Text(
//                                                         '${asyncSnapshot.data[index].name}'),
//                                                     SizedBox(
//                                                       width: 16.0,
//                                                     ),
//                                                     // Text(
//                                                     //   "_model.datetime",
//                                                     // ),
//                                                   ],
//                                                 ),
//                                                 subtitle: Text(
//                                                   '${asyncSnapshot.data[index].details}',
//                                                   overflow: TextOverflow.clip,
//                                                 ),
//                                                 // trailing: Icon(
//                                                 //   Icons.arrow_forward_ios,
//                                                 // ),
//                                               ),
//                                             );
//                                     },
//                                   );
//                           }))
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }

// //  Padding(
// //                 padding: const EdgeInsets.all(20.0),
// //                 child: TextField(
// //                   maxLines: 2,
// //                   decoration: InputDecoration(
// //                       suffixIcon: IconButton(
// //                           icon: Icon(Icons.reply, color: Colors.deepOrange),
// //                           onPressed: () {
// //                             _videoBloc.commentVideo(
// //                                 data, _singleEditingController.text);
// //                             _singleEditingController.clear();
// //                             _navigationActions.previousScreenUpdate();
// //                           }),
// //                       // focusColor: Colors.deepOrange,
// //                       // fillColor: Colors.deepOrange,`
// //                       // hoverColor: Colors.deepOrange,
// //                       border: OutlineInputBorder(),
// //                       hintText: 'Your Comment here',
// //                       hintStyle: TextStyle(
// //                           fontWeight: FontWeight.w400,
// //                           fontSize: 14.0,
// //                           fontFamily: 'Poppins')),
// //                   controller: _singleEditingController,
// //                 ),
// //               ),


// //  return StreamBuilder(
// //               stream: _videoBloc.nastedcommentListStream,
// //               builder: (BuildContext context,
// //                   AsyncSnapshot<List<Videos>> asyncSnapshot) {
// //                 return asyncSnapshot.data == null
// //                     ? Container(
// //                         width: 0,
// //                         height: 0,
// //                       )
// //                     : Wrap(
// //                         children: <Widget>[
// //                           Padding(
// //                             padding: const EdgeInsets.only(left: 15.0, top: 5),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.start,
// //                               children: <Widget>[Text("Reply")],
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: const EdgeInsets.only(
// //                                 right: 10.0, left: 10.0, top: 5),
// //                             child: TextField(
// //                               maxLines: 2,
// //                               decoration: InputDecoration(
// //                                   suffixIcon: IconButton(
// //                                       icon: Icon(Icons.reply,
// //                                           color: Colors.deepOrange),
// //                                       onPressed: () {
// //                                         _videoBloc.commentVideo(data,
// //                                             _singleEditingController.text);
// //                                         _singleEditingController.clear();
// //                                         _navigationActions
// //                                             .previousScreenUpdate();
// //                                         setState(() {});
// //                                       }),
// //                                   border: OutlineInputBorder(),
// //                                   hintText: 'Your Comment here',
// //                                   hintStyle: TextStyle(
// //                                       fontWeight: FontWeight.w400,
// //                                       fontSize: 14.0,
// //                                       fontFamily: 'Poppins')),
// //                               controller: _singleEditingController,
// //                             ),
// //                           ),
// //                           Padding(
// //                             padding: const EdgeInsets.only(left: 15.0, top: 5),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.start,
// //                               children: <Widget>[Text("Comments")],
// //                             ),
// //                           ),
// //                           Container(
// //                             height: 400,
// //                             child: ListView.builder(
// //                               itemCount: asyncSnapshot.data.length,
// //                               itemBuilder: (BuildContext context, int index) {
// //                                 return asyncSnapshot.data.length == null
// //                                     ? Container(
// //                                         height: 0,
// //                                         width: 0,
// //                                       )
// //                                     : ListTile(
// //                                         leading: CachedNetworkImage(
// //                                           fit: BoxFit.cover,
// //                                           height: 50,
// //                                           width: 50,
// //                                           imageUrl:
// //                                               "${Connect.filesUrl}${asyncSnapshot.data[index].profileImage}",
// //                                         ),
// //                                         title: Row(
// //                                           children: <Widget>[
// //                                             Text(
// //                                               '${asyncSnapshot.data[index].name}',
// //                                               style: TextStyle(fontSize: 14),
// //                                             ),
// //                                             SizedBox(
// //                                               width: 16.0,
// //                                             ),
// //                                           ],
// //                                         ),
// //                                         subtitle: Column(
// //                                           crossAxisAlignment:
// //                                               CrossAxisAlignment.start,
// //                                           children: <Widget>[
// //                                             Text(
// //                                               asyncSnapshot.data[index]
// //                                                           .details ==
// //                                                       null
// //                                                   ? ""
// //                                                   : asyncSnapshot.data[index]
// //                                                               .details.length >
// //                                                           90
// //                                                       ? "${asyncSnapshot.data[index].details.substring(0, 90)}"
// //                                                       : asyncSnapshot
// //                                                           .data[index].details,
// //                                               overflow: TextOverflow.clip,
// //                                               style: TextStyle(fontSize: 12),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       );
// //                               },
// //                             ),
// //                             padding: EdgeInsets.only(bottom: 80),
// //                           )
// //                         ],
// //                       );
// //               });

