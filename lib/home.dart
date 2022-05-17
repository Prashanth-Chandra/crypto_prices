import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:ui/Image';

import './about.dart';
import './graphs.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  final _controller = TextEditingController();

  Future<List<Coin>> getCrypto() async {
    coinList = [];
    filter = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=200&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
            filter.add(Coin.fromJson(map));
          }
        }
      }
      setState(() {
        coinList;
        filter;
      });

      return coinList;
    } else {
      throw Exception("Failed to load");
    }
  }

  void _filterList(String value) {
    setState(() {
      filter = coinList
          .where(
              (coin) => coin.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    getCrypto();
    Timer.periodic(const Duration(seconds: 10), (timer) => getCrypto());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          centerTitle: true,
          title: !isSearching
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/logo.png',
                          height: 120,
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/logo2.png',
                          height: 40,
                        ),
                      )
                    ],
                  ),
                )
              : TextField(
                  controller: _controller,
                  onChanged: (value) {
                    _filterList(value);
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 0.0),
                    ),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Coin Here",
                    hintStyle: const TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          isSearching = false;
                          filter = coinList;
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
          actions: !isSearching
              ? [
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
                ]
              : [],
          //backgroundColor: Colors.blueGrey[800],
        ),
        body: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          itemCount: filter.length,
          itemBuilder: (context, index) {
            //print(filter[index].imageUrl);
            return CoinCard(
                filter[index].name,
                filter[index].symbol,
                filter[index].imageUrl,
                filter[index].price.toDouble(),
                double.parse(
                    filter[index].change.toDouble().toStringAsFixed(5)),
                filter[index].changePercentage.toDouble());
          },
        ));
  }
}

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('./assets/muskMelon.jpg'),
                  fit: BoxFit.cover)),
          accountName: Text(
            'Prasahanth',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            'abc@123',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Eat Your Coin'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Home()));
            }),
        ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About The App'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Account()));
            }),
      ],
    ));
  }
}

class Coin {
  final String name;
  final String symbol;
  final String imageUrl;
  final num price;
  final num change;
  final num changePercentage;

  Coin(this.name, this.symbol, this.imageUrl, this.price, this.change,
      this.changePercentage);
  factory Coin.fromJson(Map<String, dynamic> json) {
    print(json["name"]);
    print(json["symbol"]);
    print(json["image"]);
    print(json["current_price"]);
    print(json["price_change_24h"]);
    print(json["price_change_percentage_24h"]);
    return Coin(
        json["name"],
        json["symbol"],
        json["image"],
        json["current_price"],
        json["price_change_24h"],
        json["price_change_percentage_24h"]);
  }
}

List<Coin> coinList = [];
List<Coin> filter = [];

class CoinCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String imageUrl;
  final double price;
  final double change;
  final double changePercentage;

  const CoinCard(this.name, this.symbol, this.imageUrl, this.price, this.change,
      this.changePercentage);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: const Color.fromARGB(111, 21, 21, 202),
        //color: Colors.blue,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 4.0),
              child: Center(
                child: Image(
                  alignment: Alignment.center,
                  height: 160,
                  width: 160,
                  image: NetworkImage(imageUrl),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Text(name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(symbol.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                            )),
                      ),
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Price : \$$price',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 0.1),
                      Row(children: <Widget>[
                        const Text(
                          "Change : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '\$$change',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: change > 0
                                ? Colors.green
                                : Color.fromARGB(255, 161, 43, 34),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        change > 0
                            ? const Icon(
                                Icons.arrow_drop_up_rounded,
                                color: Colors.green,
                                size: 30,
                              )
                            : const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Color.fromARGB(255, 161, 43, 34),
                                size: 30,
                              ),
                      ]),
                      const SizedBox(height: 1.0),
                      Row(
                        children: [
                          Text(
                            "Percentage : ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$changePercentage%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: change > 0
                                  ? Colors.green
                                  : Color.fromARGB(255, 161, 43, 34),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
