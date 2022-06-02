import 'package:flutter/material.dart';

import './transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function deleteTransaction;

  const TransactionList(this.userTransaction, this.deleteTransaction,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userTransaction.isEmpty
        ? LayoutBuilder(builder: (context, constraint) {
            return Column(
              children: [
                Text(
                  'No avaible transaction',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: constraint.maxHeight * 0.6,
                  child: Image.asset(
                    'accets/images/found.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemCount: userTransaction.length,
            itemBuilder: (context, index) {
              return TransactionItem(
                  transaction: userTransaction[index],
                  deleteTransaction: deleteTransaction);
            });
  }
}
