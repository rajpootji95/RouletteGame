import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';
import 'package:roullet_app/Helper_Constants/other_constants.dart';
import 'package:roullet_app/Helper_Constants/sounds_source_path.dart';
import 'package:roullet_app/Scale%20Size/scale_size.dart';

class RouletteTable extends StatefulWidget {
  const RouletteTable({
    super.key,
    required this.onChanged,
    required this.isClearSpecificOrReset,
    required this.selectedCoin,
    required this.selectedBetNumbers,
    this.winningNumber,
    required this.idChanged,
    required this.isBetTimeOverAndBetPlaced,
    required this.winningAmount,
  });

  final Function(bool) onChanged;
  final Function((List<int>, int)) selectedBetNumbers;
  final Function(int) idChanged;
  final Function(double) winningAmount;
  final int selectedCoin;
  final (bool, bool) isBetTimeOverAndBetPlaced;
  final (bool, bool) isClearSpecificOrReset;
  final int? winningNumber;

  @override
  State<RouletteTable> createState() => _RouletteTableState();
}

class _RouletteTableState extends State<RouletteTable>
    with TickerProviderStateMixin {
  List<(int, int, int)> selectedRowIndexAndIndexList = [];
  List<(int, int, int)> selectedSecondRowIndexAndIndexList = [];
  List<int> numberSeries = [
    3,
    6,
    9,
    12,
    15,
    18,
    21,
    24,
    27,
    30,
    33,
    36,
    2,
    5,
    8,
    11,
    14,
    17,
    20,
    23,
    26,
    29,
    32,
    35,
    1,
    4,
    7,
    10,
    13,
    16,
    19,
    22,
    25,
    28,
    31,
    34,
    0
  ];
  List<Color> numberColors = [
    colors.redColor,
    colors.blackColor,
    colors.redColor,
    colors.redColor,
    colors.blackColor,
    colors.redColor,
    colors.redColor,
    colors.blackColor,
    colors.redColor,
    colors.redColor,
    colors.blackColor,
    colors.redColor,
    colors.blackColor,
    colors.redColor,
    colors.blackColor,
    colors.blackColor,
    colors.redColor,
    colors.blackColor,
    colors.blackColor,
    colors.redColor,
    colors.blackColor,
    colors.blackColor,
    colors.redColor,
    colors.blackColor,
    colors.redColor,
    colors.blackColor,
    colors.redColor,
    colors.blackColor,
    colors.blackColor,
    colors.redColor,
    colors.redColor,
    colors.blackColor,
    colors.redColor,
    colors.blackColor,
    colors.blackColor,
    colors.redColor,
  ];
  List<String> currentSelectedTypes = [];
  bool isZero = false;
  Map<String, List<dynamic>> selectedBets = {};
  Map<String, List<int>> selectedCoins = {};
  Timer? timer;
  //
  // playAudio(String sourcePath) {
  //   AudioPlayer().play(AssetSource(sourcePath));
  // }
  late AnimationController _opacityController;
  late Animation<double> _blinkAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _opacityController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
    ..forward()
    ..addListener(() {
      if (_opacityController.isCompleted) {
        _opacityController.repeat();
      }
    });
    _blinkAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_opacityController);
  }

  ///winning amount
  getTotalWinningAmount() {

    if (widget.isBetTimeOverAndBetPlaced.$2) {
      debugPrint("winning called");
      int winningAmount = calculateWinningAmount();
      widget.winningAmount(winningAmount.toDouble());
      _opacityController.forward();
      _opacityController.addListener(() {
    if (_opacityController.isCompleted) {
    _opacityController.repeat();
    }});
    }
  }

  ///calculate winning amount
  List<int> redNumbers = [
    3,
    9,
    12,
    18,
    21,
    27,
    30,
    36,
    5,
    14,
    23,
    32,
    1,
    7,
    16,
    19,
    25,
    34
  ];
  List<int> firstRowNumbers = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36];
  List<int> secondRowNumbers = [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35];
  List<int> thirdRowNumbers = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34];

  int calculateWinningAmount() {
    debugPrint("calculation of winning amount");
    int winningAmount = 0;
    if (selectedBets.containsKey("straight_up")) {
      if (selectedBets['straight_up']!.contains(widget.winningNumber)) {
        winningAmount += 36 *
            calculateSpecificBetAmount(widget.winningNumber, "straight_up");
      }
    }
    if (selectedBets.containsKey("corner")) {
      dynamic numberOfTimesPlaced = [];
      numberOfTimesPlaced = selectedBets['corner']!
          .where((element) => element.contains(widget.winningNumber));
      if (numberOfTimesPlaced.isNotEmpty) {
        for (Set<int> element in numberOfTimesPlaced) {
          winningAmount += 9 * calculateSpecificBetAmount(element, "corner");
        }
      }
    }
    if (selectedBets.containsKey("split")) {
      dynamic numberOfTimesPlaced = [];
      numberOfTimesPlaced = selectedBets['split']!
          .where((element) => element.contains(widget.winningNumber));

      if (numberOfTimesPlaced.isNotEmpty) {
        for (Set<int> element in numberOfTimesPlaced) {
          winningAmount += 18 * calculateSpecificBetAmount(element, "split");
        }
      }
    }
    if (selectedBets.containsKey("double_street")) {
      dynamic numberOfTimesPlaced = [];
      numberOfTimesPlaced = selectedBets['double_street']!
          .where((element) => element.contains(widget.winningNumber));

      if (numberOfTimesPlaced.isNotEmpty) {
        for (Set<int> element in numberOfTimesPlaced) {
          winningAmount +=
              6 * calculateSpecificBetAmount(element, "double_street");
        }
      }
    }
    if (selectedBets.containsKey("street")) {
      dynamic numberOfTimesPlaced = [];
      numberOfTimesPlaced = selectedBets['street']!
              .where((element) => element.contains(widget.winningNumber));

      if (numberOfTimesPlaced.isNotEmpty) {
        for (Set<int> element in numberOfTimesPlaced) {
          winningAmount += 12 * calculateSpecificBetAmount(element, "street");
        }
      }
    }
    if (selectedBets.containsKey("trio")) {
      dynamic numberOfTimesPlaced = [];
      numberOfTimesPlaced = selectedBets['trio']!
          .where((element) => element.contains(widget.winningNumber));

      if (numberOfTimesPlaced.isNotEmpty) {
        for (Set<int> element in numberOfTimesPlaced) {
          winningAmount += 12 * calculateSpecificBetAmount(element, "trio");
        }
      }
    }
    if (selectedBets.containsKey("top_line")) {
      dynamic numberOfTimesPlaced = [];
      numberOfTimesPlaced = selectedBets['top_line']!
          .where((element) => element.contains(widget.winningNumber));

      if (numberOfTimesPlaced.isNotEmpty) {
        for (Set<int> element in numberOfTimesPlaced) {
          winningAmount += 9 * calculateSpecificBetAmount(element, "top_line");
        }
      }
    }
    if (selectedBets.containsKey("first_row")) {
      if (firstRowNumbers.contains(widget.winningNumber)) {
        winningAmount += 3 * calculateSpecificOutsideBetAmount("first_row");
      }
    }
    if (selectedBets.containsKey("second_row")) {
      if (secondRowNumbers.contains(widget.winningNumber)) {
        winningAmount += 3 * calculateSpecificOutsideBetAmount("second_row");
      }
    }
    if (selectedBets.containsKey("third_row")) {
      if (thirdRowNumbers.contains(widget.winningNumber)) {
        winningAmount += 3 * calculateSpecificOutsideBetAmount("third_row");
      }
    }
    if (selectedBets.containsKey("3rd_dozen")) {
      if (widget.winningNumber! > 24 && widget.winningNumber! <= 36) {
        winningAmount += 3 * calculateSpecificOutsideBetAmount("3rd_dozen");
      }
    }
    if (selectedBets.containsKey("2nd_dozen")) {
      if (widget.winningNumber! > 12 && widget.winningNumber! <= 24) {
        winningAmount += 3 * calculateSpecificOutsideBetAmount("2nd_dozen");
      }
    }
    if (selectedBets.containsKey("1st_dozen")) {
      if (widget.winningNumber! > 0 && widget.winningNumber! <= 12) {
        winningAmount += 3 * calculateSpecificOutsideBetAmount("1st_dozen");
      }
    }
    if (selectedBets.containsKey("even")) {
      if (widget.winningNumber != 0 && widget.winningNumber! % 2 == 0) {
        winningAmount += 2 * calculateSpecificOutsideBetAmount("even");
      }
    }
    if (selectedBets.containsKey("odd")) {
      if (widget.winningNumber! % 2 != 0) {
        winningAmount += 2 * calculateSpecificOutsideBetAmount("odd");
      }
    }
    if (selectedBets.containsKey("low")) {
      if (widget.winningNumber != 0 && widget.winningNumber! <= 18) {
        winningAmount += 2 * calculateSpecificOutsideBetAmount("low");
      }
    }
    if (selectedBets.containsKey("high")) {
      if (widget.winningNumber! > 18) {
        winningAmount += 2 * calculateSpecificOutsideBetAmount("high");
      }
    }
    if (selectedBets.containsKey("red")) {
      if (redNumbers.contains(widget.winningNumber)) {
        winningAmount += 2 * calculateSpecificOutsideBetAmount("red");
      }
    }
    if (selectedBets.containsKey("black")) {
      if (!redNumbers.contains(widget.winningNumber)) {
        winningAmount += 2 * calculateSpecificOutsideBetAmount("black");
      }
    }
    debugPrint("winning amount===> $winningAmount");
    return winningAmount;
  }

  ///calculate bet amount on a specific number
  int calculateSpecificBetAmount(number, type) {
    int sum = 0;
    List<(int, dynamic)> tempList = selectedBets[type]!.indexed.toList();
    List<(int, dynamic)> tempList2 = [];
    if (number is Set<int>) {
      tempList2 =
          tempList.where((element) => setEquals(element.$2, number)).toList();
    } else {
      tempList2 = tempList.where((element) => element.$2 == number).toList();
    }
    for ((int, dynamic) element in tempList2) {
      sum += selectedCoins[type]![element.$1];
    }
    return sum;
  }

  ///calculate bet amount on a specific outside bet
  int calculateSpecificOutsideBetAmount(type) {
    int sum = 0;
    if (selectedCoins[type] != null && selectedCoins[type]!.isNotEmpty) {
      for (int coin in selectedCoins[type]!) {
        sum += coin;
      }
      return sum;
    } else {
      return 0;
    }
  }

  List<int> clearedNumbers = [];
  List<int> clearedOutsideBet = [];
  int i = 0;
  clearSpecificOrResetBet() {
    if (widget.isClearSpecificOrReset.$1) {
      if (currentSelectedTypes.isNotEmpty) {
        var last = selectedBets[currentSelectedTypes.last]!.last;
        last is Set<int>
            ? clearedNumbers.addAll(last)
            : clearedNumbers.add(last);
        if (outSideBets
            .any((betType) => betType == currentSelectedTypes.last)) {
          selectedCoins[currentSelectedTypes.last]!.removeLast();
          if (selectedCoins[currentSelectedTypes.last]!.isEmpty) {
            selectedBets.remove(currentSelectedTypes.last);
          }
        } else if (selectedBets[currentSelectedTypes.last]!.isNotEmpty) {
          selectedBets[currentSelectedTypes.last]!.removeLast();
          selectedCoins[currentSelectedTypes.last]!.removeLast();
        } else {
          selectedBets.remove(currentSelectedTypes.last);
          selectedCoins[currentSelectedTypes.last]!.removeLast();
        }
        if (last is Set<int>) {
          (last.length == 2 &&
                      (last.last - last.first) != 3 &&
                      !last.contains(0)) ||
                  (last.length == 3 && !last.contains(0))
              ? selectedSecondRowIndexAndIndexList.removeLast()
              : selectedRowIndexAndIndexList.removeLast();
        }
        currentSelectedTypes.removeLast();
      }
      if (currentSelectedTypes.isEmpty) {
        selectedBets = {};
      }
    }
    else if (widget.isClearSpecificOrReset.$2) {
      selectedBets = {};
      selectedCoins = {};
      currentSelectedTypes = [];
      selectedSecondRowIndexAndIndexList = [];
      selectedRowIndexAndIndexList = [];
    }
  }

  List<String> outSideBets = [
    'first_row',
    'second_row',
    'third_row',
    '1st_dozen',
    '2nd_dozen',
    '3rd_dozen',
    'low',
    'even',
    'red',
    "black",
    'odd',
    'high'
  ];
  List<String> inSideBets = [
    'split',
    'trio',
    'top_line',
    'corner',
    'street',
    'double_street'
  ];
  bool isClear = false;

  insideBetSelect1(int rowIndex, int index) {
    if(widget.isBetTimeOverAndBetPlaced.$1){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Bet Time Over.. Please wait..."),
        duration: Duration(seconds: 1),
        backgroundColor: colors.primary,
      ));
      return;
    }
    if (widget.selectedCoin == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Select a Coin"),
        duration: Duration(seconds: 1),
        backgroundColor: colors.primary,
      ));
      return;
    }
    int betAmountOfSelectedBet = 0;
    Set<int> selectedNumbers = {};
    String? betType;
    if (index == 0) {
      Set<int> selectedIndexes = {36};
      if (rowIndex % 2 == 0) {
        betType = "split";
        selectedIndexes.add(rowIndex * 6);
      } else if (rowIndex == 5) {
        betType = "top_line";
        selectedIndexes.addAll({0, 12, 24});
      } else {
        betType = "trio";
        selectedIndexes.addAll({(rowIndex - 1) * 12, 12});
      }
      for (int i in selectedIndexes) {
        selectedNumbers.add(numberSeries[i]);
      }
    } else {
      Set<int> selectedIndexes = {};
      if (rowIndex % 2 == 0) {
        betType = "split";
        selectedIndexes = {
          (rowIndex * 6) + (index - 1),
          (rowIndex * 6) + index
        };
      } else if (rowIndex == 5) {
        betType = "double_street";
        selectedIndexes = {
          index - 1,
          index,
          index + 11,
          index + 12,
          index + 23,
          index + 24
        };
      } else {
        if (index % 4 == 0) return;
        betType = "corner";
        selectedIndexes = {
          ((rowIndex - 1) * 12) + (index - 1),
          ((rowIndex - 1) * 12) + index,
          12 + (index - 1),
          12 + index
        };
      }
      for (int i in selectedIndexes) {
        selectedNumbers.add(numberSeries[i]);
      }
    }
    onSelect(insideBet: betType, selectedNumbers: selectedNumbers);
    betAmountOfSelectedBet =
        calculateSpecificBetAmount(selectedNumbers, betType);
    selectedRowIndexAndIndexList.add((rowIndex, index, betAmountOfSelectedBet));
  }

  insideBetSelect2(int rowIndex, int index) {
    if(widget.isBetTimeOverAndBetPlaced.$1){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Bet Time Over.. Please wait..."),
        duration: Duration(seconds: 1),
        backgroundColor: colors.primary,
      ));
      return;
    }
    if (widget.selectedCoin == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Select Coins"),
        duration: Duration(seconds: 1),
        backgroundColor: colors.primary,
      ));
      return;
    }
    int betAmountOfSelectedBet = 0;
    Set<int> selectedNumbers = {};
    Set<int> selectedIndexes = {};
    String? betType;
    if (rowIndex == 5) {
      betType = "street";
      selectedIndexes = {index, index + 12, index + 24};
    } else {
      betType = "split";
      selectedIndexes =
          rowIndex == 1 ? {index, index + 12} : {index + 12, index + 24};
    }
    for (int i in selectedIndexes) {
      selectedNumbers.add(numberSeries[i]);
    }
    onSelect(insideBet: betType, selectedNumbers: selectedNumbers);
    betAmountOfSelectedBet =
        calculateSpecificBetAmount(selectedNumbers, betType);
    selectedSecondRowIndexAndIndexList
        .add((rowIndex, index, betAmountOfSelectedBet));
  }


  double w = Constants.screen.width;
  double h = Constants.screen.height;

  @override
  Widget build(BuildContext context) {
    //debugPrint("$currentSelectedTypes");
    clearSpecificOrResetBet();
    getTotalWinningAmount();
    // if (widget.isClearSpecificOrReset.$1) {
    //      isClear = true;
    //     Future.delayed(const Duration(seconds: 1), () {
    //     isClear = false;
    //     widget.onChanged(true);
    //     setState(() {});
    //   });
    // }
    // if (widget.selectedCoin == 0) {
    //   selectedBets ={};
    //   selectedRowIndexAndIndexList=[];
    //   selectedSecondRowIndexAndIndexList =[];
    // }
    return SizedBox(
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: w * 0.194,
                    ),
                    GestureDetector(
                      onTap: () {
                        //playAudio(SoundSource.numberClickSoundPath);
                        onSelect(isZeroSelected: true);
                      },
                      onLongPressStart: (val) {

                          if (timer != null) {
                            timer!.cancel();
                          }
                        // debugPrint("Button position ${val.globalPosition} ");
                        // debugPrint("Button position ${val.localPosition} ");
                        timer = Timer.periodic(500.milliseconds, (timer) {
                          onSelect(isZeroSelected: true);
                        });
                      },
                      onLongPressEnd: (val) {
                        if (timer != null) {

                          timer!.cancel();
                        }
                      },
                      child: Container(
                        height: h * 0.36,
                        width: w * 0.056,
                        decoration: BoxDecoration(
                          // color: const Color(0XFF930000),
                          border: Border.all(
                            color: colors
                                .borderColorDark, // Highlight selected number
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              widget.winningNumber == 0
                                  ? AnimatedBuilder(
                                      animation: _blinkAnimation,
                                      builder: (context, child) {
                                        Future.delayed(10.seconds, () {
                                          _opacityController.stop();
                                          setState(() {});
                                        });
                                        return Container(
                                          height: 0.1 * h,
                                          width: 0.05 * w,
                                          color: colors.borderColorLight
                                              .withOpacity(
                                                  _opacityController.isAnimating
                                                      ? _blinkAnimation.value
                                                      : 0),
                                        );
                                      },
                                    )
                                  : const SizedBox.shrink(),
                              // AnimatedContainer(
                              //     duration: const Duration(milliseconds: 500),
                              //   height: 0.1*h,
                              //   width: 0.05*w,
                              //   color: clearedNumbers.contains(0)?colors.borderColorLight:Colors.transparent,
                              // ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade900,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: colors.borderColorDark, width: 1),
                                ),
                                child: Text(
                                  '0', // Accessing number from numberSeries list
                                  textScaler: TextScaler.linear(
                                      ScaleSize.textScaleFactor(w,
                                          maxTextScaleFactor: 3)),

                                  style: const TextStyle(
                                      color: colors.borderColorDark,
                                      fontFamily: "digital"),
                                ),
                              ),
                              selectedBets.keys.contains("straight_up") &&
                                      selectedBets["straight_up"]!.contains(0)
                                  ? Container(
                                      height: h * 0.06,
                                      width: w * 0.02875,
                                      decoration: BoxDecoration(
                                        color: colors.redColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: colors.whiteTemp,
                                            width: 0.5),
                                        // image: DecorationImage(
                                        //     image: const AssetImage(ImagesPath
                                        //         .coinForeGroundImage),
                                        //     colorFilter: ColorFilter.mode(
                                        //         Colors.red.shade700,
                                        //         BlendMode.modulate),
                                        //     matchTextDirection: true)
                                      ),
                                      child: Center(
                                          child: Text(
                                        calculateSpecificBetAmount(
                                                0, "straight_up")
                                            .toString(),
                                        style: const TextStyle(
                                            color: colors.whiteTemp,
                                            fontSize: 8),
                                      )),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: w * 0.69,
                      child: Table(
                        border: const TableBorder(
                          top: BorderSide(color: colors.borderColorDark),
                          left: BorderSide(color: colors.borderColorDark),
                          bottom: BorderSide(color: colors.borderColorDark),
                          right: BorderSide(color: colors.borderColorDark),
                          horizontalInside:
                              BorderSide(color: colors.borderColorDark),
                          verticalInside:
                              BorderSide(color: colors.borderColorDark),
                        ),
                        children: [
                          TableRow(
                              children: List.generate(12, (index) {
                            final number = numberSeries[index];
                            return GestureDetector(
                              onTap: () {
                                //playAudio(SoundSource.numberClickSoundPath);
                                onSelect(number: number);
                              },
                              onLongPressStart: (val) {

                                if (timer != null) {
                                  timer!.cancel();
                                }
                                // debugPrint("Button position ${val.globalPosition} ");
                                // debugPrint("Button position ${val.localPosition} ");
                                timer =
                                    Timer.periodic(500.milliseconds, (timer) {
                                  onSelect(number: number);
                                });
                              },
                              onLongPressEnd: (val) {
                                if (timer != null) {
                                  timer!.cancel();
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  widget.winningNumber == number
                                      ? AnimatedBuilder(
                                          animation: _blinkAnimation,
                                          builder: (context, child) {
                                            Future.delayed(10.seconds, () {
                                              _opacityController.stop();
                                              setState(() {});
                                            });
                                            return Container(
                                              height: 0.1 * h,
                                              width: 0.05 * w,
                                              color: colors.borderColorLight
                                                  .withOpacity(
                                                      _opacityController
                                                              .isAnimating
                                                          ? _blinkAnimation
                                                              .value
                                                          : 0),
                                            );
                                          },
                                        )
                                      : const SizedBox.shrink(),
                                  Container(
                                    height: h * 0.08,
                                    margin: EdgeInsets.all(h * 0.02),
                                    decoration: BoxDecoration(
                                        color: numberColors[index],
                                        shape: BoxShape.circle,
                                        // boxShadow: const [
                                        //   BoxShadow(
                                        //     spreadRadius: 6,
                                        //     blurRadius: 10,
                                        //    // color: clearedNumbers.contains(number)?colors.borderColorLight:Colors.transparent,
                                        //
                                        //   )
                                        // ],
                                        border: Border.all(
                                            color: colors.borderColorDark,
                                            width: 1)),
                                    // duration: const Duration(milliseconds: 600),
                                    child: Center(
                                      child: Text(
                                        '$number',
                                        // Accessing number from numberSeries list
                                        textScaler: TextScaler.linear(
                                            ScaleSize.textScaleFactor(w,
                                                maxTextScaleFactor: 2.5)),
                                        style: const TextStyle(
                                            color: colors.borderColorDark,
                                            fontFamily: "digital"),
                                      ),
                                    ),
                                  ),
                                  selectedBets.keys.contains("straight_up") &&
                                          selectedBets["straight_up"]!
                                              .contains(number)
                                      ? Container(
                                          height: h * 0.06,
                                          width: w * 0.02875,
                                          decoration: BoxDecoration(
                                            color: colors.redColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: colors.whiteTemp,
                                                width: 0.5),
                                            // image: DecorationImage(
                                            //     image: const AssetImage(
                                            //         ImagesPath
                                            //             .coinForeGroundImage),
                                            //     colorFilter: ColorFilter.mode(
                                            //         Colors.red.shade700,
                                            //         BlendMode.modulate),
                                            //     matchTextDirection: true)
                                          ),
                                          child: Center(
                                              child: Text(
                                            calculateSpecificBetAmount(
                                                    number, "straight_up")
                                                .toString(),
                                            style: const TextStyle(
                                                color: colors.whiteTemp,
                                                fontSize: 8),
                                          )),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            );
                          })),
                          TableRow(
                              children: List.generate(12, (index) {
                            final number = numberSeries[index + 12];
                            return GestureDetector(
                              onTap: () {
                                //playAudio(SoundSource.numberClickSoundPath);
                                onSelect(number: number);
                              },
                              onLongPressStart: (val) {
                                if (timer != null) {
                                  timer!.cancel();
                                }
                                // debugPrint("Button position ${val.globalPosition} ");
                                // debugPrint("Button position ${val.localPosition} ");
                                timer =
                                    Timer.periodic(500.milliseconds, (timer) {
                                  onSelect(number: number);
                                });
                              },
                              onLongPressEnd: (val) {
                                if (timer != null) {
                                  timer!.cancel();
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  widget.winningNumber == number
                                      ? AnimatedBuilder(
                                          animation: _blinkAnimation,
                                          builder: (context, child) {
                                            Future.delayed(10.seconds, () {
                                              _opacityController.stop();
                                              setState(() {});
                                            });
                                            return Container(
                                              height: 0.1 * h,
                                              width: 0.05 * w,
                                              color: colors.borderColorLight
                                                  .withOpacity(
                                                      _opacityController
                                                              .isAnimating
                                                          ? _blinkAnimation
                                                              .value
                                                          : 0),
                                            );
                                          },
                                        )
                                      : const SizedBox.shrink(),
                                  Container(
                                    height: h * 0.08,
                                    margin: EdgeInsets.all(h * 0.02),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: numberColors[index + 12],
                                        border: Border.all(
                                            color: colors.borderColorDark,
                                            width: 1)),
                                    child: Center(
                                      child: Text(
                                        '$number',
                                        // Accessing number from numberSeries list
                                        textScaler: TextScaler.linear(
                                            ScaleSize.textScaleFactor(w,
                                                maxTextScaleFactor: 2.5)),
                                        style: const TextStyle(
                                            color: colors.borderColorDark,
                                            fontFamily: "digital"),
                                      ),
                                    ),
                                  ),
                                  selectedBets.keys.contains("straight_up") &&
                                          selectedBets["straight_up"]!
                                              .contains(number)
                                      ? Container(
                                          height: h * 0.06,
                                          width: w * 0.02875,
                                          decoration: BoxDecoration(
                                            color: colors.redColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: colors.whiteTemp,
                                                width: 0.5),
                                            // image: DecorationImage(
                                            //     image: const AssetImage(
                                            //         ImagesPath
                                            //             .coinForeGroundImage),
                                            //     colorFilter: ColorFilter.mode(
                                            //         Colors.red.shade700,
                                            //         BlendMode.modulate),
                                            //     matchTextDirection: true)
                                          ),
                                          child: Center(
                                              child: Text(
                                            calculateSpecificBetAmount(
                                                    number, "straight_up")
                                                .toString(),
                                            style: const TextStyle(
                                                color: colors.whiteTemp,
                                                fontSize: 8),
                                          )),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            );
                          })),
                          TableRow(
                              children: List.generate(12, (index) {
                            final number = numberSeries[index + 24];
                            return GestureDetector(
                              onTap: () {
                                //playAudio(SoundSource.numberClickSoundPath);
                                onSelect(number: number);
                              },
                              onLongPressStart: (val) {
                                if (timer != null) {
                                  timer!.cancel();
                                }
                                // debugPrint("Button position ${val.globalPosition} ");
                                // debugPrint("Button position ${val.localPosition} ");
                                timer =
                                    Timer.periodic(500.milliseconds, (timer) {
                                  onSelect(number: number);
                                });
                              },
                              onLongPressEnd: (val) {
                                if (timer != null) {
                                  timer!.cancel();
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  widget.winningNumber == number
                                      ? AnimatedBuilder(
                                          animation: _blinkAnimation,
                                          builder: (context, child) {
                                            Future.delayed(10.seconds, () {
                                              _opacityController.stop();
                                              setState(() {});
                                            });
                                            return Container(
                                              height: 0.1 * h,
                                              width: 0.05 * w,
                                              color: colors.borderColorLight
                                                  .withOpacity(
                                                      _opacityController
                                                              .isAnimating
                                                          ? _blinkAnimation
                                                              .value
                                                          : 0),
                                            );
                                          },
                                        )
                                      : const SizedBox.shrink(),
                                  Container(
                                    height: h * 0.08,
                                    margin: EdgeInsets.all(h * 0.02),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: numberColors[index + 24],
                                        border: Border.all(
                                            color: colors.borderColorDark,
                                            width: 1)),
                                    child: Center(
                                      child: Text(
                                        '$number',
                                        // Accessing number from numberSeries list
                                        textScaler: TextScaler.linear(
                                            ScaleSize.textScaleFactor(w,
                                                maxTextScaleFactor: 2.5)),
                                        style: const TextStyle(
                                            color: colors.borderColorDark,
                                            fontFamily: "digital"),
                                      ),
                                    ),
                                  ),
                                  selectedBets.keys.contains("straight_up") &&
                                          selectedBets["straight_up"]!
                                              .contains(number)
                                      ? Container(
                                          height: h * 0.06,
                                          width: w * 0.02875,
                                          decoration: BoxDecoration(
                                            color: colors.redColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: colors.whiteTemp,
                                                width: 0.5),
                                            // image: DecorationImage(
                                            //     image: const AssetImage(
                                            //         ImagesPath
                                            //             .coinForeGroundImage),
                                            //     colorFilter: ColorFilter.mode(
                                            //         Colors.red.shade700,
                                            //         BlendMode.modulate),
                                            //     matchTextDirection: true)
                                          ),
                                          child: Center(
                                              child: Text(
                                            calculateSpecificBetAmount(
                                                    number, "straight_up")
                                                .toString(),
                                            style: const TextStyle(
                                                color: colors.whiteTemp,
                                                fontSize: 8),
                                          )),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            );
                          })),
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(3, (index) {
                        String row = index == 0
                            ? "first_row"
                            : index == 1
                                ? "second_row"
                                : "third_row";
                        return GestureDetector(
                          onTap: () {
                            //playAudio(SoundSource.numberClickSoundPath);
                            onSelect(outSideBet: row);
                          },
                          onLongPressStart: (val) {
                            if (timer != null) {
                              timer!.cancel();
                            }
                            // debugPrint("Button position ${val.globalPosition} ");
                            // debugPrint("Button position ${val.localPosition} ");
                            timer = Timer.periodic(500.milliseconds, (timer) {
                              onSelect(outSideBet: row);
                            });
                          },
                          onLongPressEnd: (val) {
                            if (timer != null) {
                              timer!.cancel();
                            }
                          },
                          child: Container(
                            height: h * 0.12,
                            width: w * 0.05,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.borderColorDark,
                                // Highlight selected number
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // row== 'third_row'?
                                  // AnimatedBuilder(
                                  //   animation: _blinkAnimation,
                                  //   builder: (context,child){
                                  //     return Container(
                                  //       height: 0.1*h,
                                  //       width: 0.05*w,
                                  //       color: colors.borderColorLight.withOpacity(
                                  //           _opacityController.isAnimating?_blinkAnimation.value:0
                                  //       ),
                                  //     );
                                  //   },
                                  // ):const SizedBox.shrink(),
                                  Text(
                                    '2\nTo\n1',
                                    // Accessing number from numberSeries list
                                    textAlign: TextAlign.center,
                                    textScaler: TextScaler.linear(
                                        ScaleSize.textScaleFactor(w,
                                            maxFixFactor: 0.7,
                                            maxTextScaleFactor: 1)),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colors.borderColorDark,
                                        fontFamily: "digital"),
                                  ),
                                  selectedBets.keys.contains(row)
                                      ? Container(
                                          height: h * 0.06,
                                          width: w * 0.02875,
                                          decoration: BoxDecoration(
                                            color: colors.redColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: colors.whiteTemp,
                                                width: 0.5),
                                            // image: DecorationImage(
                                            //     image: const AssetImage(
                                            //         ImagesPath
                                            //             .coinForeGroundImage),
                                            //     colorFilter: ColorFilter.mode(
                                            //         Colors.red.shade700,
                                            //         BlendMode.modulate),
                                            //     matchTextDirection: true),
                                          ),
                                          child: Center(
                                              child: Text(
                                            calculateSpecificOutsideBetAmount(
                                                    row)
                                                .toString(),
                                            style: const TextStyle(
                                                color: colors.whiteTemp,
                                                fontSize: 8),
                                          )),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                ),
                Positioned(
                    left: w * 0.236,
                    top: h * 0.03,
                    child: InsideBetGestures(
                      h: h,
                      w: w,
                      spaced: false,
                      rowIndexAndIndexList: selectedRowIndexAndIndexList,
                      secondRowIndexAndIndexList:
                          selectedSecondRowIndexAndIndexList,
                      indexTap: (rowIndex, index) {
                        //playAudio(SoundSource.numberClickSoundPath);
                        insideBetSelect1(rowIndex, index);
                      },
                      onLongPressStarted: (val, rowIndex, index) {
                        if (val) {
                          if (timer != null) {
                            timer!.cancel();
                          }
                          // debugPrint("Button position ${val.globalPosition} ");
                          // debugPrint("Button position ${val.localPosition} ");
                          timer = Timer.periodic(500.milliseconds, (timer) {
                            insideBetSelect1(rowIndex, index);
                          });
                        } else {
                          if (timer != null) {
                            timer!.cancel();
                          }
                        }
                      },
                      selectedCoin: widget.selectedCoin,
                    )),
                Positioned(
                    left: w * 0.265,
                    top: h * 0.03,
                    child: InsideBetGestures(
                      h: h,
                      w: w,
                      spaced: true,
                      selectedCoin: widget.selectedCoin,
                      rowIndexAndIndexList: selectedRowIndexAndIndexList,
                      secondRowIndexAndIndexList:
                          selectedSecondRowIndexAndIndexList,
                      indexTap: (rowIndex, index) {
                        //playAudio(SoundSource.numberClickSoundPath);
                        insideBetSelect2(rowIndex, index);
                      },
                      onLongPressStarted: (val, rowIndex, index) {
                        if (val) {
                          if (timer != null) {
                            timer!.cancel();
                          }
                          // debugPrint("Button position ${val.globalPosition} ");
                          // debugPrint("Button position ${val.localPosition} ");
                          timer = Timer.periodic(500.milliseconds, (timer) {
                            insideBetSelect2(rowIndex, index);
                          });
                        } else {
                          if (timer != null) {
                            timer!.cancel();
                          }
                        }
                      },
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: w * 0.19,
                ),
                SizedBox(
                  width: w * 0.69,
                  child: Table(
                    border: const TableBorder(
                      left: BorderSide(color: colors.borderColorDark),
                      bottom: BorderSide(color: colors.borderColorDark),
                      right: BorderSide(color: colors.borderColorDark),
                      verticalInside: BorderSide(color: colors.borderColorDark),
                    ),
                    children: [
                      TableRow(
                          children: List.generate(3, (index) {
                        String dozen = index == 0
                            ? "1st_dozen"
                            : index == 1
                                ? "2nd_dozen"
                                : "3rd_dozen";
                        return GestureDetector(
                          onTap: () {
                            //playAudio(SoundSource.numberClickSoundPath);
                            onSelect(outSideBet: dozen);
                          },
                          onLongPressStart: (val) {
                            if (timer != null) {
                              timer!.cancel();
                            }
                            // debugPrint(
                            //     "Button position ${val.globalPosition} ");
                            // debugPrint("Button position ${val.localPosition} ");
                            timer = Timer.periodic(500.milliseconds, (timer) {
                              onSelect(outSideBet: dozen);
                            });
                          },
                          onLongPressEnd: (val) {
                            if (timer != null) {
                              timer!.cancel();
                            }
                          },
                          child: SizedBox(
                            height: h * 0.12,
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // dozen == '1st_dozen'?
                                  // AnimatedBuilder(
                                  //   animation: _blinkAnimation,
                                  //   builder: (context,child){
                                  //     Future.delayed(2.seconds,(){
                                  //       _opacityController.stop();
                                  //     });
                                  //     return Container(
                                  //       height: 0.1*h,
                                  //       width: 0.05*w,
                                  //       color: colors.borderColorLight.withOpacity(
                                  //           _opacityController.isAnimating?_blinkAnimation.value:0
                                  //       ),
                                  //     );
                                  //   },
                                  // ):const SizedBox.shrink(),
                                  Text(
                                    index == 0
                                        ? '1st 12'
                                        : index == 1
                                            ? '2nd 12'
                                            : '3rd 12',
                                    textScaler: TextScaler.linear(
                                        ScaleSize.textScaleFactor(w,
                                            maxTextScaleFactor: 2.5)),
                                    style: const TextStyle(
                                        color: colors.borderColorDark,
                                        fontFamily: "digital"),
                                  ),
                                  selectedBets.keys.contains(dozen)
                                      ? Container(
                                          height: h * 0.06,
                                          width: w * 0.02875,
                                          decoration: BoxDecoration(
                                            color: colors.redColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: colors.whiteTemp,
                                                width: 0.5),
                                            // image: DecorationImage(
                                            //     image: const AssetImage(
                                            //         ImagesPath
                                            //             .coinForeGroundImage),
                                            //     colorFilter: ColorFilter.mode(
                                            //         Colors.red.shade700,
                                            //         BlendMode.modulate),
                                            //     matchTextDirection: true)
                                          ),
                                          child: Center(
                                              child: Text(
                                            calculateSpecificOutsideBetAmount(
                                                    dozen)
                                                .toString(),
                                            style: const TextStyle(
                                                color: colors.whiteTemp,
                                                fontSize: 8),
                                          )),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        );
                      }))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: w * 0.2,
                ),
                BottomTableContainer(
                  onTap: () {
                    //playAudio(SoundSource.numberClickSoundPath);
                    onSelect(outSideBet: "low");
                  },
                  onLongPressStart: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                    timer = Timer.periodic(500.milliseconds, (timer) {
                      onSelect(outSideBet: 'low');
                    });
                  },
                  onLongPressEnd: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                  h: h,
                  w: w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "1 To 18",
                        textScaler:
                            TextScaler.linear(ScaleSize.textScaleFactor(w)),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'digital',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      selectedBets.keys.contains("low")
                          ? Container(
                              height: h * 0.06,
                              width: w * 0.02875,
                              decoration: BoxDecoration(
                                color: colors.redColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: colors.whiteTemp, width: 0.5),
                                // image: DecorationImage(
                                //     image: const AssetImage(
                                //         ImagesPath.coinForeGroundImage),
                                //     colorFilter: ColorFilter.mode(
                                //         Colors.red.shade700,
                                //         BlendMode.modulate),
                                //     matchTextDirection: true)
                              ),
                              child: Center(
                                  child: Text(
                                calculateSpecificOutsideBetAmount("low")
                                    .toString(),
                                style: const TextStyle(
                                    color: colors.whiteTemp, fontSize: 8),
                              )),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                BottomTableContainer(
                  onTap: () {
                    //playAudio(SoundSource.numberClickSoundPath);
                    onSelect(outSideBet: "even");
                  },
                  onLongPressStart: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                    timer = Timer.periodic(500.milliseconds, (timer) {
                      onSelect(outSideBet: 'even');
                    });
                  },
                  onLongPressEnd: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                  h: h,
                  w: w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "EVEN",
                        textScaler:
                            TextScaler.linear(ScaleSize.textScaleFactor(w)),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'digital',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      selectedBets.keys.contains("even")
                          ? Container(
                              height: h * 0.06,
                              width: w * 0.02875,
                              decoration: BoxDecoration(
                                color: colors.redColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: colors.whiteTemp, width: 0.5),
                                // image: DecorationImage(
                                //     image: const AssetImage(
                                //         ImagesPath.coinForeGroundImage),
                                //     colorFilter: ColorFilter.mode(
                                //         Colors.red.shade700,
                                //         BlendMode.modulate),
                                //     matchTextDirection: true)
                              ),
                              child: Center(
                                  child: Text(
                                calculateSpecificOutsideBetAmount("even")
                                    .toString(),
                                style: const TextStyle(
                                    color: colors.whiteTemp, fontSize: 8),
                              )),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                BottomTableContainer(
                  onTap: () {
                    //playAudio(SoundSource.numberClickSoundPath);
                    onSelect(outSideBet: "red");
                  },
                  onLongPressStart: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                    timer = Timer.periodic(500.milliseconds, (timer) {
                      onSelect(outSideBet: 'red');
                    });
                  },
                  onLongPressEnd: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                  h: h,
                  w: w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: w * 0.06,
                        height: h * 0.04,
                        decoration: const BoxDecoration(
                          color: colors.redColor,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(16),
                              left: Radius.circular(16)),
                        ),
                      ),
                      selectedBets.keys.contains("red")
                          ? Container(
                              height: h * 0.06,
                              width: w * 0.02875,
                              decoration: BoxDecoration(
                                color: colors.redColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: colors.whiteTemp, width: 0.5),
                                // image: DecorationImage(
                                //     image: const AssetImage(
                                //         ImagesPath.coinForeGroundImage),
                                //     colorFilter: ColorFilter.mode(
                                //         Colors.red.shade700,
                                //         BlendMode.modulate),
                                //     matchTextDirection: true)
                              ),
                              child: Center(
                                  child: Text(
                                calculateSpecificOutsideBetAmount("red")
                                    .toString(),
                                style: const TextStyle(
                                    color: colors.whiteTemp, fontSize: 8),
                              )),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                BottomTableContainer(
                  onTap: () {
                    //playAudio(SoundSource.numberClickSoundPath);
                    onSelect(outSideBet: "black");
                  },
                  onLongPressStart: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                    timer = Timer.periodic(500.milliseconds, (timer) {
                      onSelect(outSideBet: 'black');
                    });
                  },
                  onLongPressEnd: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                  h: h,
                  w: w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: w * 0.06,
                        height: h * 0.04,
                        decoration: const BoxDecoration(
                          color: colors.blackColor,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(16),
                              left: Radius.circular(16)),
                        ),
                      ),
                      selectedBets.keys.contains("black")
                          ? Container(
                              height: h * 0.06,
                              width: w * 0.02875,
                              decoration: BoxDecoration(
                                color: colors.redColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: colors.whiteTemp, width: 0.5),
                                // image: DecorationImage(
                                //     image: const AssetImage(
                                //         ImagesPath.coinForeGroundImage),
                                //     colorFilter: ColorFilter.mode(
                                //         Colors.red.shade700,
                                //         BlendMode.modulate),
                                //     matchTextDirection: true)
                              ),
                              child: Center(
                                  child: Text(
                                calculateSpecificOutsideBetAmount("black")
                                    .toString(),
                                style: const TextStyle(
                                    color: colors.whiteTemp, fontSize: 8),
                              )),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                BottomTableContainer(
                  onTap: () {
                    //playAudio(SoundSource.numberClickSoundPath);
                    onSelect(outSideBet: "odd");
                  },
                  onLongPressStart: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                    timer = Timer.periodic(500.milliseconds, (timer) {
                      onSelect(outSideBet: 'odd');
                    });
                  },
                  onLongPressEnd: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                  h: h,
                  w: w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "ODD",
                        textScaler:
                            TextScaler.linear(ScaleSize.textScaleFactor(w)),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'digital',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      selectedBets.keys.contains("odd")
                          ? Container(
                              height: h * 0.06,
                              width: w * 0.02875,
                              decoration: BoxDecoration(
                                color: colors.redColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: colors.whiteTemp, width: 0.5),
                                // image: DecorationImage(
                                //     image: const AssetImage(
                                //         ImagesPath.coinForeGroundImage),
                                //     colorFilter: ColorFilter.mode(
                                //         Colors.red.shade700,
                                //         BlendMode.modulate),
                                //     matchTextDirection: true)
                              ),
                              child: Center(
                                  child: Text(
                                calculateSpecificOutsideBetAmount("odd")
                                    .toString(),
                                style: const TextStyle(
                                    color: colors.whiteTemp, fontSize: 8),
                              )),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                BottomTableContainer(
                  onTap: () {
                    //playAudio(SoundSource.numberClickSoundPath);
                    onSelect(outSideBet: "high");
                  },
                  onLongPressStart: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                    timer = Timer.periodic(500.milliseconds, (timer) {
                      onSelect(outSideBet: 'high');
                    });
                  },
                  onLongPressEnd: (val) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                  h: h,
                  w: w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "19 To 36",
                        textScaler:
                            TextScaler.linear(ScaleSize.textScaleFactor(w)),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'digital',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      selectedBets.keys.contains("high")
                          ? Container(
                              height: h * 0.06,
                              width: w * 0.02875,
                              decoration: BoxDecoration(
                                color: colors.redColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: colors.whiteTemp, width: 0.5),
                                // image: DecorationImage(
                                //     image: const AssetImage(
                                //         ImagesPath.coinForeGroundImage),
                                //     colorFilter: ColorFilter.mode(
                                //         Colors.red.shade700,
                                //         BlendMode.modulate),
                                //     matchTextDirection: true)
                              ),
                              child: Center(
                                  child: Text(
                                calculateSpecificOutsideBetAmount("high")
                                    .toString(),
                                style: const TextStyle(
                                    color: colors.whiteTemp, fontSize: 8),
                              )),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                SizedBox(
                  width: w * 0.01,
                ),
              ],
            )
          ],
        ));
  }

  /// add coins selected to a map
  addCoins(type) {
    if (selectedCoins.keys.contains(type)) {
      selectedCoins[type]!.add(widget.selectedCoin);
    } else {
      selectedCoins[type] = [widget.selectedCoin];
    }
  }

  ///on select bet
  onSelect({
    int? number,
    String? outSideBet,
    String? insideBet,
    Set<int>? selectedNumbers,
    bool isZeroSelected = false,
  }) {
    if (!widget.isBetTimeOverAndBetPlaced.$1) {
      if (widget.selectedCoin != 0) {
        widget.onChanged(true);
        if (isZeroSelected) {
          widget.selectedBetNumbers(([0], widget.selectedCoin));
          isZero = true;
          if (selectedBets.keys.contains("straight_up")) {
            selectedBets["straight_up"]!.add(0);
            currentSelectedTypes.add("straight_up");
            selectedCoins["straight_up"]!.add(widget.selectedCoin);
          } else {
            selectedBets["straight_up"] = [0];
            selectedCoins["straight_up"] = [widget.selectedCoin];
            currentSelectedTypes.add("straight_up");
          }
          widget.idChanged(1);
        }
        if (number != null) {
          widget.selectedBetNumbers(([number], widget.selectedCoin));
          if (selectedBets.keys.contains("straight_up")) {
            selectedBets["straight_up"]!.add(number);
            selectedCoins["straight_up"]!.add(widget.selectedCoin);
            currentSelectedTypes.add("straight_up");
          } else {
            selectedBets["straight_up"] = [number];
            selectedCoins["straight_up"] = [widget.selectedCoin];
            currentSelectedTypes.add("straight_up");
          }
          widget.idChanged(1);
        }
        if (outSideBet != null) {
          List<int> selectedNumbers = [];
          int? id;
          currentSelectedTypes.add(outSideBet);
          addCoins(outSideBet);
          selectedBets[outSideBet] = [1];
          switch (outSideBet) {
            case 'first_row':
              for (int i = 0; i < 12; i++) {
                selectedNumbers.add(numberSeries[i]);
              }
              id = 7;
              break;
            case 'second_row':
              for (int i = 12; i < 24; i++) {
                selectedNumbers.add(numberSeries[i]);
              }
              id = 7;
              break;
            case 'third_row':
              for (int i = 24; i < 36; i++) {
                selectedNumbers.add(numberSeries[i]);
              }
              id = 7;
              break;
            case '1st_dozen':
              for (int number = 1; number < 13; number++) {
                selectedNumbers.add(number);
              }
              id = 8;
              break;
            case '2nd_dozen':
              for (int number = 13; number < 25; number++) {
                selectedNumbers.add(number);
              }
              id = 8;
              break;
            case '3rd_dozen':
              for (int number = 25; number < 37; number++) {
                selectedNumbers.add(number);
              }
              id = 8;
              break;
            case 'low':
              for (int number = 1; number < 19; number++) {
                selectedNumbers.add(number);
              }
              id = 11;
              break;
            case 'high':
              for (int number = 19; number < 37; number++) {
                selectedNumbers.add(number);
              }
              id = 11;
              break;
            case 'even':
              for (int number = 2; number < 37; number += 2) {
                selectedNumbers.add(number);
              }
              id = 9;
              break;
            case 'odd':
              for (int number = 1; number < 36; number += 2) {
                selectedNumbers.add(number);
              }
              id = 9;
              break;
            case 'red':
              for (int i = 0; i < numberColors.length; i++) {
                if (numberColors[i] == colors.redColor) {
                  selectedNumbers.add(numberSeries[i]);
                }
              }
              id = 10;
              break;
            case 'black':
              for (int i = 0; i < numberColors.length; i++) {
                if (numberColors[i] == colors.blackColor) {
                  selectedNumbers.add(numberSeries[i]);
                }
              }
              id = 10;
              break;
          }
          widget.selectedBetNumbers((selectedNumbers, widget.selectedCoin));
          widget.idChanged(id ?? 0);
        }
        if (insideBet != null) {
          int? id;
          switch (insideBet) {
            case "split":
              id = 2;
              break;
            case "street":
              id = 3;
              break;
            case "corner":
              id = 4;
              break;
            case "double_street":
              id = 5;
              break;
            case "top_line":
              id = 6;
              break;
            case "trio":
              id = 12;
              break;
          }

          if (selectedBets.keys.contains(insideBet)) {
            currentSelectedTypes.add(insideBet);
            selectedBets[insideBet]!.add(selectedNumbers);
            selectedCoins[insideBet]!.add(widget.selectedCoin);
          } else {
            currentSelectedTypes.add(insideBet);
            selectedBets[insideBet] = [selectedNumbers];
            selectedCoins[insideBet] = [widget.selectedCoin];
          }
          widget.selectedBetNumbers(
              (selectedNumbers!.toList(), widget.selectedCoin));
          if (id != null) {
            widget.idChanged(id);
          }
        }
        // debugPrint("amount calculated ==> ${calculateSpecificBetAmount(8)}");
        setState(() {});
        debugPrint("selected bets ===> $selectedBets");
        debugPrint("selected types ===> $currentSelectedTypes");
        debugPrint("selected coins ===> $selectedCoins");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please Select Coins"),
          duration: Duration(seconds: 1),
          backgroundColor: colors.primary,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Bet Time Over.. Please wait..."),
        duration: Duration(seconds: 1),
        backgroundColor: colors.primary,
      ));
    }
  }
}

class BottomTableContainer extends StatelessWidget {
  const BottomTableContainer({
    super.key,
    required this.h,
    required this.w,
    required this.child,
    required this.onTap, required this.onLongPressStart, required this.onLongPressEnd,
  });

  final Widget child;
  final double h;
  final double w;
  final VoidCallback onTap;
  final Function(LongPressStartDetails) onLongPressStart;
  final Function(LongPressEndDetails) onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        height: h * 0.067,
        width: w * 0.1,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.borderColorLight),
            boxShadow: [
              BoxShadow(
                  color: colors.borderColorLight.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 1)
            ]),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class InsideBetGestures extends StatelessWidget {
  const InsideBetGestures({
    super.key,
    required this.h,
    required this.w,
    required this.indexTap,
    required this.selectedCoin,
    required this.spaced,
    required this.rowIndexAndIndexList,
    required this.secondRowIndexAndIndexList,
    required this.onLongPressStarted,
  });
  final double h;
  final double w;
  final int selectedCoin;
  final Function(int, int) indexTap;
  final bool spaced;
  final List<(int, int, int)> rowIndexAndIndexList;
  final List<(int, int, int)> secondRowIndexAndIndexList;
  final Function(bool, int, int) onLongPressStarted;
  @override
  Widget build(BuildContext context) {
    return spaced
        ? Column(
            children: List.generate(6, (rowIndex) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  rowIndex % 2 == 0
                      ? SizedBox(
                          height: h * 0.06,
                        )
                      : const SizedBox.shrink(),
                  rowIndex % 2 != 0
                      ? Row(
                          children: List.generate(12, (index) {
                            (int, int, int) selectedIndex =
                                secondRowIndexAndIndexList.lastWhere(
                              (element) =>
                                  element.$1 == rowIndex && element.$2 == index,
                              orElse: () => (-1, -1, -1),
                            );
                            return Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      indexTap(rowIndex, index);
                                    },
                                    onLongPressStart: (val) {
                                      // debugPrint("Button position ${val.globalPosition} ");
                                      // debugPrint("Button position ${val.localPosition} ");
                                      onLongPressStarted(true, rowIndex, index);
                                    },
                                    onLongPressEnd: (val) {
                                      onLongPressStarted(
                                          false, rowIndex, index);
                                    },
                                    child: selectedIndex.$1 == rowIndex &&
                                            selectedIndex.$2 == index
                                        ? Container(
                                            height: h * 0.06,
                                            width: w * 0.02875,
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade900,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: colors.whiteTemp,
                                                  width: 0.5),
                                              // image: DecorationImage(
                                              //     image: const AssetImage(
                                              //         ImagesPath
                                              //             .coinForeGroundImage),
                                              //     colorFilter: ColorFilter.mode(
                                              //         Colors.red.shade700,
                                              //         BlendMode.modulate),
                                              //     matchTextDirection: true)
                                            ),
                                            child: Center(
                                                child: Text(
                                              selectedIndex.$3.toString(),
                                              style: const TextStyle(
                                                  color: colors.whiteTemp,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold),
                                            )))
                                        : Container(
                                            height: h * 0.06,
                                            width: w * 0.02875,
                                            color: Colors.transparent,
                                          )),
                                SizedBox(
                                  width: w * 0.02875,
                                )
                              ],
                            );
                          }),
                        )
                      : const SizedBox.shrink()
                ],
              );
            }),
          )
        : Column(
            children: List.generate(6, (rowIndex) {
              return Row(
                children: List.generate(12, (index) {
                  (int, int, int) selectedIndex =
                      rowIndexAndIndexList.lastWhere(
                    (element) => element.$1 == rowIndex && element.$2 == index,
                    orElse: () => (-1, -1, -1),
                  );
                  return Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            indexTap(rowIndex, index);
                          },
                          onLongPressStart: (val) {
                            // debugPrint("Button position ${val.globalPosition} ");
                            // debugPrint("Button position ${val.localPosition} ");
                            onLongPressStarted(true, rowIndex, index);
                          },
                          onLongPressEnd: (val) {
                            onLongPressStarted(false, rowIndex, index);
                          },
                          child: selectedIndex.$1 == rowIndex &&
                                  selectedIndex.$2 == index
                              ? Container(
                                  height: h * 0.06,
                                  width: w * 0.02875,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade900,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: colors.whiteTemp, width: 0.5),
                                    // image: DecorationImage(
                                    //     image: const AssetImage(
                                    //         ImagesPath.coinForeGroundImage),
                                    //     colorFilter: ColorFilter.mode(
                                    //         Colors.red.shade700,
                                    //         BlendMode.modulate),
                                    //     matchTextDirection: true)
                                  ),
                                  child: Center(
                                      child: Text(
                                    selectedIndex.$3.toString(),
                                    style: const TextStyle(
                                        color: colors.whiteTemp,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold),
                                  )))
                              : Container(
                                  height: h * 0.06,
                                  width: w * 0.02875,
                                  color: Colors.transparent,
                                )),
                      // rowIndex%2==0?
                      SizedBox(
                        width: w * 0.02875,
                      )
                      // GestureDetector(
                      //     onTap: () {
                      //       indexTap(rowIndex, index);
                      //     },
                      //     child:
                      //     selectedIndex.$1==rowIndex && selectedIndex.$2 == index?
                      //     Container(
                      //         height: h * 0.06,
                      //         width: w * 0.02875,
                      //         decoration:  BoxDecoration(
                      //           color: Colors.red.shade900,
                      //           shape: BoxShape.circle,
                      //           border: Border.all(
                      //               color: colors.whiteTemp, width: 0.5),
                      //           // image: DecorationImage(
                      //           //     image: const AssetImage(
                      //           //         ImagesPath.coinForeGroundImage),
                      //           //     colorFilter: ColorFilter.mode(
                      //           //         Colors.red.shade700,
                      //           //         BlendMode.modulate),
                      //           //     matchTextDirection: true)
                      //         ),
                      //         child: Center(
                      //             child:Text(
                      //               selectedIndex.$3.toString(),
                      //               style: const TextStyle(
                      //                   color: colors.whiteTemp, fontSize: 8,fontWeight: FontWeight.bold),
                      //             ))
                      //     ):
                      //     Container(
                      //       height: h * 0.06,
                      //       width: w * 0.02875,
                      //       color: Colors.white,
                      //     )
                      // ),
                    ],
                  );
                }),
              );
            }),
          );
  }
}
