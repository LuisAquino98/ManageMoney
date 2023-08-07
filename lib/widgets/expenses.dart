import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_money/widgets/main_drawer.dart';

import '../models/expense.dart';
//import 'chart/chart.dart';
import 'chart/chart.dart';
import 'expenses__list/expenses_list.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>
    with SingleTickerProviderStateMixin {
  final List<Expense> _registeredExpenses = [
    /* Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    */
  ];
  final logoManage = 'assets/images/logo_white.png';
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 2000), // Ajusta la duración de la animación
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Iniciamos la animación al cargar el widget
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Gasto eliminado.'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 1; // Establecer el índice inicial para esta página

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    Widget mainContent = const Center(
      child: Text('No se encontraron gastos. ¡Empieza a añadir algunos!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      drawer: const MainDrawer(username: 'Nombre de Usuario'),
      appBar: AppBar(
        title: const Text(
          'Gastos',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: const Color.fromARGB(255, 00, 34, 71),
            child: Center(
              child: AnimatedBuilder(
                animation: _fadeInAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeInAnimation.value,
                    child: child,
                  );
                },
                child: Image.asset(
                  logoManage,
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.price_change),
            label: 'Gastos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Estadisticas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 31, 95, 163),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseOverlay,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
