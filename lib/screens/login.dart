import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrcotton_usa_new/misc/app_colors.dart';
import 'package:hrcotton_usa_new/widgets/custom_widgets.dart';
import 'package:local_auth/local_auth.dart';

import '../api/api.dart';
import '../api/storageSharedPreferences.dart';
import '../styles/login_screen_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Api instance = Api();
  final LocalAuthentication auth = LocalAuthentication();
  bool canAuthenticateWithBiometrics = false, isDeviceSupported = false, canAuthenticate = false;
  String usernameTxt = "admin@hrcottonusa.com", passwordTxt = "umair@123456"; // TODO: make "" strings
  bool isLoggingIn = false;
  final txtUsernameController = TextEditingController();
  final txtPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0061A6),
      statusBarIconBrightness: Brightness.light,
    ));
    txtUsernameController.value = const TextEditingValue(text: "admin@hrcottonusa.com");
    txtPasswordController.value = const TextEditingValue(text: "umair@123456");
  }

  void gotoHomeScreen(isAuthorized) {
    if (isAuthorized) {
      Navigator.popAndPushNamed(context, "/home");
    } else {
      setState(() {
        isLoggingIn = false;
      });
      CustomWidgets.showSnackBar("Invalid Username or password.", Icons.error, context);
      txtUsernameController.clear();
      txtPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg2.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: 350,
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 3,
                              blurStyle: BlurStyle.normal,
                              spreadRadius: 2,
                              // offset: Offset(1, 1),
                            ),
                          ],
                          color: const Color(0xffffffff),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/logo_icon.png",
                            width: 70,
                            semanticLabel: "HR Cotton USA",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "HR Cotton USA",
                        style: LoginScreenStyles.mainHeadingTextStyles,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextField(
                        obscureText: false,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          filled: true,
                          hintText: "Username",
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF263238),
                            ),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        controller: txtUsernameController,
                        onChanged: (username) {
                          usernameTxt = username.toString();
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.key),
                          filled: true,
                          hintText: "Password",
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF263238),
                            ),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        controller: txtPasswordController,
                        onChanged: (password) {
                          passwordTxt = password.toString();
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (value) {}),
                          const Text("Remember Me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        style:
                        LoginScreenStyles.forgotPasswordButtonStyle,
                        child: const Text(
                          "Forgot Password",
                          style: LoginScreenStyles.forgotPasswordStyles,
                        ),
                        // style: LoginScreenStyles.forgotPasswordStyles,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          color: Colors.blue.shade700,
                          onPressed: () async {
                            isLoggingIn = true;
                            setState(() { });
                            SPStorage.setIsLoggedIn(true);
                            SPStorage.printIsLoggedIn("Home Screen");
                            await instance.getUser(usernameTxt, passwordTxt);
                            gotoHomeScreen(instance.isAuthorized);
                          },
                          height: 45,
                          elevation: 0,
                          child: !isLoggingIn ? const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          )
                              : const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*isDeviceSupported ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: AppColors.facebookColor,
                                width: 3,
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.fingerprint,
                                    color: AppColors.facebookColor,
                                    size: 100,
                                  ),
                                  *//*AnimatedIcon(
                                      icon: AnimatedIcons.,
                                      progress: progress
                                  ),*//*
                                  SizedBox(height: 10),
                                  Text("Place your finger on your phones fingerprint sensor", textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          )
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(
                            width: 1,
                            color: AppColors.facebookColor,
                          )
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        color: AppColors.facebookColor,
                        size: 28,
                      ),
                    ),
                  ],
                ) : const Padding(padding: EdgeInsets.symmetric(vertical: 0)),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
