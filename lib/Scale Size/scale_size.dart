import 'dart:math';
import 'package:flutter/material.dart';

class ScaleSize {
  static double textScaleFactor(width, {double maxTextScaleFactor = 2,double maxFixFactor = 0.9 }) {
    double val = (width / 1400) * maxTextScaleFactor;
    return max(maxFixFactor, min(val, maxTextScaleFactor));
  }
}