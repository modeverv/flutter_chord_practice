import 'package:flutter/material.dart';

class ProgressionWidget extends StatelessWidget {
  const ProgressionWidget({
    Key? key,
    required this.currentImgNum,
    required this.nextImgNum,
  }) : super(key: key);

  final int currentImgNum;
  final int nextImgNum;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
