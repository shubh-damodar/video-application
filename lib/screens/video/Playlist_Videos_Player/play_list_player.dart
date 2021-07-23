import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:video/utils/navigation_actions.dart';

@override
class PlayListVideoPlayerPage extends StatefulWidget {
  final String urlLink;
  PlayListVideoPlayerPage({this.urlLink});
  _PlayListVideoPlayerPageState createState() => _PlayListVideoPlayerPageState();
}

@override
class _PlayListVideoPlayerPageState extends State<PlayListVideoPlayerPage> {
  NavigationActions _navigationActions;
  IjkMediaController controller;

  void initState() {
    super.initState();
    _navigationActions = NavigationActions(context);
    controller = IjkMediaController();
    controller.setNetworkDataSource(widget.urlLink, autoPlay: true);
    Stream<IjkStatus> ijkStatusStream = controller.ijkStatusStream;
    ijkStatusStream.listen((status) {
      if (status == IjkStatus.complete) {
        controller.pause();
      }
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller?.play();
    } else if (state == AppLifecycleState.paused) {
      controller?.pause();
    }
  }

  void deactivate() {
    super.deactivate();
    controller?.pause();
  }

  void reassemble() {
    super.reassemble();
    controller?.play();
    print("----------4---------------ijkcompleted");
  }

  void dispose() {
    super.dispose();
    controller?.dispose();
    print("-----------5--------------ijkcompleted");
  }

  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: IjkPlayer(
        mediaController: controller,
        // controllerWidgetBuilder: (mController) => new Container(),
      ),
    );
  }
}
