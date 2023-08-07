import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_money/widgets/main_drawer.dart';

import '../models/expense.dart';
//import 'chart/chart.dart';
import 'chart/chart.dart';

class CharExpenses extends StatefulWidget {
  const CharExpenses({super.key});

  @override
  State<CharExpenses> createState() {
    return _CharExpensesState();
  }
}

class _CharExpensesState extends State<CharExpenses>
    with SingleTickerProviderStateMixin {
  final List<Expense> _registeredExpenses = [];
  final logoManage = 'assets/images/logo_white.png';
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

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

  @override
  Widget build(BuildContext context) {
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
            height: 250,
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
        ],
      ),
    );
  }
}
