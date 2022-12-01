import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/news_card.dart';
import './components/header_bar.dart';
import '../api_handler.dart';

class NewsListPage extends StatefulWidget {
  final String Header_Title;
  final List<String> Parameter;
  NewsListPage({this.Header_Title = "Equaler", required this.Parameter});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  ScrollController scrollController = ScrollController();
  late Future<dynamic> newsData;
  int pageNum = 0;

  @override
  void initState() {
    super.initState();
    newsData = apiHandler.getNews(widget.Parameter);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          pageNum++;
          widget.Parameter.last = "Page=$pageNum";
          newsData = apiHandler.getNews(widget.Parameter);
        });
      }
    });
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Headerbar(
          headerTitle: widget.Header_Title,
        ),
        body: Center(
          child: FutureBuilder<dynamic>(
            future: newsData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          NewsCard(
                            imgUrl: snapshot.data[index]['image_url'],
                            newsTitle: snapshot.data[index]['title'],
                            newsDate: snapshot.data[index]['pubDate'],
                            newsContent: snapshot.data[index]['content'],
                          )
                        ],
                      );
                    });
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
