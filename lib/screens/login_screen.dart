
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/local_database/local_store.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController phoneController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isOtpSending = false;
  String? isSignedIn = prefs.getString(LocalStore.isSignedIn);

  void initState() {
    super.initState();
    phoneController = TextEditingController();
    if (isSignedIn == "true") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new HomeScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(isSignedIn);
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .35),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: RichText(
                      text: const TextSpan(
                        // style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'TODO',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' APP',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Task Harmony  ",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .18),
                  Text("Your Productivity Companion"),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * .85,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        color: Colors.blue[50],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid phone number';
                            }
                            return null; // Return null if the validation is successful
                          },
                          decoration: const InputDecoration(
                            hintText: 'Please enter mobile number',
                            contentPadding: EdgeInsets.symmetric(vertical: 2),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isOtpSending = true;
                        });
                        try {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+91${phoneController.text}',
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {
                              setState(() {
                                isOtpSending = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "OTP Sending Failed due to ${e.toString()}"),
                              ));
                            },
                            codeSent:
                                (String verificationId, int? resendToken) {
                              LoginScreen.verify = verificationId;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OTPScreen(
                                          phone: phoneController.text)));
                              setState(() {
                                isOtpSending = false;
                              });
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        } catch (e) {
                          setState(() {
                            isOtpSending = false;
                          });
                        }
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Invalid Phone"),
                        ));
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * .85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xffFC353C).withOpacity(0.9)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.smartphone,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          Text(
                            "Continue via Phone",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withOpacity(0.9),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "by continue you will accept our T&C and Privacy policy",
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
        isOtpSending
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