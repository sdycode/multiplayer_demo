// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multiplayer_demo/functions/common/checkWhetherInternetConnection.dart';
import 'package:multiplayer_demo/functions/special/adduser_to_userlist.dart';
import 'package:multiplayer_demo/main.dart';
import 'package:multiplayer_demo/widgets/assetimg.dart';
import 'package:multiplayer_demo/widgets/lable.dart';
import 'package:multiplayer_demo/widgets/special/checkinternet_connection_widget.dart';
import 'package:multiplayer_demo/widgets/special/get_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multiplayer_demo/constants/gaps.dart';
import 'package:multiplayer_demo/constants/global.dart';
import 'package:multiplayer_demo/constants/images.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/common/navigateWithTransition.dart';
import 'package:multiplayer_demo/functions/common/showsnackbar.dart';
import 'package:multiplayer_demo/screens/homepage.dart';
import 'package:multiplayer_demo/screens/signup_page.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';
import 'package:multiplayer_demo/widgets/textfieldbox.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool guestLoading = false;
  bool appleLoading = false;
  bool googleLoading = false;
  bool emailLoading = false;
  bool get _isLoading =>
      guestLoading || appleLoading || googleLoading || emailLoading;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    DeviceLocation.instance.getAndSetCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    // if (SharedPrefe.isSizeInitialisationRequired()) {
    //   SharedPrefe.setScreenSizes(context);
    // }
    // ThemesProvider tp = Provider.of<ThemesProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        // showExitDialog(context);
        return false;
        // exit(0);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(top: 30),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 53, 52, 52),
                      borderRadius:
                          // 56.borderRadiusCircular()
                          BorderRadius.vertical(top: Radius.circular(56))),
                  child: AutofillGroup(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextWithFontWidget.white(
                            maxLines: 4,
                            text: DeviceLocation.instance.currentPosition
                                .toString()),
                        gap20,
                        TextWithFontWidget.black(
                          text: "Welcome Back!",
                          fontsize: w * 0.06,
                          fontweight: FontWeight.w800,
                        ).topPadding(),
                        TextWithFontWidget(
                          color: Colors.grey,
                          text: "Let's log in and continue exploring.",
                          fontsize: w * 0.04,
                        ).bottomPadding(),
                        title("Email").leftAlignWidget(),
                        TextFieldBox(
                          autofillHints: const [AutofillHints.email],
                          controller: emailcontroller,
                          hint: "Enter Email",
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          emailValidatorSuffixIcon: const [
                            Icon(
                              Icons.check_circle,
                              // color: tp.color.primary,
                            ),
                            Icon(Icons.check_circle_outline)
                          ],
                        ),
                        gap10,
                        title("Password").leftAlignWidget(),
                        TextFieldBox(
                          autofillHints: const [AutofillHints.password],
                          controller: passwordController,
                          hint: "Enter Password",
                          showEyeButton: true,
                          prefixIcon: const Icon(
                            Icons.lock_open,
                            color: Colors.black,
                          ),
                        ),
                        gap20,
                        "Login"
                            .roundButtonExpanded(
                                onTap: () async {
                                  TextInput.finishAutofillContext();
                                  if (_isLoading) {
                                    return;
                                  }
                                  await _loginToFireabse(
                                      emailcontroller.text.trim(),
                                      passwordController.text.trim());
                                },
                                loading: emailLoading)
                            .vertPadding(),
                        "Guest Login"
                            .roundButtonExpanded(
                                onTap: () {
                                  _registerAnonUser(context);
                                },
                                loading: guestLoading)
                            .vertPadding(),
                        TextWithFontWidget(
                          text: "Login with",
                          fontsize: w * 0.04,
                        ).vertPadding(vert: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                              2,
                              (i) => InkWell(
                                    onTap: () async {
                                      if (_isLoading) {
                                        return;
                                      }
                                      switch (i) {
                                        case 0:
                                          signInWithGoogle();
                                          break;
                                        case 1:
                                          signinwithApple();
                                          break;
                                        default:
                                      }
                                    },
                                    splashColor: Colors.grey,
                                    borderRadius: 56.borderRadiusCircular(),
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2, color: Colors.grey)),
                                      child: Center(
                                        child: AssetImgSizeWidget(
                                          size: 36,
                                          img: [Images.google, Images.apple][i],
                                        ),
                                      ),
                                    ),
                                  )),
                        ).opaqueWithIgnore(
                            opacityValue: _isLoading ? 0.5 : 1,
                            ignore: _isLoading),
                        gap20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWithFontWidget(
                              text: "Don’t have account ? ",
                              fontsize: w * 0.04,
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateWithTransitionToScreen(
                                      context, const SignupScreenV2());
                                },
                                child: TextWithFontWidget(
                                  text: "Sign Up here",
                                  fontsize: w * 0.042,
                                  // color: tp.color.appbarBG,
                                  fontweight: FontWeight.bold,
                                ))
                            // InkWell(
                            //   onTap: () {

                            //   },
                            //   child: .vertPadding(),
                            // )
                          ],
                        ).verticalPadding(),
                      ],
                    ).symmetricPadding().scrollColumnWidget(),
                  ),
                ),
                CheckInterentWidget(
                  onRefreshPressed: () {
                    setState(() {});
                  },
                )
              ],
            ),
          )),
    );
  }

  Widget iconimgWithText(String img, String text, VoidCallback onTap) {
    return InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: 12.borderRadiusCircular(),
                  border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.8,
                      style: BorderStyle.solid)),
              // shape: 8.cardRoundShape(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AssetImgSizeWidget(
                    size: w * 0.08,
                    img: img,
                    color: Colors.black,
                  ).horzPadding(horz: w * 0.02 * 0),
                  Container(
                    width: 1.2,
                    color: Colors.grey.shade300,
                    height: w * 0.1,
                  ).horzPadding(horz: w * 0.03),
                  TextWithFontWidget(
                    text: text,
                    align: TextAlign.start,
                    fontsize: w * 0.045,
                    color: Colors.black.withOpacity(0.665),
                    fontweight: FontWeight.w700,
                  ).expnd()
                ],
              ).symmetricPadding(horz: w * 0.05, vert: 12),
            ).horzPadding())
        .verticalPadding();
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    return "";
  }

  Future _loginToFireabse(String email, String pwd) async {
    bool network = await internetAvaliable();
    dblog("user before start $network");
// signOut();
    // await FirebaseAuth.instance.signOut();

    bool isLogin = false;
    if (network) {
      setState(() {
        emailLoading = true;
      });
      try {
        dblog("user start");
        UserCredential? userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pwd)
            .then((value) {
          return value;
        });
        if (userCredential != null) {
          isLogin = true;
        }
      } on FirebaseAuthException catch (e) {
        dblog("e.code err ${e.code}");
        setState(() {
          emailLoading = false;
        });
        if (e.code == "invalid-credential") {
          setState(() {
            emailLoading = false;
          });
          showSnackbarWithButton(context, "Invalid Credential");
        }
        if (e.code == "channel-error") {
          setState(() {
            emailLoading = false;
          });
          showSnackbarWithButton(context, "Some error occured");
        }
        if (e.code == 'user-not-found') {
          setState(() {
            emailLoading = false;
          });
          SnackBarMessage.show(context: context, message: "User not found!");
          isLogin = false;
        } else if (e.code == 'wrong-password') {
          setState(() {
            emailLoading = false;
          });
          SnackBarMessage.show(context: context, message: "Wrong password!");
          isLogin = false;
        }
      }
      if (isLogin) {
        setState(() {
          emailLoading = false;
        });
        Navigator.popUntil(context, (route) => false);
        if (auth.currentUser != null) {
          addBasicUserInfoToFirebase(auth.currentUser!);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homePage),
        );
      }
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  Future _registerAnonUser(BuildContext context) async {
    dblog("anonuser");
    bool network = await internetAvaliable();
    if (network) {
      setState(() {
        guestLoading = true;
      });
      try {
        print("Creating anonuser: ");
        UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        userCredential.user?.updateDisplayName("Guest");
        // Navigator.popUntil(context, (route) => false);
        // ignore: use_build_context_synchronously
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          guestLoading = true;
        });
        if (auth.currentUser != null) {
          dblog("guest auth ${auth.currentUser!.uid}");
          addBasicUserInfoToFirebase(auth.currentUser!);
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => homePage));
      } on FirebaseAuthException catch (e) {
        setState(() {
          guestLoading = false;
        });
        print("Error in anonuser: ${e}");
        // ignore: use_build_context_synchronously
        showSnackbarWithButton(context, 'Error in process.');
        // SnackBarMessage.show(context: context, message: 'Error in process.');
        guestLoading = false;
      } catch (e) {
        //print(e);
      }
    } else {
      showSnackbarWithButton(context, 'Check internet connection');

      setState(() {
        guestLoading = false;
      });
    }
  }

  Future signInWithGoogle() async {
    setState(() {
      googleLoading = true;
    });
    const List<String> scopes = <String>[
      'email',
    ];

    GoogleSignIn _googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: 'your-client_id.apps.googleusercontent.com',
      scopes: scopes,
    );
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Obtain the auth details from the GoogleSignInAccount
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Create a new credential using the token from the GoogleSignInAuthentication
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to Firebase with the credential
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Get the user information from the UserCredential
        final User? user = userCredential.user;

        if (user != null) {
          var email = user.email;
          var name = user.displayName;

          await setEmail(email ?? "");
          await setName(name ?? "");
          // Navigator.popUntil(context, (route) => false);

          setState(() {
            googleLoading = false;
          });
          if (auth.currentUser != null) {
            addBasicUserInfoToFirebase(auth.currentUser!);
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homePage),
          );
          // print('User signed in with Google: ${user.displayName}');
          // You can now use the 'user' object to access user details
        } else {
          setState(() {
            googleLoading = false;
          });
          // print('Failed to sign in with Google.');
        }
      } else {
        setState(() {
          googleLoading = false;
        });
      }

      dblog("google sign success");
    } catch (error) {
      showSnackbarWithButton(context, "Some error occured");
      setState(() {
        googleLoading = false;
      });
      dblog("google err " + error.toString());
    }
  }

  Future signinwithApple() async {
    setState(() {
      appleLoading = true;
    });
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('name');
    try {
      var appleCredential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
      var email = appleCredential.user!.email ?? "";
      var name = appleCredential.user!.displayName ?? "";
      var userIdentifier =
          appleCredential.additionalUserInfo!.authorizationCode!;
      if (email.isEmpty) {
        email = "${appleCredential.user!.uid}@temporaryemail.com";
      }
      if (name.isEmpty) {
        name = "Guest";
      }
      print(email);
      await setEmail(email ?? "");
      await setName(name ?? "");
      await setIdentifier(userIdentifier ?? "");
      // Navigator.popUntil(context, (route) => false);

      setState(() {
        appleLoading = false;
      });
      if (auth.currentUser != null) {
        addBasicUserInfoToFirebase(auth.currentUser!);
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homePage),
      );
    } on FirebaseAuthException catch (e) {
      showSnackbarWithButton(context, "Some error occured");
      setState(() {
        appleLoading = false;
      });

      if (e.code == "invalid-credential") {
        setState(() {
          emailLoading = false;
        });
        showSnackbarWithButton(context, "Invalid Credential");
      }
    } catch (e) {
      setState(() {
        appleLoading = false;
      });
    }

    return;
  }
}

getIdentifier() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("IS_Identifier") ?? "";
}

setEmail(String value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("IS_Gmail", value);
}

getEmail() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("IS_Gmail") ?? "";
}

setName(String value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("IS_Name", value);
}

getName() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("IS_Name") ?? "";
}

setIdentifier(String value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("IS_Identifier", value);
}
