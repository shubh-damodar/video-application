import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video/bloc_patterns/videos/video_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_tab/comment/nasted_comments_page.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';

class NastedCommentList extends StatefulWidget {
  NastedCommentList({this.id, this.commentId, this.parentId});
  final String id, commentId, parentId;
  @override
  _NastedCommentListState createState() => _NastedCommentListState();
}

class _NastedCommentListState extends State<NastedCommentList> {
  final VideoBloc _videoBloc = VideoBloc();
  DateFormat _dateFormat = DateFormat('MMM dd yyyy');
  WidgetsCollection _widgetsCollection;
  NavigationActions _navigationActions;

  @override
  void initState() {
    _videoBloc.getNastedCommentList(widget.id);
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _settingModalBottomSheet(id) async {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        useRootNavigator: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return new PopUp(
            parentId: id,
            commentId: widget.id,
            id: widget.commentId,
          );
        });
  }

  void _showDialog(String articleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Favourite Article"),
          content: Text("Do yo want to remove all Favourite Articles?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                _videoBloc.deleteNastedComment(
                  "${widget.id}",
                  "${widget.commentId}",
                  "$articleId",
                );
                Navigator.of(context).pop(false);
                _widgetsCollection.showToastMessage("Text Removed");
                // setState(() {
                //   _navigationActions
                //       .navigateToScreenWidget(ExploreArticlePage());
                // });
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _videoBloc.nastedcommentListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Videos>> asyncSnapshot) {
          return asyncSnapshot.data == null
              ? Container(
                  child: Center(child: Text("loading comments....")),
                )
              : Container(
                  height: 300,
                  child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    itemCount: asyncSnapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return asyncSnapshot.data.length == null
                          ? Container(
                              child: Text("No Comments....."),
                            )
                          : ListTile(
                              leading: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                                imageUrl:
                                    "${Connect.filesUrl}${asyncSnapshot.data[index].profileImage}",
                              ),
                              title: Row(
                                children: <Widget>[
                                  Text(
                                    '${asyncSnapshot.data[index].name}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    asyncSnapshot.data[index].details == null
                                        ? ""
                                        : asyncSnapshot.data[index].details
                                                    .length >
                                                90
                                            ? "${asyncSnapshot.data[index].details.substring(0, 90)}"
                                            : asyncSnapshot.data[index].details,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  GestureDetector(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          asyncSnapshot.data[index]
                                                      .repliesCount ==
                                                  0
                                              ? ''
                                              : 'Show ${asyncSnapshot.data[index].repliesCount} Replies',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.0,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _settingModalBottomSheet(
                                        "${asyncSnapshot.data[index].id}",
                                      );
                                    },
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Icon(
                                          Icons.thumb_up,
                                          size: 14,
                                        ),
                                        onTap: () {
                                          print("like Button");
                                        },
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${asyncSnapshot.data[index].likes.toString()}",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _settingModalBottomSheet(
                                              asyncSnapshot.data[index].id);
                                        },
                                        child: Icon(
                                          Icons.reply,
                                          size: 14,
                                        ),
                                      ),
                                      asyncSnapshot.data[index].userId ==
                                              Connect.currentUser.userId
                                          ? Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 14,
                                                  ),
                                                  onTap: () {
                                                    _showDialog(
                                                        "${asyncSnapshot.data[index].id}");
                                                  },
                                                )
                                              ],
                                            )
                                          : SizedBox.shrink()
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      "${_dateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data[index].dateOfAddon))}",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                  )
                                ],
                              ),
                            );
                    },
                  ),
                  // padding: EdgeInsets.only(bottom: 80),
                );
        });
  }
}
