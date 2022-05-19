import 'package:flutter/material.dart';

class PayButton extends StatelessWidget {
  final function;

  PayButton({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
    //   child: Ink(
    // decoration: const ShapeDecoration(
    //   color: Colors.blue,
    //   shape: CircleBorder(),
    // ),
    // child: IconButton(
    //   icon: Icon(Icons.bluetooth),
    //   iconSize: 48,
    //   color: Colors.white, onPressed: () {  },
     
    // ),
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
