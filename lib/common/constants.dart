import 'package:audioplayers/audioplayers.dart';
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

const List mantraAudioAssetList = [
  'sounds/SP3.mp3',
  'sounds/ShriKrishnaSharanamMama.mp3',
  'sounds/SP3.mp3',
];

const List curemanTalksAssetList = [
  'sounds/SP3.mp3',
  'sounds/ShriKrishnaSharanamMama.mp3',
  'sounds/SP3.mp3',
];

//late int mantraSoundSelected;
//late String mantraSoundPath;
//late Source mantraSoundSource;

//Duration mantraDuration = const Duration(seconds: 0);
//Duration totalMantraDuration = const Duration(seconds: 0);
int recitations = 0;

final mantraAudioController = TextEditingController();
