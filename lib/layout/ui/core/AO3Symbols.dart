import 'package:flutter/material.dart';
import 'package:exui/exui.dart';



enum ContentRating {
  None(image: "assets/symbols/none.png"),
  General(image: "assets/symbols/rating/rating-general-audience.png"),
  Teen(image: "assets/symbols/rating/rating-teen.png"),
  Mature(image: "assets/symbols/rating/rating-mature.png"),
  Explicit(image: "assets/symbols/rating/rating-explicit.png");

  const ContentRating({ required this.image });

  final String image;

  String get imageLoc => image;
}

enum RPO {
  None(image: "assets/symbols/none.png"),
  FF(image: "assets/symbols/RPO/category-femslash.png"),
  FM(image: "assets/symbols/RPO/category-het.png"),
  Gen(image: "assets/symbols/RPO/category-gen.png"),
  MM(image: "assets/symbols/RPO/category-slash.png"),
  Multi(image: "assets/symbols/RPO/category-multi.png"),
  Other(image: "assets/symbols/RPO/category-other.png");

  const RPO({ required this.image });

  final String image;

  String get imageLoc => image;
}

enum ContentWarning {
  None(image: "assets/symbols/none.png"),
  Unspecified(image: "assets/symbols/warning/warning-choosenotto.png"),
  Explicit(image: "assets/symbols/warning/warning-yes.png"),
  External(image: "assets/symbols/warning/warning-external-work.png");

  const ContentWarning({ required this.image });

  final String image;

  String get imageLoc => image;
}

enum Status {
  Unknown(image: "assets/symbols/none.png"),
  InProgress(image: "assets/symbols/status/complete-no.png"),
  Completed(image: "assets/symbols/status/complete-yes.png");

  const Status({ required this.image });

  final String image;

  String get imageLoc => image;
}





class AO3Symbols extends StatelessWidget {

  final double height;
  final double width;
  final ContentRating ratingSymbol;
  final RPO RPOSymbol;
  final ContentWarning warningSymbol;
  final Status statusSymbol;

  const AO3Symbols({
    super.key,
    required this.height,
    required this.width,
    this.ratingSymbol = ContentRating.None,
    this.RPOSymbol = RPO.None,
    this.warningSymbol = ContentWarning.None,
    this.statusSymbol = Status.Unknown
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      child: Row(
        children: [
          Column(children: [
            Image.asset(this.ratingSymbol.imageLoc, height: (this.height/2), width: (this.width/2),),
            Image.asset(this.warningSymbol.imageLoc, height: (this.height/2), width: (this.width/2),)
          ],),
          Column(children: [
            Image.asset(this.RPOSymbol.imageLoc, height: (this.height/2), width: (this.width/2),),
            Image.asset(this.statusSymbol.imageLoc, height: (this.height/2), width: (this.width/2),)
          ],),
        ],
      ),
    );
  }
}
