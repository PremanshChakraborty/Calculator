import 'dart:ffi';

import 'package:flutter/material.dart';
class Button extends StatelessWidget {
  final ontap;
  Color? color=null;
  Color? bgcolor=null;
  double? fontsize=null;
  final String text;
  Button({required this.ontap,required this.text,this.color,this.bgcolor,this.fontsize,super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ontap,
      style: TextButton.styleFrom(
        backgroundColor: bgcolor ?? Theme.of(context).colorScheme.surfaceVariant,
          shape: CircleBorder()
        ),
      child: Text(text,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color,
        fontSize: fontsize
      ),),
    );
  }
}
