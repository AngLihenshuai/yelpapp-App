import 'package:flutter/material.dart';
import '../tools/ratingStar.dart';

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.recommand,
    this.point,
  }) : super(key: key);

  final String title;
  final String recommand;
  final String point;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24.0,
                  color: Colors.black54
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20.0)),
              Row(children: <Widget>[
                SmoothStarRating(
                  starCount: 1,
                  color: Colors.orangeAccent[400],
                  allowHalfRating: true,
                  rating: 5.0,
                  size: 12.0,
                ),
                const Padding(padding: EdgeInsets.only(right: 5.0)),
                Text(
                  '$point',
                  // ★
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.orangeAccent[400],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 15.0)),
                Text(
                  '$recommand',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.red[300],
                  ),
                )
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.recommand,
    this.point,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String recommand;
  final String point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  recommand: recommand,
                  point: point,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
