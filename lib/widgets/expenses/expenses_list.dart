import 'package:expenses_wise/models/expense.dart';
import 'package:expenses_wise/widgets/expenses/expenses_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemove,
  });

  final void Function(Expense expense) onRemove;

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder:
          (ctx, index) => Dismissible(
            key: ValueKey(expenses[index]),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(.75),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              ),
            ),
            onDismissed: (dire) {
              onRemove(expenses[index]);
            },
            child: ExpenseItem(expenses[index]),
          ),
    );
  }
}
