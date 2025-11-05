import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category {
  food,
  travel,
  bills,
  household,
  credit,
  debit,
  installments,
  other,
}

const categoryIcons = {
  Category.food: Icons.lunch_dining_outlined,
  Category.bills: Icons.library_books_rounded,
  Category.travel: Icons.wallet_travel_rounded,
  Category.other: Icons.label_outline_sharp,
  Category.household: Icons.house_rounded,
  Category.credit: Icons.account_balance_wallet_outlined,
  Category.debit: Icons.payments_outlined,
  Category.installments: Icons.calendar_month_outlined,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Enum category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expen});

  ExpenseBucket.forCategory(List<Expense> allExpanses, this.category)
    : expen =
          allExpanses.where((expense) => expense.category == category).toList();

  final Category category;
  final List<Expense> expen;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expen) {
      sum += expense.amount;
    }

    return sum;
  }
}
