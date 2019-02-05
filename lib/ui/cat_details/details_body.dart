import 'package:cat_box/models/cat.dart';
import 'package:flutter/material.dart';

class CatDetailBody extends StatelessWidget {
  final Cat cat;

  CatDetailBody(this.cat);

  _createCircleBagde(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var LocationInfo = new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            cat.location,
            style: textTheme.subhead.copyWith(color: Colors.white)
          ),
        )
      ],
    );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          cat.name,
          style: textTheme.headline.copyWith(color: Colors.white)
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: LocationInfo,
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Text(
            cat.description,
            style: textTheme.body1.copyWith(color: Colors.white70, fontSize: 16.0)
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              _createCircleBagde(Icons.share, theme.accentColor),
              _createCircleBagde(Icons.phone, Colors.white12),
              _createCircleBagde(Icons.email, Colors.white12)
            ],
          ),
        )
      ],
    );
  }
}