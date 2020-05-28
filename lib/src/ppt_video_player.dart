import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'full_player.dart';
import 'widget/SliderComponent.dart';
import 'widget/pptVideoPlayer.dart';

class PPtVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final Duration startAt;
  final List<String> sliderList;

  PPtVideoPlayer({
    @required this.videoController,
    this.startAt = const Duration(seconds: 0),
    this.sliderList = const [],
  }) : assert(videoController != null);

  @override
  _PPtVideoPlayerState createState() => _PPtVideoPlayerState();
}

class _PPtVideoPlayerState extends State<PPtVideoPlayer> {
  bool _toggle = false;
  PageController _pageController = PageController(initialPage: 0);

  VideoPlayerController get controller => widget.videoController;

  List<String> get sliderList => widget.sliderList;

  void _listenVideoControllerWrapper() {
    controller.addListener(() {
//      print(
//          '${(_pageController.page + 1) * 100}--${controller.value.position.inSeconds}---555');
//      if (controller.value.position.inSeconds >
//          (_pageController.page + 1) * 20) {
//        _pageController.animateTo(_pageController.page + 1,
//            duration: Duration(milliseconds: 400), curve: Curves.ease);
//      }
    });
  }

  @override
  void initState() {
    super.initState();
    _listenVideoControllerWrapper();
  }

//  @override
//  void didUpdateWidget(PPtVideoPlayer oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    oldWidget.videoController.removeListener(_listener); // <<<<< controller has already been disposed at this point resulting in the exception being thrown
////    _textureId = widget.controller.textureId;
//    widget.videoController.addListener(_listener);
//  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void pushFullScreenWidget() {
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      settings: RouteSettings(name: '全屏播放'),
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          FullscreenPlayer(
        controller: controller,
        pageController: _pageController,
        sliderList: sliderList,
      ),
    );

    route.completed.then((void value) {
//      controller.setVolume(0.0);
    });

//    controller.setVolume(1.0);
    Navigator.of(context).push(route).then((_) {
      if (mounted)
        setState(() {
          _listenVideoControllerWrapper();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * (9 / 16),
        child: Stack(
          children: <Widget>[
            _toggle
                ? SliderComponent(
                    _pageController,
                    sliderList: sliderList,
                  )
                : PPTVideoPlayer(controller),
            Positioned(
              width: 90.0,
              height: 50.0,
              bottom: 10.0,
              right: 10.0,
              child: GestureDetector(
                onTap: () => setState(() {
                  _toggle = !_toggle;
                }),
                child: _toggle
                    ? PPTVideoPlayer(controller)
                    : SliderComponent(
                        _pageController,
                        sliderList: sliderList,
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FlatButton(
                child: Text('全屏'),
                onPressed: () => pushFullScreenWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
