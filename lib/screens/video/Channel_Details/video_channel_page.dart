import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video/bloc_patterns/videos/video_channel_bloc.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Channel_Details/Tab/about_page.dart';
import 'package:video/screens/video/Channel_Details/Tab/channel_page.dart';
import 'package:video/screens/video/Channel_Details/Tab/home_tab_page.dart';
import 'package:video/screens/video/Channel_Details/Tab/playlist_page.dart';
import 'package:video/screens/video/Channel_Details/Tab/top_videos_page.dart';
import 'package:video/screens/video/compose_page.dart';
import 'package:video/screens/video/edit_channel_page.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';

class VideoChannelPage extends StatefulWidget {
  final String userId, previousScreen, name;

  VideoChannelPage({this.userId, this.previousScreen, this.name});

  @override
  _VideoChannelPageState createState() => _VideoChannelPageState();
}

class _VideoChannelPageState extends State<VideoChannelPage>
    with SingleTickerProviderStateMixin {
  @override
  double _screenWidth, _screenHeight;
  final ScrollController _scrollController = ScrollController();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;

  TabController _tabController;

  VideoChannelDetailsList _videoChannelDetailsListBloc =
      VideoChannelDetailsList();

  @override
  void initState() {
    _navigationActions = NavigationActions(context);
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('Channel ',
                style: TextStyle(color: Colors.black, fontSize: 14)),
            backgroundColor: Colors.white,
            actions: <Widget>[
              widget.userId == Connect.currentUser.userId
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _navigationActions
                            .navigateToScreenWidget(EditChannelPage(
                          userId: widget.userId,
                        ));
                      },
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              labelStyle: TextStyle(fontSize: 13),
              isScrollable: true,
              tabs: <Widget>[
                Tab(text: "Home"),
                Tab(text: "Top Videos"),
                Tab(text: "Playlist"),
                Tab(text: "Channels"),
                Tab(text: "About"),
              ],
            ),
          ),
          floatingActionButton: widget.userId == Connect.currentUser.userId
              ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _navigationActions.navigateToScreenWidget(ComposeVideoPage(
                      userId: widget.userId,
                    ));
                  },
                )
              : null,
          body: TabBarView(controller: _tabController, children: <Widget>[
            HomeTabPage(userId: widget.userId),
            TopVideoPage(userId: widget.userId),
            ChannelPlayListPage(userId: widget.userId),
            ChannelsListPage(userId: widget.userId),
            AboutPage(userId: widget.userId),
          ]),
        ));
  }
}
