import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var cdetails;
  var val = 1;
  List currencies;
  List value;
  TextEditingController _controller = TextEditingController();
  Future<void> postLogin() async {
    var response = await http.get(
     'https://api.exchangeratesapi.io/latest'
    );

    setState(() {
      try {
        var convertJsonData = json.decode(response.body);
       cdetails = convertJsonData;
        Fluttertoast.showToast(msg: 'Refreshed');
        Map curMap = cdetails['rates'];
        currencies = curMap.keys.toList();
        value = curMap.values.toList();
        print(value);
       print(currencies);
      } catch (e) {

        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }

  @override
  void initState(){
   super.initState();
   postLogin();
  }

  @override
  Widget build(BuildContext context) {
    return cdetails!=null?Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(cdetails['base']),subtitle: Text(cdetails['date']),trailing: RaisedButton(onPressed: (){
            postLogin();

        },child: Text('Refresh'),),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 70,
            margin: EdgeInsets.all(10.0),
            child: TextFormField(controller: _controller,keyboardType: TextInputType.number,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0)
                )
              ),
            ),
          ),
      Container(margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: RaisedButton(color: Colors.blueAccent,onPressed: (){
            setState(() {
              val = int.parse(_controller.text);
            });
          },child: Text('Convert'))),

          Row(
            children: [
             Spacer(),
              Expanded(
                child: ListView.builder(shrinkWrap: true,itemCount: currencies.length,itemBuilder: (context,int index){
                  return Text(currencies[index]);
                }),
              ),
              Spacer(),
              Expanded(
                child: ListView.builder(shrinkWrap: true,itemCount: value.length,itemBuilder: (context,int index){
                  return Text('${(val * value[index]).toString()}');
                }),
              ),
              Spacer()
            ],
          )




        ],
      ),

    ):Center(child: CircularProgressIndicator());
  }
}
