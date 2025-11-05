import 'dart:io';

import 'package:expenses_wise/models/expense.dart';
import 'package:expenses_wise/widgets/chart/chart.dart';
import 'package:expenses_wise/widgets/expenses/expenses_list.dart';
import 'package:expenses_wise/widgets/new_expenses.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class AppMemory {
  static final AppMemory _instance = AppMemory._internal();
  factory AppMemory() => _instance;
  AppMemory._internal();

  final List<Expense> regesteredExpenses = [];
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _regesteredExpenses = AppMemory().regesteredExpenses;

  double _totalExpenses() {
    return _regesteredExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  void _openAddExp() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAdd: _addExpense),
    );
  }

  void _addExpense(Expense exp) {
    setState(() {
      _regesteredExpenses.add(exp);
    });
  }

  void _removeExpense(Expense expense) {
    final expIndex = _regesteredExpenses.indexOf(expense);
    setState(() {
      _regesteredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Deleted Successfully"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _regesteredExpenses.insert(expIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _exportPdf() async {
    final pdf = pw.Document();
    final now = DateTime.now().toLocal();
    final formatted =
        '${now.toString().split(' ')[0]} ${now.toString().split(' ')[1].substring(0, 8)}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Expenses Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Date: $formatted',
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Title',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // البيانات من الarray
                  ..._regesteredExpenses.map(
                    (exp) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(exp.title),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(exp.amount.toStringAsFixed(2)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(exp.date.toString().split(' ')[0]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total: ${_totalExpenses().toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Time: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/expenses_report.pdf";

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    bool pdfSaved = false;
    // bool _snackbarShown = false;

    if (!pdfSaved) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("PDF saved Successfully")));
      pdfSaved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    Widget mainContent = const Center(child: Text("No Expenses Found. Start "));

    if (_regesteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _regesteredExpenses,
        onRemove: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpensesWise'),
        actions: [
          IconButton(onPressed: _openAddExp, icon: const Icon(Icons.add)),
        ],
      ),
      body:
          width < 600
              ? Column(
                children: [
                  Chart(expenses: _regesteredExpenses),
                  Expanded(child: mainContent),
                  Container(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                    color: Colors.blue,
                    child: Text(
                      "Total: ${_totalExpenses().toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                    child: ElevatedButton.icon(
                      onPressed: _exportPdf,
                      label: Text("Export As PDF"),
                      icon: Icon(Icons.picture_as_pdf),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: Chart(expenses: _regesteredExpenses)),
                  Expanded(child: mainContent),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                        margin: EdgeInsets.fromLTRB(0, 25, 8, 25),
                        color: Colors.blue,
                        child: Text(
                          "Total: ${_totalExpenses().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                        child: ElevatedButton.icon(
                          onPressed: _exportPdf,
                          label: Text("Export As PDF"),
                          icon: Icon(Icons.picture_as_pdf),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
