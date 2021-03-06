import 'package:flutter/material.dart';
import 'package:flutter_video/src/type.dart';

import '../customBehavior.dart';

class SliderComponent extends StatelessWidget {
  final PageController pageController;
  final List<PPTType> sliderList;

  SliderComponent(this.pageController, {this.sliderList})
      : assert(pageController != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.6),
      child: ScrollConfiguration(
        behavior: CustomBehavior(),
        child: PageView.builder(
          controller: pageController,
          key: PageStorageKey('slider'),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => Image.network(
            sliderList[index].url,
            fit: BoxFit.cover,
          ),
          itemCount: sliderList.length,
        ),
      ),
    );
  }
}
