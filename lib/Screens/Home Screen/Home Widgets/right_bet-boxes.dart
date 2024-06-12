
import 'package:flutter/material.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';
import 'package:roullet_app/Scale%20Size/scale_size.dart';
class RightBetBoxes extends StatelessWidget {
  const RightBetBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w =  size.width;
    return Column(
      children:  [
        BetBox(text: "Make tHis Bet",w: w,h: h),
        SizedBox(height: h*0.03,),
        BetBox(text: "Cancel\n Specific Bet",w: w,h: h),
      ],
    );
  }
}

 class BetBox extends StatelessWidget {
   const BetBox({super.key,required this.text, required this.h, required this.w});
   final String text;
   final double h;
   final  double w;

   @override
   Widget build(BuildContext context) {
     return Container(
       width: w*0.16 > 112? w*0.16:112,
       padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 1),
       decoration: BoxDecoration(
         color: colors.primary.withOpacity(0.8),
         border: Border.all(color: colors.borderColorDark),
         borderRadius: const BorderRadius.horizontal(right: Radius.circular(24),left:Radius.circular(24) ),

       ),
       child:  Text(text,
         textAlign: TextAlign.center,
         textScaleFactor: ScaleSize.textScaleFactor(w,maxTextScaleFactor:1, maxFixFactor: 0.7),
         style: const TextStyle(
           color: Colors.white,
           fontFamily: 'CinzelDecorative',
           fontStyle: FontStyle.normal,
         ),),
     );
   }
 }

