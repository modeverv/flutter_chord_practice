import 'package:flutter/material.dart';

class BpmWidget extends StatelessWidget {
  const BpmWidget({
    Key? key,
    required this.tempo,
  }) : super(key: key);

  final int tempo;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
