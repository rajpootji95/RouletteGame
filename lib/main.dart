
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'dart:developer' as dev;
import 'package:roullet_app/Helper_Constants/colors.dart';
import 'package:roullet_app/Helper_Constants/other_constants.dart';
import 'package:roullet_app/Screens/Splash/splash_screen.dart';
import 'audio_controller.dart';

void main() async {
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;

  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });


  WidgetsFlutterBinding.ensureInitialized();
  final audioController = AudioController();
  await audioController.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);

    runApp(
        MyApp(audioController: audioController,));
}

class MyApp extends StatefulWidget  {
  const MyApp({Key? key, required this.audioController}) : super(key: key);
  final AudioController audioController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state==AppLifecycleState.resumed) {
      //stop your audio player
      widget.audioController.muteAudio();
    }
    else{
      debugPrint(state.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {

    Constants.getScreenSize(context);
    debugPrint("my app");
    return MaterialApp(
        title: 'Uncle Casino',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: colors.primary_app,
        ),
        home:
        // LudoHome(audioController: audioController ,)
        SplashScreen(
          audioController: widget.audioController,
        )
        //MainApp(audioController: audioController ,)
        //MyHomePage(audioController: audioController),
        );
  }
}

/*import 'package:flutter/material.dart';
import 'ludo_pawn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Ludo King Pawns')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Determine the size of the pawn based on screen width
            double pawnSize = constraints.maxWidth / 4;

            return Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LudoPawn(color: Colors.red, size: pawnSize),
                        SizedBox(width: pawnSize / 4),
                        LudoPawn(color: Colors.green, size: pawnSize),
                      ],
                    ),
                    SizedBox(height: pawnSize / 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LudoPawn(color: Colors.blue, size: pawnSize),
                        SizedBox(width: pawnSize / 4),
                        LudoPawn(color: Colors.yellow, size: pawnSize),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}*/

/*class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.audioController});

  final AudioController audioController;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _gap = SizedBox(height: 16);
  bool filterApplied = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter SoLoud Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                widget.audioController
                    .playSound('assets/Sounds/pew1.mp3', 'pew1_sound');
              },
              child: const Text('Play Sound'),
            ),
            _gap,
            OutlinedButton(
              onPressed: () {
                widget.audioController.startMusic();
              },
              child: const Text('Start Music'),
            ),
            _gap,
            OutlinedButton(
              onPressed: () {
                widget.audioController.fadeOutMusic();
              },
              child: const Text('Fade Out Music'),
            ),
            _gap,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Apply Filter'),
                Checkbox(
                  value: filterApplied,
                  onChanged: (value) {
                    setState(() {
                      filterApplied = value!;
                    });
                    if (filterApplied) {
                      widget.audioController.applyFilter();
                    } else {
                      widget.audioController.removeFilter();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/

/*class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.audioController});
  final AudioController audioController;

  Stream<int> countdownTimer({
    VoidCallback? onStart,
    VoidCallback? onEnd,
    Function(int)? onChange,
  }) {
    const int maxCountdown = 60;
    const interval = Duration(seconds: 1);

    return Stream.periodic(interval, (_) {
      final int currentCount = maxCountdown - DateTime.now().second;

      onChange?.call(currentCount);

      if (currentCount == 0) {
        onEnd?.call();
      } else if (currentCount == maxCountdown) {
        onStart?.call();
      }
      return currentCount;
    });
  }

  playAudio(String sourcePath) {
    AudioPlayer().play(AssetSource(sourcePath));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<int>(
            stream: countdownTimer(
              onEnd: () {},
              onStart: () {},
              onChange: (int count) {
                debugPrint('$count');
                // audioController.playSound('assets/Sounds/pew1.mp3');
                audioController.playSound(
                    'assets/Sounds/clock_ticking_natural_sound.mp3',
                    'count_down');
                // playAudio(SoundSource.countDownSoundPath);
              },
            ),
            builder: (_, snapshot) => Text('${snapshot.data ?? 0}'),
          ),
        ),
      ),
    );
  }
}*/

