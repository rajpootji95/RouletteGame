
import 'package:flutter/material.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';
import 'package:roullet_app/Scale%20Size/scale_size.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key, required this.text, required this.h, required this.w});
  final String text;
  final double h;
  final double w;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: h*0.09,
      width: w*0.11,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.6),
          border: Border.all(color: colors.borderColorDark,width: 2),
          //  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16),left:Radius.circular(16) ),
          boxShadow: [
            BoxShadow(
              color: colors.borderColorDark.withOpacity(0.7),
              blurRadius: 10,
              spreadRadius: 3,
              // offset: Offset(-3, -3)
            ),

          ]
      ),
      child:  Center(
        child:  Text(text,
          textScaleFactor: ScaleSize.textScaleFactor(w,maxTextScaleFactor: 1.5),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'CinzelDecorative',
            fontStyle: FontStyle.normal,
          ),),
      ),
    );
  }
}
