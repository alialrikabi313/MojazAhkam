import 'package:flutter/material.dart';
import 'package:mojazahkam/screens/fontSetting.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';
import '../models/chapter.dart';
import '../models/favorites.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('المسائل المفضلة'),
        ),
        body:  ListView.builder(
          itemCount: favorites.favoriteIssues.length,
          itemBuilder: (ctx, index) {
            final issue = favorites.favoriteIssues[index];
            final issueNumber = favorites.favoriteIssues[index];
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
                          {index+1}.toString(),
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
                            style: TextStyle(fontSize: globalFontSize,fontFamily: globalFontFamily, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  favorites.isFavorite(issue) ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  favorites.toggleFavorite(issue);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.share, color: Colors.white),
                                onPressed: () {
                                  Share.share(issue);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.content_copy, color: Colors.white),
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
    );
  }
}
