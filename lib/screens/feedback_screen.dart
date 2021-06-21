import 'package:flutter/material.dart';
import 'package:kups_project_mobile_app/network/API_actions.dart';

//Интерфейс экрана написания отзыва
class FeedbackPage extends StatelessWidget{
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var headerController = TextEditingController();
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Обратная связь"),
      ),
      body:
      Padding(
        padding: EdgeInsets.all(20),
        child:  Form(
          key: _formKey,
          child:  Column(
            children: [
              Text("Есть предложения или пожелания? Напишите нам, мы ответим на указанный email."),
              TextFormField(
                controller: emailController,
                decoration:InputDecoration(
                    hintText: "example@gmail.com"
                ),
                validator: (value) {
                  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                  if (!emailValid) {return 'Невалидный email.';}
                  return null;
                },
              ),
              Text("email"),
              TextFormField(
                controller: headerController,
                validator: (value){
                  bool messageThemeValid = RegExp(r"^[\S]+").hasMatch(value);
                  if (!messageThemeValid) {return 'Тема не должна быть пустой и начинаться с пробелов';}
                  return null;
                },
              ),
              Text("Тема сообщения"),
              TextFormField(
                controller: messageController,
                validator: (value){
                  if (value == null || value.isEmpty) {return 'Введите текст сообщения';}
                  return null;
                },
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration:InputDecoration(hintText: "Ваше сообщение"),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
            Icons.send
        ),
        tooltip: "Отправить",
        onPressed: () async {
          if ((_formKey.currentState.validate())) {
            await sendFeedback(messageController.text, emailController.text, headerController.text);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Сообщение отправлено')));
            Navigator.pop(context);
          }
        },
      ),
    );
  }

}
