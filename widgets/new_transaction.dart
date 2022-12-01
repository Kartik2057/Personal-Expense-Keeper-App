import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/widgets/adaptive_button.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class NewTransaction extends StatefulWidget {
  final Function _addnew;//For storing address of private method addNewTransaction in 
    //private class

  
  NewTransaction(this._addnew){
    print("Constructor NewTransaction Widget");
  }
   
  @override
  State<NewTransaction> createState() {
    print("Constructor createState in NewTransactionWidget");
    return _NewTransactionState();
    }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titlecontroller = TextEditingController();
  DateTime _selectedDate;
  final _amountcontroller = TextEditingController();
  

  _NewTransactionState() {
    print("Constructor NewTransactionState");
  }

  //Not necessary
  @override
  void initState() {
    print("initState()");
    super.initState();
  }

  
  //Not Necessary
  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  // Not Necessary
  @override
  void dispose() {
    print("dispose()");
    super.dispose();
  }


  
  void _presentDatePicker(){
    showDatePicker(context: context, 
    initialDate: DateTime.now(),
    firstDate: DateTime(2022),
    lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null){
        return;
      }
      setState(() {
      _selectedDate=pickedDate;        
      });
    });
    print('...');//This will be printed immmediately as the user clicks choose date
  }

  
  void _submitData(){
    if (_amountcontroller.text.isEmpty){
      return;
    }
    final enteredTitle = _titlecontroller.text;
    final enteredAmount = double.parse(_amountcontroller.text);
    //LITTLE DUMMY VALIDATION
    if(enteredTitle.isEmpty||enteredAmount<=0|| _selectedDate == null){
      return;
    }
    //CALLING ADDNEW FUNCTION
    //Here we are accessing the functions of 
    //  your widget class inside of your state 
    //   class
     widget._addnew(enteredTitle,enteredAmount,_selectedDate);

     Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child:
      Container(
          padding:EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              /*onChanged: (val) {
                             titleinput=val;
                                 },*/
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titlecontroller,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              keyboardType: TextInputType.number,
              //onChanged: (val)=>amountinput=val,
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountcontroller,
              //There is no use of val in onSubmitted: (val) => submitData
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
                child: Row(children: <Widget>[
                  Expanded(
                    child: Text(_selectedDate==null?'No Date Chosen': 
                    'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  AdaptiveFlatButton('Choose Date', _presentDatePicker)
                ],
              ),
            ),
            ElevatedButton(
              child: Text("Add Transaction",
              style: TextStyle(
                color: Colors.white,
              ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: _submitData,
            )
          ]
          )
      )
      ),
    );
  }
}
