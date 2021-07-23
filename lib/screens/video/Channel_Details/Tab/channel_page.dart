import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_channel_bloc.dart';
import 'package:video/models/videos.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/utils/date_category.dart';
import 'package:video/utils/navigation_actions.dart';

class ChannelsListPage extends StatefulWidget {
  final String userId;
  ChannelsListPage({this.userId});
  _ChannelsListPageState createState() => _ChannelsListPageState();
}

class _ChannelsListPageState extends State<ChannelsListPage>
    with AutomaticKeepAliveClientMixin {
  _ChannelsListPageState({this.userId});
  NavigationActions _navigationActions;
  final Map<String, dynamic> userId;
  bool fev = false;

  DateCategory _dateCategory = DateCategory();
  final ScrollController _scrollController = ScrollController();

  VideoChannelDetailsList _videoChannelDetailsListBloc =
      VideoChannelDetailsList();

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _videoChannelDetailsListBloc.getChannelListInChannel(widget.userId);
  }

  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _videoChannelDetailsListBloc.channeListListStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<Videos>> asyncSnapshot) {
            return asyncSnapshot.data == null
                ? Container(
                    child: Text("Loading Data.............."),
                  )
                : Column(
                    children: <Widget>[
                      ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: asyncSnapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return asyncSnapshot.data.length == null
                                ? Container(
                                    child: Text("No Channel List..........."),
                                  )
                                : ListTile(
                                    leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${Connect.filesUrl}${asyncSnapshot.data[index].logo}",
                                          fit: BoxFit.contain,
                                          height: 45,
                                          width: 45,
                                          placeholder: (BuildContext context,
                                              String url) {
                                            return Image.asset(
                                              'assets/images/male-avatar.png',
                                              fit: BoxFit.contain,
                                              height: 45,
                                              width: 45,
                                            );
                                          },
                                        )),
                                    title: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                          width: 5,
                                          child: Text(
                                            "${asyncSnapshot.data[index].name}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.fade,
                                            maxLines: 3,
                                          ),
                                        )),
                                      ],
                                    ),
                                    subtitle: Text(
                                      "${_dateCategory.EEEEMMMMdDateFormat.format(DateTime.fromMillisecondsSinceEpoch(asyncSnapshot.data[index].updatedAt))}",
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    trailing: SizedBox(
                                        width: 140,
                                        child: asyncSnapshot
                                                .data[index].subscribedChannel
                                            ? RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                child: Text(
                                                  "Unsubscribe",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.grey,
                                                onPressed: () {},
                                              )
                                            : RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                child: Text(
                                                  "Subscribe ${asyncSnapshot.data[index].subscribers} ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.deepOrange,
                                                onPressed: () {},
                                              )),
                                  );
                          }),
                    ],
                  );
          }),
      padding: EdgeInsets.only(bottom: 30),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
