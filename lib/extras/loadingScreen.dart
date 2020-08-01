import 'dart:math';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}
AnimationController controller;

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin{

  Animation<double> rotation;
  Animation<double> radius_in;
  Animation<double> radius_out;

  final int maxRadius = 50;
  double outerRadius = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );


    rotation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller ,
        curve: Interval(0.0 , 1.0 , curve: Curves.linear)));

    radius_in = Tween<double> (
     begin: 1.0,
     end: 0.0,
    ).animate(CurvedAnimation(parent: controller ,
        curve: Interval(0.75 , 1.0 , curve: Curves.elasticIn)));
    radius_out = Tween<double> (
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller ,
        curve: Interval(0.0 , 0.25 , curve: Curves.elasticOut)));

    controller.addListener(() {
      setState(() {
        if(controller.value <= 1 && controller.value >= 0.75) {
          outerRadius = maxRadius * radius_in.value;
        }
        if(controller.value <= 0.25 && controller.value >= 0) {
          outerRadius = maxRadius * radius_out.value;
        }
      });
    });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            child: RotationTransition(
              turns: rotation,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Dot(radius: 50 , color: Colors.grey[300],),
                  transformDots(0 , Colors.white),
                  transformDots(pi/4 , Colors.yellow),
                  transformDots(pi/2 , Colors.white),
                  transformDots(3*pi/4 , Colors.yellow),
                  transformDots(pi , Colors.white),
                  transformDots(5*pi/4 , Colors.yellow),
                  transformDots(3*pi/2 , Colors.white),
                  transformDots(7*pi/4 , Colors.yellow),
                ],
              ),
            ),
      );
  }
  Transform transformDots(double angle , Color color) {
    return Transform.translate(
      offset: Offset(outerRadius * cos(angle) , outerRadius * sin(angle)),
      child: Dot(
        radius: 10,
        color: color,
      ),
    );
  }
}

// ignore: must_be_immutable
class Dot extends StatelessWidget{
  double radius;
  Color color;
  Dot({this.radius , this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color
        ),
      ),
    );
    //TODO setting txt of Loading
  }
}