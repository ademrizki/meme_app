import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImagePickerInterface {
  final ImagePicker picker = ImagePicker();
  File image;

  Future fnOpenCamera(BuildContext context) async {
    final PickedFile _cameraPicture = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 90,
      maxHeight: 600,
      maxWidth: 600,
    );

    if (_cameraPicture != null) {
      image = File(_cameraPicture.path);
    }
  }

  Future fnOpenGallery(BuildContext context) async {
    final PickedFile _galleryPicture = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxHeight: 600,
      maxWidth: 600,
    );

    if (_galleryPicture != null) {
      image = File(_galleryPicture.path);
    }
  }

  Future fnOpenVideoCamera(BuildContext context) async {
    final PickedFile _cameraVideo = await picker.getVideo(
      source: ImageSource.camera,
      maxDuration: Duration(minutes: 2),
    );

    if (_cameraVideo != null) {
      image = File(_cameraVideo.path);
    }
  }

  Future fnOpenVideoGallery(BuildContext context) async {
    final PickedFile _cameraVideo = await picker.getVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(minutes: 2),
    );

    if (_cameraVideo != null) {
      image = File(_cameraVideo.path);
    }
  }

  Future fnShowChoiceDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Choose one:"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Video from Camera"),
                onTap: () async {
                  await fnOpenVideoCamera(context);
                  Navigator.pop(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Video from Gallery"),
                onTap: () async {
                  await fnOpenVideoGallery(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
