import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/new_transaktion.dart';
import './widgets/chart.dart';

void main() {
// Disable landscape mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.red[100],
        fontFamily: 'Redressed',
        accentColor: Colors.amber[800],
        primarySwatch: Colors.red,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.amber[800],
          ),
          button: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 30, fontFamily: 'Redressed'),
        ),
      ),
      title: 'Shopping list',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransaction = [];
  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _startAddNewTransaction() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => NewTransaction(_addTransaction),
    );
  }

  void _addTransaction(String txTitle, double txAmount, DateTime selectDate) {
    var newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        id: DateTime.now().toString(),
        date: selectDate);
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Do you want to delete this transaction?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _userTransaction
                            .removeWhere((element) => element.id == id);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Ok',
                    ),
                    textColor: Theme.of(context).primaryColor,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cansel'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          );
        });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.6,
              child: Chart(_recentTransaction))
          : txListWidget
    ];
  }

  List<Widget> _buildPortretContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransaction),
      ),
      txListWidget
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Shopping list'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _startAddNewTransaction,
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: const Text('Shopping list'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: _startAddNewTransaction,
                icon: const Icon(Icons.add),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = _buildAppBar();

    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!_isLandscape)
              ..._buildPortretContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: _startAddNewTransaction,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
