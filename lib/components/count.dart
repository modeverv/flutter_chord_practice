import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  const CountWidget({
    Key? key,
    required int count,
  })  : _count = count,
        super(key: key);

  final int _count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.0,
      child: Image.asset(
        'assets/images/haku${_count + 1}.png',
        height: 48,
      ),
    );
  }
}
