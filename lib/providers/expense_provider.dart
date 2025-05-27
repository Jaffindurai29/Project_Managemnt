import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await ExpenseRepository.getAllExpenses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addExpense(Expense expense) async {
    try {
      final success = await ExpenseRepository.addExpense(expense);
      if (success) {
        await loadExpenses(); // Refresh the list
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExpense(Expense expense) async {
    try {
      final success = await ExpenseRepository.updateExpense(expense);
      if (success) {
        await loadExpenses(); // Refresh the list
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExpense(Expense expense) async {
    if (expense.id == null) return false;
    
    try {
      final success = await ExpenseRepository.deleteExpense(expense.id!);
      if (success) {
        await loadExpenses(); // Refresh the list
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}