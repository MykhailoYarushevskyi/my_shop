import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 5,
          top: 2,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: color != null ? color : Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              value,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
          ),
        ),
      ],
    );
  }
}
