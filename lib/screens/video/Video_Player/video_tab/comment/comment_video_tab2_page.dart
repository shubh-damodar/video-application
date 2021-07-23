import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video/bloc_patterns/videos/video_bloc.dart';
import 'package:video/bloc_patterns/videos/video_channel_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_tab/comment/nasted_comments_page.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';

class CommentVideoPage extends StatefulWidget {
  CommentVideoPage({this.id});

  final String id;

  _CommentVideoPageState createState() => _CommentVideoPageState();
}

class _CommentVideoPageState extends State<CommentVideoPage>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _commentArticleTextEditingController =
          TextEditingController(),
      _singleEditingController = TextEditingController();

  DateCategory _dateCategory = DateCategory();
  DateFormat _dateFormat = DateFormat('MMM dd yyyy');
  final ScrollController _scrollController = ScrollController();
  TabController _tab3Controller;
  final VideoBloc _videoBloc = VideoBloc();
  VideoChannelDetailsList _videoChannelDetailsListBloc =
      VideoChannelDetailsList();

  WidgetsCollection _widgetsCollection;
  NavigationActions _navigationActions;

  @override
  bool get wantKeepAlive => false;

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _videoBloc.getCommentList(widget.id);
  }

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
                _videoBloc.deleteComment("${widget.id}", "$articleId");
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

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    focusColor: Colors.deepOrange,
                    fillColor: Colors.deepOrange,
                    hoverColor: Colors.deepOrange,
                    border: OutlineInputBorder(),
                    hintText: 'Your Comment here',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  controller: _commentArticleTextEditingController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: RaisedButton(
                        child: Text(
                          "Comment",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Colors.deepOrange,
                        onPressed: () {
                          _videoBloc.commentVideo(
                            widget.id,
                            _commentArticleTextEditingController.text,
                          );
                          _commentArticleTextEditingController.clear();
                          _widgetsCollection
                              .showToastMessage("Comment Posted successfully");
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Divider(),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    "Comments",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 500,
              child: StreamBuilder(
                  stream: _videoBloc.commentListStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Videos>> asyncSnapshot) {
                    return asyncSnapshot.data == null
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : asyncSnapshot.data.length == 0
                            ? Center(
                                child: Text(
                                    "No Comments on this Video..................."),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                itemCount: asyncSnapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: ListTile(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            asyncSnapshot.data[index].details ==
                                                    null
                                                ? ""
                                                : asyncSnapshot.data[index]
                                                            .details.length >
                                                        90
                                                    ? "${asyncSnapshot.data[index].details.substring(0, 90)}"
                                                    : "${asyncSnapshot.data[index].details}",
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                                      "${asyncSnapshot.data[index].id}",
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.reply,
                                                    size: 14,
                                                  )),
                                              asyncSnapshot
                                                          .data[index].userId ==
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
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox.shrink()
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: Text(
                                              "${_dateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data[index].dateOfAddon))}",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                  }))
        ],
      ),
    );
  }
}
