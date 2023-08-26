import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {

  final String os;

  const CircularLoading({super.key , required this.os});

  @override
  Widget build(BuildContext context) {

    if(os == 'android') {

      return const CircularProgressIndicator();

    } else {

      return const CupertinoActivityIndicator();

    }


  }
}
