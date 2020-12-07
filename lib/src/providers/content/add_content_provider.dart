import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/src/interfaces/image_interface.dart';
import 'package:meme_app/src/screens/dashboard/home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as Path;

class AddContentProvider extends ChangeNotifier with ImagePickerInterface {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  VideoPlayerController videoPlayerController;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future fnOnFetchVideo(BuildContext context) async {
    await super.fnShowChoiceDialog(context);
    if (super.image != null) {
      videoPlayerController = VideoPlayerController.file(super.image);
      await videoPlayerController.initialize();
      videoPlayerController.setLooping(true);
      await videoPlayerController.play();
      notifyListeners();
    }
  }

  Widget fnCheckVideoIsExist(BuildContext context) {
    return super.image == null
        ? SizedBox()
        : Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: VideoPlayer(videoPlayerController),
              ),
              Positioned(
                bottom: 5,
                right: 10,
                child: RaisedButton(
                  onPressed: () => fnOnFetchVideo(context),
                  color: Colors.blue,
                  child: Text(
                    'New Video',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          );
  }

  Future fnOnSaved(BuildContext context) async {
    final _pr = ProgressDialog(context);

    try {
      final SharedPreferences _preferences = await SharedPreferences.getInstance();
      final _userID = _preferences.getString('uid');
      if (formKey.currentState.validate()) {
        await _pr.show();
        formKey.currentState.save();
        final CollectionReference firebase = FirebaseFirestore.instance.collection('contents');

        if (image != null) {
          await videoPlayerController.pause();
          final Reference storageRef = _firebaseStorage.ref().child('videos/${Path.basename(image.path)}');

          final UploadTask uploadTask = storageRef.putFile(image);
          await uploadTask.whenComplete(() async {
            final downloadUrl = await storageRef.getDownloadURL();

            await firebase.doc(Path.basename(image.path)).set({
              'user_id': _userID,
              'name': Path.basename(image.path),
              'title': titleController.text,
              'description': descriptionController.text,
              'content_url': downloadUrl,
              'created_at': DateTime.now(),
              'last_update': DateTime.now(),
            });

            await _pr.hide();
            return Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
          });
        }

        await firebase.add({
          'user_id': _userID,
          'name': null,
          'title': titleController.text,
          'description': descriptionController.text,
          'content_url': null,
          'created_at': DateTime.now(),
          'last_update': DateTime.now(),
        });

        await _pr.hide();
        return Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
      }
    } catch (e) {
      await _pr.hide();
      print('Upload Error ==> ' + e.toString());
    }
  }
}
