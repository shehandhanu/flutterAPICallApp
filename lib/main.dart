import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/Responce.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'What Is The Fastest Framework'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  List<Items> users = [];

  var count = 0;
  var url = Uri.parse('https://api.github.com/search/users?q=followers:%3E=1&ref=searchresults&s=followers&type=Users&per_page=100&page=1');

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    await callAPI(url);
    print(users.length);
  }

  callAPI(var url) async{
    try{
      final response = await http.get(
        url,
        headers: {
          "Accept" : "application/json"
        },
      );

      Map<String,dynamic> responseBody = json.decode(response.body);
      if(response.statusCode == 200){
        User userDetails = User.fromJson(responseBody);
        for(int i = 0;i < userDetails.items!.length; i++){
          setState(() {
            users.add(userDetails.items![i]);
          });
        }
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff007fa3),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 60),
        itemCount: users.length,
        itemBuilder: (context, i) {
          return Card(
            child: Padding(padding: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(11.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(users[i].avatarUrl.toString()),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Text(users[i].id.toString()),
                          Text(users[i].login??"")
                        ],
                      )
                  )
                ],
              ),
            )
          );
        },
      ),
    );
  }
}


// Card(
// clipBehavior: Clip.antiAlias,
// child: Column(
// children: [
// ListTile(
// leading:  CircleAvatar(
// backgroundImage: NetworkImage(users[i].avatarUrl??""),
// ),
// title: Text(users[i].login??""),
// subtitle: Text(
// users[i].nodeId??"",
// style: TextStyle(color: Colors.black.withOpacity(0.6)),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(16.0),
// child: Text(
// users[i].followersUrl??"",
// style: TextStyle(color: Colors.black.withOpacity(0.6)),
// ),
// ),
// ],
// ),
// );