
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:todo_app/local_database/local_store.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/login_screen.dart';


class OTPScreen extends StatefulWidget {
  final String phone;

  const OTPScreen({super.key, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // List<TextEditingController> otpControllers =
  //     List.generate(6, (index) => TextEditingController());
  TextEditingController otpController = TextEditingController();
  bool isLoggingIn = false;
  // late NetworkHandler networkHandler;
  bool isOtpIncorrect = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // void initState() {
  //   super.initState();
  //   networkHandler = NetworkHandler();
  // }

  @override
  Widget build(BuildContext context) {
    // print(prefs.getString(LocalStore.isSignedIn));
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login_screen_route");
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                    ),
                    Spacer(),
                    Text(
                      "Edit Phone number",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.edit, color: Colors.grey)
                  ],
                ),
              ),
              SizedBox(
                height: 88,
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'OTP sent to ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                "Enter OTP to confirm your phone",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "You’ll receive a six digit verification code. ",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 24,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                controller: otpController,
                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              // Row(
              //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: List.generate(
              //     4,
              //     (index) => Container(
              //       margin: EdgeInsets.only(right: 24.0),
              //       width: 48,
              //       height: 48,
              //       alignment: Alignment.center,
              //       decoration: BoxDecoration(
              //           color: isOtpIncorrect
              //               ? Colors.white
              //               : isDigitEntered[index]
              //                   ? Colors.blue
              //                   : Colors.white,
              //           borderRadius: BorderRadius.circular(8),
              //           border: Border.all(
              //               color: isOtpIncorrect ? Colors.red : Colors.blue)),
              //       child: TextField(
              //         controller: otpControllers[index],
              //         keyboardType: TextInputType.number,
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //             color: isOtpIncorrect ? Colors.red : Colors.white,
              //             fontSize: 18),
              //         maxLength: 1,
              //         onChanged: (value) {
              //           setState(() {
              //             isDigitEntered[index] = value.isNotEmpty;
              //           });
              //           if (value.length == 1) {
              //             if (index < 3) {
              //               FocusScope.of(context).nextFocus();
              //             } else {
              //               FocusScope.of(context).requestFocus(
              //                 FocusNode(),
              //               );
              //               FocusScope.of(context).previousFocus();
              //             }
              //           } else if (value.isEmpty && index > 0) {
              //             FocusScope.of(context).previousFocus();
              //           }
              //         },
              //         onSubmitted: (value) {
              //           // When Enter is pressed, move focus to the next box
              //           if (index < 3) {
              //             FocusScope.of(context).nextFocus();
              //           }
              //         },
              //         decoration: const InputDecoration(
              //             counterText: '', // Hide the character counter

              //             border: InputBorder.none,
              //             contentPadding: EdgeInsets.only(bottom: 6)),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 12,
              ),
              isOtpIncorrect
                  ? const Text(
                      "Please enter correct OTP",
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
              // : RichText(
              //     text: TextSpan(
              //       children: <TextSpan>[
              //         TextSpan(
              //           text: "Didn't receive OTP? ",
              //           style: TextStyle(color: Colors.grey, fontSize: 14),
              //         ),
              //         TextSpan(
              //             text: 'Resend',
              //             style: TextStyle(color: Colors.blue, fontSize: 14),
              //             recognizer: TapGestureRecognizer()
              //               ..onTap = () async {
              //                 // await networkHandler.sendOTP(
              //                 //     "/api/d2/auth/v2/login",
              //                 //     widget.phone,
              //                 //     widget.countryCode);
              //               }),
              //       ],
              //     ),
              //   ),
              Expanded(
                child: SizedBox.expand(),
              ),
              GestureDetector(
                  onTap: () async {
                    try {
                      setState(() {
                        isLoggingIn=true;
                      });
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: LoginScreen.verify,
                              smsCode: otpController.text);
                      await auth.signInWithCredential(credential);
                      await prefs.setString(LocalStore.isSignedIn,"true");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()),
                          (route) => false);
                    } catch (e) {
                      setState(() {
                        isLoggingIn=false;
                        isOtpIncorrect = true;
                      });
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //   content: Text("Wrong OTP"),
                      // ));
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .85,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffFC353C).withOpacity(0.9)),
                    child: Text(
                      "Verify Phone",
                      style: TextStyle(
                          color: Colors.white.withOpacity(.9),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )),
            ],
          ),
        ),
        isLoggingIn
            ? Center(
                child: Container(
                    color: Colors.blue.withOpacity(0.1),
                    child: Center(child: CircularProgressIndicator())),
              )
            : Container()
      ]),
    );
  }
}