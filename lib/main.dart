import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/common/initialiseSize.dart';
import 'package:multiplayer_demo/screens/homepage.dart';
import 'package:multiplayer_demo/screens/login_page.dart';
import 'package:multiplayer_demo/screens/signup_page.dart';
import 'package:multiplayer_demo/screens/tictactoe_game/latlong_page.dart';
import 'package:multiplayer_demo/screens/tictactoe_game/tictactoe_homepage.dart';
import 'package:multiplayer_demo/widgets/special/get_location.dart';
Widget get homePage => const TicTacToeHomepage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(RoutesWidget());  return;
  DeviceLocation _instance = DeviceLocation();
  try {
    await Firebase.initializeApp();
    FirebaseDatabase.instance.setPersistenceEnabled(true);

    dblog("firebase init success");
  } catch (e) {
    dblog("firebase init error $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: Builder(builder: (context) {
        initialiseGloablSizes(context);
        DeviceLocation.instance;
        // return LatLongPage();
        return auth.currentUser == null ? LoginPage() : TicTacToeHomepage();
      }),
    );
  }
}
 