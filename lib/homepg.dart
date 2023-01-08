import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechat/auth.dart';
import 'package:mechat/chatroom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String, dynamic>? userMap, userMap2;
  final TextEditingController _searchcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool load = false;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }


  void Searching() async{
    setState(() {
      load=true;
    });

    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('users').where("email", isEqualTo: _searchcontroller.text).get().then((value){
      if (value.size==0){load=false;
      Fluttertoast.showToast(msg: "No user found");}
      else{
      setState(() {
        userMap = value.docs[0].data();
        load=false;
      });
      if (userMap!=null){
        if(_name.contains(userMap!['name'])){
          Fluttertoast.showToast(msg: "User already in chat list");
        }else {
          Fluttertoast.showToast(msg: "User added");
          _name.add(userMap!["name"]);
          _email.add(userMap!["email"]);
          _umap.add(userMap!);
        }
      }else{print("No user exists"); load=false;}}
    });
  }

  List _name = [];
  List _email = [];
  List _umap = [];

  void Initial() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('chatroom').where("users", arrayContains: _auth.currentUser!.displayName!).get().then((value){
      setState(() {
        int len = value.docs.length;
        for (var i=0; i<len; i++){
          userMap = value.docs[i].data();
          if(userMap!=null){
            if(userMap!['per1']==_auth.currentUser!.displayName!){
              if(_name.contains(userMap!["per2"])){
              }else{
                _name.add(userMap!["per2"]);
                _email.add(userMap!["email2"]);
                _umap.add(userMap!);}
            }
            else if(userMap!["per2"]==_auth.currentUser!.displayName!){
              if(_name.contains(userMap!["per1"])){
              }else{
                _name.add(userMap!["per1"]);
                _email.add(userMap!["email1"]);
                _umap.add(userMap!);}
            }
          }
        }
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    Initial();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("ChatsConvo", style: GoogleFonts.alfaSlabOne(),),
        actions: [IconButton(onPressed: (){logOut(context);}, icon: Icon(Icons.logout_outlined))],),
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
          child: load? Center(child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 150, 10, 50),
            child: Container(width: w/2,height: h/4,child: CircularProgressIndicator(color: Colors.black,),),
          ),): Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                SizedBox(width: w,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: w/1.4,
                        child: TextField(
                          controller: _searchcontroller,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.9),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            labelText: "Search for user",
                            labelStyle: GoogleFonts.asap(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.9),
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
                      ),
                      SizedBox(height: 50,width: w/20,),
                      Container(
                        width: w/6,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(200),color: Colors.white.withOpacity(0.33)),
                        child: IconButton(onPressed: (){
                          Searching();
                        }, icon: Icon(Icons.search_outlined)),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15,),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _name.length,
                    itemBuilder: (context,index){
                      return Card(
                        color: Colors.transparent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(_name[index], style: GoogleFonts.alata(fontSize: 25, color: Colors.black),),
                            subtitle: Text(_email[index], style: TextStyle(fontStyle: FontStyle.italic),),
                            trailing: IconButton(onPressed: (){
                              if(_umap[index]!['name']!=null){
                                String roomId = chatRoomId(
                                    _auth.currentUser!.displayName!,
                                    _umap[index]!['name']);
                                _name.removeAt(index);
                                _email.removeAt(index);
                                _umap.removeAt(index);
                                var ref = _firestore.collection('chatroom').doc(roomId);

                              }else{
                                if(_umap[index]["per1"]==_auth.currentUser!.displayName!){
                                  String roomId = chatRoomId(
                                      _auth.currentUser!.displayName!,
                                      _umap[index]!['per2']);
                                  _name.removeAt(index);
                                  _email.removeAt(index);
                                  _umap.removeAt(index);
                                  _firestore.collection('chatroom').doc(roomId).delete();
                                }
                                else if (_umap[index]["per2"]==_auth.currentUser!.displayName!){
                                  String roomId = chatRoomId(
                                      _auth.currentUser!.displayName!,
                                      _umap[index]!['per1']);
                                  _name.removeAt(index);
                                  _email.removeAt(index);
                                  _umap.removeAt(index);
                                  _firestore.collection('chatroom').doc(roomId).delete();
                                }
                              }
                            }, icon: Icon(Icons.archive_outlined, color: Colors.black,size: 30,)),
                            leading: Icon(Icons.chat, color: Colors.black,size: 30,),
                            onTap: () async {
                              if(_umap[index]!['name']!=null){
                                String roomId = chatRoomId(
                                    _auth.currentUser!.displayName!,
                                    _umap[index]!['name']);
                                await _firestore.collection('chatroom').doc(roomId).set(
                                    {
                                      'users': [_auth.currentUser!.displayName!,_umap[index]!['name']],
                                      'email1': _auth.currentUser!.email!,
                                      'email2':  _umap[index]!['email'],
                                      'per1': _auth.currentUser!.displayName!,
                                      'per2':  _umap[index]!['name'],
                                    });

                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chats(
                                  userMap: _umap[index]!,
                                  chatRoomId: roomId,
                                )));
                              }
                              else{
                                if(_umap[index]["per1"]==_auth.currentUser!.displayName!){
                                  String roomId = chatRoomId(
                                      _auth.currentUser!.displayName!,
                                      _umap[index]!['per2']);
                                  await _firestore.collection('chatroom').doc(roomId).set(
                                      {
                                        'users': [_auth.currentUser!.displayName!,_umap[index]!['per2']],
                                        'email1': _auth.currentUser!.email!,
                                        'email2':  _umap[index]!['email2'],
                                        'per1': _auth.currentUser!.displayName!,
                                        'per2':  _umap[index]!['per2'],
                                      });

                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chats(
                                    userMap: _umap[index]!,
                                    chatRoomId: roomId,
                                  )));
                                }
                                else if (_umap[index]["per2"]==_auth.currentUser!.displayName!){
                                  String roomId = chatRoomId(
                                      _auth.currentUser!.displayName!,
                                      _umap[index]!['per1']);
                                  await _firestore.collection('chatroom').doc(roomId).set(
                                      {
                                        'users': [_auth.currentUser!.displayName!,_umap[index]!['per1']],
                                        'email1': _auth.currentUser!.email!,
                                        'email2':  _umap[index]!['email1'],
                                        'per1': _auth.currentUser!.displayName!,
                                        'per2':  _umap[index]!['per1'],
                                      });

                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chats(
                                    userMap: _umap[index]!,
                                    chatRoomId: roomId,
                                  )));
                                }
                              }
                            },
                          ),
                        )
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
