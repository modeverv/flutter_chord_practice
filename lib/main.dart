import 'dart:math';

import 'package:chord_practice/logics/my_periodic_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int tempo = 60;

  int _count = 3;
  int currentImgNum = 1;
  int nextImgNum = 1;

  @override
  void initState() {
    super.initState();
    precacheImage(const AssetImage('assets/images/haku1.png'), context);
    precacheImage(const AssetImage('assets/images/haku2.png'), context);
    precacheImage(const AssetImage('assets/images/haku3.png'), context);
    precacheImage(const AssetImage('assets/images/haku4.png'), context);
    precacheImage(const AssetImage('assets/images/1.png'), context);
    precacheImage(const AssetImage('assets/images/2.png'), context);
    precacheImage(const AssetImage('assets/images/3.png'), context);
    precacheImage(const AssetImage('assets/images/4.png'), context);
    precacheImage(const AssetImage('assets/images/5.png'), context);
    precacheImage(const AssetImage('assets/images/6.png'), context);
    precacheImage(const AssetImage('assets/images/7.png'), context);
    precacheImage(const AssetImage('assets/images/to.png'), context);
    precacheImage(const AssetImage('assets/images/play.png'), context);
    precacheImage(const AssetImage('assets/images/stop.png'), context);
    cache();
    changeImgNum();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    timer.cancelTimer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  MyPeriodicTimer timer = MyPeriodicTimer();
  Soundpool pool = Soundpool(streamType: StreamType.ring);

  int soundIdOne = 0;
  int soundIdClick = 0;
  Future<void> cache() async {
    soundIdOne = await rootBundle
        .load("assets/sounds/beep.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    soundIdClick = await rootBundle
        .load("assets/sounds/click.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
  }

  void delayedCount() {
    setState(() {
      _count++;
      _count = _count % 4;
      if (_count == 0) {
        changeImgNum();
      }
    });
  }

  void changeImgNum() {
    setState(() {
      currentImgNum = nextImgNum;
      nextImgNum = Random().nextInt(7) + 1;
    });
  }

  void changeTempo() {
    if (mode == "stop") {
      resetTimer();
    }
  }

  String mode = "play";
  void togglePlayStop() {
    if (mode == "play") {
      resetTimer();
      setState(() {
        mode = "stop";
      });
    } else {
      timer.cancelTimer();
      setState(() {
        mode = "play";
      });
    }
  }

  Future<void> playSound() async {
    if (_count == 0) {
      await pool.play(soundIdOne);
    } else {
      await pool.play(soundIdClick);
    }
  }

  void resetTimer() {
    timer.cancelTimer();
    timer.tempo = tempo;
    timer.runTimer(() async {
      delayedCount();
      await playSound();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        timer.cancelTimer();
        setState(() {
          mode = "play";
        });
        break;
      case AppLifecycleState.paused:
        timer.cancelTimer();
        setState(() {
          mode = "play";
        });
        break;
      case AppLifecycleState.detached:
        timer.cancelTimer();
        setState(() {
          mode = "play";
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    timer.tempo = tempo;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('CHORD PRACTICE'),
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      'bpm',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      tempo.toString(),
                      style: const TextStyle(
                        fontSize: 96.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 15.0),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 30.0),
                    thumbColor: const Color(0xFFEB5757),
                    activeTrackColor: const Color(0XFF0000FF),
                    inactiveTrackColor: const Color(0xff8d8e98),
                    overlayColor: const Color(0x29EB1555),
                  ),
                  child: Slider(
                      value: tempo.toDouble(),
                      min: 30.0,
                      max: 600.0,
                      onChanged: (double x) {
                        setState(() {
                          tempo = x.toInt();
                        });
                        changeTempo();
                      }),
                ),
                SizedBox(
                  height: 64.0,
                  child: Image.asset(
                    'assets/images/haku${_count + 1}.png',
                    height: 48,
                  ),
                ),
                SizedBox(
                  height: 96.0,
                  child: TextButton(
                    onPressed: () {
                      togglePlayStop();
                    },
                    child: Image.asset(
                      "assets/images/$mode.png",
                      height: 80,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          'assets/images/$currentImgNum.png',
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Image.asset('assets/images/to.png'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          'assets/images/$nextImgNum.png',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
