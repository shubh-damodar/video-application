import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_channel_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';

class ChannelPlayListPage extends StatefulWidget {
  final String userId;
  ChannelPlayListPage({this.userId});
  _ChannelPlayListPageState createState() => _ChannelPlayListPageState();
}

class _ChannelPlayListPageState extends State<ChannelPlayListPage>
    with AutomaticKeepAliveClientMixin {
  _ChannelPlayListPageState({this.userId});
  NavigationActions _navigationActions;
  final Map<String, dynamic> userId;

  DateCategory _dateCategory = DateCategory();
  final ScrollController _scrollController = ScrollController();

  VideoChannelDetailsList _videoChannelDetailsListBloc =
      VideoChannelDetailsList();

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    // _videoChannelDetailsListBloc.getchannelInfoDetails(widget.userId);
    _videoChannelDetailsListBloc.getPlayListChannel(widget.userId);
  }


  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _videoChannelDetailsListBloc.playListChannelStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<Videos>> asyncSnapshot) {
            return asyncSnapshot.data == null
                ? Container(
                    width: 0,
                    height: 0,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemExtent: 106.0,
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: asyncSnapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return asyncSnapshot.data.length == 0
                          ? Container(
                              child: Text("No video........."),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: _width,
                                      imageUrl:
                                          "${Connect.filesUrl}${asyncSnapshot.data[index].thumbnail}",
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 0.0, 0.0, 0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${asyncSnapshot.data[index].name}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0)),
                                          Text(
                                            "10",
                                            // "asyncSnapshot.data[index].videoCount",
                                            style:
                                                const TextStyle(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.more_vert,
                                    size: 16.0,
                                  ),
                                ],
                              ),
                            );
                    });
          }),
      // padding: EdgeInsets.only(bottom: 30),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
