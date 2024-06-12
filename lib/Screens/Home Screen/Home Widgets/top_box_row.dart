
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roullet_app/Helper_Constants/Images_path.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';
import 'package:roullet_app/Scale%20Size/scale_size.dart';

class TopBoxesRow extends StatefulWidget {
  ValueNotifier<int> /*minuteM,*/ secondS;
   TopBoxesRow({super.key, required this.w, required this.h,/*required this.minuteM,*/required this.secondS,
     /*required this.countDown, */required this.primaryWalletAmount});
   /*final Stream<int> countDown;*/
  final double w;
  final String primaryWalletAmount;
  final double h ;

  @override
  State<TopBoxesRow> createState() => _TopBoxesRowState();
}

class _TopBoxesRowState extends State<TopBoxesRow> with TickerProviderStateMixin {

  late final AnimationController _animationController;
  late Animation<double> _blinkAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this,duration: const Duration(milliseconds: 500))
    ..forward()
    ..addListener(() {
      if(_animationController.isCompleted){
        _animationController.repeat();
      }
    });
    _blinkAnimation = Tween<double>(begin: 1,end: 0).animate(_animationController);
  }
  int i =0;
  @override
  Widget build(BuildContext context) {
    // i++;
    // debugPrint("called $i");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(ImagesPath.scoreImage,width: widget.w*0.11,height: widget.h*0.17,),
         SizedBox(width: widget.w*0.06,),
        Stack(
          alignment: Alignment.center,
          children: [
          Image.asset(ImagesPath.timerImage,width: widget.w*0.11,height: widget.h*0.17,),
           Positioned(
            top: widget.h*0.08,
              child:
              ValueListenableBuilder(
                valueListenable: widget.secondS,
                builder: (_,second,child) {
                  return
                    second<=10?
                    AnimatedBuilder(
                      animation: _blinkAnimation,
                    builder: (context,child) {
                      return Text(
                         // '${widget.minuteM.value.toString().padLeft(2,"0")}:${second.toString().padLeft(2, '0')}',
                        second.toString(),
                        textScaleFactor: ScaleSize.textScaleFactor(widget.w,maxTextScaleFactor: 2.6),
                        style:  TextStyle(
                          fontFamily: 'digital',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color:colors.borderColorLight.withOpacity(_blinkAnimation.value),
                          //backgroundColor: widget.secondS.value<= 10?Colors.red.withOpacity(_blinkAnimation.value):Colors.transparent
                        ),
                      );
                    }
                  ):
                    Text(
                      // '${widget.minuteM.value.toString().padLeft(2,"0")}:${snapshot.data.toString().padLeft(2, '0')}',
                      second.toString(),
                      textScaleFactor: ScaleSize.textScaleFactor(widget.w,maxTextScaleFactor: 2.6),
                      style:  const TextStyle(
                        fontFamily: 'digital',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: colors.borderColorDark,
                        //backgroundColor: widget.secondS.value<= 10?Colors.red.withOpacity(_blinkAnimation.value):Colors.transparent
                      ),
                    );
                }
              ),
              // Text("${minuteM}:${secondS}",style: const TextStyle(
              //   fontSize: 18,color: colors.whiteTemp,fontFamily: "DIGITAL",fontWeight: FontWeight.bold
              // ),)
           ),
           ],
        ),
         SizedBox(width:  widget.w*0.06,),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(ImagesPath.winnerImage,width: widget.w*0.11,height: widget.h*0.17,),
            Positioned(
              top: widget.h*0.09,
              child: Text(
                // '${widget.minuteM.value.toString().padLeft(2,"0")}:${snapshot.data.toString().padLeft(2, '0')}',
                '₹${widget.primaryWalletAmount}',
                textScaleFactor: ScaleSize.textScaleFactor(widget.w,maxTextScaleFactor: 2.2),
                style:  TextStyle(
                  fontFamily: 'digital',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color:colors.borderColorLight,
                  //backgroundColor: widget.secondS.value<= 10?Colors.red.withOpacity(_blinkAnimation.value):Colors.transparent
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
