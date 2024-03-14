import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/basicdialog.dart';
import 'package:shelfobsessed/components/datatextbox.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../queries/queryfunc.dart';
import '../sharedpreferencehandler/setprefs.dart';

const List<String> list = <String>['-select-', 'Male', 'Female'];

class EditProfile extends StatefulWidget {
  final int uid;
  final String uname, dob, gen, bio;
  final int pid;

  EditProfile(
      {super.key,
      required this.uid,
      required this.uname,
      required this.dob,
      required this.gen,
      required this.bio,
      required this.pid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var date = DateTime.now().toString().substring(0, 10);
  final String regstr =
      '''mutation (\$d:String!,\$u:Int!,\$g:String!,\$un:String!,\$pi:Int!,\$b:String!){
                    registerUser(dob:\$d,uid:\$u,gen:\$g,uname:\$un,pid:\$pi,bio:\$b) {
                                u
                    }
          }''';

  var username = TextEditingController();

  var bio = TextEditingController();

  var gender;

  @override
  void initState() {
    super.initState();
    setState(() {
      username.text = widget.uname;
      bio.text = widget.bio;
      if (widget.gen == "f")
        gender = "Female";
      else
        gender = "Male";
      date = widget.dob;
    });
  }

  final String query = '''mutation (\$file:Upload!){
                        setProf(file: \$file) {
                                 i
                              }
                          }
                        ''';

  var _imageFile;
  final String checkun = '''query(\$u:String!) {
                            checkUname(uname:\$u) 
                          }''';

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  Widget _previewImage() {
    var d = dim(context);
    if (_imageFile != null) {
      return Center(
        child: Column(
          children: <Widget>[
            Container(
              height: d[1] * 0.21,
              width: d[0] * 0.15,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(File(_imageFile!.path)),
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(50)),
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retriveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Retrieve error ' + response.exception!.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return BasicBG(
        align: Alignment.topRight,
        imgname: "bg3.jpg",
        placed: 80,
        content: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Column(children: [
                      TextLabel(
                        value: "Account Set Up",
                        col: Colors.grey.shade200,
                        style: FontStyle.normal,
                        size: 30,
                      ),
                      Container(
                        height: 10,
                      ),
                      TextLabel(
                          col: Colors.grey.shade200,
                          style: FontStyle.normal,
                          size: 15,
                          value: "Welcome To Book-topia <3"),
                    ]),
                    Container(
                      width: d[0] * 0.05,
                    ),
                    Container(
                      child: Container(
                          alignment: Alignment.center,
                          width: d[0] * 0.1,
                          height: d[1] * 0.22,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Stack(children: [
                            FutureBuilder<void>(
                              future: retriveLostData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<void> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return const Text('Picked an image');
                                  case ConnectionState.done:
                                    return _previewImage();
                                  default:
                                    return const Text('Picked an image');
                                }
                              },
                            ),
                            OutlinedButton(
                              onPressed: _pickImage,
                              child: Text(
                                "\nchange\n profile\n",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: "font1"),
                              ),
                            ),
                          ])),
                    ),
                    Container(
                      height: 100,
                    ),
                  ]),
                  TextLabel(
                    value: "Username",
                    col: Colors.grey.shade200,
                    style: FontStyle.normal,
                    size: 20,
                  ),
                  Container(
                    height: 20,
                  ),
                  BasicTF(
                    h: 50,
                    text: "",
                    ctrl: username,
                    w: 0.9,
                    onchange: (value) {},
                    col: Colors.white,
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          TextLabel(
                            value: "Date Of Birth",
                            col: Colors.grey.shade200,
                            style: FontStyle.normal,
                            size: 20,
                          ),
                          Container(
                            height: 20,
                          ),
                          BasicButton(
                              onpress: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2023),
                                  initialDate: DateTime(2023),
                                );
                                if (pickedDate != null) {
                                  print(pickedDate);
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(formattedDate);

                                  setState(() {
                                    date = formattedDate;
                                  });
                                }
                              },
                              text: date,
                              w: d[1] * 0.4,
                              h: d[0] * 0.06),
                        ],
                      ),
                      Container(
                        width: d[1] * 0.1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextLabel(
                            value: "Gender",
                            col: Colors.grey.shade200,
                            style: FontStyle.normal,
                            size: 20,
                          ),
                          Container(
                            height: 20,
                          ),
                          DropdownButton<String>(
                            dropdownColor: Colors.black,
                            value: gender,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 30,
                              color: Colors.white,
                            ),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "font1",
                                fontSize: 20),
                            underline: Container(
                              height: 0.5,
                              color: Colors.white,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  TextLabel(
                    value: "Bio",
                    col: Colors.grey.shade200,
                    style: FontStyle.normal,
                    size: 20,
                  ),
                  Container(
                    height: 20,
                  ),
                  BasicTF(
                    h: 50,
                    text: "",
                    ctrl: bio,
                    w: 0.9,
                    onchange: (value) {},
                    col: Colors.white,
                  ),
                  Container(
                    height: 20,
                  ),
                  Mutation(
                    options: MutationOptions(
                        document: gql(query),
                        onError: (e) => print(e),
                        onCompleted: (dynamic resultData) async {
                          int i = await resultData["setProf"]["i"];
                          var j = await getmutation({
                            "d": date,
                            "un": username.text,
                            "g": gender.substring(0, 1).toLowerCase(),
                            "u": widget.uid,
                            "pi": i,
                            "b": bio.text
                          }, regstr, "registerUser", "u");
                          if (j == true) {
                            await setprefs(1, widget.uid);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TabsScreen(uid: widget.uid)));
                          }
                        }),
                    builder:
                        (RunMutation runMutation, QueryResult? queryresult) {
                      return BasicButton(
                        onpress: () async{
                          if(username.text!=widget.uname){
                          var res = await getquery(
                              {"u": username.text}, checkun, "checkUname");
                          print(res);
                          if (res == 0)
                            dialogprompt(context, "username exists");
                          }
                          else if(_imageFile==null)
                            {
                              var j = await getmutation({
                                "d": date,
                                "un": username.text,
                                "g": gender.substring(0, 1).toLowerCase(),
                                "u": widget.uid,
                                "pi": widget.pid,
                                "b": bio.text
                              }, regstr, "registerUser", "u");
                              if (j == true) {
                                await setprefs(1, widget.uid);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TabsScreen(uid: widget.uid)));
                              }
                            }
                          else {
                            var byteData =
                            File(_imageFile.path).readAsBytesSync();

                            var multipartFile = http.MultipartFile.fromBytes(
                              'photo',
                              byteData,
                              filename: 'user' + widget.uid.toString() + '.jpg',
                            );
                            runMutation(
                              {
                                "file": multipartFile,
                              },
                            );
                          }
                        },
                        text: "Save",
                        w: d[1] * 0.4,
                        h: d[0] * 0.06,
                      );
                    },
                  )
                ],
              )),
        ));
  }
}
