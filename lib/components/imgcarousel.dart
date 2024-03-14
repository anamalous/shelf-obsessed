import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
class ImageCaro extends StatelessWidget {
  final List<String> imgurls;
  const ImageCaro({required this.imgurls});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CarouselSlider(
          options: CarouselOptions(height: 500.0),
          items: imgurls.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    border:Border.all(color: Colors.grey.shade700,width: 1)
                  ),
                  padding: EdgeInsets.all(20),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Image(
                    image:AssetImage("assets/images/$i"),
                fit: BoxFit.cover,
                )
                );
              },
            );
          }).toList(),
        )
    );
  }
}