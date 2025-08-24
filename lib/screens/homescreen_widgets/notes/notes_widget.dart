import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/screens/homescreen_widgets/notes/note_items.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late Future<List<Map<String, dynamic>>> _notesFuture;
  String _selectedTab = "Things not on my resume..";
  final Map<String, String> noteOptions = {
    "Things not on my resume..": "notes",
    "Shower Thoughts": "showerThoughts",
  };

  @override
  void initState() {
    super.initState();
    _notesFuture = _fetchNotesFromFirebase(noteOptions[_selectedTab]!);
  }

  Future<List<Map<String, dynamic>>> _fetchNotesFromFirebase(
    String collectionName,
  ) async {
    final notes = await FirebaseFirestore.instance
        .collection(collectionName)
        .get();
    return notes.docs.map((doc) => doc.data()).toList();
  }

  Widget _renderNoteItems(
    String selectedTab,
    AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
  ) {
    if (snapshot.data == null || snapshot.data!.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Text(
          'No notes found',
          style: TextStyle(color: Colors.white70, fontSize: 16.sp),
        ),
      );
    }

    if (selectedTab == "Things not on my resume..") {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final note = snapshot.data![index];
          return NoteItem(
            title: note['question'] ?? 'No title',
            content: note['answer'] ?? 'No content',
          );
        },
      );
    } else if (selectedTab == "Shower Thoughts") {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final note = snapshot.data![index];
          return ThoughtNoteItem(content: note['content'] ?? 'No content');
        },
      );
    }
    return const SizedBox.shrink();
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            decoration: BoxDecoration(color: Colors.orange),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PopupMenuButton<String>(
                    color: Colors.amber,
                    elevation: 5,
                    menuPadding: EdgeInsets.all(5.w),
                    borderRadius: BorderRadius.circular(12),
                    icon: Icon(
                      CupertinoIcons.ellipsis_vertical_circle_fill,
                      size: 28.sp,
                    ),
                    onSelected: (String newTitle) {
                      setState(() {
                        _selectedTab = newTitle;
                        _notesFuture = _fetchNotesFromFirebase(
                          noteOptions[newTitle]!,
                        );
                      });
                    },
                    itemBuilder: (context) => noteOptions.keys
                        .map(
                          (String option) => PopupMenuItem(
                            padding: EdgeInsets.all(5.w),
                            value: option,
                            child: Text(
                              option,
                              style: GoogleFonts.newsreader(
                                color: Colors.white,
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  _selectedTab,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.newsreader(
                    color: Colors.white,
                    fontSize: 20.sp,
                  ),
                ),
                const SizedBox(),
              ],
            ),
          ),
          Expanded(
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
                  return _renderNoteItems(_selectedTab, snapshot);
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
