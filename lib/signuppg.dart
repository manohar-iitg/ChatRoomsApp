import 'package:flutter/material.dart';
import 'package:mechat/auth.dart';
import 'package:mechat/homepg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


class SignUpPg extends StatefulWidget {
  const SignUpPg({Key? key}) : super(key: key);

  @override
  State<SignUpPg> createState() => _SignUpPgState();
}

class _SignUpPgState extends State<SignUpPg> {
  final TextEditingController _usernamecontrollerup = TextEditingController();
  final TextEditingController _passwordcontrollerup = TextEditingController();
  final TextEditingController _emailcontrollerup = TextEditingController();
  bool load=false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Sign Up",
          style: GoogleFonts.ubuntu(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: load? Center(child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 150, 10, 50),
              child: Container(width: w/2,height: h/4,child: CircularProgressIndicator(color: Colors.black,),),
            ),):
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _usernamecontrollerup,
                  style: GoogleFonts.ubuntu(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.white70,
                    ),
                    labelText: "Enter username",
                    labelStyle: TextStyle(
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
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(controller: _emailcontrollerup,
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
                  keyboardType: TextInputType.emailAddress,),
                const SizedBox(
                  height: 20,
                ),
                TextField(controller: _passwordcontrollerup,
                  obscureText: true,
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
                  keyboardType: TextInputType.visiblePassword,),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                    onPressed: (){
                      if(_usernamecontrollerup.text.isNotEmpty&&_passwordcontrollerup.text.isNotEmpty&&_emailcontrollerup.text.isNotEmpty){
                        setState(() {
                          load=true;
                        });
                        createAccount(_usernamecontrollerup.text, _emailcontrollerup.text, _passwordcontrollerup.text).then((user){
                          if(user!=null){
                            setState(() {
                              load=false;
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                            Fluttertoast.showToast(msg: "Account Creation Successful");
                          } else{Fluttertoast.showToast(msg: "Account Creation Failed"); setState(() {
                            load=false;
                          });}
                        });
                      }else{Fluttertoast.showToast(msg: "Enter the fields");}
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
