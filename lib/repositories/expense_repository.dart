import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';
import '../models/expense.dart';
import '../services/database_service.dart';

class ExpenseRepository {
  static Future<List<Expense>> getAllExpenses() async {
    try {
      final expenses = await DatabaseService.expensesCollection
          .find()
          .map((doc) => Expense.fromMap(doc))
          .toList();
      return expenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  static Future<bool> addExpense(Expense expense) async {
    try {
      await DatabaseService.expensesCollection.insertOne(expense.toMap());
      return true;
    } catch (e) {
      print('Error adding expense: $e');
      return false;
    }
  }

  static Future<bool> updateExpense(Expense expense) async {
    try {
      if (expense.id == null) return false;
      
      await DatabaseService.expensesCollection.updateOne(
        where.id(expense.id!),
        modify.set('title', expense.title)
            .set('amount', expense.amount)
            .set('category', expense.category)
            .set('date', expense.date.toIso8601String())
            .set('description', expense.description),
      );
      return true;
    } catch (e) {
      print('Error updating expense: $e');
      return false;
    }
  }

  static Future<bool> deleteExpense(ObjectId id) async {
    try {
      await DatabaseService.expensesCollection.deleteOne(where.id(id));
      return true;
    } catch (e) {
      print('Error deleting expense: $e');
      return false;
    }
  }

  static Future<double> getTotalExpenses() async {
    try {
      final expenses = await getAllExpenses();
      return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      print('Error calculating total: $e');
      return 0.0;
    }
  }
}

extension on FutureOr<double> {
  FutureOr<double> operator +(double other) {}
}