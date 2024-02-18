import 'package:firebase_auth/firebase_auth.dart';

bool get isValidCurrentUser => FirebaseAuth.instance.currentUser != null;
bool get isInvalidCurrentUser => !isValidCurrentUser;

User get validUser => FirebaseAuth.instance.currentUser!;
String get validId => FirebaseAuth.instance.currentUser!.uid;
