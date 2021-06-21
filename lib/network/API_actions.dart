import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kups_project_mobile_app/article_info.dart';
import 'package:kups_project_mobile_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Метод для выставления оценки статьи
Future<int> changeReaction(int articleId, String newReaction, String oldReaction) async{
  log("Set reaction: start request");
  var uri = Uri.http(ConstantStorage.SERVER_ADDR, "/article/"+articleId.toString()+'/reaction-'+newReaction+",prev-"+oldReaction);
  final response = await http.get(uri);
  if (response.statusCode == 200){
    log('Set Reaction: completed successfully');
    return 0;
  }
  else{return 1;}
}

//метод для получения значения из Shared Preferences
getValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringValue = prefs.getString(key);
  return stringValue;
}
//метод для записи значения из Shared Preferences
saveValue(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

//метод для запроса статей из веб-сервера
Future<List<ArticleInfo>> fetchArticles() async{
  String dateSharedPref = await getValue('requestDate') ?? "-";
  log("REST: start request");
  var uri = Uri.http(ConstantStorage.SERVER_ADDR,"/api/all-articles");
  final response = await http.get(uri,
      headers: {HttpHeaders.dateHeader:dateSharedPref});
  if(response.statusCode == 200){
    log("REST: request successfull");
    String dateFromResponse = response.headers[HttpHeaders.dateHeader];
    log(dateFromResponse);
    saveValue('requestDate', dateFromResponse);
    List responseJson = json.decode(utf8.decode(response.bodyBytes));
    return responseJson.map((e) => new ArticleInfo.fromJson(e)).toList();
  }
  else{
    log("REST: request unsuccessfull");
    throw Exception('Failed to load Articles');
  }
}

//метод для отправки отзыва на сервер
Future<void> sendFeedback(String message, String email, String header) async{
  log('SOAP: send message');
  var uri = Uri.http(ConstantStorage.SERVER_ADDR, '/api/add-feedback-soap');
  String body =
      '<?xml version="1.0"?>'
      '<soap11env:Envelope xmlns:soap11env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tran="spyne.django">'
      '<soap11env:header/><soap11env:Body>'
      '<tran:create_feedback_fom_soap>'
      '<tran:email>'+email+'</tran:email>'
      '<tran:title>'+header+'</tran:title>'
      '<tran:message>'+message+'</tran:message>'
      '</tran:create_feedback_fom_soap>'
      '</soap11env:Body>'
      '</soap11env:Envelope>';
  final response = await http.post(uri, body:body);
  if(response.statusCode==200){
    log("SOAP: request successfull");
  }
}