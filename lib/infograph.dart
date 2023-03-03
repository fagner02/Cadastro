import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Infograph extends StatefulWidget {
  const Infograph({super.key});

  @override
  State<Infograph> createState() => _InfographState();
}

class _InfographState extends State<Infograph> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 7,
              offset: const Offset(0, 0),
              blurStyle: BlurStyle.outer),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 247, 247, 247).withOpacity(0.20),
              // boxShadow: [
              //   BoxShadow(
              //       color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              //       spreadRadius: 0,
              //       blurRadius: 7,
              //       offset: const Offset(0, 0),
              //       blurStyle: BlurStyle.outer),
              // ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Infograph"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
