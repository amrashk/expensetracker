import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final function;

  SendButton({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Center(
         child: Icon(
                      Icons.send_outlined,
                      color: Colors.black,
                      size: 30.0,),
        ),
      ),
    );
  }
}
