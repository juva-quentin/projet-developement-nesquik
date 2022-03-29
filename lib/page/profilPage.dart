import 'package:flutter/material.dart';
import 'package:projet_developement_nesquik/Components/scrollList.dart';

class ProfilOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        top: false,
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return buildProfilOverlay(context);
  }

  Widget buildTop(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.22,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          // ignore: prefer_const_constructors
          color: Color(0xFF72B0EA),
          borderRadius: BorderRadius.only(
            // ignore: prefer_const_constructors
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
      );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(0.0, -0.95);
    const end = Offset.zero;
    // You can add your own animations for the overlay content
    var tween = Tween(begin: begin, end: end);
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
