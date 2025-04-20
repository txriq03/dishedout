import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final storage = FirebaseStorage.instance;
  final postImagesRef = FirebaseStorage.instance.ref('images/posts');
  final profileImagesRef = FirebaseStorage.instance.ref('images/profiles');
}
