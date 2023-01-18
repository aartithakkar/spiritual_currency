import 'package:flutter/material.dart';
import '../constants.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({required this.cardChild, required this.onPress});

  final Widget cardChild;
  final VoidCallback onPress;

//  ReusableCard({this.colour = kActiveCardColour, this.cardChild = , this.onPress = (){}})

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(3.0),
        decoration: kBoxDecoration,
      ),
    );
  }
}
