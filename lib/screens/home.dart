import 'package:budget_tracker/view_models/budget_view_model.dart';
import 'package:budget_tracker/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/pages/home_page.dart';
import 'package:budget_tracker/pages/profile_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List for the bottom nav bar
  List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  // Load the pages based on the button you click
  List<Widget> pages = const [
    HomePage(),
    ProfilePage(),
  ];

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        // Add an icon to the appbar for theme switching
        leading: IconButton(
          onPressed: (() {
            themeService.darkTheme = !themeService.darkTheme;
          }),
          icon: Icon(themeService.darkTheme ? Icons.sunny : Icons.dark_mode),
        ),
        // Add an icon to the appbar
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: () {
              // Dialog to add budget
              showDialog(
                context: context,
                builder: (context) {
                  return AddBudgetDialog(
                    budgetToAdd: (budget) {
                      final budgetService =
                          Provider.of<BudgetViewModel>(context, listen: false);
                      budgetService.budget = budget;
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      // Changes the index based on which page you click
      body: pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        // Load the items from the List above
        items: bottomNavItems,
        onTap: (index) {
          // Change state to the page that you click on
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}

class AddBudgetDialog extends StatefulWidget {
  final Function(double) budgetToAdd;
  const AddBudgetDialog({required this.budgetToAdd, Key? key})
      : super(key: key);

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Add a budget",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(hintText: "Budget in \$"),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    widget.budgetToAdd(double.parse(amountController.text));
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
