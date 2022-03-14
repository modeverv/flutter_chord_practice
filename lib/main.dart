import 'dart:math';

import 'package:chord_practice/logics/my_periodic_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'components/bpm.dart';
import 'components/count.dart';
import 'components/playstop.dart';
import 'components/progression.dart';
import 'components/slider.dart';

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
  MyPeriodicTimer timer = MyPeriodicTimer();
  Soundpool pool = Soundpool(streamType: StreamType.ring);
  int soundIdOne = 0;
  int soundIdClick = 0;
  String modePlay = "play";
  String modeStop = "stop";
  String mode = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      cacheImg();
      cacheAudio();
    });
    changeImgNum();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    timer.tempo = tempo;
    mode = modePlay;
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        cacheImg();
        cacheAudio();
        break;
      case AppLifecycleState.inactive:
        timer.cancelTimer();
        changeToStop();
        break;
      case AppLifecycleState.paused:
        timer.cancelTimer();
        changeToStop();
        break;
      case AppLifecycleState.detached:
        timer.cancelTimer();
        changeToStop();
        break;
    }
  }

  void cacheImg() {
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
  }

  Future<void> cacheAudio() async {
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

  void changeToPlaying() {
    setState(() {
      mode = modeStop;
    });
  }

  void changeToStop() {
    setState(() {
      mode = modePlay;
    });
  }

  void changeTempo() {
    if (mode == modeStop) {
      resetTimer();
    }
  }

  void togglePlayStop() {
    if (mode == modePlay) {
      resetTimer();
      changeToPlaying();
    } else {
      timer.cancelTimer();
      changeToStop();
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
  Widget build(BuildContext context) {
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
                BpmWidget(tempo: tempo),
                SliderWidget(
                  tempo: tempo,
                  onChanged: (double x) {
                    setState(() {
                      tempo = x.toInt();
                    });
                    changeTempo();
                  },
                ),
                CountWidget(count: _count),
                PlayStopWidget(
                  mode: mode,
                  onPress: () {
                    togglePlayStop();
                  },
                ),
                ProgressionWidget(
                    currentImgNum: currentImgNum, nextImgNum: nextImgNum),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
