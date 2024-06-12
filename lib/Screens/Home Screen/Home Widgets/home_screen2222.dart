// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:blurrycontainer/blurrycontainer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gradient_borders/gradient_borders.dart';
// import 'package:roullet_app/Helper_Constants/Images_path.dart';
// import 'package:roullet_app/Helper_Constants/colors.dart';
// import 'package:roullet_app/Helper_Constants/sounds_source_path.dart';
// import 'package:roullet_app/Scale%20Size/scale_size.dart';
// import 'package:roullet_app/Screens/Home%20Screen/Home%20Widgets/bottom_boxes.dart';
// import 'package:roullet_app/Screens/Home%20Screen/Home%20Widgets/odd_even_boxes.dart';
// import 'package:roullet_app/Screens/Home%20Screen/Home%20Widgets/right_bet-boxes.dart';
// import 'package:roullet_app/Screens/Home%20Screen/Home%20Widgets/roulette_table.dart';
// import 'package:roullet_app/Screens/Home%20Screen/Home%20Widgets/top_box_row.dart';
// import 'package:roullet_app/Screens/Auth/login_screen.dart';
// import 'package:roullet_app/Screens/Update%20Password/change_password.dart';
// import 'package:roullet_app/Widgets/coins_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int? selectedCoin;
//   bool? canceled = false;
//
//   // void selectNumber() {
//   //   setState(() {
//   //     selectedNumber = Random().nextInt(36) + 1; // Generates random number from 1 to 36
//   //   });
//   // }
//   int _minutes = 0;
//   int _seconds = 10;
//   late Timer timer;
//   late int time;
//   int value = 0;
//   bool isLoading = false;
//   final TextEditingController _amountController = TextEditingController();
//
//   void startCountdown() {
//     const oneSec = Duration(seconds: 1);
//     timer = Timer.periodic(
//       oneSec,
//       (timer) {
//         if (_minutes == 0 && _seconds == 0) {
//           setState(() {});
//           timer.cancel();
//
//           _minutes = 0;
//           _seconds = 10;
//         } else if (_seconds == 0) {
//           setState(() {
//             _minutes--;
//             _seconds = 59;
//           });
//         } else {
//           setState(() {
//             _seconds--;
//           });
//         }
//       },
//     );
//   }
//
//   late double degree;
//
//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
//
//   bool showWheel = false;
//
//   bool showSettings = false;
//
//   double rotationAngle = 0;
//   String rotationSpeedText = "20"; // Initial rotation speed
//   static const rotationDuration = Duration(
//       seconds:
//           4); // Adjust the duration as needed for your desired rotation speed
//   Timer? rotationTimer;
//
//   void startTimer() {
//     time = 5000;
//     timer = Timer.periodic(const Duration(milliseconds: 10), (timer) async {
//       if (time > 0) {
//         setState(() {
//           rotationTimer = Timer(rotationDuration, () {
//             // rotationTimer?.cancel();
//           });
//         });
//         time = time - 100;
//       } else {}
//     });
//   }
//
//   void startRotation() {
//     playAudio(SoundSource.spinWheelSoundPath);
//     double rotationSpeed = 20; // Initial rotation speed
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (rotationTimer?.isActive ?? false) {
//         rotationAngle += rotationSpeed;
//
//         if (rotationAngle >= 360) {
//           rotationAngle = 0;
//         }
//
//         setState(() {
//           // Update rotation speed text
//           rotationSpeedText =
//               'Rotation Speed: ${rotationSpeed.toStringAsFixed(2)}';
//         });
//
//         if (rotationSpeed > 0.5) {
//           // Define a threshold to stop rotation
//           rotationSpeed -= 0.5; // Decrease the rotation speed gradually
//         }
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   playAudio(String sourcePath) {
//     AudioPlayer().play(AssetSource(sourcePath));
//   }
//
//   onCoinTap(value) {
//     setState(() {
//       if (selectedCoin == null || selectedCoin != value) {
//         selectedCoin = value;
//         playAudio(SoundSource.coinSelectSoundPath);
//       } else {
//         playAudio(SoundSource.coinRemoveSoundPath);
//         selectedCoin = null;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//       ),
//     );
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: [SystemUiOverlay.bottom],
//     );
//     Size size = MediaQuery.of(context).size;
//     double h = size.height;
//     double w = size.width;
//     debugPrint("height $h & width $w");
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: () => showExitPopup(context),
//         child: Scaffold(
//             body: Stack(
//           children: [
//             Container(
//               height: h,
//               width: w,
//               decoration: const BoxDecoration(
//                   gradient: LinearGradient(colors: [
//                     colors.secondary,
//                     colors.primary,
//                     colors.secondary,
//                   ]),
//                   image: DecorationImage(
//                       image: AssetImage(ImagesPath.backGroundImage),
//                       fit: BoxFit.fill)),
//             ),
//             Positioned(
//                 top: 6,
//                 left: 6,
//                 child: Row(
//                   children: const [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundColor: colors.whiteTemp,
//                       child: Icon(
//                         Icons.person,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 )),
//             Positioned(
//                 top: 6,
//                 right: 13,
//                 child: Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           showSettings = !showSettings;
//                         });
//                       },
//                       child: const Icon(
//                         Icons.settings,
//                         color: colors.white70,
//                       ),
//                     ),
//                   ],
//                 )),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 16.0),
//                   child: Container(
//                       decoration: const BoxDecoration(boxShadow: [
//                         BoxShadow(
//                             color: Colors.black38,
//                             blurRadius: 60,
//                             spreadRadius: 12,
//                             offset: Offset(1, 24))
//                       ]),
//                       child: Image.asset(
//                         ImagesPath.rouletteImage,
//                         width: w * 0.2,
//                       )),
//                 ),
//                 // const SizedBox(height: 20,),
//                 // const Padding(
//                 //   padding:  EdgeInsets.only(left: 12),
//                 //   child: OddEvenBoxes(),
//                 // ),
//                 SizedBox(
//                   height: h * 0.07,
//                 ),
//               ],
//             ),
//             Positioned(
//               left: 12,
//               bottom: 16,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 4),
//                 child: GestureDetector(
//                     onTap: () {
//                       showExitPopup(context);
//                     },
//                     child: Image.asset(
//                       ImagesPath.exitImage,
//                       width: w * 0.15,
//                     )),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topCenter,
//               child: Column(
//                 children: [
//                   TopBoxesRow(h: h, w: w, minuteM: _minutes, secondS: _seconds),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       BetBox(text: "Cancel\n Specific Bet", w: w, h: h),
//                       SizedBox(
//                         width: w * 0.02,
//                       ),
//                       CoinWidget(
//                         foreGroundColor: Colors.teal.shade700,
//                         text: "50",
//                         onTap: () {
//                           onCoinTap(50);
//                         },
//                         selected: selectedCoin == 50,
//                       ),
//                       SizedBox(
//                         width: w * 0.02,
//                       ),
//                       CoinWidget(
//                         foreGroundColor: Colors.red.shade900,
//                         text: "100",
//                         onTap: () {
//                           onCoinTap(100);
//                         },
//                         selected: selectedCoin == 100,
//                       ),
//                       SizedBox(
//                         width: w * 0.02,
//                       ),
//                       CoinWidget(
//                         foreGroundColor: Colors.yellow.shade900,
//                         text: "200",
//                         onTap: () {
//                           onCoinTap(200);
//                         },
//                         selected: selectedCoin == 200,
//                       ),
//                       SizedBox(
//                         width: w * 0.02,
//                       ),
//                       CoinWidget(
//                         foreGroundColor: Colors.blueGrey.shade700,
//                         text: "500",
//                         onTap: () {
//                           onCoinTap(500);
//                         },
//                         selected: selectedCoin == 500,
//                       ),
//                       SizedBox(
//                         width: w * 0.02,
//                       ),
//                       CoinWidget(
//                         foreGroundColor: Colors.pink.shade900,
//                         text: "1000",
//                         onTap: () {
//                           onCoinTap(1000);
//                         },
//                         selected: selectedCoin == 1000,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: h * 0.03,
//                   ),
//                   RouletteTable(
//                     selectedCoin: selectedCoin ?? 0,
//                     isClear: canceled ?? false,
//                     onChanged: (v) {
//                       if (v) {
//                         setState(() {
//                           canceled = false;
//                         });
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: h * 0.04,
//                   ),
//                   BottomBoxes(
//                     onMove: () {
//                       setState(() {
//                         showWheel = true;
//                         startRotation(); // Start t
//                         startTimer();
//                       });
//                     },
//                     onCanceled: () {
//                       setState(() {
//                         canceled = true;
//                       });
//                     },
//                   )
//                 ],
//               ),
//             ),
//             showWheel
//                 ? Align(
//                     alignment: Alignment.center,
//                     child: Stack(
//                       children: [
//                         BlurryContainer(
//                           blur: 2,
//                           height: h,
//                           width: w,
//                           elevation: 0,
//                           color: Colors.transparent,
//                           child: Stack(
//                             alignment: Alignment.topRight,
//                             children: [
//                               Container(
//                                 alignment: Alignment.center,
//                                 child: SizedBox(
//                                   width: 250,
//                                   height: 250,
//                                   child: Stack(children: [
//                                     Align(
//                                       alignment: Alignment.center,
//                                       child: Stack(
//                                         children: [
//                                           // Image.asset(
//                                           //   ImagesPath.rouletteBorderImage,
//                                           //   scale: 2,
//                                           // ),
//                                           Transform.rotate(
//                                             angle: rotationAngle * (3.14 / 25),
//
//                                             // Convert degrees to radians
//                                             child: Image.asset(
//                                               ImagesPath.rouletteImage,
//                                               scale: 1,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Align(
//                                         alignment: Alignment.topCenter,
//                                         child: Column(
//                                           children: const [
//                                             Icon(Icons.place,
//                                                 size: 30, color: colors.yellow),
//                                           ],
//                                         ))
//                                   ]),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Positioned(
//                             right: 12,
//                             top: 12,
//                             child: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     showWheel = !showWheel;
//                                   });
//                                 },
//                                 icon: const Icon(
//                                   Icons.close,
//                                   color: colors.grad2Color,
//                                 )))
//                       ],
//                     ),
//                   )
//                 : const SizedBox(),
//             showSettings
//                 ? Align(
//                     alignment: Alignment.bottomRight,
//                     child: Stack(
//                       children: [
//                         AnimatedContainer(
//                           decoration: const BoxDecoration(
//                               color: colors.white70,
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(10),
//                                   bottomLeft: Radius.circular(80))),
//                           height: h * 0.9,
//                           width: w * 0.25,
//                           duration: Duration(milliseconds: 1000),
//                           child: Stack(
//                             alignment: Alignment.topRight,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // const SizedBox(height: 20,),
//                                   Container(
//                                     padding: const EdgeInsets.all(5),
//                                     color: colors.secondary,
//                                     child: Row(
//                                       children: [
//                                         const CircleAvatar(
//                                           radius: 20,
//                                           backgroundColor: colors.whiteTemp,
//                                           child: Icon(
//                                             Icons.person,
//                                             size: 30,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children:  [
//                                             Text("$userName",
//                                                 style: const TextStyle(
//                                                     color: colors.whiteTemp)),
//                                             Text("$userEmail",
//                                                 style:  const TextStyle(
//                                                     color: colors.whiteTemp)),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>WithdrawalScreen())).then((value) {
//                                       showSettings=false;
//                                       SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//
//                                     });
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(5),
//                                       color: colors.secondary,
//                                       child: Row(
//                                         children: const [
//                                           Icon(
//                                             Icons.wallet,
//                                             color: colors.whiteTemp,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text(
//                                             "Wallet",
//                                             style: TextStyle(
//                                               color: colors.whiteTemp,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePassword())).then((value) {
//                                         showSettings=false;
//                                         SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//                                       });
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(5),
//                                       color: colors.secondary,
//                                       child: Row(
//                                         children: const [
//                                           Icon(
//                                             Icons.lock_outlined,
//                                             color: colors.whiteTemp,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text(
//                                             "Change Password",
//                                             style: TextStyle(
//                                               color: colors.whiteTemp,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       showLogOutPopup(context);
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(5),
//                                       color: colors.secondary,
//                                       child: Row(
//                                         children: const [
//                                           Icon(
//                                             Icons.logout_outlined,
//                                             color: colors.whiteTemp,
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text(
//                                             "Logout",
//                                             style: TextStyle(
//                                               color: colors.whiteTemp,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : const SizedBox()
//           ],
//         )),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getUserDetails();
//     startCountdown();
//
//   }
//   String? userName,userEmail;
//
//   getUserDetails() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     userName = preferences.getString("userName");
//     userEmail = preferences.getString("userEmail");
//     print(userName);
//   }
//
//   Map<int, double> winningNumbers = {
//     1: 45,
//     2: 90,
//     3: 135,
//   };
//   int winningNumber = -1;
//
//   Future<bool> showExitPopup(context) async {
//     return await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: SizedBox(
//               height: 90,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Do you want to exit?"),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             print('yes selected');
//                             exit(0);
//                           },
//                           style: ElevatedButton.styleFrom(
//                               primary: colors.whiteTemp),
//                           child: const Text("Yes",
//                               style: TextStyle(color: Colors.black)),
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                           child: ElevatedButton(
//                         onPressed: () {
//                           print('no selected');
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text("No",
//                             style: TextStyle(color: Colors.white)),
//                         style: ElevatedButton.styleFrom(
//                           primary: colors.primary,
//                         ),
//                       ))
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   Future<bool> showLogOutPopup(context) async {
//     return await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             backgroundColor: Colors.white30,
//             content: SizedBox(
//               height: 90,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Are you sure you want to logout?",
//                     style: TextStyle(color: colors.whiteTemp),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             SharedPreferences preferences =
//                                 await SharedPreferences.getInstance();
//                             preferences.setBool("isLoggedIn", false);
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => const LoginScreen()));
//                           },
//                           style: ElevatedButton.styleFrom(
//                               primary: colors.whiteTemp),
//                           child: const Text("Logout",
//                               style: TextStyle(color: Colors.black)),
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                           child: ElevatedButton(
//                         onPressed: () {
//                           print('no selected');
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text("No",
//                             style: TextStyle(color: Colors.white)),
//                         style: ElevatedButton.styleFrom(
//                           primary: colors.primary,
//                         ),
//                       ))
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//     }
// }
