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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth > 600 ? 8 * 14 : 80,
          child: TextButton(
            onPressed: onPress,
            child: Image.asset(
              "assets/images/$mode.png",
              height: constraints.maxWidth > 600 ? 8 * 14 : 80,
              fit: BoxFit.fill,
            ),
//            style: TextButton.styleFrom(
//              fixedSize: const Size.fromHeight(30),
//            ),
          ),
        );
      },
    );
  }
}
