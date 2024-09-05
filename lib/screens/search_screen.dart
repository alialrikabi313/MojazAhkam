import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';
import '../models/chapter.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final chapters = Provider.of<ChapterProvider>(context).chapters;
    final results = chapters
        .expand((chapter) => chapter.issues.asMap().entries.map((entry) {
      int idx = entry.key;
      String issue = entry.value;
      int issueNumber = chapter.startingIssueNumber + idx;
      return {'chapterId': chapter.id, 'issueNumber': issueNumber, 'issue': issue};
    }))
        .where((entry) => (entry['issue'] as String).contains(_query))
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(hintText: 'ابحث في المسائل...'),
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
          ),
        ),
        body: ListView.builder(
          itemCount: results.length,
          itemBuilder: (ctx, index) {
            final result = results[index];
            return ListTile(
              title: Container(
                padding: EdgeInsets.all(0),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                              result['issueNumber'].toString(),
                              style: TextStyle(fontSize: 16, color: Colors.teal),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: _highlightOccurrences(result['issue'] as String, _query),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.share, color: Color.fromRGBO(239, 221, 171, 1)),
                                    onPressed: () {
                                      Share.share(result['issue'] as String);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.content_copy, color: Color.fromRGBO(239, 221, 171, 1)),
                                    onPressed: () {
                                      FlutterClipboard.copy(result['issue'] as String).then((value) =>
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<TextSpan> _highlightOccurrences(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final matches = query.allMatches(text).map((match) => match.start).toList();

    if (matches.isEmpty) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    int previousMatchEnd = 0;

    for (int start in matches) {
      if (start > previousMatchEnd) {
        spans.add(TextSpan(text: text.substring(previousMatchEnd, start)));
      }
      final matchEnd = start + query.length;
      spans.add(TextSpan(
        text: text.substring(start, matchEnd),
        style: TextStyle(backgroundColor: Color.fromRGBO(238, 154, 0, 1)),
      ));
      previousMatchEnd = matchEnd;
    }

    if (previousMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(previousMatchEnd)));
    }

    return spans;
  }
}
