import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'APIs.dart';

void main() {
  runApp(const MyApp());
}

String OnOffline = "1";
String OnOffStatus = "";


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Counter Management'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            child: const Counters(),
          ),
        ],
      )
    );
  }
}

class Counters extends StatefulWidget {
  const Counters({Key? key}) : super(key: key);
  @override
  _CountersState createState() => _CountersState();
}
class _CountersState extends State<Counters> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        FutureBuilder<String>(
            future: Functions.counterOfCounter(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                String status = snapshot.data ?? "";
                Map<String, dynamic> decodeResponse = jsonDecode(status);
                return Wrap(
                  children: [
                    for(int i = 1 ; i <= int.parse(decodeResponse["aryresultlist"][0]["count"]) ; i++)
                      Counter(AoC: i.toString())
                  ],
                );
              } else {
                return Container();
              }
            }
        ),
      ],
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({Key? key ,required this.AoC}) : super(key: key);
  final String AoC;
  @override
  _CounterState createState() => _CounterState();
}
class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      color: Colors.grey[200],
      constraints: const BoxConstraints( maxWidth: 200,maxHeight: 200),
      // width: (MediaQuery.of(context).size.width/5),
      // height: (MediaQuery.of(context).size.height/5),
      width: 200,
      height: 200,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20)),
          Text('COUNTER '+widget.AoC),
          Padding(padding: EdgeInsets.all(10)),
          OffOnlineButton(cID: widget.AoC),
          CompleteButton(cID: widget.AoC),
          CallNextButton(cID: widget.AoC),
        ],
      ),
    );
  }
}

class OffOnlineButton extends StatefulWidget {
  const OffOnlineButton({Key? key, required this.cID}) : super(key: key);
  final String cID;
  @override
  _OffOnlineButtonState createState() => _OffOnlineButtonState();
}
class _OffOnlineButtonState extends State<OffOnlineButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ()async{
        var response = await Functions.counterStatus(widget.cID);
        Map<String, dynamic> decodeResponse = jsonDecode(response);
        setState(() {
          if(decodeResponse["aryresultlist"][0]["status"]=='0'){
            OnOffline = "1";
          }else{
            OnOffline = "0";
          }
          OnOffStatus = decodeResponse["aryresultlist"][0]["status"];
        });
        if(decodeResponse["aryresultlist"][0]["current_number"] != null){
          showDialog(
            context: context,
            builder: (_) =>
            const CupertinoAlertDialog(
              title: Text("Error"),
              content: Text("Complete current ticket first."),
            )
          );
        }else{
          var response = await Functions.updateCounterStatus(widget.cID,OnOffline);
          if(decodeResponse["aryresultlist"][0]["status"]=='0'){
            showDialog(
              context: context,
              builder: (_) =>
                CupertinoAlertDialog(
                  title: Text("Online"),
                  content: Text("Counter"+widget.cID+" Online"),
                )
            );
          }else{
            showDialog(
              context: context,
              builder: (_) =>
                CupertinoAlertDialog(
                  title: Text("Offline"),
                  content: Text("Counter"+widget.cID+" Offline"),
                )
            );
          }
        }
      },
      child:
      ((){
        if(OnOffStatus!='0'){
          return Text('Go Online');
        }else{
          return Text('Go Offline');
        }
      }())
    );

    // return FutureBuilder<String>(
    //   future: Functions.counterStatus(widget.cID),
    //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //     if (snapshot.hasData) {
    //       String status = snapshot.data ?? "";
    //       Map<String, dynamic> decodeResponse = jsonDecode(status);
    //       return TextButton(
    //         onPressed: ()async{
    //
    //           var response1 = await Functions.counterStatus(widget.cID);
    //           Map<String, dynamic> decodeResponse1 = jsonDecode(response1);
    //           setState(() {
    //             if(decodeResponse["aryresultlist"][0]["status"]=='0'){
    //               OnOffline = "1";
    //             }else{
    //               OnOffline = "0";
    //             }
    //           });
    //           if(decodeResponse1["aryresultlist"][0]["current_number"] != null){
    //             showDialog(
    //               context: context,
    //               builder: (_) =>
    //               const CupertinoAlertDialog(
    //                 title: Text("Error"),
    //                 content: Text("Complete current ticket first."),
    //               )
    //             );
    //           }else{
    //             var response = await Functions.updateCounterStatus(widget.cID,OnOffline);
    //             if(decodeResponse["aryresultlist"][0]["status"]=='0'){
    //               showDialog(
    //                 context: context,
    //                 builder: (_) =>
    //                   CupertinoAlertDialog(
    //                     title: Text("Online"),
    //                     content: Text("Counter"+widget.cID+" Online"),
    //                   )
    //               );
    //             }else{
    //               showDialog(
    //                 context: context,
    //                 builder: (_) =>
    //                   CupertinoAlertDialog(
    //                     title: Text("Offline"),
    //                     content: Text("Counter"+widget.cID+" Offline"),
    //                   )
    //               );
    //             }
    //           }
    //         },
    //         child:
    //           ((){
    //             if(decodeResponse["aryresultlist"][0]["status"]=='0'){
    //               return Text('Go Online');
    //             }else{
    //               return Text('Go Offline');
    //             }
    //           }())
    //       );
    //     } else {
    //       return Container();
    //     }
    //   }
    // );
  }
}

