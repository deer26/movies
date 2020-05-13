import 'package:flutter/material.dart';

class MyCustomRoute<T> extends MaterialPageRoute {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.isInitialRoute )// mu neydi ? bu flutter upgrade ile bozuldu
    //   // Fades between routes.(If you don't want to animation,just return child)
    //   return child;
    // }
    return new FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
