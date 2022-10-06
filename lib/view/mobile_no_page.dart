import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_prectice_app/view/otp_page.dart';
import 'package:flutter/material.dart';

String? verificationCode;

class MobileNoPage extends StatefulWidget {
  const MobileNoPage({Key? key}) : super(key: key);

  @override
  _MobileNoPageState createState() => _MobileNoPageState();
}

class _MobileNoPageState extends State<MobileNoPage> {
  final mobileNo = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  CountryCode? countryCode;

  Future sendOtp() async {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '$countryCode' + mobileNo.text,
        codeSent: (String verificationid, int? forceResendingToken) {
          setState(() {
            verificationCode = verificationid;
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("ERROR===>>${error.message}")));
        },
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          print("Completed=====>>");
          print("*****************");
        },
        codeAutoRetrievalTimeout: (String verificationid) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(60)),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (value) {
                          setState(() {
                            countryCode = value;
                          });
                        },
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'IT',
                        favorite: ['${countryCode}', 'FR'],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: mobileNo,
                          decoration: InputDecoration(
                              hintText: 'Mobile No.', border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      sendOtp().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpPage(),
                            ),
                          ));
                    }
                  },
                  child: Text('Send Otp'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
