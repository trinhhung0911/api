import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Network API",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Trinh Văn Hưng Api"),
        ),
        body: DemoNetWork(),
      ),
    );
  }
}

class DemoNetWork extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DemoNetWorkState();
  }
}

class _DemoNetWorkState extends State<DemoNetWork> {
  void initState() {
    super.initState();
    HttpOverrides.global = new MyHttpOverrides();
  }

  String title = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(140),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$title',
            style: TextStyle(fontSize: 20),
          ),
          RaisedButton(
            onPressed: () {
              makeHttpGet();
            },
            child: Text('Make Request'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
    );
  }
  //lấy dữ liệu về
  makeHttpGet() async {
    final client = Client(); //khởi tạo đường dẫn
    const URL = 'https://61dcde73591c3a0017e1aacc.mockapi.io/hung'; //đường dẫn
    final response = await client.get(URL); //lấy dữ liệu về
    if (response.statusCode == 200) {
      //kiểm tra nếu lấy về thành công
      var post = Post.fromJson(jsonDecode(response.body)); //frommat lại dữ liệ
      setState(() {
        title = post.title;
      });
    }
  }
  makeHttpPost() async {
    final client = Client(); //khởi tạo đường dẫn
    const URL = 'https://jsonplancehoder.typicode.com/posts'; //đường dẫn
    // đẩy dữ liệu lên
    final response = await client.post(URL, body: {
      'title': 'Mai Thi Linh',
      'body': 'Nguoi Yeu Cu'
    }); //lấy dữ liệu về
    if (response.statusCode == 201) {
      var post = Post.fromJson(jsonDecode(response.body)); //frommat lại dữ liệ
      setState(() {
        title = post.title;
      });
    }
  }
}
class Post {
  int userId;
  int id;
  String title;
  String body;
  Post(this.userId, this.id, this.title, this.body);
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json['userId'],
      json['id'],
      json['title'],
      json['body'],
    );
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}