import 'dart:async';
import 'dart:convert';
import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import 'package:roullet_app/Helper_Constants/sounds_source_path.dart';
import 'package:roullet_app/Ludo/players/collision_details.dart';
import 'package:roullet_app/Ludo/players/players.dart';
import 'package:roullet_app/Ludo/players/players_notifier.dart';
import 'package:roullet_app/Ludo/result/result.dart';
import 'package:roullet_app/Ludo/result/result_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api Services/api_end_points.dart';
import '../Helper_Constants/Images_path.dart';
import '../Helper_Constants/colors.dart';
import '../Screens/Model/get_profile_model.dart';
import '../audio_controller.dart';
import '../util/colors.dart';
import 'board/board.dart';
import 'board/overlay_surface.dart';
import 'dice/dice.dart';
import 'dice/dice_base.dart';
import 'dice/dice_notifier.dart';

class LudoHome extends StatefulWidget {
  final AudioController audioController;
  String userName;
   LudoHome({super.key, required this.audioController,required this.userName});
  @override
  _LudoHomeState createState() => _LudoHomeState();
}

class _LudoHomeState extends State<LudoHome> with TickerProviderStateMixin {
  late Animation<Color?> _playerHighlightAnim;
  Animation<double>? _diceHighlightAnim;
  late AnimationController? _playerHighlightAnimCont, _diceHighlightAnimCont;
  final List<List<AnimationController>> _playerAnimContList = [];
  final List<List<Animation<Offset>>> _playerAnimList = [];
  final List<List<int>> _winnerPawnList = [];
  bool _provideFreeTurn = false;
  CollisionDetails _collisionDetails = CollisionDetails();

  late int _stepCounter = 0,
      _diceOutput = 0,
      _currentTurn = 0,
      _selectedPawnIndex,
      _maxTrackIndex = 57,
      _straightSixesCounter = 0,
      _forwardStepAnimTimeInMillis = 250,
      _reverseStepAnimTimeInMillis = 60;
  List<List<List<Rect>>>? _playerTracks;
  late List<Rect> _safeSpots;
  List<List<MapEntry<int, Rect>>> _pawnCurrentStepInfo = []; //step index, rect

  PlayersNotifier? _playerPaintNotifier;
  ResultNotifier? _resultNotifier;
  DiceNotifier? _diceNotifier;