class CompleteButton extends StatefulWidget {
  const CompleteButton({Key? key, required this.cID}) : super(key: key);
  final String cID;
  @override
  _CompleteButtonState createState() => _CompleteButtonState();
}
class _CompleteButtonState extends State<CompleteButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: ()async{
          var response = await Functions.counterStatus(widget.cID);
          Map<String, dynamic> decodeResponse = jsonDecode(response);
          if(decodeResponse["aryresultlist"][0]["current_number"] == null){
            showDialog(
                context: context,
                builder: (_) =>
                const CupertinoAlertDialog(
                  title: Text("No ticket serving."),
                  content: Text(""),
                )
            );
          }else{
            var response = await Functions.completeCurrent(widget.cID);
            Map<String, dynamic> decodeResponse2 = jsonDecode(response);
            showDialog(
                context: context,
                builder: (_) =>
                    CupertinoAlertDialog(
                      title: const Text("Ticket Complete"),
                      content: Text(decodeResponse2["message"]),
                    )
            );
          }
        },
        child: const Text("Complete Current"));

    // return FutureBuilder<String>(
    //   future: Functions.counterStatus(widget.cID),
    //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //     if (snapshot.hasData) {
    //       String status = snapshot.data ?? "";
    //       Map<String, dynamic> decodeResponse = jsonDecode(status);
    //       return TextButton(
    //         onPressed: ()async{
    //           var response = await Functions.counterStatus(widget.cID);
    //           Map<String, dynamic> decodeResponse = jsonDecode(response);
    //           if(decodeResponse["aryresultlist"][0]["current_number"] == null){
    //             showDialog(
    //               context: context,
    //               builder: (_) =>
    //               const CupertinoAlertDialog(
    //                 title: Text("No ticket serving."),
    //                 content: Text(""),
    //               )
    //             );
    //           }else{
    //             var response = await Functions.completeCurrent(widget.cID);
    //             Map<String, dynamic> decodeResponse2 = jsonDecode(response);
    //             showDialog(
    //                 context: context,
    //                 builder: (_) =>
    //                 CupertinoAlertDialog(
    //                   title: const Text("Ticket Complete"),
    //                   content: Text(decodeResponse2["message"]),
    //                 )
    //             );
    //           }
    //         },
    //         child: const Text("Complete Current"));
    //     }else{
    //       return Container();
    //     }
    //   }
    // );
  }
}

