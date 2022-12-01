import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';
import 'package:flutter_complete_guide/widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'package:intl/intl.dart';
import './widgets/transactionlist.dart';
import 'widgets/chart.dart';
import 'dart:io';


void main() {
  // For locking the app in landscape mode
// WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([
//   DeviceOrientation.portraitUp,
//   DeviceOrientation.portraitDown
//  ,]);
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext cont) {
    return Platform.isIOS ? CupertinoApp(
      title: 'Personal Expenses',
      theme: CupertinoThemeData(
        
      ),
    ):
    MaterialApp(
      title: 'Personal Expense Keeper',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                  titleSmall: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                //button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 40,
            fontWeight: FontWeight.bold,
          )
          )
          ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  final List<Transaction> _userTransactions = [
    //  Transaction(id: 't1', title:"Purchased socks", amount:14.9, date: DateTime.now()),
    //  Transaction(id: 't2', title:"Purchased caps", amount:78.9, date: DateTime.now()),
    //  Transaction(id: 't3', title:"Purchased trousers", amount:56.7, date: DateTime.now()),
  ];

  bool _showChart = false;
  
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
     print(state);
  }

  
  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: (() {}),
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransactions(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }


  
  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,AppBar appBar,Widget txlistWidget)
  {
     return [Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children:<Widget>[
                Text('Show Chart', style: Theme.of(context).textTheme.titleMedium,),
                //Adaptive for different platforms
                Switch.adaptive(value:_showChart,onChanged: (val){
                  setState(() {
                    _showChart = val;
                  }
                  );
                },
                )
                ]
                ),_showChart?
                Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_recentTransactions)
                    )
                    :txlistWidget];
  }


  List<Widget> _buildPortraitContent
  (MediaQueryData mediaQuery,AppBar appBar,
  Widget txlistWidget)
  {
     return [Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -MediaQuery.of(context).padding.top) *
                        0.3,
                    child: Chart(_recentTransactions)
                    ),txlistWidget];
  }
  

  Widget _buildAppBar(){
    return Platform.isIOS?CupertinoNavigationBar(
      middle: Text("Personal Expense Keeper"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
         GestureDetector(
          child: Icon(CupertinoIcons.add),
          onTap: () => _startAddNewTransaction(context),)
      ]
      ),
    ): AppBar(
      title: Text("Personal Expense Keeper"),
      titleTextStyle: TextStyle(fontFamily: 'Open Sans'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    }


// String titleinput;
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = _buildAppBar();
    final txlistWidget =Container(
                height: (mediaQuery.size.height -
                          appBar.preferredSize.height -MediaQuery.of(context).padding.top) *
                      0.7,
                child: TransactionList(_userTransactions, _deleteTransactions)
                );
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final pageBody = SafeArea(
      child: SingleChildScrollView(
          child: Column(
              //mainAxisAlignment:
              // MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if(isLandscape)
                ..._buildLandscapeContent(
                  mediaQuery,
                  appBar,
                  txlistWidget
                  ),
                if (!isLandscape)
                //Spread operator for lists
                ..._buildPortraitContent(
                  mediaQuery,
                  appBar,
                  txlistWidget
                  )
              ]
              ),
        ),
  );


    return Platform.isIOS ? CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,
    )
    :Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ?Container() 
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
