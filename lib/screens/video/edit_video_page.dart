import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video/bloc_patterns/edit_profile_bloc_patterns/profile_bloc.dart';
import 'package:video/bloc_patterns/videos/edit_video_bloc.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/screens/video/Video_Player/video_player.dart';
import 'package:video/utils/data_collection.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class EditVideoPage extends StatefulWidget {
  final String userId, shortDescription, id, channelId;
  EditVideoPage({this.userId, this.shortDescription, this.channelId, this.id});
  _EditVideoPageState createState() => _EditVideoPageState();
}

class _EditVideoPageState extends State<EditVideoPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _editVideoformKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  final ProfileBloc _profileBloc = ProfileBloc();
  final EditVideosBloc _editVideosBloc = EditVideosBloc();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  DataCollection _dataCollection = DataCollection();
  String userId, title, _selectedCategory, _selectedPrivacy, _selectedContent;
  Country _country;
  TextEditingController countryCodeTextEditingController =
          TextEditingController(),
      _emailsTextEditingController = TextEditingController(),
      _descriptionTextEditingController = TextEditingController(),
      _mobileNumberTextEditingController = TextEditingController(),
      _countryTextEditingController = TextEditingController(),
      _titleTextEditingController = TextEditingController(),
      _tagsTextEditingController = TextEditingController(),
      _nameTextEditingController = TextEditingController();
  File image;

  @override
  void initState() {
    super.initState();
    _country = Country.IN;
    _navigationActions = NavigationActions(context);
    _widgetsCollection = WidgetsCollection(context);
    _selectedCategory = null;
    _editVideosBloc.getVideoDetails(Connect.currentUser.userId, widget.id);
    // _editVideosBloc.getVideoLink(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    _profileBloc.dispose();
    _editVideosBloc.dispose();
  }

  takePicture() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    setState(() {
      _editVideosBloc.takePicture(image);
    });
  }

  _imageBuilder(String image) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      height: 250,
      width: double.infinity,
    );
  }

  Future<bool> _onWillPop() async {
    return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Do you want to Cancel Update?'),
                content: Text('Unsaved data will be lost!!'),
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

  Future<bool> _deleteVideo() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this video?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  _editVideosBloc.deleteVideo(widget.id);
                  _widgetsCollection.showMessageDialog();
                  _navigationActions.previousScreenUpdate();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text('Edit Video',
              style: TextStyle(color: Colors.black, fontSize: 16.0)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () {
                _deleteVideo();
              },
            ),
          ],
        ),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
                key: _editVideoformKey,
                autovalidate: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        StreamBuilder(
                          stream: _editVideosBloc.composeFinishedStream,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: StreamBuilder(
                            stream: _editVideosBloc.linkAddressStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              return asyncSnapshot.data == null
                                  ? Container(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ))
                                  : VideoPlayerPage(
                                      urlLink: asyncSnapshot.data);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Text("Video Title"),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.titleStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _titleTextEditingController.value =
                                      _titleTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _titleTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.titleStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Name',
                                ),
                              );
                            },
                          ),
                        ),
                        //---------------------------channel List----------------------------->
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Container(
                        //         child: Text("Channel Name"),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 5),
                        //   child: StreamBuilder(
                        //     stream: _editVideosBloc.nameChannelStream,
                        //     builder: (BuildContext context,
                        //         AsyncSnapshot<String> asyncSnapshot) {
                        //       asyncSnapshot.data == null
                        //           ? Container(
                        //               width: 0,
                        //               height: 0,
                        //             )
                        //           : _nameTextEditingController.value =
                        //               _nameTextEditingController.value
                        //                   .copyWith(text: asyncSnapshot.data);
                        //       return TextField(
                        //         controller: _nameTextEditingController,
                        //         onChanged: (String value) {
                        //           _editVideosBloc.nameChannelStreamSink
                        //               .add(value);
                        //         },
                        //         decoration: InputDecoration(
                        //           border: OutlineInputBorder(),
                        //           hintText: 'Name',
                        //           // hintStyle: TextStyle(
                        //           //     fontWeight: FontWeight.w400,
                        //           //     fontSize: 14.0,
                        //           //     fontFamily: 'Poppins')
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        //---------------------------channel List End----------------------------->
                        // Row(
                        //   children: <Widget>[
                        //     Padding(
                        //       padding: const EdgeInsets.only(top: 20),
                        //       child: Container(
                        //         child: Text("Category"),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: <Widget>[
                        //     Container(
                        //         margin: EdgeInsets.only(top: 0, bottom: 0.0),
                        //         child: StreamBuilder(
                        //             stream: _editVideosBloc.categoryStream,
                        //             builder: (BuildContext context,
                        //                 AsyncSnapshot<String> asyncSnapshot) {
                        //               return DropdownButton<String>(
                        //                   underline: Container(
                        //                     color: Colors.transparent,
                        //                   ),
                        //                   hint: Text(
                        //                     'Select Category',
                        //                     style: TextStyle(),
                        //                   ),
                        //                   value: asyncSnapshot.data,
                        //                   items: _dataCollection.categoryList
                        //                       .map<DropdownMenuItem<String>>(
                        //                           (String value) {
                        //                     return DropdownMenuItem(
                        //                       value: value,
                        //                       child: Text(
                        //                         value,
                        //                         style: TextStyle(
                        //                           fontWeight: FontWeight.w500,
                        //                           fontSize: 15.0,
                        //                         ),
                        //                       ),
                        //                     );
                        //                   }).toList(),
                        //                   onChanged: (String selectedValue) {
                        //                     _editVideosBloc.categoryStreamSink
                        //                         .add(selectedValue);
                        //                   });
                        //             })),
                        //   ],
                        // ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Description"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.descriptionStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              _descriptionTextEditingController.value =
                                  _descriptionTextEditingController.value
                                      .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                // enableInteractiveSelection: true,
                                expands: false,
                                maxLines: null,
                                minLines: null,
                                // maxLength: 2,
                                controller: _descriptionTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.descriptionStreamSink
                                      .add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Description',
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text("Video Thumbnail"),
                              ),
                              IconButton(
                                icon: Icon(Icons.error_outline,
                                    color: Colors.grey),
                                onPressed: () {
                                  _widgetsCollection.showToastMessage(
                                      "This image would appear in this video list as a banner image");
                                },
                              )
                            ],
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 250,
                              width: double.infinity,
                              child: image == null
                                  ? StreamBuilder(
                                      stream: _editVideosBloc.thumbnailStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> asyncSnapshot) {
                                        return asyncSnapshot.data == null
                                            ? Container(
                                                width: 0,
                                                height: 0,
                                              )
                                            : Column(
                                                children: <Widget>[
                                                  _imageBuilder(
                                                      '${Connect.filesUrl}${asyncSnapshot.data}')
                                                ],
                                              );
                                      })
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
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Privacy Policy"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                child: StreamBuilder(
                                    stream: _editVideosBloc.privacyPolicyStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> asyncSnapshot) {
                                      return DropdownButton<String>(
                                          underline: Container(
                                            color: Colors.transparent,
                                          ),
                                          hint: Text(
                                            'Privacy Policy',
                                          ),
                                          value: asyncSnapshot.data == "0"
                                              ? _dataCollection
                                                  .privacyListName[0]
                                              : _dataCollection
                                                  .privacyListName[1],
                                          items: _dataCollection.privacyListName
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String selectedValue) {
                                            _editVideosBloc
                                                .privacyPolicyStreamSink
                                                .add(selectedValue == "Private"
                                                    ? "1"
                                                    : "0");
                                          });
                                    })),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Content Policy"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: StreamBuilder(
                                stream: _editVideosBloc.contentPolicyStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> asyncSnapshot) {
                                  return DropdownButton<String>(
                                    underline: Container(
                                      color: Colors.transparent,
                                    ),
                                    hint: Text(
                                      'Content Policy',
                                    ),
                                    value: asyncSnapshot.data,
                                    items: _dataCollection.contentList
                                        .map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String selectedValue) {
                                      _editVideosBloc.contentPolicyStreamSink
                                          .add(selectedValue);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.deepOrange,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add, color: Colors.white),
                              Text(
                                'Modify Video',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
                            _editVideosBloc.sendEditedArticale(
                              widget.channelId,
                              //contentPolicy
                              _descriptionTextEditingController.text,
                              widget.id,
                              //privecy
                              // _tagsTextEditingController.text,
                              //tumnail
                              _titleTextEditingController.text,
                            );
                          },
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                ))),
      ),
    );
  }

  // Widget _composeFinished(Map<String, dynamic> mapResponse) {
  //   if (mapResponse['code'] == 200) {
  // _navigationActions.closeDialog();
  // _navigationActions.previousScreenUpdate();
  // _widgetsCollection.showToastMessage("Success");
  //   } else {
  //     _widgetsCollection.showToastMessage(mapResponse['content']['message']);
  //   }
  //   return Container(width: 0.0, height: 0.0);
  // }

  Widget _composeFinished(Map<String, dynamic> mapResponse) {
    mapResponse['code'] == 200
        ? {
            _navigationActions.closeDialog(),
            _navigationActions.previousScreenUpdate(),
            _widgetsCollection.showToastMessage("Success"),
          }
        : _widgetsCollection
            .showToastMessage(mapResponse['content']['message']);
    return Container();
  }
}
