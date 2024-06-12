import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roullet_app/audio_controller.dart';

import '../../Helper_Constants/Images_path.dart';
import '../../Helper_Constants/colors.dart';
import '../../Ludo/select_type_screen.dart';
import '../Home Screen/home_screen.dart';

class SelectGame extends StatefulWidget {
  const SelectGame({super.key, required this.audioController});

  final AudioController audioController;

  @override
  State<SelectGame> createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        body: Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.secondary,
                    colors.primary,
                    colors.secondary,
                  ],
                ),
                image: DecorationImage(
                    image: AssetImage(ImagesPath.backGroundImage),
                    fit: BoxFit.cover)),
            child: selectGame()),
      ),
    );
  }

  int _currentIndex = 2;

  selectGame() {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Row(
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset(ImagesPath.mainLogoImage)),
                  // const Text("Select Game",style: TextStyle(
                  //     color: colors.yellow,fontSize: 25
                  // ),),
                  GradientText(
                    'Select Game',
                    gradient: const LinearGradient(
                      colors: [
                        colors.red,
                        colors.yellow,
                      ],

                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _currentIndex = 2;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                        audioController: widget
                                            .audioController))).then((value) {
                              // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                            });
                          });
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _currentIndex == 2
                                      ? colors.whiteTemp
                                      : colors.yellow)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Image.asset(
                                "assets/images/roulette.png",
                                scale: 8.0,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Roulette",
                                style: TextStyle(
                                    color: _currentIndex == 2
                                        ? colors.whiteTemp
                                        : colors.yellow,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _currentIndex = 4;
                            // getNewListApi(1);
                            /*yha se ja rha hu tab*/
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectTypeScreen(
                                            audioController:
                                                widget.audioController)))
                                .then((value) async {
                              await Future.delayed(250.milliseconds);
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight,
                              ]);
                            });
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text('Ludo Game No Implement')),
                            // );
                          });
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _currentIndex == 4
                                      ? colors.whiteTemp
                                      : colors.yellow)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Image.asset(
                                "assets/images/ludo.png",
                                scale: 8.0,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Ludo",
                                style: TextStyle(
                                    color: _currentIndex == 4
                                        ? colors.whiteTemp
                                        : colors.yellow,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _currentIndex = 3;
                            // getNewListApi(1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Card Game No Implement ')),
                            );
                          });
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _currentIndex == 3
                                      ? colors.whiteTemp
                                      : colors.yellow)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Image.asset(
                                "assets/images/3d-card-game.png",
                                scale: 8.0,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Card",
                                style: TextStyle(
                                    color: _currentIndex == 3
                                        ? colors.whiteTemp
                                        : colors.yellow,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _currentIndex = 1;
                            // getNewListApi(1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Dice Game No Implement ')),
                            );
                          });
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _currentIndex == 1
                                      ? colors.whiteTemp
                                      : colors.yellow)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Image.asset(
                                "assets/images/dice.png",
                                scale: 8.0,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Dice",
                                style: TextStyle(
                                    color: _currentIndex == 1
                                        ? colors.whiteTemp
                                        : colors.yellow,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Do you want to exit?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('yes selected');
                            exit(0);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colors.whiteTemp),
                          child: const Text("Yes",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          print('no selected');
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                        ),
                        child: const Text("No",
                            style: TextStyle(color: Colors.white)),
                      ))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  GradientText(
    this.text, {
    required this.gradient,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: (style == null)
            ? TextStyle(color: Colors.yellow)
            : style.copyWith(color: Colors.yellow),
      ),
    );
  }
}
