import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Uri _search;

   int _offset = 0;

 Future<Set> _getGif() async{
    http.Response response;
    _search = Uri.parse("");

    if(_search == Uri.parse("")){
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=PAL5nXwylMkiVPfb3QAgHJpKdc4sodZU&limit=20&rating=g"));
    }else {
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=PAL5nXwylMkiVPfb3QAgHJpKdc4sodZU&q=$_search&limit=19&offset=$_offset&rating=g&lang=en"));
    } return{
      json.decode(response.body)
    };
  }

  // @override
  // void initState() {
  //   super.initState();

  // _getGif().then((value) => print(value));

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
           Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
            decoration: const InputDecoration(
              labelText: "Pesquise Aqui...",
              labelStyle: TextStyle(
               color: Colors.white,
              ),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
            onSubmitted:(text) {
              setState(() {
              _search = text as Uri;
              _offset = 0;
              });
            },
            ),
          ),
          Expanded(child: FutureBuilder(
            future: _getGif(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                return Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 5.0,
                  ),
                );
                default:
                if(snapshot.hasError) {
                  return Container(color: Colors.red,);
                } else {
                  // return Container(color: Colors.green);
                  return _createGifTable(context, snapshot);
                }
              }
            }
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if(_search == Uri.parse("")){
     return data.length;
    }else{
      return data.length + 1;
    }
      
  }


  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        ),
        itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) {
          if(_search == Uri.parse("") || index < snapshot.data["data"].length){
            return GestureDetector(
            child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
            height: 300,
            fit: BoxFit.cover,
            ),
            );
          }else{
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 70.0,),
                  Text("Buscar por mais...",
                  style: TextStyle(color: Colors.white, fontSize: 22.0),),
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            );
          }
        }
   );
  }
}
