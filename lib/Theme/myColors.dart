import 'dart:ui';

/// light theme  color

final lightbgColor = Color(0xFF9EE2A0); //granny smith apple color
final lightbgColor1 = Color(0xFF393939); // mine shaft color
final lightbgColor2 = Color(0xFFABC0AC); // spring rain color
final lightbgColor3 = Color(0xFFD7CDF1); //moon raker color
final lightbgColor4 = Color(0xFFB4A2DE); // cold purple color
final lightbgColor5 = Color(0xFFC9D1FF); // periwinkle color
final lightbgColor6 = Color(0xFFE0E0E0); // alto grey color
final lightbgColor7 = Color(0xFFD1C5FF); // fog color
final lightbgColor8 = Color(0xFFF0D8DA); // Vanilla Ice color

/// dark theme color

final darkcolor1 = Color(0xFF4F2800); // Camaby tan color
final darkcolor2 = Color(0xFF27273E);
final darkcolor3 = Color(0xFF000A19);
final darkcolor4 = Color(0xFF00296B);
final darkcolor5 = Color(0xFF111111);
final darkcolor6 = Color(0xFF065808);
final darkcolor7 = Color(0xFF010F01);
final darkcolor8 = Color(0xFF365B37);
final darkcolor9 = Color(0xFF039BE5);

/// common color

final appbarColor = Color(0xFF4C9BBA);
final bodyColor = Color(0xFFB1D2DF);
final btnColor = Color(0xFF4C9BBA);


extension HexToColor on String {
  Color hexToColor() {
    return Color(
        int.parse(toLowerCase().substring(1, 7), radix: 16) + 0xFF000000);
  }
}

