import 'package:flutter/material.dart';
import '../constants.dart';

class ImageContent extends StatelessWidget {
  ImageContent({required this.displayImage, required this.label});

  final ImageProvider displayImage;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 1.0,
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadiusCircular),
            child: Image(
              image: ResizeImage(displayImage, width: 400, height:500, allowUpscaling: true),
              //fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          height: 1.0,
        ),
      ],
    );
  }
}
