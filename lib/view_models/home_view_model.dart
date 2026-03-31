import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _filteredUsers;

  List<UserModel> _filteredUsers = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _searchQuery = '';
  String _sortOption = 'All'; 
  String get sortOption => _sortOption;

  int _currentPage = 0;
  final int _pageSize = 15;

  final List<UserModel> _mockDatabase = [
    UserModel(id: '0', name: 'Martin Dokidis', age: 34, imageUrl: 'https://i.pravatar.cc/150?img=11'),
    UserModel(id: '1', name: 'Marilyn Rosser', age: 34, imageUrl: 'https://i.pravatar.cc/150?img=5'),
    UserModel(id: '2', name: 'Cristofer Lipshutz', age: 34, imageUrl: 'https://i.pravatar.cc/150?img=12'),
    UserModel(id: '3', name: 'Wilson Botosh', age: 34, imageUrl: 'https://i.pravatar.cc/150?img=33'),
    UserModel(id: '4', name: 'Anika Saris', age: 34, imageUrl: 'https://i.pravatar.cc/150?img=9'),
    UserModel(id: '5', name: 'Phillip Gouse', age: 65, imageUrl: 'https://i.pravatar.cc/150?img=14'),
    UserModel(id: '6', name: 'Wilson Bergson', age: 62, imageUrl: 'https://i.pravatar.cc/150?img=15'),
  ];

  HomeViewModel() {
    fetchUsers(isRefresh: true);
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (isRefresh) {
      _currentPage = 0;
      _users.clear();
      _hasMore = true;
    }

    if (!_hasMore) return;

    _isLoading = true;
    if (isRefresh) notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;

    if (startIndex >= _mockDatabase.length) {
      _hasMore = false;
    } else {
      final newUsers = _mockDatabase.sublist(
        startIndex,
        endIndex > _mockDatabase.length ? _mockDatabase.length : endIndex,
      );
      _users.addAll(newUsers);
      _currentPage++;
      if (endIndex >= _mockDatabase.length) {
        _hasMore = false;
      }
    }

    _isLoading = false;
    _applyFilters();
  }

  void addUser(UserModel user) {
    _mockDatabase.insert(0, user);
    _users.insert(0, user);
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setSortOption(String option) {
    _sortOption = option;
    _applyFilters();
  }

  void _applyFilters() {
    var temp = _users;

    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where((u) => u.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                 u.phoneNumber.contains(_searchQuery))
          .toList();
    }

    if (_sortOption == 'Older') {
      temp = temp.where((u) => u.age >= 60).toList();
    } else if (_sortOption == 'Younger') {
      temp = temp.where((u) => u.age < 60).toList();
    }

    _filteredUsers = temp;
    notifyListeners();
  }
}
