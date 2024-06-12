import 'package:flutter/material.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';
import 'package:roullet_app/Scale%20Size/scale_size.dart';


class OddEvenBoxes extends StatelessWidget {
  const OddEvenBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w =  size.width;
    return Row(
      children: [
         OddEvenBox(color: colors.darkPinkColor,text: "EVEN",width: w,height: h),
        SizedBox(width: w*0.02 ,),
         OddEvenBox(color: colors.borderColorLight,text: "ODD",width: w,height: h),
      ],
    );
  }
}


class OddEvenBox extends StatelessWidget {
  const OddEvenBox({super.key, required this.text, required this.color, required this.height, required this.width});
   final String text;
   final Color color;
   final double height;
   final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height*0.067,
      width: width*0.098,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: colors.secondary,
          border: Border.all(color: colors.borderColorLight),
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(16),left:Radius.circular(16) ),
          boxShadow: [
            BoxShadow(
                color: colors.borderColorLight.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 3
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
            textScaleFactor: ScaleSize.textScaleFactor(width) ,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'digital',
                fontStyle: FontStyle.normal,
                letterSpacing: 1.5
            ),),
          Container(
            width: width*0.022,
            height: height*0.028,
            decoration:  BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16),left:Radius.circular(16) ),
            ),
          ),
        ],
      ),
    );
  }
}
