import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chapter.dart';
import 'issues_screen.dart';

class TaqleedScreen extends StatelessWidget {
  TaqleedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chapters = Provider.of<ChapterProvider>(context).taqleedChapters;
    return ListView.builder(
      itemCount: chapters.length,
      itemBuilder: (ctx, index) {
        final chapter = chapters[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListTile(
            title: Text(
              chapter.title,
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => IssuesScreen(chapterId: chapter.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
