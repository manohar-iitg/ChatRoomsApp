import 'package:flutter/material.dart';
import 'package:mechat/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mechat/homepg.dart';
import 'package:mechat/resetpg.dart';
import 'package:mechat/signuppg.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool load=false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          width: w,
          height: h,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.orangeAccent, Colors.redAccent],
              )),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: load? Center(child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 150, 10, 50),
              child: Container(width: w/2,height: h/4,child: CircularProgressIndicator(color: Colors.black,),),
            ),) :Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding: EdgeInsets.fromLTRB(0, 20, 0, 10), child: Image.asset("img/chatapp.png", width: w*0.7, height: h * 0.33, fit: BoxFit.cover,),),
                const SizedBox(height: 20,),
                Text("ChatConvo", style: GoogleFonts.alfaSlabOne(fontSize: 60),),
                Text("Welcome\nSign-in and Chat", style: GoogleFonts.arvo(fontSize: 20, color: Colors.white54),),
                const SizedBox(height: 30,),
                TextField(
                  controller: _usernamecontroller,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.white70,
                    ),
                    labelText: "Enter e-mail address",
                    labelStyle: GoogleFonts.ubuntu(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10,),
                TextField(
                  obscureText: true,
                  controller: _passwordcontroller,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.white70,
                    ),
                    labelText: "Enter password",
                    labelStyle: GoogleFonts.ubuntu(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                    onPressed: () {
                      if(_usernamecontroller.text.isNotEmpty&&_passwordcontroller.text.isNotEmpty){
                        setState(() {
                          load=true;
                        });
                        logIn(_usernamecontroller.text, _passwordcontroller.text).then((user){
                          if(user!=null){
                            setState(() {
                              load=false;
                            });
                            Fluttertoast.showToast(msg: "Login Succesful",gravity: ToastGravity.TOP);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                          } else{setState(() {
                            load=false;
                          });
                          Fluttertoast.showToast(msg: "Login Failed",gravity: ToastGravity.TOP);
                          }
                        });
                      }else{Fluttertoast.showToast(msg: "Enter Details correctly",gravity: ToastGravity.TOP);}
                    },
                    child: Text(
                      "SIGN IN",
                      style: GoogleFonts.ubuntu(
                          color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return Colors.white;
                        }),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
                  )
                ),
                forgetPassword(context),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account? ",
                      style: GoogleFonts.ubuntu(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SignUpPg()));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height:35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: Text(
          "Forgot Password?",
          style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ResetPg()));
        },
      ),
    );
  }
}

