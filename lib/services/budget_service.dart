import 'package:budget_tracker/model/transaction_item.dart';
import 'package:flutter/material.dart';

class BudgetService extends ChangeNotifier {
  double _budget = 2000;

  double get budget => _budget;

  double balance = 0.0;

  final List<TransactionItem> _items = [];

  List<TransactionItem> get items => _items;

  set budget(double value) {
    _budget = value;
    notifyListeners();
  }

  void addItems(TransactionItem item) {
    _items.add(item);
    updateBalance(item);
    notifyListeners();
  }

  void updateBalance(TransactionItem item) {
    if (item.isExpense) {
      balance += item.amount;
    } else {
      balance -= item.amount;
    }
  }
}
