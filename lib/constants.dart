import 'package:flutter/material.dart';

const kActiveCardColour = Color(0xFF1D1E33);
const kInactiveCardColour = Color(0xFF111328);
const kBorderRadiusCircular = 10.0;

const kLabelTextStyle = TextStyle(
  fontSize: 28.0,
  color: Color(0xFF00008b),
  fontWeight: FontWeight.w600,
);

const kNumberTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

BoxDecoration kBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(kBorderRadiusCircular),
  gradient: const LinearGradient(
    colors: <Color>[
      Color(0xFFFDB777), //Mellow Apricot
      Color(0xFFFDB777),
      Color(0xFFFDB777),
    ],
  ),
);
