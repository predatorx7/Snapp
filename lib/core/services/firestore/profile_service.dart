import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final DocumentReference dr = Firestore.instance.collection('profiles').document();

}