class CallNextButton extends StatefulWidget {
  const CallNextButton({Key? key,required this.cID}) : super(key: key);
  final String cID;
  @override
  _CallNextButtonState createState() => _CallNextButtonState();
}
class _CallNextButtonState extends State<CallNextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ()async{
        var response = await Functions.counterOfWaiting();
        Map<String, dynamic> decodeResponse = jsonDecode(response);
        var response1 = await Functions.counterStatus(widget.cID);
        Map<String, dynamic> decodeResponse1 = jsonDecode(response1);

        if(decodeResponse1["aryresultlist"][0]["status"] == "0"){
          showDialog(
            context: context,
            builder: (_) =>
            const CupertinoAlertDialog(
              title: Text("Error"),
              content: Text("Go Online first"),
            )
          );
        }else{
          if(decodeResponse["aryresultlist"][0]["count"]=='0'){
            showDialog(
                context: context,
                builder: (_) =>
                const CupertinoAlertDialog(
                  title: Text("No tickets in the waiting queue"),
                  content: Text(""),
                )
            );
          }
          else if(decodeResponse1["aryresultlist"][0]["current_number"] != null){
            showDialog(
                context: context,
                builder: (_) =>
                const CupertinoAlertDialog(
                  title: Text("Error"),
                  content: Text("Complete current ticket first."),
                )
            );
          }
          else if(decodeResponse1["aryresultlist"][0]["current_number"] == null){
            var response2 = await Functions.callNext(widget.cID);
            Map<String, dynamic> decodeResponse2 = jsonDecode(response2);
            showDialog(
                context: context,
                builder: (_) =>
                    CupertinoAlertDialog(
                      title: Text("Called "+decodeResponse2["aryresultlist"][0]["count"]+" for next."),
                      content: Text(""),
                    )
            );
          }
          else{
            Text("Got Bug GG");
          }
        }
      },
      child: const Text('Call Next')
    );

    // return FutureBuilder<String>(
    //   future: Functions.counterOfWaiting(),
    //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //     if (snapshot.hasData) {
    //       String status = snapshot.data ?? "";
    //       Map<String, dynamic> decodeResponse = jsonDecode(status);
    //       return TextButton(
    //         onPressed: ()async{
    //           var response = await Functions.counterOfWaiting();
    //           Map<String, dynamic> decodeResponse = jsonDecode(response);
    //           var response1 = await Functions.counterStatus(widget.cID);
    //           Map<String, dynamic> decodeResponse1 = jsonDecode(response1);
    //
    //           if(decodeResponse["aryresultlist"][0]["count"]=='0'){
    //             showDialog(
    //               context: context,
    //               builder: (_) =>
    //               const CupertinoAlertDialog(
    //                 title: Text("No tickets in the waiting queue"),
    //                 content: Text(""),
    //               )
    //             );
    //           }else if(decodeResponse1["aryresultlist"][0]["current_number"] != null){
    //             showDialog(
    //               context: context,
    //               builder: (_) =>
    //                 const CupertinoAlertDialog(
    //                   title: Text("Error"),
    //                   content: Text("Complete current ticket first."),
    //                 )
    //             );
    //           } else if(decodeResponse1["aryresultlist"][0]["current_number"] == null){
    //             var response2 = await Functions.callNext(widget.cID);
    //             Map<String, dynamic> decodeResponse2 = jsonDecode(response2);
    //             showDialog(
    //                 context: context,
    //                 builder: (_) =>
    //                 CupertinoAlertDialog(
    //                   title: Text("Called "+decodeResponse2["aryresultlist"][0]["count"]+" for next."),
    //                   content: Text(""),
    //                 )
    //             );
    //           }else{
    //             Text("Got Bug GG");
    //           }
    //         },
    //         child: const Text('Call Next')
    //
    //       );
    //     } else {
    //       return Container();
    //     }
    //   }
    // );

  }
}

