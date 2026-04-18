import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // သီချင်းများအားလုံးကို Stream ဖြင့် ဖတ်ယူရန်
  Stream<List<Map<String, dynamic>>> getSongs() {
    return _db
        .collection('songs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );
  }

  // သီချင်းအသစ်ထည့်ရန် (Admin Only)
  Future<void> addSong(String title, String artist, String lyric) async {
    await _db.collection('songs').add({
      'title': title,
      'artist': artist,
      'lyricWithChords': lyric,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
