import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
    void initState() {
      super.initState();

      catController = AnimationController(
        duration: Duration(milliseconds: 200),
        vsync: this,
      );

      boxController = AnimationController(
        duration: Duration(milliseconds: 300),
        vsync: this,
      );

      boxAnimation = Tween(
        begin: pi * 0.6, end: pi * 0.65,
      ).animate(
        CurvedAnimation(
          curve: Curves.linear,
          parent: boxController
        ),
      );

      catAnimation = Tween(
        begin: -20.0,
        end: -80.0,
      ).animate(
        CurvedAnimation(
          parent: catController,
          curve: Curves.easeIn,
        ),
      );

      boxAnimation.addStatusListener((status) {
        if (status == AnimationStatus.completed) boxController.reverse();
        else if (status == AnimationStatus.dismissed) boxController.forward();
      });

      boxController.forward();

    }
  
  onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      boxController.stop();
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text('Animation'),
         ),
         body: GestureDetector(
           child: Center(
             child: Stack(
              children: <Widget>[
                  buildAnimation(),
                  buildBox(),
                  buildLeftFlap(),
                  buildRightFlap(),
              ],
              overflow: Overflow.visible,
            ),
           ),
           onTap: onTap,
         ),
       ),
    );
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned (
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }
  
  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: boxAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: -boxAnimation.value,
            alignment: Alignment.topRight,
            child: child,
          );
        },
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
      ),
    );
  }

}