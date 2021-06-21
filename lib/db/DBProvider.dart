import 'package:sqflite/sqflite.dart';
import '../article_info.dart';
import 'dart:developer';

//класс для работы с базой данных
class DBProvider{
  static Database _database;
  static DBProvider _dbProvider;
  DBProvider._createInstance();
  factory DBProvider(){
    if (_dbProvider == null){
      _dbProvider = DBProvider._createInstance();
    }
    return _dbProvider;
  }
  Future<Database> get database async {
    if (_database == null)
      _database = await initDB();
    return _database;
  }
  Future<Database> initDB() async {
    var databaseDir = await getDatabasesPath();
    var path = databaseDir+"mobile_app.db";
    var database = await openDatabase(path, version: 1, onCreate: (db,version){
      db.execute('PRAGMA encoding = "UTF-8"');
      db.execute("""CREATE TABLE ArticleOffline (
          id INTEGER PRIMARY KEY,
          Title TEXT,
          Preambule TEXT,
          Text_of_article TEXT,
          Author_Full_Name TEXT,
          Photo blob,
          liked_or_disliked INTEGER,
          Created TEXT
          )""");
    });
    return database;
  }
  //метод для добавления статьи в базу данных
  void insertArticle(ArticleInfo articleInfo) async{
    var db = await this.database;
    try{
      await db.insert("ArticleOffline", articleInfo.toMap());
      log("DATABASE: iniserted data: "+articleInfo.id.toString()+" "+articleInfo.title);
    }
    //При возникновении ошибки (статья с таким id уже существует) - обнвление информации в этой статье
    catch(e){
      log("DATABASE: article already exists, id:"+articleInfo.id.toString());
      await db.execute("""update ArticleOffline set
          Title = '"""+articleInfo.title+"""',
          Preambule = '"""+articleInfo.preambule+"""',
          Text_of_article = '"""+articleInfo.text+"""',
          Author_Full_Name = '"""+articleInfo.author+"""',
          Photo = '"""+articleInfo.photo+"""',
          liked_or_disliked = """+articleInfo.likedORdisliked.toString()+""",
          Created = '"""+articleInfo.created+"""'
          WHERE id = """+articleInfo.id.toString());
    }
  }
  //Метод для получения всех статей из базы данных
  Future <List<ArticleInfo>> getAllArticles() async {
    List<ArticleInfo> _articles = [];
    var db = await this.database;
    var res = await db.query("ArticleOffline");
    res.forEach((element) {
      var article = ArticleInfo.fromMap(element);
      _articles.add(article);
    });
    return _articles;
  }

}
