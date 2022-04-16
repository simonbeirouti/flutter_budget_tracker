import 'package:budget_tracker/services/budget_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:budget_tracker/model/transaction_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final budgetService = Provider.of<BudgetService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AddTransactionDialog(
                  itemToAdd: (transactionItem) {
                    final budgetService =
                        Provider.of<BudgetService>(context, listen: false);
                    budgetService.addItems(transactionItem);
                  },
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Consumer<BudgetService>(
                    builder: ((context, value, child) {
                      return CircularPercentIndicator(
                        radius: screenSize.width / 2,
                        backgroundColor: Colors.white,
                        lineWidth: 10.0,
                        percent: value.balance / value.balance,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "\$" + value.balance.toString().split(".")[0],
                              style: const TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Balance",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              "Budget: \$" + budgetService.budget.toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        progressColor: Theme.of(context).colorScheme.primary,
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 35.0),
                const Text(
                  "Items",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                // Add to the existing list of items
                Consumer<BudgetService>(
                  builder: ((context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.items.length,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TransactionCard(
                          item: value.items[index],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionItem item;
  const TransactionCard({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 5.0),
      // Container for the card with the basic styling
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 50.0,
              offset: const Offset(0.0, 25),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15.0),
        width: MediaQuery.of(context).size.width,
        // Row for the name and amount
        child: Row(
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const Spacer(),
            Text(
              (!item.isExpense ? "+ \$" : "- \$") + item.amount.toString(),
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog for adding a new transaction - has to be staeful because it's a modal and changes the state
class AddTransactionDialog extends StatefulWidget {
  final Function(TransactionItem) itemToAdd;
  const AddTransactionDialog({required this.itemToAdd, Key? key})
      : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  // Controllers for the fields
  final TextEditingController itemTitleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool _isExpenseController = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          // Single Column for the form
          child: Column(
            children: [
              const Text(
                "Add an expense",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 15),
              // TextField using the controller for the name
              TextField(
                controller: itemTitleController,
                decoration: const InputDecoration(
                  labelText: "Name of expense",
                ),
              ),
              // TextField using the controller for the amount
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: "Amount in \$"),
              ),
              // Row for a toggle switch to choose if it's an expense or income
              // Would prefer two buttons but couldn't get it to work
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Is an expense?"),
                  Switch.adaptive(
                      value: _isExpenseController,
                      onChanged: (b) {
                        setState(() {
                          _isExpenseController = b;
                        });
                      })
                ],
              ),
              const SizedBox(height: 15),
              // Button to add the item to the List, change state and close the dialog
              ElevatedButton(
                onPressed: () {
                  if (amountController.text.isNotEmpty &&
                      itemTitleController.text.isNotEmpty) {
                    widget.itemToAdd(
                      TransactionItem(
                        amount: double.parse(amountController.text),
                        name: itemTitleController.text,
                        isExpense: _isExpenseController,
                      ),
                    );
                    // Return to the previous screen
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
