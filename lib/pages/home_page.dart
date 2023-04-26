import 'package:flutter/material.dart';
import 'package:my_app/components/expense_summary.dart';
import 'package:my_app/components/expense_tile.dart';
import 'package:my_app/data/expense_data.dart';
import 'package:my_app/models/expense_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicione um novo item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: newExpenseNameController,
            ),
            // expense amount
            TextField(
              controller: newExpenseAmountController,
            ),
          ],
        ),
        //save btn
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text('Salvar'),
          ),
          // cancel btn
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  // save
  void save() {
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: Colors.grey,
              floatingActionButton: FloatingActionButton(
                onPressed: addNewExpense,
                backgroundColor: Colors.black,
                child: const Icon(Icons.add),
              ),
              body: ListView(children: [
                // weekly summary
                ExpenseSummary(startOfWeek: value.startOfWeekDate()),

                const SizedBox(height: 20),
                // expense list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => ExpenseTile(
                        name: value.getAllExpenseList()[index].name,
                        amount: value.getAllExpenseList()[index].amount,
                        dateTime: value.getAllExpenseList()[index].dateTime,
                  ),
              ),

              ],)
            ));
  }
}
