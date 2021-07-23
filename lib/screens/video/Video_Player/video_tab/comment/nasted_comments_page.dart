import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/screens/video/Video_Player/video_tab/comment/nasted_comment_list.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';

class PopUp extends StatefulWidget {
  PopUp({this.parentId, this.commentId, this.id});

  final String parentId, commentId, id;
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  final VideoBloc _videoBloc = VideoBloc();
  TextEditingController _singleEditingController = TextEditingController();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;

  @override
  void initState() {
    _widgetsCollection = WidgetsCollection(context);
    _navigationActions = NavigationActions(context);
    _videoBloc.getNastedCommentList(widget.parentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder(
            stream: _videoBloc.nastedcommentListStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<Videos>> asyncSnapshot) {
              return asyncSnapshot.data == null
                  ? Container(
                      width: 0,
                      height: 0,
                    )
                  : Wrap(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Reply"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, left: 10.0, top: 5),
                          child: TextField(
                            maxLines: 2,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.reply,
                                        color: Colors.deepOrange),
                                    onPressed: () {
                                      setState(() {});
                                      _videoBloc.addNastedComment(
                                          widget.parentId,
                                          widget.commentId,
                                          _singleEditingController.text);
                                      _navigationActions.previousScreenUpdate();
                                      _videoBloc
                                          .getCommentList(widget.commentId);
                                    }),
                                border: OutlineInputBorder(),
                                hintText: 'Your Comment here',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    fontFamily: 'Poppins')),
                            controller: _singleEditingController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[Text("Comments")],
                          ),
                        ),
                        NastedCommentList(
                          id: widget.parentId,
                          commentId: widget.commentId,
                          parentId: widget.id,
                        )
                      ],
                    );
            }),
      ],
    );
  }
}
