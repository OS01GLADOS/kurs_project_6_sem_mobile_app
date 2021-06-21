import 'package:flutter/material.dart';
import 'package:kups_project_mobile_app/db/DBProvider.dart';
import 'article_info.dart';
import 'network/API_actions.dart';
import 'screens/feedback_screen.dart';
import 'screens/article_page.dart';

class ConstantStorage{
  static String SERVER_ADDR =  "18eaf5fe7aa5.ngrok.io";
}

void main() {
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class ListViewElem extends StatelessWidget{
  ArticleInfo _item;
  ListViewElem(this._item);
  String getPreambule(){
    if (_item.preambule.length <=60){
      return _item.preambule;
    }
    else {
      return _item.preambule.substring(0,60)+"...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Container(
        height: 180,
        padding: EdgeInsets.all(20),
        decoration:  BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child:
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(_item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
             Text(getPreambule(), style: TextStyle(fontSize: 15),),
             Text(_item.author, style: TextStyle(color: Colors.grey),)
           ],
      ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  DBProvider _dbProvider = DBProvider();
  Future<List<ArticleInfo>> _articles;

  void loadArticles(){
    _articles = _dbProvider.getAllArticles();
    setState(() {});
  }
  void loadArticlesFromServerToDB() async {
    await fetchArticles().then((value) =>{
      for (ArticleInfo elem in value){_dbProvider.insertArticle(elem)}
    });
    loadArticles();
  }
  @override
  void initState(){
    _dbProvider.initDB().then((value){
      loadArticles();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Главная"),
        actions: [
          IconButton(
            tooltip: "Обновить",
              icon: Icon(Icons.refresh),
              onPressed: loadArticlesFromServerToDB
          )
        ],
      ),
      body:
          FutureBuilder(
            future: _articles,
            builder: (content, snapshot){
              if(snapshot.hasData)
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return
                      GestureDetector(
                        onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>ArticlePage(snapshot.data[index])));},
                        child: ListViewElem(snapshot.data[index]),
                      );
                  },
                );
              return Center(child: Text("Загрузка..."),) ;
            }
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){Navigator.push(context,
            MaterialPageRoute(builder: (context)=>FeedbackPage()));
          },
        tooltip: 'Написать нам',
        child: Icon(Icons.messenger),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
