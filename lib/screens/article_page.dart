import 'package:flutter/material.dart';
import 'package:kups_project_mobile_app/network/API_actions.dart';
import '../article_info.dart';
import 'dart:convert';

//Интерфейс экрана показа статьи
class ArticlePage extends StatefulWidget {
  ArticleInfo _item;
  ArticlePage(ArticleInfo item) {
    _item = item;
  }
  @override
  State<StatefulWidget> createState() => new ArticlePageState(_item);
}

class ArticlePageState extends State<ArticlePage> {
  Color LikeBgr;
  Color LikeFgr;
  Color DislikeBgr;
  Color DislikeFgr;
  String old_reaction;  /*
  * // Default value likeBackgroud will be set
  * void setReaction(Reaction reaction)
  * {
  *   setState(){
  *       likeBackground = reaction.like ? Color.white : Color.blue
  * }
  * }
  *
  *
  * */
  void setLiked() {
    setState(() {
      LikeBgr = Colors.white;
      LikeFgr = Colors.blue;
      DislikeBgr = Colors.blue;
      DislikeFgr = Colors.white;
    });
  }

  void setDisliked() {
    setState(() {
      DislikeBgr = Colors.white;
      DislikeFgr = Colors.blue;
      LikeBgr = Colors.blue;
      LikeFgr = Colors.white;
    });
  }

  void setNoReaction() {
    setState(() {
      DislikeBgr = Colors.blue;
      DislikeFgr = Colors.white;
      LikeBgr = Colors.blue;
      LikeFgr = Colors.white;
    });
  }

  void dislikeClick() async {
    try {
      if (_item.likedORdisliked != 0) {
        await changeReaction(_item.id, 'dislike', old_reaction);
        setDisliked();
        _item.likedORdisliked = 0;
        old_reaction = "dislike";
      } else {
        await changeReaction(_item.id, 'none', old_reaction);
        setNoReaction();
        _item.likedORdisliked = 3;
        old_reaction = "none";
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Произошла ошибка')));
    }
  }

  void likeClick() async {
    try {
      if (_item.likedORdisliked != 1) {
        int res = await changeReaction(_item.id, 'like', old_reaction);
        setLiked();
        _item.likedORdisliked = 1;
        old_reaction = "like";
      } else {
        await changeReaction(_item.id, 'none', old_reaction);
        setNoReaction();
        _item.likedORdisliked = 3;
        old_reaction = "none";
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Произошла ошибка')));
    }
  }

  ArticleInfo _item;

  ArticlePageState(ArticleInfo item) {
    _item = item;
    switch (_item.likedORdisliked) {
      case 1:
        old_reaction = "liked";
        break;
      case 0:
        old_reaction = 'dislike';
        break;
      case 3:
        old_reaction = 'none';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_item.likedORdisliked) {
      case 1:
        {setLiked();}
        break;
      case 0:
        {setDisliked();}
        break;
      case 3:
        {setNoReaction();}
        break;
    }

    String getTitle() {
      if (_item.title.length <= 20) {
        return _item.title;
      } else {
        return _item.title.substring(0, 20) + "...";
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(getTitle()),
        ),
        body: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      _item.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Image.memory(base64Decode(_item.photo)),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      _item.preambule,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  Text(_item.text),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      _item.author,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      _item.created,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                backgroundColor: LikeBgr,
                onPressed: () {
                  likeClick();
                },
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: LikeFgr,
                ),
              ),
            ),
            FloatingActionButton(
              backgroundColor: DislikeBgr,
              onPressed: () {
                dislikeClick();
              },
              child: Icon(
                Icons.thumb_down_alt_outlined,
                color: DislikeFgr,
              ),
            ),
          ],
        ));
  }
}
