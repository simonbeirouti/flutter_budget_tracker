import 'package:hive/hive.dart';
part 'transaction_item.g.dart';

@HiveType(typeId: 1)
class TransactionItem {
  @HiveField(0)
  String name;
  @HiveField(1)
  double amount;
  @HiveField(2)
  bool isExpense;

  TransactionItem({
    required this.name,
    required this.amount,
    required this.isExpense,
  });
}
