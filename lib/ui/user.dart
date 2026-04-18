import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ThachinChord'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Firebase က သီချင်းတွေကို Stream နဲ့ ဖတ်မယ်
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('songs').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text("Error!"));
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final songs = snapshot.data!.docs;

              if (constraints.maxWidth > 800) {
                return _buildGridView(songs);
              } else {
                return _buildListView(songs);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSongDialog(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Web အတွက် Grid View (3 columns)
  Widget _buildGridView(List<QueryDocumentSnapshot> songs) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // တစ်တန်းမှာ ၃ ခုပြမယ်
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: songs.length,
      itemBuilder: (context, index) => _songCard(songs[index]),
    );
  }

  // Mobile အတွက် List View
  Widget _buildListView(List<QueryDocumentSnapshot> songs) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: songs.length,
      itemBuilder: (context, index) => _songCard(songs[index]),
    );
  }

  // သီချင်းတစ်ပုဒ်ချင်းစီရဲ့ Design (Card)
  Widget _songCard(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(
          data['title'] ?? 'No Title',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(data['artist'] ?? 'Unknown Artist'),
        trailing: const Icon(Icons.music_note, color: Colors.blue),
        onTap: () {
          // သီချင်းစာသားနဲ့ ကော်ဒ်ကြည့်တဲ့ Screen ကိုသွားဖို့ logic ထည့်ရန်
        },
      ),
    );
  }

  // သီချင်းအသစ်ထည့်ဖို့ Dialog Box
  void _showAddSongDialog(BuildContext context) {
    final titleController = TextEditingController();
    final artistController = TextEditingController();
    final lyricController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Song"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Song Title"),
              ),
              TextField(
                controller: artistController,
                decoration: const InputDecoration(labelText: "Artist Name"),
              ),
              TextField(
                controller: lyricController,
                decoration: const InputDecoration(labelText: "Lyrics & Chords"),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('songs').add({
                  'title': titleController.text,
                  'artist': artistController.text,
                  'lyricWithChords': lyricController.text,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
