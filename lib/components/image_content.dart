import 'package:flutter/material.dart';
import '../common/constants.dart';

class ImageData {
  final String imagePath;
  final String imageCaption;

  ImageData(this.imagePath, this.imageCaption);
}

class ImageContent extends StatelessWidget {
  ImageContent({required this.displayImage, required this.label});

  final ImageProvider displayImage;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(kBorderRadiusCircular),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: displayImage, fit: BoxFit.fill),
                  ),
                ),
              ),
              Center(
                child: Text(
                  label,
                  style: kLabelTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}