import 'dart:io';
import 'package:video/bloc_patterns/videos/create_channel_bloc.dart';
import 'package:video/utils/data_collection.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CreateChannelPage extends StatefulWidget {
  final String userId, previousScreen, title, shortDescription, id;
  CreateChannelPage(
      {this.previousScreen,
      this.userId,
      this.title,
      this.shortDescription,
      this.id});

  _CreateChannelPageState createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  final GlobalKey<FormState> _createformKey = GlobalKey<FormState>();

  CreateChannelBloc _createChannelBloc = CreateChannelBloc();
  final String previousScreen;
  _CreateChannelPageState({this.previousScreen});
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  DataCollection _dataCollection = DataCollection();
  TextEditingController _titleTextEditingController = TextEditingController(),
      _shortDescriptionTextEditingController = TextEditingController();

  File image;
  VideoPlayerController _videoPlayerController;

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Unsaved data will be lost.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  _navigationActions.previousScreenUpdate();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.white,
          title: Text('Create Channel',
              style: TextStyle(color: Colors.deepOrange, fontSize: 16.0)),
          centerTitle: true,
        ),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
                key: _createformKey,
                autovalidate: false,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        child: Text(
                          "Channel Title",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _titleTextEditingController,
                      validator: (String value) {
                        if (value.length < 3) {
                          return 'Minimum Length should be at least 3 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Channel Title',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              fontFamily: 'Poppins')),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Description',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              fontFamily: 'Poppins')),
                      controller: _shortDescriptionTextEditingController,
                      validator: (String value) {
                        if (value.length < 1 || value.length > 2000) {
                          return 'Description should be at least 200-2000 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                          child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.deepOrange,
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_createformKey.currentState.validate()) {
                            _widgetsCollection.showMessageDialog();
                            _createChannelBloc.sendBodyMessage(
                                _titleTextEditingController.text,
                                _shortDescriptionTextEditingController.text);
                          }
                        },
                      )),
                    ),
                    StreamBuilder(
                      stream: _createChannelBloc.composeFinishedStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> asyncSnapshot) {
                        return asyncSnapshot.data == null
                            ? Container(width: 0.0, height: 0.0)
                            : asyncSnapshot.data.length == 0
                                ? Container(width: 0.0, height: 0.0)
                                : _composeFinished(asyncSnapshot.data);
                      },
                    ),
                  ],
                ))),
      ),
    );
  }

  Widget _composeFinished(Map<String, dynamic> mapResponse) {
    if (mapResponse['code'] == 200) {
      _navigationActions.closeDialog();
      _navigationActions.previousScreenUpdate();
      _widgetsCollection.showToastMessage("${mapResponse['message']}");
    } else {
      _widgetsCollection.showToastMessage(mapResponse['content']['message']);
    }

    return Container(width: 0.0, height: 0.0);
  }
}