  @override
  void initState() {
    super.initState();
    _playerPaintNotifier = PlayersNotifier();
    _resultNotifier = ResultNotifier();
    _diceNotifier = DiceNotifier();
    Future.microtask(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initData();
        _playerPaintNotifier!.rebuildPaint();
        _highlightCurrentPlayer();
        _highlightDice();
      });
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) async{
    //    await Future.delayed(Duration.zero);
    //   _initData();
    //   _playerPaintNotifier!.rebuildPaint();
    //   _highlightCurrentPlayer();
    //   _highlightDice();
    // });
    print("call for intiState--->");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);  //full screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]); //force portrait mode



    _playerHighlightAnimCont =
        AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _diceHighlightAnimCont =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);

    _playerHighlightAnim =
    (ColorTween(begin: Colors.black12, end: Colors.black45)
        .animate(_playerHighlightAnimCont!) as Animation<Color?>);
    _diceHighlightAnim =
        Tween(begin: 0.0, end: 2 * pi).animate(_diceHighlightAnimCont!);
  }

  @override
  void dispose() {
    _playerAnimContList.forEach((controllerList) {
      controllerList.forEach((controller) {
        controller.dispose();
      });
    });
    _playerHighlightAnimCont?.dispose();
    _diceHighlightAnimCont?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    return Scaffold(
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
        child:
        //getProfileModel?.data.first.username == null ? const Center(child: CupertinoActivityIndicator(color: Colors.amberAccent,)) :
        MultiProvider(
          providers: [
            ChangeNotifierProvider<PlayersNotifier>(
                create: (_) => _playerPaintNotifier!),
            ChangeNotifierProvider<ResultNotifier>(
                create: (_) => _resultNotifier!),
            ChangeNotifierProvider<DiceNotifier>(create: (_) => _diceNotifier!),
          ],
          child: Stack(
            children: <Widget>[
              SizedBox.expand(
                  child: Container(
                    //color: const Color(0xff1f0d67),
                      color:  Colors.white.withOpacity(0.10)
                  )),
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       CircleAvatar(
              //         radius: 20,
              //         backgroundColor: colors.whiteTemp,
              //         child: Icon(
              //           Icons.person,
              //           size: 30,
              //         ),
              //       ),
              //       // SizedBox(
              //       //   height: 50,
              //       //   width: 50,
              //       //   child: ClipRRect(
              //       //       borderRadius: BorderRadius.circular(100),
              //       //       child: Image.asset("assets/images/mam_images.png",fit: BoxFit.fill,)),
              //       // ),
              //       SizedBox(width: 10,),
              //        Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           SizedBox(height: 0,),
              //           Text("User Name...",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12)),
              //           Text("User Email...",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12)),
              //           // Text("${getProfileModel?.data.first.username}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
              //           // Text("${getProfileModel?.data.first.email}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),)
              //
              //
              //         ],
              //         )
              //     ],
              //   ),
              // ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding:  const EdgeInsets.symmetric(horizontal: 16),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                               CircleAvatar(
                                radius: 20,
                                backgroundColor: colors.whiteTemp,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                    child: Image.asset("assets/ludo/user1.jpg",fit: BoxFit.fill,))
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 0,),
                                  Text("${widget.userName}" ??  "Player 1",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                           Row(
                            children: [
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 0,),
                                  Text("Player 2",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12)),
                                ],
                              ),
                              const SizedBox(width: 10,),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: colors.whiteTemp,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                    child: Image.asset("assets/ludo/user5.jpg",fit: BoxFit.fill,))
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.all(20),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          children: <Widget>[
                            SizedBox.expand(
                              child: CustomPaint(
                                painter: BoardPainter(
                                    trackCalculationListener: (playerTracks) {
                                      _playerTracks = playerTracks;
                                    }),
                              ),
                            ),
                            SizedBox.expand(
                                child: AnimatedBuilder(
                                  animation: _playerHighlightAnim,
                                  builder: (_, __) => CustomPaint(
                                    painter: OverlaySurface(
                                        highlightColor: _playerHighlightAnim.value,
                                        selectedHomeIndex: _currentTurn,
                                        clickOffset: (clickOffset) {
                                          _handleClick(clickOffset);
                                        }),
                                  ),
                                )),
                            Consumer<PlayersNotifier>(builder: (_, notifier, __) {
                              debugPrint("shold paint players == > ${notifier.shoulPaintPlayers}");
                              if (notifier.shoulPaintPlayers) {
                                return SizedBox.expand(
                                  child: Stack(
                                    children: _buildPawnWidgets(),
                                  ),
                                );
                              } else
                                return Container();
                            }),
                            Consumer<ResultNotifier>(builder: (_, notifier, __) {
                              return SizedBox.expand(
                                  child: CustomPaint(
                                    painter: ResultPainter(notifier.ranks),
                                  ));
                            })
                          ],
                        ),
                      ),
                    ),
                      Padding(
                      padding:  const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: colors.whiteTemp,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                    child: Image.asset("assets/ludo/user6.jpg",fit: BoxFit.fill,))
                              ),
                              const SizedBox(width: 10,),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 0,),
                                  Text("Player 3",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Player 4",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12)),
                                ],
                              ),
                              const SizedBox(width: 10,),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: colors.whiteTemp,
                                child:ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                    child: Image.asset("assets/ludo/user4.jpg",fit: BoxFit.fill,)))


                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        if (_diceHighlightAnimCont!.isAnimating) {
                          _playerHighlightAnimCont?.reset();
                          _diceHighlightAnimCont?.reset();
                          _diceNotifier?.rollDice();
                          widget.audioController.playSound(SoundSource.diceSound, "Ludo");
                        }
                      },
                      child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(children: [
                            SizedBox.expand(
                              child: AnimatedBuilder(
                                animation: _diceHighlightAnim!,
                                builder: (_, __) => CustomPaint(
                                  painter:
                                  DiceBasePainter(
                                      _diceHighlightAnim!.value,_currentTurn),
                                ),
                              ),
                            ),
                            Consumer<DiceNotifier>( builder: (_, notifier, __) {
                              if (notifier.isRolled) {
                                _highlightCurrentPlayer();
                                _diceOutput = notifier.output;
                                if (_diceOutput == 6) _straightSixesCounter++;
                                _checkDiceResultValidity();
                              }
                              return SizedBox.expand(
                                child: CustomPaint(
                                  painter: DicePaint(notifier.output),
                                ),
                              );
                            })
                          ])),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),



    );
  }
  bool isPlayed = false;

  List<Widget> _buildPawnWidgets() {
    List<Widget> playerPawns = [];

    for (int playerIndex = 0; playerIndex < 4; playerIndex++) {
      Color playerColor;
      switch (playerIndex) {
        case 0:
          playerColor = AppColors.player1;
          break;
        case 1:
          playerColor = AppColors.player2;
          break;
        case 2:
          playerColor = AppColors.player3;
          break;
        default:
          playerColor = AppColors.player4;
      }

      for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
        playerPawns.add(SizedBox.expand(
          child: AnimatedBuilder(
            animation: _playerAnimList[playerIndex][pawnIndex],
            builder: (_, child) {
              Map<Offset, List<Player>> groupedPlayers = {};
              for (int pIndex = 0; pIndex < 4; pIndex++) {
                for (int ppIndex = 0; ppIndex < 4; ppIndex++) {
                  Offset currentSpot = _playerAnimList[pIndex][ppIndex].value;
                  Color color = (pIndex == playerIndex && ppIndex == pawnIndex)
                      ? playerColor
                      : Colors.transparent;
                  Player player = Player(
                      playerColor: color,
                      playerCurrentSpot:currentSpot);
                  if (groupedPlayers.containsKey(player.playerCurrentSpot)) {
                    groupedPlayers[player.playerCurrentSpot]!.add(player);
                  } else {
                    groupedPlayers[player.playerCurrentSpot!] = [player];
                  }

              if (_playerAnimContList[playerIndex][pawnIndex].isAnimating) {
                if (!isPlayed) {
                  _playSoundOfPawnMoving();
                  isPlayed = true;
                }
              }
              if (_playerAnimContList[playerIndex][pawnIndex].isCompleted) {
                isPlayed = false;
              }}}
              // debugPrint("grouped players===> $groupedPlayers");
             // debugPrint("grouped players --> $groupedPlayers");
             //  return Transform.translate(
             //    offset: _playerAnimList[playerIndex][pawnIndex].value,
             //      child: Icon(Icons.location_on,color: playerColor,));
              return CustomPaint(
                  painter: PlayersPainter(groupedPlayers: groupedPlayers));
            },
          ),
        ));
      }
    }

    return playerPawns;
  }

  _initData() {
    // debugPrint("length------>${_playerTracks!.length}");
    for (int playerIndex = 0;
    playerIndex < _playerTracks!.length;
    playerIndex++) {
      List<Animation<Offset>> currentPlayerAnimList = [];
      List<AnimationController> currentPlayerAnimContList =[];
      List<MapEntry<int, Rect>> currentStepInfoList = [];

      for (int pawnIndex = 0;
      pawnIndex < _playerTracks![playerIndex].length;

      pawnIndex++) {
        AnimationController currentAnimCont = AnimationController(
            duration: Duration(milliseconds: _forwardStepAnimTimeInMillis),
            vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (!_collisionDetails.isReverse) _stepCounter++;
              _movePawn();

            }
          });

        currentPlayerAnimContList.add(currentAnimCont);
        currentPlayerAnimList.add(Tween(
            begin: _playerTracks![playerIndex][pawnIndex][0].center,
            end: _playerTracks![playerIndex][pawnIndex][1].center)
            .animate(currentAnimCont));
        currentStepInfoList
            .add(MapEntry(0, _playerTracks![playerIndex][pawnIndex][0]));
      }
      _playerAnimContList.add(currentPlayerAnimContList);
      _playerAnimList.add(currentPlayerAnimList);
      _pawnCurrentStepInfo.add(currentStepInfoList);
      _winnerPawnList.add([]);
    }

    /**
     * Fetch all safe spot rects
     */
    var playerTrack = _playerTracks![0][0];

    _safeSpots = [
      playerTrack[1],
      playerTrack[9],
      playerTrack[14],
      playerTrack[22],
      playerTrack[27],
      playerTrack[35],
      playerTrack[40],
      playerTrack[48]
    ];
  }

  _handleClick(Offset clickOffset) {
    if (!_diceHighlightAnimCont!.isAnimating) if (_stepCounter == 0) {
      for (int pawnIndex = 0;
      pawnIndex < _pawnCurrentStepInfo[_currentTurn].length;
      pawnIndex++)
        if (_pawnCurrentStepInfo[_currentTurn][pawnIndex]
            .value
            .contains(clickOffset)) {
          var clickedPawnIndex =
              _pawnCurrentStepInfo[_currentTurn][pawnIndex].key;

          if (clickedPawnIndex == 0) {
            if (_diceOutput == 6)
              _diceOutput = 1; //to move pawn out of the house when 6 is rolled
            else
              break; //disallow pawn selection because 6 is not rolled and the pawn is in house
          } else if (clickedPawnIndex + _diceOutput > _maxTrackIndex)
            break; //disallow pawn selection because dice number is more than step left

          _playerHighlightAnimCont!.reset();
          _selectedPawnIndex = pawnIndex;

          _movePawn(considerCurrentStep: true);

          break;
        }
    }
  }
  _playSoundOfPawnMoving(){
    int stopAfter = _diceOutput;
    Timer.periodic(250.milliseconds, (timer) {
      if(stopAfter == 1){
        timer.cancel();
      }
      widget.audioController
          .playSound(SoundSource.pawnMovingSound, "pawn_move");
      stopAfter --;
    });
  }

  _checkDiceResultValidity() {
    var isValid = false;

    for (var stepInfo in _pawnCurrentStepInfo[_currentTurn]) {
      if (_diceOutput == 6) {
        if (_straightSixesCounter ==
            3) //change turn in case of 3 straight sixes
          break;
        else if (stepInfo.key + _diceOutput >
            _maxTrackIndex) //ignore pawn if it can't move 6 steps
          continue;

        _provideFreeTurn = true;
        isValid = true;
        break;
      } else if (stepInfo.key != 0) {
        if (stepInfo.key + _diceOutput <= _maxTrackIndex) {
          isValid = true;
          break;
        }
      }
    }

    if (!isValid) _changeTurn();
  }

  _movePawn({bool considerCurrentStep = false}) {
    int playerIndex, pawnIndex, currentStepIndex;

    if (_collisionDetails.isReverse) {
      playerIndex = _collisionDetails.targetPlayerIndex;
      pawnIndex = _collisionDetails.pawnIndex;
      currentStepIndex = max(
          _pawnCurrentStepInfo[playerIndex][pawnIndex].key -
              (considerCurrentStep ? 0 : 1),
          0);
    } else {
      playerIndex = _currentTurn;
      pawnIndex = _selectedPawnIndex;
      currentStepIndex = min(
          _pawnCurrentStepInfo[playerIndex][pawnIndex].key +
              (considerCurrentStep
                  ? 0
                  : 1), //condition to avoid incrementing key for initial step
          _maxTrackIndex);
    }

    //update current step info in the [_pawnCurrentStepInfo] list
    var currentStepInfo = MapEntry(currentStepIndex,
        _playerTracks![playerIndex][pawnIndex][currentStepIndex]);
    _pawnCurrentStepInfo[playerIndex][pawnIndex] = currentStepInfo;

    var animCont = _playerAnimContList[playerIndex][pawnIndex];

    if (_collisionDetails.isReverse) {
      if (currentStepIndex > 0) {
        //animate one step reverse
        _playerAnimList[_collisionDetails.targetPlayerIndex]
        [_collisionDetails.pawnIndex] = Tween(
            begin: currentStepInfo.value.center,
            end: _playerTracks![_collisionDetails.targetPlayerIndex]
            [_collisionDetails.pawnIndex][currentStepIndex - 1]
                .center)
            .animate(animCont);
        animCont.forward(from: 0.0);
      } else {
        _playerAnimContList[playerIndex][pawnIndex].duration =
            Duration(milliseconds: _forwardStepAnimTimeInMillis);
        _collisionDetails.isReverse = false;
        _provideFreeTurn = true; //free turn for collision
        _changeTurn();
      }
    } else if (_stepCounter != _diceOutput) {
      //animate one step forward
      _playerAnimList[playerIndex][pawnIndex] = Tween(
          begin: currentStepInfo.value.center,
          end: _playerTracks![playerIndex][pawnIndex]
          [min(currentStepIndex + 1, _maxTrackIndex)]
              .center)
          .animate(CurvedAnimation(
          parent: animCont,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic)));
      animCont.forward(from: 0.0);
    } else {
      if (_checkCollision(currentStepInfo))
        _movePawn(considerCurrentStep: true);
      else {
        if (currentStepIndex == _maxTrackIndex) {
          _winnerPawnList[_currentTurn]
              .add(_selectedPawnIndex); //add pawn to [_winnerPawnList]

          if (_winnerPawnList[_currentTurn].length < 4)
            _provideFreeTurn =
            true; //if player has remaining pawns, provide free turn for reaching destination
          else {
            _resultNotifier?.rebuildPaint(_currentTurn);
            _provideFreeTurn =
            false; //to discard free turn if he completes the game
          }
        }

        _changeTurn();
      }
    }
  }

  bool _checkCollision(MapEntry<int, Rect> currentStepInfo) {
    var currentStepCenter = currentStepInfo.value.center;

    if (currentStepInfo.key <
        52) //no need to check if the pawn has entered destination lane
      if (!_safeSpots.any((safeSpot) {
        //avoid checking if it has landed on a safe spot
        return safeSpot.contains(currentStepCenter);
      })) {
        List<CollisionDetails> collisions = [];
        for (int playerIndex = 0;
        playerIndex < _pawnCurrentStepInfo.length;
        playerIndex++) {
          for (int pawnIndex = 0;
          pawnIndex < _pawnCurrentStepInfo[playerIndex].length;
          pawnIndex++) {
            if (playerIndex != _currentTurn ||
                pawnIndex != _selectedPawnIndex) if (_pawnCurrentStepInfo[
            playerIndex][pawnIndex]
                .value
                .contains(currentStepCenter)) {
              collisions.add(CollisionDetails()
                ..pawnIndex = pawnIndex
                ..targetPlayerIndex = playerIndex);
            }
          }
        }

        /**
         * Check if collision is valid
         */
        if (collisions.isEmpty ||
            collisions.any((collision) {
              return collision.targetPlayerIndex == _currentTurn;
            }) ||
            collisions.length >
                1) //conditions to no collision and group collisions
          _collisionDetails.isReverse = false;
        else {
          _collisionDetails = collisions.first;
          _playerAnimContList[_collisionDetails.targetPlayerIndex]
          [_collisionDetails.pawnIndex]
              .duration = Duration(milliseconds: _reverseStepAnimTimeInMillis);

          _collisionDetails.isReverse = true;
        }
      }
    return _collisionDetails.isReverse;
  }

  _changeTurn() {

    if (_winnerPawnList.where((playerPawns) {
      return playerPawns.length == 4;
    }).length !=
        3) //if any 3 players have completed
        {
      _highlightDice();

      _stepCounter = 0; //reset step counter for next turn
      if (!_provideFreeTurn) {
        do {
          //to ignore winners
          _currentTurn =
              (_currentTurn + 1) % 4; //change turn after animation completes
          if (_winnerPawnList[_currentTurn].length != 4)
            break; //select player if he is not yet a winner
        } while (true);
        _straightSixesCounter = 0;
      } else if (_diceOutput != 6)
        _straightSixesCounter =
        0; //reset 6s counter if free turn is provided by other means

      if (!_playerHighlightAnimCont!.isAnimating) _highlightCurrentPlayer();

      _provideFreeTurn = false;
    }
    debugPrint("current turn --> $_currentTurn");
  }

  _highlightCurrentPlayer() {
    _playerHighlightAnimCont?.repeat(reverse: true);
  }

  _highlightDice() {
    _diceHighlightAnimCont?.repeat();
  }
}

extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}