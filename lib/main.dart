import 'package:flutter/material.dart';
import 'travel_route.dart';
import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menetrend demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(title: 'Menetrend demo'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<TravelRoute> _result;
  bool _loading = false;
  final _from = TextEditingController();
  final _to = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  _refresh() async {
    setState(() {
      _result = null;
      _loading = true;
    });

    _result = await Api.getRoutes(
        _from.text, _to.text, DateTime.utc(2020, 11, 11), TravelType.train);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                  title: TextField(
                      decoration: InputDecoration(hintText: "Honnan"),
                      controller: _from),
                  subtitle: TextField(
                      decoration: InputDecoration(hintText: "Hova"),
                      controller: _to),
                  trailing: RaisedButton(
                      child: Text('Lekérés'), onPressed: _refresh)),
              (_result != null
                  ? Table(
                      children: _result
                          .map((route) => TableRow(
                                children: [
                                  Text(route.from),
                                  Text(route.departure),
                                  Text(route.to),
                                  Text(route.arrival),
                                  Text(route.transferCount == 0
                                      ? "-"
                                      : route.transferCount.toString()),
                                  Text(route.transferCount > 0
                                      ? route.transfers.join(", ")
                                      : "-")
                                ],
                              ))
                          .toList())
                  : (_loading ? CircularProgressIndicator() : Container()))
            ],
          ),
        )));
  }
}
