import 'dart:convert';

ArticleInfo clientFromJson(String str) {
  final jsonData = json.decode(str);
  return ArticleInfo.fromMap(jsonData);
}

String clientToJson(ArticleInfo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class ArticleInfo{
  static int tempID = 400;
  static String tempPhoto;

  int id;
  String title;
  String preambule;
  String text;
  String author;
  String photo;//base64string
  int likedORdisliked;//1 == liked, 0 == disliked, 3 == none reaction
  String created;

  ArticleInfo({
    this.id,
    this.title,
    this.preambule,
    this.text,
    this.author,
    this.photo,
    this.likedORdisliked,
    this.created
});
  factory ArticleInfo.fromJson(Map<String, dynamic> json)=>new ArticleInfo(
    id: json['id'],
    title: json['Title'],
    preambule: json['Preambule'],
    text: json['Text'],
    author: json['Author_Full'],
    likedORdisliked: 3,
    photo: json['Image_64'],
    created: json['Created_date_time'],
  );
  factory ArticleInfo.fromMap(Map<String, dynamic> json) =>
   ArticleInfo(
    id: json["id"],
    title: json["Title"],
    preambule: json["Preambule"],
    text: json["Text_of_article"],
    author: json["Author_Full_Name"],
    likedORdisliked: json["liked_or_disliked"],
    photo: json["Photo"],
    created: json["Created"],
  );
  Map<String, dynamic> toMap() => {
    "id":id,
    "Title":title,
    "Preambule":preambule,
    "Text_of_article":text,
    "Author_Full_Name":author,
    "liked_or_disliked":likedORdisliked,
    "Created":created,
    "Photo":photo,
  };

}