import 'package:flutter/material.dart';

Color seeThrough() => Colors.transparent;
Color appBarColor() => Colors.blue[900] ?? seeThrough();
Color backgroundColor() => Colors.blue[50] ?? seeThrough();
Color lightColor() => Colors.blue;
Color disabledColor() => Colors.grey;
Color goodColor() => Colors.green[800] ?? seeThrough();
Color fineColor() => Colors.grey[900] ?? seeThrough();
Color badColor() => Colors.red[900] ?? seeThrough();
Color offWhiteColor() => Colors.grey[200] ?? seeThrough();
Color whisperColor() => Colors.grey[600] ?? seeThrough();

class RavenColor {
  RavenColor();

  Color get appBar => appBarColor();
  Color get background => backgroundColor();
  Color get light => lightColor();
  Color get disabled => disabledColor();
  Color get good => goodColor();
  Color get fine => fineColor();
  Color get bad => badColor();
  Color get offWhite => offWhiteColor();
  Color get whisper => whisperColor();
}
