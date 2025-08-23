import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:portfolio/config/app_design.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late Future<List<Map<String, dynamic>>> _notesFuture;
  @override
  void initState() {
    super.initState();
    _notesFuture = _fetchNotesFromFirebase();
  }

  Future<List<Map<String, dynamic>>> _fetchNotesFromFirebase() async {
    final notes = await FirebaseFirestore.instance.collection('notes').get();
    return notes.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        colors: [Colors.black87, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      child: Column(
        children: [
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(color: Colors.orange),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(CupertinoIcons.add_circled_solid),
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(
                          CupertinoIcons.chevron_left,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Things not on my resume..",
                        style: AppDesign.body.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        child: Icon(
                          CupertinoIcons.chevron_right,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: FutureBuilder(
              future: _notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: NoteItem(
                      title: 'Error',
                      content: snapshot.error.toString(),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      ...snapshot.data!.map(
                        (note) => NoteItem(
                          title: note['question'],
                          content: note['answer'],
                        ),
                      ),
                    ],
                  );
                } else {
                  return NoteItem(title: "Oops", content: "No data found");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  final String title;
  final String content;
  const NoteItem({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [const Color.fromARGB(8, 255, 255, 255), Colors.white24],
          center: Alignment.topLeft,
          radius: AppDesign.largeRadius,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: AppDesign.body.copyWith(color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              content,
              style: AppDesign.body.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
