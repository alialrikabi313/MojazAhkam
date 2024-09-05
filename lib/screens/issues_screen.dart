import 'package:flutter/material.dart';
import 'package:mojazahkam/screens/fontSetting.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';
import '../models/chapter.dart';
import '../models/favorites.dart';

class IssuesScreen extends StatelessWidget {
  final String chapterId;
  final String tab;

  IssuesScreen({required this.chapterId, required this.tab});

  @override
  Widget build(BuildContext context) {
    final chapterProvider = Provider.of<ChapterProvider>(context);
    List<Chapter> chapters;
    if (tab == 'taqleed') {
      chapters = chapterProvider.taqleedChapters;
    } else if (tab == 'ibadat') {
      chapters = chapterProvider.ibadatChapters;
    } else if (tab == 'muamalat') {
      chapters = chapterProvider.muamalatChapters;
    } else {
      chapters = [];
    }

    final chapter = chapterProvider.findById(chapterId);
    final favorites = Provider.of<FavoritesProvider>(context);

    void _navigateToNextChapter() {
      final currentIndex = chapters.indexWhere((c) => c.id == chapterId);
      if (currentIndex < chapters.length - 1) {
        final nextChapterId = chapters[currentIndex + 1].id;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => IssuesScreen(chapterId: nextChapterId, tab: tab)),
        );
      }
    }

    void _navigateToPreviousChapter() {
      final currentIndex = chapters.indexWhere((c) => c.id == chapterId);
      if (currentIndex > 0) {
        final previousChapterId = chapters[currentIndex - 1].id;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => IssuesScreen(chapterId: previousChapterId, tab: tab)),
        );
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(chapter.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chapter.issues.length,
                itemBuilder: (ctx, index) {
                  final issue = chapter.issues[index];
                  final issueNumber = chapter.startingIssueNumber + index;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    color: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$issueNumber',
                                style: TextStyle(fontSize: 16, color: Colors.teal),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  issue,
                                  style: TextStyle(fontSize: globalFontSize, fontFamily: globalFontFamily, color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        favorites.isFavorite(issue) ? Icons.favorite : Icons.favorite_border,
                                        color: Color.fromRGBO(239, 221, 171, 1),
                                      ),
                                      onPressed: () {
                                        favorites.toggleFavorite(issue);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.share, color: Color.fromRGBO(239, 221, 171, 1)),
                                      onPressed: () {
                                        Share.share(issue);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.content_copy, color: Color.fromRGBO(239, 221, 171, 1)),
                                      onPressed: () {
                                        FlutterClipboard.copy(issue).then((value) =>
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('تم نسخ المسألة')),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _navigateToPreviousChapter,
                  child: Text('السابق'),
                ),
                ElevatedButton(
                  onPressed: _navigateToNextChapter,
                  child: Text('التالي'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
