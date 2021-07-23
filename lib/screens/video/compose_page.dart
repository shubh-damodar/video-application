import 'dart:io';
import 'package:video/bloc_patterns/edit_profile_bloc_patterns/profile_bloc.dart';
import 'package:video/bloc_patterns/videos/compose_bloc.dart';
import 'package:video/utils/data_collection.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ComposeVideoPage extends StatefulWidget {
  final String userId, previousScreen, title, shortDescription, id;
  ComposeVideoPage(
      {this.previousScreen,
      this.userId,
      this.title,
      this.shortDescription,
      this.id});

  _ComposeVideoPageState createState() => _ComposeVideoPageState();
}

class _ComposeVideoPageState extends State<ComposeVideoPage> {
  final GlobalKey<FormState> _composeformKey = GlobalKey<FormState>();
  final String previousScreen;
  _ComposeVideoPageState({this.previousScreen});
  final ProfileBloc _profileBloc = ProfileBloc();
  ComposeBloc _composeBloc = ComposeBloc();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  DataCollection _dataCollection = DataCollection();
  String userId, title, _channel, _catogary, _content, _privacy;
  Country _country;
  TextEditingController _titleTextEditingController = TextEditingController(),
      countryCodeTextEditingController = TextEditingController(),
      _tagsTextEditingController = TextEditingController(),
      _shortDescriptionTextEditingController = TextEditingController();

  File image;
  VideoPlayerController _videoPlayerController;

  void initState() {
    super.initState();
    _country = Country.IN;
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _channel = 'English';
    _catogary = null;
    _content = null;
    _privacy = null;
    _composeBloc.getChannnelList();
    userId = widget.userId;
  }

  @override
  void dispose() {
    super.dispose();
    _profileBloc.dispose();
    _composeBloc.dispose();
  }

  takePicture() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    setState(() {
      _composeBloc.takePicture(image);
    });
  }

  File _video;

  _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _video = video;
    setState(() {
      _composeBloc.takeVideo(_video);
    });
    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  Future<bool> _onWillPop() {
    return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
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
              );
            }) ??
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
          title: Text('Upload Video',
              style: TextStyle(color: Colors.deepOrange, fontSize: 16.0)),
          centerTitle: true,
        ),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
                key: _composeformKey,
                autovalidate: false,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 250,
                              child: image == null
                                  ? Image.asset(
                                      'assets/images/cover3.jpg',
                                      width: double.infinity,
                                      height: 250.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      image,
                                      height: 250.0,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            if (_video != null)
                              _videoPlayerController.value.initialized
                                  ? AspectRatio(
                                      aspectRatio: _videoPlayerController
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(_videoPlayerController),
                                    )
                                  : Container()
                            else
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Card(
                                  margin: EdgeInsets.all(5),
                                  color: Colors.black.withOpacity(0.4),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              _pickVideo();
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              size: 20,
                                              // size: .0,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Video Title",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _titleTextEditingController,
                          validator: (String value) {
                            if (value.length < 4 || value.length > 101) {
                              return 'Password should have characters between 3 and 100';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Video Title',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins')),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                child: Text(
                                  "Select a Channel",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                child: DropdownButton<String>(
                                    underline: Container(
                                      color: Colors.transparent,
                                    ),
                                    value: _channel,
                                    items: _dataCollection.channelList
                                        .map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String selectedValue) {
                                      setState(() {
                                        _channel = selectedValue;
                                      });
                                    })),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                child: Text(
                                  "Category",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                child: DropdownButton<String>(
                                    hint: Text(
                                      "Select a Catogary",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    underline: Container(
                                      color: Colors.transparent,
                                    ),
                                    value: _catogary,
                                    items: _dataCollection.categoryList
                                        .map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String selectedValue) {
                                      setState(() {
                                        _catogary = selectedValue;
                                      });
                                    })),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Tags",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Tags',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins')),
                          controller: _tagsTextEditingController,
                          validator: (String value) {
                            if (value.length < 2) {
                              return 'Minimum Length should be at least 1 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Description",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
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
                            if (value.length < 1) {
                              return 'Minimum Length should be at least 400 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Tags",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 250,
                              child: image == null
                                  ? Image.asset(
                                      'assets/images/cover3.jpg',
                                      width: double.infinity,
                                      height: 250.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      image,
                                      height: 250.0,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Card(
                                margin: EdgeInsets.all(5),
                                color: Colors.black.withOpacity(0.4),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            takePicture();
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            size: 20,
                                            // size: .0,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                child: Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                child: DropdownButton<String>(
                                    hint: Text("Select Privacy"),
                                    underline: Container(
                                      color: Colors.transparent,
                                    ),
                                    value: _privacy,
                                    items: _dataCollection.privacyListName
                                        .map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String selectedValue) {
                                      setState(() {
                                        _privacy = selectedValue;
                                      });
                                    })),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                child: Text(
                                  "Content Policy",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                child: DropdownButton<String>(
                                    hint: Text("Select Content"),
                                    underline: Container(
                                      color: Colors.transparent,
                                    ),
                                    value: _content,
                                    items: _dataCollection.contentList
                                        .map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String selectedValue) {
                                      setState(() {
                                        _content = selectedValue;
                                      });
                                    })),
                          ],
                        ),
                        SizedBox(
                          height: 20,
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
                              if (_composeformKey.currentState.validate()) {
                                _widgetsCollection.showMessageDialog();
                                _composeBloc.sendBodyMessage(
                                    widget.id,
                                    _content,
                                    _shortDescriptionTextEditingController.text,
                                    _privacy,
                                    _tagsTextEditingController.text,
                                    _titleTextEditingController.text);
                              }
                            },
                          )),
                        ),
                        StreamBuilder(
                          stream: _composeBloc.composeFinishedStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>>
                                  asyncSnapshot) {
                            return asyncSnapshot.data == null
                                ? Container(width: 0.0, height: 0.0)
                                : asyncSnapshot.data.length == 0
                                    ? Container(width: 0.0, height: 0.0)
                                    : _composeFinished(asyncSnapshot.data);
                          },
                        ),
                      ],
                    ),
                  ),
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
