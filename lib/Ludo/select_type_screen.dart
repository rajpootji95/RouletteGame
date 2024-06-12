
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';

import '../Helper_Constants/Images_path.dart';
import '../audio_controller.dart';
import 'connect_to_user_socket.dart';
import 'game.dart';

class SelectTypeScreen extends StatefulWidget {
  final AudioController audioController;
  const SelectTypeScreen({super.key,required this.audioController});

  @override
  State<SelectTypeScreen> createState() => _SelectTypeScreenState();
}

class _SelectTypeScreenState extends State<SelectTypeScreen> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return  SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar : true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: colors.whiteTemp), // 1,
          elevation: 0.0,
            backgroundColor: Colors.transparent,
        /*  leading:  InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
              child: Icon(Icons.arrow_back,color: colors.whiteTemp,)),*/
          centerTitle: true,
          title: const Text("Select Game Type",style: TextStyle(color: colors.whiteTemp),),
        ),
        body:Container(
            height: h,
            width: w,
            decoration:  BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // colors.primary.withOpacity(0.9),
                    // colors.primary.withOpacity(0.9),
                    colors.secondary,
                    colors.primary.withOpacity(0.8),
                    colors.secondary,
                   // colors.secondary,
                  ],
                ),
                image: const DecorationImage(
                    image: AssetImage(ImagesPath.backGroundImage),
                    fit: BoxFit.cover)),
            child:  ListView(
              children: [
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {

                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(audioController: widget.audioController))).then((value){
                          //   // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                          //
                          // });

                        });
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.whiteTemp)

                        ),
                        child: Column(
                          children: [
                            Image.asset("assets/ludo/single-removebg-preview.png",scale: 3,),
                            const SizedBox(height: 1,),
                            const Text("Play With\n   Single",style: TextStyle(color: colors.whiteTemp,fontSize: 15),),
                          ],
                        ),
                      ),

                    ),
                    const SizedBox(width: 10,),
                    //Icon(Icons.arr)
                    InkWell(
                      onTap: (){
                        //setState(() {

                          // getNewListApi(1);
                          /*yha se ja rha hu tab*/

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ConnectSocket(audioController: widget.audioController,))).then((value) {
                           // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                          });
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Ludo Game No Implement')),
                          // );


                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.whiteTemp)
                        ),
                        child: Column(
                          children: [
                            Image.asset("assets/ludo/team1-removebg-preview.png",scale: 3,),
                            const SizedBox(height: 5,),
                            const Text("Play With\n   Team",style: TextStyle(color: colors.whiteTemp,fontSize: 15),),
                          ],
                        ),
                      ),


                    ),
                  ],
                )
              ],
            ),),


      ),
    );
  }

}
