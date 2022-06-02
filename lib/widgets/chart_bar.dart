import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String lable;
  final double spendingAmount;
  final double spendingPctOfTotal;

  const ChartBar(
    this.lable,
    this.spendingAmount,
    this.spendingPctOfTotal, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Column(
        children: [
          SizedBox(
            height: constraint.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                '\$${spendingAmount.toStringAsFixed(0)}',
              ),
            ),
          ),
          SizedBox(height: constraint.maxHeight * 0.05),
          SizedBox(
            height: constraint.maxHeight * 0.6,
            width: 10,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(220, 220, 220, 1)),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: constraint.maxHeight * 0.05),
          SizedBox(
            height: constraint.maxHeight * 0.15,
            child: FittedBox(child: Text(lable)),
          ),
        ],
      );
    });
  }
}
