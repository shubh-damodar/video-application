import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:video/bloc_patterns/edit_profile_bloc_patterns/profile_bloc.dart';
import 'package:video/bloc_patterns/videos/edit_channel_bloc.dart';
import 'package:video/network/user_connect.dart';
import 'package:video/utils/data_collection.dart';
import 'package:video/utils/navigation_actions.dart';
import 'package:video/utils/widgets_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:image_picker/image_picker.dart';

class EditChannelPage extends StatefulWidget {
  final String userId, previousScreen, title, shortDescription;
  EditChannelPage(
      {this.previousScreen, this.userId, this.title, this.shortDescription});
  _EditChannelPageState createState() => _EditChannelPageState();
}

class _EditChannelPageState extends State<EditChannelPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _editChannelformKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  final ProfileBloc _profileBloc = ProfileBloc();
  final EditChannelBloc _editVideosBloc = EditChannelBloc();
  NavigationActions _navigationActions;
  WidgetsCollection _widgetsCollection;
  DataCollection _dataCollection = DataCollection();
  String userId, title, _selectedCategory;
  Country _country;
  TextEditingController countryCodeTextEditingController =
          TextEditingController(),
      _emailsTextEditingController = TextEditingController(),
      _descriptionTextEditingController = TextEditingController(),
      _mobileNumberTextEditingController = TextEditingController(),
      _countryTextEditingController = TextEditingController(),
      _facebookTextEditingController = TextEditingController(),
      _instagramTextEditingController = TextEditingController(),
      _twitterTextEditingController = TextEditingController(),
      _linkDinTextEditingController = TextEditingController(),
      _youTubeTextEditingController = TextEditingController(),
      _webSiteTextEditingController = TextEditingController(),
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
    _editVideosBloc.getChannelDetails(widget.userId);
    userId = widget.userId;
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
      _editVideosBloc.takelogo(image, widget.userId);
    });
  }

  takeBackground() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    setState(() {
      _editVideosBloc.takecoverPicture(image, widget.userId);
    });
  }

  void _addonsTags(String value) {
    // print("-1-1--1-1-1--1-1-1$value");
    _editVideosBloc.tagsList.add(value);
    _editVideosBloc.listVideoTagsStreamSink.add(_editVideosBloc.tagsList);
    _tagsTextEditingController.text = '';
  }

  Future<bool> _onWillPop() async {
    return showDialog(
          context: context,
          child: AlertDialog(
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
          ),
        ) ??
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
                Text('Do you want to delete this article?'),
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
                  _widgetsCollection.showMessageDialog();
                  _navigationActions.previousScreenUpdate();
                  _editVideosBloc.deletChannel(widget.userId);
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
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.white,
          title: Text('Edit Channel',
              style: TextStyle(color: Colors.deepOrange, fontSize: 16.0)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.deepOrange,
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
                key: _editChannelformKey,
                autovalidate: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        new StreamBuilder(
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
                        new Container(
                          width: double.infinity,
                          height: 290.0,
                          child: Stack(
                            children: <Widget>[
                              StreamBuilder(
                                  stream: _editVideosBloc.coverPictureStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> asyncSnapshot) {
                                    return asyncSnapshot.data == null
                                        ? Image.asset(
                                            'assets/images/cover.png',
                                            width: double.infinity,
                                            height: 250.0,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            height: 250.0,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                '${Connect.filesUrl}${asyncSnapshot.data}',
                                            placeholder: (BuildContext context,
                                                String url) {
                                              return Image.asset(
                                                'assets/images/cover.png',
                                                width: double.infinity,
                                                height: 250.0,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          );
                                  }),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.6),
                                      padding: EdgeInsets.all(3),
                                      child: GestureDetector(
                                          onTap: () {
                                            takeBackground();
                                          },
                                          child: new Icon(
                                            Icons.edit,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            size: 20,
                                            // size: .0,
                                          )),
                                    )),
                              ),
                              Positioned(
                                top: 160.0,
                                left: MediaQuery.of(context).size.width / 2 -
                                    130 / 2,
                                child: PhysicalModel(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(10.0),
                                  elevation: 5,
                                  child: Stack(
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: _editVideosBloc.logoStream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String>
                                                  asyncSnapshot) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: asyncSnapshot.data == null
                                                  ? Image.asset(
                                                      'assets/images/male-avatar.png',
                                                      fit: BoxFit.cover,
                                                      width: 130.0,
                                                      height: 130.0,
                                                    )
                                                  : CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      width: 130.0,
                                                      height: 130.0,
                                                      imageUrl:
                                                          '${Connect.filesUrl}${asyncSnapshot.data}',
                                                      placeholder:
                                                          (BuildContext context,
                                                              String url) {
                                                        return Container(
                                                          color: Colors.white,
                                                          child: Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                          width: 130.0,
                                                          height: 130.0,
                                                        );
                                                      },
                                                    ),
                                            );
                                          }),
                                      Positioned(
                                          top: 5,
                                          right: 5,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              padding: EdgeInsets.all(3),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    takePicture();
                                                  },
                                                  child: new Icon(
                                                    Icons.edit,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    size: 15,
                                                    // size: .0,
                                                  )),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text("Channel Name"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.nameStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _nameTextEditingController.value =
                                      _nameTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _nameTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.nameStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Name',
                                  // hintStyle: TextStyle(
                                  //     fontWeight: FontWeight.w400,
                                  //     fontSize: 14.0,
                                  //     fontFamily: 'Poppins')
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                child: Text("Select Category"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 0, bottom: 0.0),
                                child: StreamBuilder(
                                    stream: _editVideosBloc.categoryStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> asyncSnapshot) {
                                      return DropdownButton<String>(
                                          underline: Container(
                                            color: Colors.white,
                                          ),
                                          hint: Text(
                                            'Select Category',
                                            style: TextStyle(),
                                          ),
                                          value: asyncSnapshot.data,
                                          isDense: true,
                                          items: _dataCollection
                                              .channelListCatgory
                                              .map(
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
                                            _editVideosBloc.categoryStreamSink
                                                .add(selectedValue);
                                          });
                                    })),
                          ],
                        ),
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
                                maxLines: 4,
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
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Tags"),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: StreamBuilder(
                              stream: _editVideosBloc.listVideoTagsStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> asyncSnapshot) {
                                return asyncSnapshot.data == null
                                    ? Container(
                                        width: 0,
                                        height: 0,
                                      )
                                    // : ListView.builder(
                                    //     scrollDirection: Axis.horizontal,
                                    //     itemCount: asyncSnapshot.data.length,
                                    //     padding: EdgeInsets.only(bottom: 5),
                                    //     itemBuilder:
                                    //         (BuildContext context, int index) {
                                    //       return asyncSnapshot.data.length ==
                                    //               null
                                    //           ? Container(
                                    //               width: 0,
                                    //               height: 0,
                                    //             )
                                    //           : ChoiceChip(
                                    //               // selected:
                                    //               //     _selectedIndex == null,
                                    //               label: GestureDetector(
                                    //                 onTap: () {
                                    //                   _editVideosBloc.tagsList
                                    //                       .removeAt(index);
                                    //                   _editVideosBloc
                                    //                       .listVideoTagsStreamSink
                                    //                       .add(_editVideosBloc
                                    //                           .tagsList);
                                    //                 },
                                    //                 child: Row(
                                    //                   children: <Widget>[
                                    //                     Text(
                                    //                       '${asyncSnapshot.data[index]}',
                                    //                       style: TextStyle(
                                    //                         fontSize: 14.0,
                                    //                       ),
                                    //                     ),
                                    //                     Icon(Icons.cancel)
                                    //                   ],
                                    //                 ),
                                    //               ));
                                    //     },
                                    //   );
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: asyncSnapshot.data.length,
                                        dragStartBehavior:
                                            DragStartBehavior.start,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () {
                                                _editVideosBloc.tagsList
                                                    .removeAt(index);
                                                _editVideosBloc
                                                    .listVideoTagsStreamSink
                                                    .add(_editVideosBloc
                                                        .tagsList);
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        asyncSnapshot.data
                                                                    .length ==
                                                                0
                                                            ? Container(
                                                                width: 0.0,
                                                                height: 0.0,
                                                              )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                child: Container(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        top:
                                                                            5.0,
                                                                        bottom:
                                                                            5.0),
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    child: Text(
                                                                        asyncSnapshot
                                                                            .data[index])))
                                                      ])));
                                        },
                                      );
                              }),
                        ),
                        TextField(
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Tags',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins')),
                          controller: _tagsTextEditingController,
                          // onTap: () {
                          //   Future.delayed(Duration.zero, () {
                          //     _addonsTags(_tagsTextEditingController.text);
                          //   });
                          // },
                          onSubmitted: (String value) {
                            _addonsTags(value);
                          },
                        ),
                        //Tags-------------------------------------------------------------------------------------------->>>>
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Contact Email"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.emailStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _emailsTextEditingController.value =
                                      _emailsTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _emailsTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.emailStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Email Address',
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Mobile Number"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.mobileStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _mobileNumberTextEditingController.value =
                                      _mobileNumberTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _mobileNumberTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.mobileStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Mobile Number',
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Country"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.countryStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _countryTextEditingController.value =
                                      _countryTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _countryTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.countryStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Country',
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("FaceBook Account"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.facebookStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _facebookTextEditingController.value =
                                      _facebookTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _facebookTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.facebookStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'FaceBook Account',
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Instagram"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.instagramStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _instagramTextEditingController.value =
                                      _instagramTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _instagramTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.instagramStreamSink
                                      .add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Instagram',
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Twitter"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.twitterStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _twitterTextEditingController.value =
                                      _twitterTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _twitterTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.twitterStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Twitter',
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("Linkedin"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.linkDinStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _linkDinTextEditingController.value =
                                      _linkDinTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _linkDinTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.linkDinStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Linkedin',
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("YouTube"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.youTubeStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _youTubeTextEditingController.value =
                                      _youTubeTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _youTubeTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.youTubeStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'YouTube',
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                child: Text("WebSite"),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: StreamBuilder(
                            stream: _editVideosBloc.webSiteStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> asyncSnapshot) {
                              asyncSnapshot.data == null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : _webSiteTextEditingController.value =
                                      _webSiteTextEditingController.value
                                          .copyWith(text: asyncSnapshot.data);
                              return TextField(
                                controller: _webSiteTextEditingController,
                                onChanged: (String value) {
                                  _editVideosBloc.webSiteStreamSink.add(value);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Web Site',
                                ),
                              );
                            },
                          ),
                        ),
                        //         StreamBuilder(
                        Container(
                            child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.deepOrange,
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _editVideosBloc.sendEditedArticale(
                              // _tagsTextEditingController.text,
                              _nameTextEditingController.text,
                              _descriptionTextEditingController.text,
                              _emailsTextEditingController.text,
                              _mobileNumberTextEditingController.text,
                              _countryTextEditingController.text,
                              _facebookTextEditingController.text,
                              _instagramTextEditingController.text,
                              _twitterTextEditingController.text,
                              _linkDinTextEditingController.text,
                              _youTubeTextEditingController.text,
                              _webSiteTextEditingController.text,
                              _selectedCategory,
                              widget.userId,
                            );
                          },
                        )),
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
      // _navigationActions.previousScreenUpdate();
      _navigationActions.previousScreen();
      _widgetsCollection.showToastMessage("${mapResponse['message']}");
    } else {
      _widgetsCollection.showToastMessage(mapResponse['content']['message']);
    }
    return Container(width: 0.0, height: 0.0);
  }
}
