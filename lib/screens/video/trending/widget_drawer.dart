import 'package:flutter/material.dart';
import 'package:video/models/user.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/idm/login_page.dart';
import 'package:video/screens/profile_screens/edit_profile_screens/profile_page.dart';
import 'package:video/screens/video/History_page.dart';
import 'package:video/screens/video/Library_page.dart';
import 'package:video/screens/video/Liked_Video_page.dart';
import 'package:video/screens/video/favourite_video_page.dart';
import 'package:video/screens/video/my_video_page.dart';
import 'package:video/screens/video/playlist_page.dart';
import 'package:video/screens/video/subscriptions_page.dart';
import 'package:video/screens/video/watch_later_page.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/shared_pref_manager.dart';
import 'package:video/utils/widgets_collection.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({
    Key key,
    @required double screenWidth,
    @required List<User> usersList,
    @required WidgetsCollection widgetsCollection,
    @required NavigationActions navigationActions,
  })  : _screenWidth = screenWidth,
        _usersList = usersList,
        _widgetsCollection = widgetsCollection,
        _navigationActions = navigationActions,
        super(key: key);

  final NavigationActions _navigationActions;
  final double _screenWidth;
  final List<User> _usersList;
  final WidgetsCollection _widgetsCollection;

  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget._screenWidth * 0.90,
      child: Row(
        children: <Widget>[
          Flexible(
              flex: 2,
              child: Container(
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  color: Colors.grey.withOpacity(0.25),
                  child: ListView(
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget._usersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: widget._widgetsCollection
                                .getDrawerProfileImage(
                                    45.0, widget._usersList[index]),
                            onTap: () {
                              setState(
                                () {
                                  SharedPrefManager.switchCurrentUser(
                                          widget._usersList[index])
                                      .then(
                                    (value) {
                                      widget._navigationActions
                                          .navigateToScreenWidget(
                                        ProfilePage(
                                          userId: Connect.currentUser.userId,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white)),
                        padding: EdgeInsets.all(0.5),
                        width: 45.0,
                        height: 45.0,
                        child: Center(
                          child: ClipOval(
                            child: IconButton(
                              icon: Icon(Icons.person_add),
                              onPressed: () {
                                widget._navigationActions
                                    .navigateToScreenWidget(
                                  LoginPage(previousScreen: 'trending_page'),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Flexible(
            flex: 7,
            child: Drawer(
              elevation: 1.0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  DrawerHeader(
                    child: Image.asset(
                      'assets/images/mesbro.png',
                      width: widget._screenWidth * 0.4,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.video_library),
                    title: Text('Library', style: TextStyle()),
                    onTap: () {
                      widget._navigationActions.navigateToScreenWidget(
                          LibraryPage(
                              userId: Connect.currentUser.userId,
                              previousScreen: 'trending_page'));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.watch_later),
                    title: Text('Watch Later'),
                    onTap: () {
                      widget._navigationActions
                          .navigateToScreenWidget(WatchLaterPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.thumb_up),
                    title: Text('Liked Video'),
                    onTap: () {
                      widget._navigationActions
                          .navigateToScreenWidget(LikedVideoPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Favourite Videos'),
                    onTap: () {
                      widget._navigationActions
                          .navigateToScreenWidget(FevouritVideoPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.subscriptions),
                    title: Text("Subscriptions"),
                    onTap: () {
                      widget._navigationActions
                          .navigateToScreenWidget(SubscriptionPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.ondemand_video),
                    title: Text("My Videos"),
                    onTap: () {
                      widget._navigationActions
                          .navigateToScreenWidget(MyVideosPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text("History"),
                    onTap: () {
                      widget._navigationActions
                          .navigateToScreenWidget(HistoryPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.playlist_play),
                    title: Text("Playlist"),
                    onTap: () {
                      widget._navigationActions
                          .navigateToScreenWidget(PlayListPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Log Out'),
                    onTap: () {
                      SharedPrefManager.removeAll().then((bool value) {
                        widget._navigationActions
                            .navigateToScreenWidgetRoot(LoginPage());
                      });
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Version: 0.0.8',
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
