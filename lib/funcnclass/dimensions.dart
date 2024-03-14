
import 'package:flutter/material.dart';

List<double> dim(context) {
  double h = MediaQuery
      .of(context)
      .size
      .height;
  double w = MediaQuery
      .of(context)
      .size
      .width;
  return [h, w];
}