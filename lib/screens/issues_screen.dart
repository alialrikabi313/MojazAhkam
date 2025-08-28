import 'package:flutter/material.dart';
import 'package:mojazahkam/screens/fontSetting.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share_plus/share_plus.dart';

import '../models/chapter.dart';
import '../models/favorites.dart';

class IssuesScreen extends StatelessWidget {
  final String chapterId;
  final String tab;

  const IssuesScreen({
    super.key,
    required this.chapterId,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    // ❶ احضار البيانات من الـ Providers
    final chapterProvider = Provider.of<ChapterProvider>(context);
    List<Chapter> chapters;
    if (tab == 'taqleed') {
      chapters = chapterProvider.taqleedChapters;
    } else if (tab == 'ibadat') {
      chapters = chapterProvider.ibadatChapters;
    } else if (tab == 'muamalat') {
      chapters = chapterProvider.muamalatChapters;
    }
    else if (tab == 'manasik') {         // ⬅️ إضافة هذا الفرع
      chapters = chapterProvider.manasikChapters;
    }else {
      chapters = [];
    }

    final chapter = chapterProvider.findById(chapterId);
    final favorites = Provider.of<FavoritesProvider>(context);

    // ❷ تحريك الشاشة إلى الفصل التالي / السابق
    void _navigateToNextChapter() {
      final currentIndex = chapters.indexWhere((c) => c.id == chapterId);
      if (currentIndex < chapters.length - 1) {
        final nextChapterId = chapters[currentIndex + 1].id;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => IssuesScreen(chapterId: nextChapterId, tab: tab),
          ),
        );
      }
    }

    void _navigateToPreviousChapter() {
      final currentIndex = chapters.indexWhere((c) => c.id == chapterId);
      if (currentIndex > 0) {
        final previousChapterId = chapters[currentIndex - 1].id;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) =>
                IssuesScreen(chapterId: previousChapterId, tab: tab),
          ),
        );
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 242, 223, 1),
          title: Text(chapter.title),
        ),

        // ❸ استُخدم bottomNavigationBar لتثبيت أزرار «السابق» و«التالي» في الأسفل
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateToPreviousChapter,
                    child: const Text('السابق'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateToNextChapter,
                    child: const Text('التالي'),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: chapter.issues.length,
          itemBuilder: (ctx, index) {
            final issue = chapter.issues[index];
            final issueNumber = chapter.startingIssueNumber + index;

            // ❹ نص يُستخدم للنسخ والمشاركة: اسم الكتاب + رقم المسألة + النص
            final String bookTitle = (tab == 'manasik') ? 'موجز المناسك' : 'موجز الأحكام';

// نص النسخ/المشاركة
            final String formattedIssueText =
                '$bookTitle – مسألة رقم $issueNumber:\n$issue';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              color: const Color.fromRGBO(121, 95, 70, 1),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$issueNumber',
                          style:
                          const TextStyle(fontSize: 16, color: Colors.teal),
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
                            style: TextStyle(
                              fontSize: globalFontSize,
                              fontFamily: globalFontFamily,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  favorites.isFavorite(issue)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                  const Color.fromRGBO(239, 221, 171, 1),
                                ),
                                onPressed: () {
                                  favorites.toggleFavorite(issue);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share,
                                    color: Color.fromRGBO(239, 221, 171, 1)),
                                onPressed: () {
                                  Share.share(formattedIssueText);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.content_copy,
                                    color: Color.fromRGBO(239, 221, 171, 1)),
                                onPressed: () {
                                  FlutterClipboard.copy(formattedIssueText)
                                      .then(
                                        (_) => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text('تم نسخ المسألة')),
                                    ),
                                  );
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
    );
  }
}
