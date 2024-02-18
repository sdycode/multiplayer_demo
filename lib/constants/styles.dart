// import 'package:multiplayer_demo/main.dart';
// import 'package:flutter/material.dart';
// import 'package:multiplayer_demo/extensions/exte_paths.dart';

// TextStyle blackstyle = TextStyle(color: Colors.black);

// TextStyle whitestyle = TextStyle(color: Colors.white);
// InputDecoration textfieldDecoration = InputDecoration(
//   filled: true,
//   fillColor: Color.fromARGB(255, 91, 89, 89), // Background color
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(24.0), // Border radius
//     borderSide: BorderSide.none,
//   ),
// );

// Gradient calulatorCardGradient = LinearGradient(
//   stops: [0.4, 0.97],
//   begin: Alignment.topCenter,
//   end: Alignment.bottomCenter,
//   colors: [
//     Color.fromARGB(255, 140, 181, 234),
//     Color.fromARGB(255, 14, 23, 70),
//   ],
//   tileMode: TileMode.mirror,
// );
// Gradient purchanseCardGradient = LinearGradient(
//   stops: [0.3, 0.97],
//   begin: Alignment.topCenter,
//   end: Alignment.bottomCenter,
//   colors: [Color.fromARGB(255, 8, 76, 170), Colors.blue],
//   tileMode: TileMode.mirror,
// );

// Gradient appBarGradient = LinearGradient(colors: [
//   Color(0xFF002458),
//   Color(0xFF3360A1),
// ]);

// Gradient primaryLRGradient = LinearGradient(
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//     colors: [
//       Color(0xFF002458),
//       Color(0xFF3360A1),
//     ]);
// Gradient blackgreyDiagonalGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [
//       Color(0xFF6B6A6A),
//       Color(0xFF2D2D2D),
//     ]);
// OutlineInputBorder whiteBoarder =
//     OutlineInputBorder(borderSide: BorderSide(color: Colors.white));
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';

OutlineInputBorder roundBorderStyle = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xffD8D8D8)),
  borderRadius: 100.borderRadiusCircular(),
);
OutlineInputBorder primaryBorderStyle = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xffD8D8D8)),
  borderRadius: 12.borderRadiusCircular(),
);

Gradient aminityGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff3399CC),
      Color(0xff60BDF1),
    ]);
Gradient aminitySelectedGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0xffFFC700),
      Color(0xffF2264B),
    ]);
ShapeBorder bottomSheetShape({double rad = 40}) => RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(rad)));
ShapeBorder bottomSheetShap = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(40)));
// const Gradient primaryTBGradient = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [
//       Color(0xFFF2E205),
//       Color(0xFFF2B705),
//     ]);
// const Gradient TBGradientGreen = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [
//       Color(0xFF29CC80),
//       Color(0xFF09A05A),
//     ]);
// const Gradient TBGradientRed = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [
//       Color(0xFFF27D7D),
//       Color(0xFFF25050),
//     ]);
// final ShapeBorder cardShape =
//     RoundedRectangleBorder(borderRadius: 12.borderRadiusCircular());
