import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/theme/custom_theme.dart';

class TakePictureWidget extends StatefulWidget {
  const TakePictureWidget({Key? key, required this.onTakedPicture})
      : super(key: key);
  final ValueChanged<String> onTakedPicture;
  @override
  State<TakePictureWidget> createState() => _TakePictureWidgetState();
}

class _TakePictureWidgetState extends State<TakePictureWidget> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile = null;
  String _valueBase64 = "";
  @override
  Widget build(BuildContext context) {
    return Container(
        child: imageFile == null
            ? GestureDetector(
                onTap: () {
                  _getFromCamera();
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: Icon(
                        CupertinoIcons.photo_camera,
                        color: ThemeHelper.primaryColor,
                      )),
                    )),
              )
            : Container(
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              ));
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 100,
      maxHeight: 100,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Future<Uint8List> valueInBytes = pickedFile.readAsBytes();
      valueInBytes.then((value) {
        widget.onTakedPicture(value.toString()); //value[0].toString());
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }
  }
}
