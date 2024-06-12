// onSelect({
//   int? number,
//   String? outSideBet,
//   String? insideBet,
//   Set<int>? indexes,
//   bool isZeroSelected = false,
// }) {
//   // playAudio(SoundSource.numberClickSoundPath);
//   if (widget.selectedCoin != 0) {
//     widget.onChanged(true);
//     if (isZeroSelected) {
//       widget.selectedBetNumbers(([0],widget.selectedCoin));
//       isZero = true;
//       if (selectedBets.keys.contains("straight_up")) {
//         if (!(selectedBets["straight_up"]!.contains(0))) {
//           selectedBets["straight_up"]!.add(0);
//           currentSelectedTypes.add("straight_up");
//           selectedCoins["straight_up"]!.add(widget.selectedCoin);
//         }
//       } else {
//         selectedBets["straight_up"] = [0];
//         selectedCoins["straight_up"] = [widget.selectedCoin];
//         addCoins("straight_up");
//         currentSelectedTypes.add("straight_up");
//       }
//       widget.idChanged(1);
//     }
//     if (number != null) {
//       widget.selectedBetNumbers(([number],widget.selectedCoin));
//       if (selectedBets.keys.contains("straight_up")) {
//         if (!(selectedBets["straight_up"]!.contains(number))) {
//           selectedBets["straight_up"]!.add(number);
//           selectedCoins["straight_up"]!.add(widget.selectedCoin);
//           currentSelectedTypes.add("straight_up");
//         }
//       } else {
//         selectedBets["straight_up"] = [number];
//         selectedCoins["straight_up"] = [widget.selectedCoin];
//         currentSelectedTypes.add("straight_up");
//       }
//       widget.idChanged(1);
//     }
//     if (outSideBet != null) {
//       if(!currentSelectedTypes.contains(outSideBet)){
//         currentSelectedTypes.add(outSideBet);
//       }
//       switch (outSideBet) {
//         case 'first_row':
//           for (int i = 0; i < 12; i++) {
//             if (selectedBets.keys.contains("first_row")) {
//               if (!(selectedBets["first_row"]!.contains(numberSeries[i]))) {
//
//                 selectedBets["first_row"]!.add(numberSeries[i]);
//               }
//             } else {
//               selectedBets["first_row"] = [numberSeries[i]];
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["first_row"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(7);
//           break;
//         case 'second_row':
//           for (int i = 12; i < 24; i++) {
//             if (selectedBets.keys.contains("second_row")) {
//               if (!(selectedBets["second_row"]!.contains(numberSeries[i]))) {
//                 selectedBets["second_row"]!.add(numberSeries[i]);
//               }
//             } else {
//               selectedBets["second_row"] = [numberSeries[i]];
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["second_row"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(7);
//           break;
//         case 'third_row':
//           for (int i = 24; i < 36; i++) {
//             if (selectedBets.keys.contains("third_row")) {
//               if (!(selectedBets["third_row"]!.contains(numberSeries[i]))) {
//                 selectedBets["third_row"]!.add(numberSeries[i]);
//               }
//             } else {
//               selectedBets["third_row"] = [numberSeries[i]];
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["third_row"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(7);
//           break;
//         case '1st_dozen':
//           for (int number in numberSeries) {
//             if (number > 0 && number < 13) {
//               if (selectedBets.keys.contains("1st_dozen")) {
//                 if (!(selectedBets["1st_dozen"]!.contains(number))) {
//                   selectedBets["1st_dozen"]!.add(number);
//                 }
//               } else {
//                 selectedBets["1st_dozen"] = [number];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["1st_dozen"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(8);
//           break;
//         case '2nd_dozen':
//           for (int number in numberSeries) {
//             if (number > 12 && number < 25) {
//               if (selectedBets.keys.contains("2nd_dozen")) {
//                 if (!(selectedBets["2nd_dozen"]!.contains(number))) {
//                   selectedBets["2nd_dozen"]!.add(number);
//                 }
//               } else {
//                 selectedBets["2nd_dozen"] = [number];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["2nd_dozen"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(8);
//           break;
//         case '3rd_dozen':
//           for (int number in numberSeries) {
//             if (number > 24) {
//               if (selectedBets.keys.contains("3rd_dozen")) {
//                 if (!(selectedBets["3rd_dozen"]!.contains(number))) {
//                   selectedBets["3rd_dozen"]!.add(number);
//                 }
//               } else {
//                 selectedBets["3rd_dozen"] = [number];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["3rd_dozen"]!.cast<int>(),widget.selectedCoin)
//           );
//           widget.idChanged(8);
//           break;
//         case 'low':
//           for (int number in numberSeries) {
//             if (number > 0 && number < 19) {
//               if (selectedBets.keys.contains("low")) {
//                 if (!(selectedBets["low"]!.contains(number))) {
//                   selectedBets["low"]!.add(number);
//                 }
//               } else {
//                 selectedBets["low"] = [number];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["low"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(11);
//           break;
//         case 'high':
//           for (int number in numberSeries) {
//             if (number > 18) {
//               if (selectedBets.keys.contains("high")) {
//                 if (!(selectedBets["high"]!.contains(number))) {
//                   selectedBets["high"]!.add(number);
//                 }
//               } else {
//                 selectedBets["high"] = [number];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               ( selectedBets["high"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(11);
//           break;
//         case 'even':
//           for (int number in numberSeries) {
//             if (number != 0 && number % 2 == 0) {
//               if (selectedBets.keys.contains("even")) {
//                 if (!(selectedBets["even"]!.contains(number))) {
//                   selectedBets["even"]!.add(number);
//                 }
//               } else {
//                 selectedBets["even"] = [number];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["even"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(9);
//           break;
//         case 'odd':
//           for (int number in numberSeries) {
//             if (number % 2 != 0) {
//               if (selectedBets.keys.contains("odd")) {
//                 if (!(selectedBets["odd"]!.contains(number))) {
//                   selectedBets["odd"]!.add(number);
//                 }
//               } else {
//                 selectedBets["odd"] = [number];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["odd"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(9);
//           break;
//         case 'red':
//           for (int i = 0; i < numberColors.length; i++) {
//             if (numberColors[i] == colors.redColor) {
//               if (selectedBets.keys.contains("red")) {
//                 if (!(selectedBets["red"]!.contains(numberSeries[i]))) {
//                   selectedBets["red"]!.add(numberSeries[i]);
//                 }
//               } else {
//                 selectedBets["red"] = [numberSeries[i]];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["red"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(10);
//           break;
//         case 'black':
//           for (int i = 0; i < numberColors.length; i++) {
//             if (numberColors[i] == colors.blackColor) {
//               if (selectedBets.keys.contains("black")) {
//                 if (!(selectedBets["black"]!.contains(numberSeries[i]))) {
//                   selectedBets["black"]!.add(numberSeries[i]);
//                 }
//               } else {
//                 selectedBets["black"] = [numberSeries[i]];
//               }
//             }
//           }
//           widget.selectedBetNumbers(
//               (selectedBets["black"]!.cast<int>(),
//               widget.selectedCoin)
//           );
//           widget.idChanged(10);
//           break;
//       }
//     }
//     if (insideBet != null) {
//       int? id ;
//       switch(insideBet){
//         case "split":
//           id = 2;
//           break;
//         case "street":
//           id = 3;
//           break;
//         case "corner":
//           id = 4;
//           break;
//         case "double_street":
//           id = 5;
//           break;
//         case "top_line":
//           id = 6;
//           break;
//         case "trio":
//           id = 12;
//           break;
//       }
//       Set<int> numberSet = {};
//       for (var index in indexes!) {
//         numberSet.add(numberSeries[index]);
//       }
//       if (selectedBets.keys.contains(insideBet)) {
//         if (!(selectedBets[insideBet]!
//             .any((element) => setEquals(element, numberSet)))) {
//           currentSelectedTypes.add(insideBet);
//           selectedBets[insideBet]!.add(numberSet);
//         }
//       } else {
//         currentSelectedTypes.add(insideBet);
//         selectedBets[insideBet] = [numberSet];
//       }
//       widget.selectedBetNumbers(
//           (numberSet.toList(),
//           widget.selectedCoin)
//       );
//       if(id!= null){
//         widget.idChanged(id);
//       }
//     }
//
//     setState(() {});
//     debugPrint("selected bets ===> $selectedBets");
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text("Please Select Coins"),
//       duration: Duration(seconds: 1),
//       backgroundColor: colors.primary,
//     ));
//   }
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     const darkBlue = Color.fromARGB(255, 18, 32, 47);
//     return MaterialApp(
//       theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
//       debugShowCheckedModeBanner: false,
//       home: const AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.light,
//         child: GameWidget(),
//       ),
//     );
//   }
// }
//
// const _targetColors = [Colors.orange, Colors.green, Colors.yellow, Colors.blue];
// const _textColors = [Colors.blue, Colors.yellow, Colors.green, Colors.orange];
// const _colorNames = ['orange', 'green', 'yellow', 'blue'];
//
// enum TargetType { color, number }
//
// class TargetData {
//   TargetData({required this.type, required this.index});
//   final TargetType type;
//   final int index;
//
//   String get text => type == TargetType.color
//       ? 'COLOR ${_colorNames[index]}'
//       : 'NUMBER $index';
//   Color get color => _textColors[index];
// }
//
// class GameTimer {
//   Timer? _timer;
//   ValueNotifier<int> remainingSeconds = ValueNotifier<int>(10);
//
//   void startGame() {
//     _timer?.cancel();
//     remainingSeconds.value = 15;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       remainingSeconds.value--;
//       if (remainingSeconds.value == 0) {
//         _timer?.cancel();
//       }
//     });
//   }
// }
//
// class GameWidget extends StatefulWidget {
//   const GameWidget({super.key});
//
//   @override
//   State<GameWidget> createState() => _GameWidgetState();
// }
//
// class _GameWidgetState extends State<GameWidget> {
//   static final _rng = Random();
//
//   late Alignment _playerAlignment;
//   late List<Alignment> _targets;
//   late TargetData _targetData;
//   int _score = 0;
//   bool _gameInProgress = false;
//   final GameTimer _gameTimer = GameTimer();
//
//   @override
//   void initState() {
//     super.initState();
//     _playerAlignment = const Alignment(0, 0);
//     _gameTimer.remainingSeconds.addListener(() {
//       if (_gameTimer.remainingSeconds.value == 0) {
//         setState(() {
//           _gameInProgress = false;
//         });
//       }
//     });
//     _randomize();
//   }
//
//   void _randomize() {
//     _targetData = TargetData(
//       type: TargetType.values[_rng.nextInt(2)],
//       index: _rng.nextInt(_targetColors.length),
//     );
//     _targets = [
//       for (var i = 0; i < _targetColors.length; i++)
//         Alignment(
//           _rng.nextDouble() * 2 - 1,
//           _rng.nextDouble() * 2 - 1,
//         )
//     ];
//   }
//
//   void _startGame() {
//     _randomize();
//     setState(() {
//       _score = 0;
//       _gameInProgress = true;
//     });
//     _gameTimer.startGame();
//   }
//
//   // This method contains most of the game logic
//   void _handleTapDown(TapDownDetails details, int? selectedIndex) {
//     if (!_gameInProgress) {
//       return;
//     }
//     final size = MediaQuery.of(context).size;
//     setState(() {
//       if (selectedIndex != null) {
//         _playerAlignment = _targets[selectedIndex];
//         final didScore = selectedIndex == _targetData.index;
//         Future.delayed(const Duration(milliseconds: 250), () {
//           setState(() {
//             if (didScore) {
//               _score++;
//             } else {
//               _score--;
//             }
//             _randomize();
//           });
//         });
//         // score point
//       } else {
//         _playerAlignment = Alignment(
//           2 * (details.localPosition.dx / size.width) - 1,
//           2 * (details.localPosition.dy / size.height) - 1,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Handle taps anywhere
//           Positioned.fill(
//             child: GestureDetector(
//               onTapDown: (details) => _handleTapDown(details, null),
//             ),
//           ),
//           // Player
//           // TODO: Convert to AnimatedAlign & add a duration argument
//           Align(
//             alignment: _playerAlignment,
//             child: Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: _targetData.color,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           // Targets
//           for (var i = 0; i < _targetColors.length; i++)
//             GestureDetector(
//               // Handle taps on targets
//               onTapDown: (details) => _handleTapDown(details, i),
//               // TODO: Convert to AnimatedAlign & add a duration argument
//               child: Align(
//                 alignment: _targets[i],
//                 child: Target(
//                   color: _targetColors[i],
//                   textColor: _textColors[i],
//                   text: i.toString(),
//                 ),
//               ),
//             ),
//           // Next Command
//           Align(
//             alignment: const Alignment(0, 0),
//             child: IgnorePointer(
//               ignoring: _gameInProgress,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextPrompt(
//                     'Score: $_score',
//                     color: Colors.white,
//                     fontSize: 24,
//                   ),
//                   TextPrompt(
//                     _gameInProgress ? 'Tap ${_targetData.text}' : 'Game Over!',
//                     color: _gameInProgress ? _targetData.color : Colors.white,
//                   ),
//                   _gameInProgress
//                       ? ValueListenableBuilder(
//                     valueListenable: _gameTimer.remainingSeconds,
//                     builder: (context, remainingSeconds, _) {
//                       return TextPrompt(remainingSeconds.toString(),
//                           color: Colors.white);
//                     },
//                   )
//                       : OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       shape: const StadiumBorder(),
//                       side:
//                       const BorderSide(width: 2, color: Colors.white),
//                     ),
//                     onPressed: _startGame,
//                     child: const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: TextPrompt('Start', color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Target extends StatelessWidget {
//   const Target({
//     super.key,
//     required this.color,
//     required this.textColor,
//     required this.text,
//   });
//   final Color color;
//   final Color textColor;
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 75,
//       height: 75,
//       decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//       child: Align(
//         alignment: Alignment.center,
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 50,
//             fontWeight: FontWeight.bold,
//             color: textColor,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TextPrompt extends StatelessWidget {
//   const TextPrompt(
//       this.text, {
//         super.key,
//         required this.color,
//         this.fontSize = 32,
//       });
//   final String text;
//   final Color color;
//   final double fontSize;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedDefaultTextStyle(
//       duration: const Duration(milliseconds: 250),
//       style: TextStyle(
//         color: color,
//         fontWeight: FontWeight.bold,
//         fontSize: fontSize,
//         shadows: const [
//           Shadow(
//             blurRadius: 4.0,
//             color: Colors.black,
//             offset: Offset(0.0, 2.0),
//           ),
//         ],
//       ),
//       child: Text(text),
//     );
//   }
// }