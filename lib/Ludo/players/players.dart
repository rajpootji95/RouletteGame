
import 'dart:math';

import 'package:flutter/material.dart';

class PlayersPainter extends CustomPainter {
  // Offset? playerCurrentSpot;
  // Color? playerColor;
  final Map<Offset, List<Player>> groupedPlayers;
  PlayersPainter(
      {required this.groupedPlayers});

  double? playerSize, playerInnerSize, _stepSize;
  Paint _playerPaint = Paint()..style = PaintingStyle.fill;
  Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    _stepSize = size.width / 15;
    playerSize = _stepSize! / 3;
    playerInnerSize = playerSize! / 1.5;
   // Path path = Path();

    // Draw players
    // debugPrint("grouped players ==> ${groupedPlayers}");

    groupedPlayers.forEach((pos, playersAtPos) {
      // path.moveTo(pos.dx,pos.dy);
      // path.quadraticBezierTo(pos.dx, pos.dy, pos.dx+1, pos.dy+1);
      if (playersAtPos.length == 1) {
        _drawPlayerShape(canvas, pos, playersAtPos.first.playerColor!);
        // _drawPlayerShape(canvas, pos, playersAtPos.first.playerColor!);
      } else {
        _drawMultiplePlayers(canvas, pos, playersAtPos);
      }
    });

    // for(Player player in players) {
    //   _drawPlayerShape(canvas, player.playerCurrentSpot!, player.playerColor!);
    // }
  }

  void _drawMultiplePlayers(Canvas canvas, Offset pos, List<Player> players) {
    // debugPrint("drawing multi players");
    int playerCount = players.length;
    double multiPlayerSize = playerSize! / (1 + (playerCount / 4));
    double multiPlayerInnerSize = playerInnerSize! / (1 + (playerCount / 4));
    double radius = playerSize! * 0.9;
    double strokeWidth = 1.5/playerCount;
    for (int i = 0; i < playerCount; i++) {
      if(players[i].playerColor == Colors.transparent){}else {
        double angle = (2 * pi * i + 1) / playerCount;
        Offset offset =
            Offset(pos.dx + radius * cos(angle), pos.dy + radius * sin(angle));
        _drawPlayerShape(canvas, offset, players[i].playerColor!,
            multiPlayerSize, multiPlayerInnerSize, strokeWidth);
      }
    }
  }

  /*void _drawMultiplePlayers(Canvas canvas, Offset pos, List<Player> players) {
    int playerCount = players.length;
    double multiPlayerSize = playerSize! / playerCount;
    double multiPlayerInnerSize = playerInnerSize! / playerCount;
    double radius = multiPlayerSize * playerCount;

    // Draw players in a grid or circle around the position
    for (int i = 0; i < playerCount; i++) {
      double angle = (2 * pi * i) / playerCount;
      // debugPrint("angle...${i}..${angle}");
      Offset offset = Offset(pos.dx + radius * sin(angle), pos.dy + radius * sin(angle));
      _drawPlayerShape(canvas, offset, players[i].playerColor!, multiPlayerSize, multiPlayerInnerSize);

    }
  }*/

  void _drawPlayerShape(Canvas canvas, Offset pos, Color color, [double? size, double? innerSize, double? strokeWidth]) {
    if(color == Colors.transparent)return;
    double actualSize = size ?? playerSize!;
    double actualInnerSize = innerSize ?? playerInnerSize!;
    _strokePaint.strokeWidth = strokeWidth??1.5;
    _playerPaint.color = Colors.white;

    canvas.drawCircle(pos, actualSize, _playerPaint);
    canvas.drawCircle(pos, actualSize, _strokePaint);

    _playerPaint.color = color;
    canvas.drawCircle(pos, actualInnerSize, _playerPaint);
    canvas.drawCircle(pos, actualInnerSize, _strokePaint);
  }
  // void _drawPlayerShape(Canvas canvas, Offset pos, Color color) {
  //   debugPrint("painting single  player...");
  //   _playerPaint.color = color;
  //   canvas.drawCircle(pos, playerSize!, _playerPaint);
  //   canvas.drawCircle(pos, playerSize!, _strokePaint);
  //   _playerPaint.color = Colors.white;
  //   canvas.drawCircle(pos, playerInnerSize!, _playerPaint);
  //   canvas.drawCircle(pos, playerInnerSize!, _strokePaint);
  // }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool hitTest(Offset position) => false; //to pass touches to layer beneath
}


class Player {
  final Offset? playerCurrentSpot;
  final Color? playerColor;

  Player({this.playerCurrentSpot, this.playerColor});
}

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayersPainter extends CustomPainter {
  Offset? playerCurrentSpot;
  Color? playerColor;

  PlayersPainter(
      {this.playerCurrentSpot, this.playerColor});

  double? _playerSize, _playerInnerSize, _stepSize;
  Paint _playerPaint = Paint()..style = PaintingStyle.fill;
  Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    _stepSize = size.width / 15;
    _playerSize = _stepSize! / 3;
    _playerInnerSize = _playerSize! / 2.5;
    Map<Offset, List<Player>> groupedPlayers = {};
      if (playerCurrentSpot != null) {
        if (!groupedPlayers.containsKey(playerCurrentSpot)) {
          groupedPlayers[player.playerCurrentSpot!] = [];
        }
        groupedPlayers[player.playerCurrentSpot!]!.add(player);
      }


    for (Offset pos in groupedPlayers.keys) {
      List<Player> playersAtPos = groupedPlayers[pos]!;
      if (playersAtPos.length > 1) {
        _drawMultiplePlayers(canvas, pos, playersAtPos);
      } else {
        Player player = playersAtPos.first;
        _drawPlayerShape(canvas, player.playerCurrentSpot!, player.playerColor!);
      }
    }
    _drawPlayerShape(canvas, playerCurrentSpot!, playerColor!);
  }
  void _drawPlayerShape(Canvas canvas, Offset pos, Color color) {
    _playerPaint.color = color;
    canvas.drawCircle(pos, _playerSize!, _playerPaint);
    canvas.drawCircle(pos, _playerSize!, _strokePaint);

    _playerPaint.color = Colors.white;
    canvas.drawCircle(pos, _playerInnerSize!, _playerPaint);
    canvas.drawCircle(pos, _playerInnerSize!, _strokePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool hitTest(Offset position) => false; //to pass touches to layer beneath
}

class Player {
  final Offset? playerCurrentSpot;
  final Color? playerColor;

  Player({this.playerCurrentSpot, this.playerColor});
}*/