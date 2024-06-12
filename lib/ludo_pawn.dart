import 'package:flutter/material.dart';

class LudoPawn extends StatelessWidget {
  final Color color;
  final double size;

  LudoPawn({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size*0.6, size*0.52),
      painter: LudoPawnPainter(color: color),
    );
  }
}

class LudoPawnPainter extends CustomPainter {
  final Color color;

  LudoPawnPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

    canvas.save();
    canvas.translate(3, 3); // Offset for shadow
    drawPawn(canvas, size, shadowPaint,true);
    canvas.restore();

    drawPawn(canvas, size, paint,false);
  }

  void drawPawn(Canvas canvas, Size size, Paint paint,bool isShadow) {
    // Draw the body
    Path bodyPath = Path();
    bodyPath.moveTo(size.width * 0.5, size.height);
    bodyPath.quadraticBezierTo(
        size.width * 0.15, size.height * 0.5, size.width * 0.5, size.height * 0.4);
    bodyPath.quadraticBezierTo(
        size.width * 0.85, size.height * 0.5, size.width * 0.5, size.height);
    canvas.drawPath(bodyPath, paint);

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final whiteCenter = Offset(size.width / 2, size.height * 0.6);
    final whiteRadius = size.width * 0.09;
    isShadow?null:canvas.drawCircle(whiteCenter, whiteRadius, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
