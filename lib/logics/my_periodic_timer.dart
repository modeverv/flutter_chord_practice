import 'dart:async';

class MyPeriodicTimer {
  int _tempo = 60;

  late Timer _timer;

  bool _maked = false;

  int get tempo {
    return _tempo;
  }

  set tempo(int t) {
    if (t < 1) {
      t = 1;
    }
    if (t > 400) {
      t = 400;
    }
    _tempo = t;
  }

  double _getPeriod() {
    return 1000 * 60 / tempo * 1000;
  }

  void runTimer(Function task) {
    double period = _getPeriod();
    print(period);
    _timer = Timer.periodic(Duration(microseconds: period.toInt()), (timer) {
      task();
    });
//    print('started');
    _maked = true;
  }

  void cancelTimer() {
    if (_maked) {
      _timer.cancel();
      print('canceled');
      _maked = false;
    }
  }
}
