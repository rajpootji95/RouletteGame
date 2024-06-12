import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// We shift the coordinates to the center of the screen
    canvas.translate(size.width / 2, size.height / 2);

    // Total angle of a circle is 360
    const totalDegree = 360;

    // Total ticks to display
    const totalTicks = 12;


    /// The angle between each tick
    const unitAngle = totalDegree / totalTicks;

    final clockPaint = Paint()
      ..color = Colors.red[900]!.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    /// Draws the clock circle frame
    canvas.drawCircle(
      Offset.zero,
      90,
      clockPaint,
    );

    /// Draws the clock hour hand
    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(3.1416, 40),
      Paint()
        ..color = Colors.red[400]!
        ..strokeWidth = 4,
    );

    /// Draws the clock minute hand
    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(-3.1416/ 2, 60),
      Paint()
        ..color = Colors.red[400]!
        ..strokeWidth = 4,
    );

    /// Draws the center smaller circle
    canvas.drawCircle(
      Offset.zero,
      6,
      clockPaint
        ..style = PaintingStyle.fill
        ..color = Colors.red[900]!,
    );


    for (int i = 0; i <= 11; i++) {
      /// calculates the angle of each tick index
      /// reason for adding 90 degree to the angle is
      /// so that the ticks starts from
      final angle = -90.radians + (i * unitAngle).radians;

      /// Draws the tick for each angle
      canvas.drawLine(
        Offset.fromDirection(angle, 70),
        Offset.fromDirection(angle, 80),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 4,
      );
    }
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) => false;
}
extension on num {
  double get radians => (this * 3.1416)/180;
}