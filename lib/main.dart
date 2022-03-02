import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:chord_practice/logics/my_periodic_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

const SOUND_CLICK = 'sounds/click2.wav';
const SOUND_CLICKA = 'assets/sounds/click2.wav';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tempo = 60;

  int _count = 0;
  int currentImgNum = 1;
  int imgNum = 1;

  Soundpool pool = Soundpool(streamType: StreamType.notification);

  int soundId = 0;
//  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    cache();
    changeImgNum();
  }

  MyPeriodicTimer timer = MyPeriodicTimer();

  final AudioCache _cache = AudioCache(
    fixedPlayer: AudioPlayer(mode: PlayerMode.LOW_LATENCY),
  );

  Future<void> cache() async {
    _cache.loadAll([SOUND_CLICK]);
    soundId = await rootBundle
        .load("assets/sounds/click2.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });

    //var duration = await player.setUrl('https://foo.com/bar.mp3');
    //var duration = await player.setFilePath(SOUND_CLICKA);
//    var duration = await player.setAsset(SOUND_CLICKA);
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
      currentImgNum = imgNum;
      imgNum = Random().nextInt(7) + 1;
    });
  }

  void dispose() {
    timer.cancelTimer();
  }

  AudioPlayer? _player = null;
  void resetTimer() {
    print('resetTimer');
    timer.cancelTimer();
    timer.tempo = tempo;
    timer.runTimer(() async {
      delayedCount();
//      var now = DateTime.now();
//      var formatter = DateFormat('HH:mm:ss.S');
//      var formattedTime = formatter.format(now);
//      print(formattedTime);
//      await _cache.fixedPlayer?.stop();
//      await _cache.fixedPlayer?.release();
//      await _cache.fixedPlayer?.stop();
//      if (null != _player) {
//        await _player?.stop();
//        await _player?.release();
//        print('release');
//      }
//      _player = await _cache.play(SOUND_CLICK,
//          mode: PlayerMode.LOW_LATENCY, isNotification: false);

      int streamId = await pool.play(soundId);
//      await player.stop();
//      await player.seek(Duration(seconds: 0));
//      await player.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    timer.tempo = tempo;
    print('build');
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                Text(
                  tempo.toString(),
                ),
                Text(
                  (4 - _count).toString(),
                ),
                Text(
                  (currentImgNum).toString() + '-' + (imgNum).toString(),
                ),
                TextButton(
                  onPressed: () {
                    resetTimer();
                  },
                  child: const Text('start'),
                ),
                TextButton(
                  onPressed: () {
                    timer.cancelTimer();
                  },
                  child: const Text('stop'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/$currentImgNum.png'),
                    Image.asset('assets/images/arrow.png'),
                    Image.asset('assets/images/$imgNum.png'),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: TextField(
                      maxLength: 3,
                      maxLines: 1,
                      onChanged: (value) {
                        try {
                          int intval = int.parse(value);
                          if (intval > 400) {
                            intval = 400;
                          } else if (intval < 1) {
                            intval = 1;
                          }
                          setState(() {
                            tempo = intval;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
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
