import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './transaction_item.dart';
class TransactionList extends StatelessWidget {
  List<Transaction> _userTransactions;
  final Function deletetx;
  TransactionList(this._userTransactions,this.deletetx);

  @override
  Widget build(BuildContext context) {
    return  _userTransactions.isEmpty ?
    LayoutBuilder(builder: (ctx,constraints){
 return
    Column(
        children: <Widget>[
          Text("No Transactions",
          style: Theme.of(context).textTheme.titleSmall,
          ),
          //To provide spacing between title and image
          SizedBox(
            height: 10,),
          Container(
            height: constraints.maxHeight * 0.6 , 
            child: Image.asset(
              'assets/images/waiting.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
      }
      )
      :ListView
      (children: _userTransactions.map((tx) => TransactionItem(
            key: ValueKey(tx.id),
            transaction: tx, 
            deletetx: deletetx
            )
            ).toList(),
      );       
  }
}


