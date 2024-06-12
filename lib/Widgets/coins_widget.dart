
import 'package:flutter/material.dart';
import 'package:roullet_app/Helper_Constants/Images_path.dart';
import 'package:roullet_app/Scale%20Size/scale_size.dart';

import '../Helper_Constants/colors.dart';

class CoinWidget extends StatelessWidget {
   const CoinWidget({super.key, required this.foreGroundColor,required this.text,required this.onTap, required this.selected});
   final Color? backGroundColor = Colors.white;
   final Color foreGroundColor;
   final String text;
   final bool selected;
   final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w =  size.width;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              decoration:   BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow:
                  selected?[
                              const BoxShadow(
                                color: colors.borderColorDark,
                                blurRadius: 4,
                                spreadRadius: 4,
                              )
                            ]:[]
              ),
              child: Image.asset(ImagesPath.coinForeGroundImage,width: w*0.04,color:foreGroundColor,)),
          Text(
            text,
            textScaler: TextScaler.linear(ScaleSize.textScaleFactor(w,maxFixFactor: 0.55,maxTextScaleFactor: 1)),
            style: TextStyle(
                color: backGroundColor,
                fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
