import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    Key? key,
    required this.tempo,
    required this.onChanged,
  }) : super(key: key);

  final int tempo;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),
          thumbColor: const Color(0xFFEB5757),
          activeTrackColor: const Color(0XFF0000FF),
          inactiveTrackColor: const Color(0xff8d8e98),
          overlayColor: const Color(0x29EB1555),
        ),
        child: Slider(
          value: tempo.toDouble(),
          min: 30.0,
          max: 300.0,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
