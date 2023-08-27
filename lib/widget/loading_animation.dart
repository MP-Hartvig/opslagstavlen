import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingAnimation() {
  return Scaffold(
    body: Center(
      child: LoadingAnimationWidget.inkDrop(
        color: const Color.fromARGB(255, 26, 153, 68),
        size: 50,
      ),
    ),
  );
}
