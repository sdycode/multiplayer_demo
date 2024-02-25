// ignore_for_file: unnecessary_import, use_build_context_synchronously

import 'package:multiplayer_demo/functions/common/checkWhetherInternetConnection.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/common/navigateWithTransition.dart';
import 'package:multiplayer_demo/functions/special/adduser_to_userlist.dart';
import 'package:multiplayer_demo/main.dart';
import 'package:multiplayer_demo/screens/homepage.dart';
import 'package:multiplayer_demo/screens/login_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:multiplayer_demo/constants/gaps.dart';
import 'package:multiplayer_demo/constants/paths.dart';

import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/showsnackbar.dart';
import 'package:multiplayer_demo/functions/common/validateEmailAddress.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';
import 'package:flutter/services.dart';
import 'package:multiplayer_demo/widgets/lable.dart';
import 'package:multiplayer_demo/widgets/textfieldbox.dart';

FirebaseAuth get auth => FirebaseAuth.instance;

class SignupScreenV2 extends StatefulWidget {
  const SignupScreenV2({Key? key}) : super(key: key);

  @override
  SignupScreenV2State createState() => SignupScreenV2State();
}

class SignupScreenV2State extends State<SignupScreenV2> {
  late double heightScale, widthScale;

  _registerUserToFirebase(String name, String email, String pwd) async {
    bool network = await internetAvaliable();
    if (network) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pwd);
        await userCredential.user?.updateDisplayName(name).whenComplete(() {
          dblog("username ${name} : [${auth.currentUser!.displayName}]");
          // return;
          Navigator.popUntil(context, (route) => false);
           if (auth.currentUser != null) {
          addBasicUserInfoToFirebase(auth.currentUser!);
        }
          navigateWithTransitionToScreen(context, homePage);
        });
      } on FirebaseAuthException catch (e) {
        setState(() {});
        if (e.code == 'weak-password') {
          SnackBarMessage.show(
              context: context, message: 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          SnackBarMessage.show(
              context: context,
              message: 'The account already exists for that email.');
        }
      } catch (e) {
        //print(e);
      }
    } else {
      setState(() {});
    }
  }

  bool _privacyPolicyAccepted = false;

  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernamecontroller.dispose();
    emailcontroller.dispose();
    passwordController.dispose();
    reenterPasswordController.dispose();
  }

  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    widthScale = MediaQuery.of(context).size.width / 375;
    heightScale = MediaQuery.of(context).size.height / 812;
    return Scaffold(
        // backgroundColor: tp.color.primary,
        appBar: AppBar(
          title: const Text(
            "Sign In",
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          margin: const EdgeInsets.only(top: 40),
          child: AutofillGroup(
            child: Column(
              children: [
                gap20,
                TextWithFontWidget.black(
                  text: "Sign In to Your Account",
                  fontsize: w * 0.06,
                  fontweight: FontWeight.w800,
                ).topPadding(),
                TextWithFontWidget(
                  color: Colors.grey,
                  text: "Let’s login for explore continues",
                  fontsize: w * 0.04,
                ).bottomPadding(),
                title("Name").leftAlignWidget(),
                TextFieldBox(
                  autofillHints: const [AutofillHints.email],
                  controller: usernamecontroller,
                  hint: "Enter Username",
                  prefixIcon: const Icon(
                    Icons.face,
                    color: Colors.black,
                  ),
                ),
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
                gap10,
                title("Confirm Password").leftAlignWidget(),
                TextFieldBox(
                  autofillHints: const [AutofillHints.password],
                  controller: reenterPasswordController,
                  hint: "Confirm Password",
                  prefixIcon: const Icon(
                    Icons.lock_open,
                    color: Colors.black,
                  ),
                ),
                gap20,
                "Sign In"
                    .roundButtonExpanded(
                        onTap: () async {
                          if (usernamecontroller.text.trim().isNotEmpty &&
                              emailcontroller.text.trim().isNotEmpty) {
                            if (validateEmailAddress(
                                emailcontroller.text.trim())) {
                              if (passwordController.text.trim().length < 8) {
                                showSnackbarWithButton(context,
                                    "Password should have minimum 8 characters");
                                return;
                              } else {
                                if (passwordController.text.trim() !=
                                    reenterPasswordController.text.trim()) {
                                  showSnackbarWithButton(context,
                                      "Password and Reentered passwords are not same");
                                  return;
                                } else {
                                  setState(() {
                                    showLoading = true;
                                  });
                                  TextInput.finishAutofillContext();
                                  await _registerUserToFirebase(
                                      usernamecontroller.text.trim(),
                                      emailcontroller.text.trim(),
                                      passwordController.text.trim());
                                  showLoading = false;
                                }
                              }
                            } else {
                              showSnackbarWithButton(
                                  context, "Please enter valid email id");
                            }
                          } else {
                            showSnackbarWithButton(
                                context, "Please enter username and email id");
                          }
                        },
                        loading: showLoading)
                    .vertPadding(vert: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWithFontWidget(
                      text: "Already created account?  ",
                      fontsize: w * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        navigateReplaceWithTransitionToScreen(
                            context, const LoginPage());
                      },
                      child: TextWithFontWidget(
                        text: "Login",
                        fontsize: w * 0.042,
                        fontweight: FontWeight.bold,
                      ),
                    )
                  ],
                ).verticalPadding(),
              ],
            ).symmetricPadding().scrollColumnWidget(),
          ),
        ));
  }

  // method for validate email
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp("$pattern");
    if (regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }
}
