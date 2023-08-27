import 'package:flutter/material.dart';

Widget removeAddFAB(
    {required IconData leftSideIcon,
    required VoidCallback leftSideOnClick,
    required IconData rightSideIcon,
    required VoidCallback rightSideOnClick}) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: FloatingActionButton(
        onPressed: leftSideOnClick,
        child: Icon(
          leftSideIcon,
        ),
      ),
    ),
    FloatingActionButton(
      onPressed: rightSideOnClick,
      child: Icon(
        rightSideIcon,
      ),
    ),
  ]);
}
