import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';

class DiceBasePainter extends CustomPainter {
  double _startAngle;
  final int _currentTurn;

  DiceBasePainter(this._startAngle,this._currentTurn);

  getDiceBgColor(currentTurn){
    Color bgColor = Colors.red;
    switch(currentTurn){
      case 0:
        bgColor = Colors.red;
        break;
      case 1:
        bgColor = Colors.green;
        break;
      case 2:
        bgColor = Colors.yellow;
        break;
      default:
        bgColor = Colors.blue;
        break;
    }
    return bgColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var radius = size.width;

    var center = Offset(size.width / 2, size.width / 2);
    var acrAngle = 30 * pi / 180;

    for (int arcIndex = 0; arcIndex < 12; arcIndex++) {
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          _startAngle,
          acrAngle,
          false,
          Paint()
            ..color = arcIndex % 2 == 0 ? getDiceBgColor(_currentTurn) : Colors.white
            ..strokeWidth = 7
            ..style = PaintingStyle.stroke);

      _startAngle += acrAngle;
    }

    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = getDiceBgColor(_currentTurn)
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
