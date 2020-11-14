import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;

      for (var i = 0; i < recentTransactions.length; i++) {
        final currentTransaction = recentTransactions[i];
        if (currentTransaction.date.day == weekDay.day &&
            currentTransaction.date.month == weekDay.month &&
            currentTransaction.date.year == weekDay.year) {
          totalSum += currentTransaction.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get getTotalSpending {
    return groupedTransactionValues.fold(
        0.0, (previousValue, element) => previousValue += element['amount']);
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  getTotalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / getTotalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
