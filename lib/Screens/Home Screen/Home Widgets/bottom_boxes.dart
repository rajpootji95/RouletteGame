import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roullet_app/Widgets/bottom_container.dart';


class BottomBoxes extends StatelessWidget {
  final VoidCallback onMove;
  final VoidCallback onCanceled;
  final VoidCallback onTake;
  const BottomBoxes({super.key, required this.onMove, required this.onCanceled, required this.onTake});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w =  size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onTake,
            child: BottomContainer(text: "TAKE", h: h, w: w)),
        // SizedBox(width: h*0.06,),
        // GestureDetector(
        //   onTap: onMove,
        //     child: BottomContainer(text: "BET OK", h: h, w: w)),
        SizedBox(width: h*0.06,),
        GestureDetector(
          onTap: onCanceled,
            child: BottomContainer(text: "CANCEL", h: h, w: w)),
        SizedBox(width: h*0.12,),
      ],
    );
  }
}
