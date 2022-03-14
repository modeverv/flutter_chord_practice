import 'package:flutter/material.dart';

class PlayStopWidget extends StatelessWidget {
  const PlayStopWidget({
    Key? key,
    required this.mode,
    required this.onPress,
  }) : super(key: key);

  final String mode;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0,
      child: TextButton(
        onPressed: onPress,
        child: Image.asset(
          "assets/images/$mode.png",
          height: 72,
          width: 72,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
