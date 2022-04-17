import 'package:budget_tracker/model/transaction_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  static const String transactionBoxKey = "transactionBox";
  static const String balanceBoxKey = "balanceBox";
  static const String budgetBoxKey = "budgetBoxKey";

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionItemAdapter());
    }
    await Hive.openBox<double>(budgetBoxKey);
    await Hive.openBox<TransactionItem>(transactionBoxKey);
    await Hive.openBox<double>(balanceBoxKey);
  }

  void saveTransactionItem(TransactionItem transaction) {
    Hive.box<TransactionItem>(transactionBoxKey).add(transaction);
    saveBalance(transaction);
  }

  List<TransactionItem> getAllTransactions() {
    return Hive.box<TransactionItem>(transactionBoxKey).values.toList();
  }

  double getBudget() {
    return Hive.box<double>(budgetBoxKey).get("budget") ?? 2000.0;
  }

  Future<void> saveBudget(double budget) {
    return Hive.box<double>(budgetBoxKey).put("budget", budget);
  }

  double getBalance() {
    return Hive.box<double>(balanceBoxKey).get("balance") ?? 0.0;
  }

  Future<void> saveBalance(TransactionItem item) async {
    final balanceBox = Hive.box<double>(balanceBoxKey);
    final currentBalance = balanceBox.get("balance") ?? 0.0;
    if (item.isExpense) {
      balanceBox.put("balance", currentBalance + item.amount);
    } else {
      balanceBox.put("balance", currentBalance - item.amount);
    }
  }
}