//
// class Page extends StatefulWidget {
//   const Page({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _PageState();
// }
//
// class _PageState extends State<Page> with SingleTickerProviderStateMixin {
//   // Set the initial position to something that will be offscreen for sure
//   Tween<Offset> tween = Tween<Offset>(
//     begin: Offset(0.0, 10000.0),
//     end: Offset(0.0, 0.0),
//   );
//  late Animation<Offset> animation;
//  late  AnimationController animationController;
//
//   GlobalKey _widgetKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // initialize animation controller and the animation itself
//     animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );
//     animation = tween.animate(animationController);
//
//     Future<void>.delayed(Duration(seconds: 1), () {
//       // Get the screen size
//       final Size screenSize = MediaQuery.of(context).size;
//       // Get widget's size
//       final Size widgetSize = _widgetKey.currentContext!.size!;
//
//       // Calculate the dy offset.
//       // We divide the screen height by 2 because the initial position of the widget is centered.
//       // Ceil the value, so we get a position that is a bit lower the bottom edge of the screen.
//       final double offset = (screenSize.height / 2 / widgetSize.height).ceilToDouble();
//
//       // Re-set the tween and animation
//       tween = Tween<Offset>(
//         begin: Offset(0.0, offset),
//         end: Offset(0.0, 0.0),
//       );
//       animation = tween.animate(animationController);
//
//       // Call set state to re-render the widget with the new position.
//       this.setState((){
//         // Animate it.
//         animationController.forward();
//         if(animationController.isCompleted){
//           animationController.reset();
//           animationController.repeat();
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // Don't forget to dispose the animation controller on class destruction
//     animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       fit: StackFit.loose,
//       children: <Widget>[
//         SlideTransition(
//           position: animation,
//           child: CircleAvatar(
//             key: _widgetKey,
//             backgroundImage: NetworkImage(
//               'https://pbs.twimg.com/media/DpeOMc3XgAIMyx_.jpg',
//             ),
//             radius: 50.0,
//           ),
//         ),
//       ],
//     );
//   }
// }
//

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});
//
//   @override
//   State<MainApp> createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin{
//  late AnimationController numberAnimation ;
//  late Animation<num> balance;
//   @override
//   void initState() {

//     super.initState();
//     numberAnimation = AnimationController(vsync: this,duration: 3.seconds)
//       ..forward()
//       ..addListener(() {
//         if(numberAnimation.isCompleted) {
//           // numberAnimation.repeat();
//         }
//         });
//     balance = Tween<num>(begin: 0,end: 5000,).animate(numberAnimation);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: numberAnimation,
//           builder: (_,value){
//             return Text(balance.value.toStringAsFixed(2));
//           },
//         ),
//       ),
//     );
//   }
// }
//

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});
//
//   @override
//   State<MainApp> createState() => _MainAppState();
// }
//
// class _MainAppState extends State<MainApp> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         // Box decoration takes a gradient
//         gradient: LinearGradient(
//           // Where the linear gradient begins and ends
//           begin: Alignment.centerLeft,
//           end: Alignment(-1, 0.25),
//           stops: [0.0,0.5,0.5,1.0],
//           tileMode: TileMode.repeated,
//           colors: [
//             Colors.green,
//             Colors.green,
//             Colors.greenAccent,
//             Colors.greenAccent,
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:async';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 10;
//
//
//   Timer? _timer;
//
//
//   void startTimer() {
//     const oneSec = const Duration(seconds: 1);
//     _timer = new Timer.periodic(
//       oneSec,
//           (Timer timer) {
//         if (_counter == 0) {
//           AudioPlayer().play(AssetSource('Sounds/large-underwater-explosion.mp3'));
//           setState(() {
//             timer.cancel();
//             _counter = 10;
//           });
//         } else {
//           setState(() {
//             _decrementCounter();
//           });
//           AudioPlayer().play(AssetSource('Sounds/clock-close-1-tick.mp3'));
//         }
//       },
//     );
//   }
//   void _decrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter--;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           startTimer();
//           //AudioPlayer().play(AssetSource('Sounds/large-underwater-explosion-190270.mp3'));
//            //AudioPlayer().play(AssetSource('Sounds/ui-click-97915.mp3'));
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

