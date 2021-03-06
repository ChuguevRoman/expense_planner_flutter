import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import './adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function _addTransaction;

  const NewTransaction(this._addTransaction, {Key? key}) : super(key: key);
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectDate == null) {
      return;
    }
    widget._addTransaction(enteredTitle, enteredAmount, _selectDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2018),
            lastDate: DateTime.now())
        .then((picketDate) {
      if (picketDate == null) {
        return;
      }
      setState(() {
        _selectDate = picketDate;
      });
      _submitData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                onSubmitted: (_) => _submitData(),
                controller: _titleController,
                keyboardType: TextInputType.text,
                autocorrect: true,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              TextField(
                onSubmitted: (_) => _submitData(),
                controller: _amountController,
                keyboardType: TextInputType.number,
                autocorrect: true,
                decoration: const InputDecoration(
                  label: Text('Amount'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectDate == null
                          ? 'Date not choose!'
                          : DateFormat('dd MMMM yyyy').format(_selectDate!),
                    ),
                  ),
                  AdaptiveButton('Choose date', _presentDatePicker),
                ],
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button?.color,
                onPressed: _submitData,
                child: const Text(
                  'Add transaction',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
