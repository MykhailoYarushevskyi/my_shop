import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    //if it's initial route (first page), we don't want to animate it
    if (settings.name == '/') {
      return child;
    }
    // If it's not the initial route, so if we're already in the app
    // and we're just moving to a different screen, then we can
    // for example return a fade transition
    return FadeTransition(
      opacity: animation,
      child: child,
    );

    // return super
    //     .buildTransitions(context, animation, secondaryAnimation, child);
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    //if it's initial route (first page), we don't want to animate it
    if (route.settings.name == '/') {
      return child;
    }
    // If it's not the initial route, so if we're already in the app
    // and we're just moving to a different screen, then we can
    // for example return a fade transition
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
