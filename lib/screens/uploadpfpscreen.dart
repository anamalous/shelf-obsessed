import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../funcnclass/dimensions.dart';

class UploadPFP extends StatefulWidget {
  const UploadPFP({super.key});

  @override
  State<UploadPFP> createState() => UploadState();
}

class UploadState extends State<UploadPFP> {
  final String query = '''mutation (\$file:Upload!){
                        setProf(file: \$file) {
                                 i
                              }
                          }
                        ''';
  var _imageFile;
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
    var d=dim(context);
    if (_imageFile != null) {
      return Center(
        child: Column(
          children: <Widget>[
            Container(
              height: d[1]*0.22,
              width: d[0]*0.15,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit:BoxFit.cover,
                  image: FileImage(
                      File(_imageFile!.path)),
                  ),
                border: Border.all(color: Colors.white,width: 2),
                borderRadius: BorderRadius.circular(50)
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Mutation(
              options: MutationOptions(
                  document: gql(query),
                  onError: (e) => print(e),
                  onCompleted: (
                      dynamic resultData) async {
                    var i = await resultData["setProf"]["i"];
                  }),
              builder: (RunMutation runMutation, QueryResult? queryresult) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("black.jpg"),
                      fit: BoxFit.cover,
                    )
                  ),
                  alignment: Alignment.topRight,
                    child:TextButton(
                  onPressed: () {
                    var byteData = File(_imageFile.path).readAsBytesSync();

                    var multipartFile = http.MultipartFile.fromBytes(
                      'photo',
                      byteData,
                      filename: 'test.jpg',
                    );
                    runMutation(
                      {
                        "file": multipartFile,
                      },
                    );
                  },
                  child: const Icon(Icons.check,color: Colors.black,size: 20,),
                )
                );
              },
            )
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
    var d=dim(context);
    return Container(
      width: d[0]*0.1,
        height: d[1]*0.5,
        child: Stack(children: [
      FutureBuilder<void>(
        future: retriveLostData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
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
            child: Container(height: 100,width: 100,),
          ),
    ]));
  }
}
