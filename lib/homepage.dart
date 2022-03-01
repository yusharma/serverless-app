import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serverless_app/apis/firebase_apis.dart';
import 'package:foundation/model/coffee.dart';
import 'package:serverless_app/main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showStock = false;
  final TextEditingController _userController = TextEditingController();

  void _validateUser(BuildContext context) {
    FirebaseApi.validateUser(_userController.text).then((value) {
      if (value.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Text(
                "User not found",
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        );
      } else {
        globalCart = {};
        _showStock = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: TextField(
                controller: _userController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.deepOrange, width: 2)),
                  hintText: "Enter username to proceed",
                  hintStyle: TextStyle(color: Colors.black45, letterSpacing: 1),
                ),
                style: const TextStyle(
                  color: Colors.deepOrange,
                  letterSpacing: 2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: OutlinedButton(
                  onPressed: () {
                    _validateUser(context);
                  },
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.deepOrange)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 5, horizontal: 30))),
                  child: Text("Get Coffee"),
                ),
              ),
            ),
            _showStock ? _StockWidget() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _StockWidget extends StatelessWidget {
  const _StockWidget({
    Key key,
  }) : super(key: key);

  List<Widget> _getCoffeStock(List<Coffee> stocks) {
    List<Widget> widgets = [];
    for (var stock in stocks) {
      widgets.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.name,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      stock.stock.toString(),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 100,
                child: TextField(
                  onChanged: (value) {
                    if (int.tryParse(value) != null) {
                      globalCart[stock.name] = int.parse(value);
                    } else {
                      globalCart[stock.name] = 0;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.shade400, width: 2.5)),
                    hintText: "Qty.",
                    hintStyle:
                        TextStyle(color: Colors.black26, letterSpacing: 1),
                  ),
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Coffee>>(
        stream: FirebaseApi.getCoffee(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(snapshot);
                return Text('Something Went Wrong Try later');
              } else {
                final stockData = snapshot.data;
                return stockData.isEmpty
                    ? Text('Coffee is not available right now')
                    : Container(
                        margin:
                            const EdgeInsets.only(top: 30, left: 40, right: 40),
                        child: Column(
                          children: _getCoffeStock(stockData),
                        ),
                      );
              }
          }
        },
      );
}
