import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:chord_practice/logics/my_periodic_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

const SOUND_CLICK = 'sounds/pi.wav';
const SOUND_CLICKA = 'assets/sounds/pi.wav';

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
        .load("assets/sounds/pi.wav")
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

  @override
  void dispose() {
    timer.cancelTimer();
  }

  String mode = "play";
  void toggle() {
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
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text('bpm'),
                    Text(
                      tempo.toString(),
                      style: const TextStyle(fontSize: 96.0),
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
                      max: 300.0,
                      onChanged: (double x) {
                        setState(() {
                          tempo = x.toInt();
                        });
                      }),
                ),
                Image.asset('assets/images/haku${_count + 1}.png'),
                TextButton(
                    onPressed: () {
                      toggle();
                    },
                    child: Image.asset("assets/images/$mode.png")),
//                TextButton(
//                  onPressed: () {
//                    timer.cancelTimer();
//                  },
//                  child: Image.asset("assets/images/stop.png"),
//                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/$currentImgNum.png'),
                    Image.asset('assets/images/to.png'),
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
