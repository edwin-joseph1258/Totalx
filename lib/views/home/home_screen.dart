import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/home_view_model.dart';
import 'widgets/user_card.dart';
import 'widgets/add_user_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeViewModel>().fetchUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
         return AlertDialog(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
           title: Text('Sort', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
           contentPadding: const EdgeInsets.only(top: 12, bottom: 20),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
                _sortOptionTile(context, 'All', 'All'),
                _sortOptionTile(context, 'Older', 'Age: Elder'),
                _sortOptionTile(context, 'Younger', 'Age: Younger'),
             ],
           ),
         );
      }
    );
  }

  Widget _sortOptionTile(BuildContext context, String option, String title) {
     final viewModel = context.watch<HomeViewModel>();
     return RadioListTile<String>(
       title: Text(title, style: GoogleFonts.inter(fontSize: 14)),
       value: option,
       groupValue: viewModel.sortOption,
       activeColor: Colors.blue,
       onChanged: (val) {
          if (val != null) {
             context.read<HomeViewModel>().setSortOption(val);
             Navigator.pop(context);
          }
       },
     );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Nilambur',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: viewModel.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search by name',
                        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => _showSortDialog(context),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.white),
                    ),
                  )
                ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Users Lists',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: viewModel.users.isEmpty && viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.black))
                    : viewModel.users.isEmpty
                        ? Center(child: Text('No users found.', style: GoogleFonts.inter()))
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: viewModel.users.length + (viewModel.hasMore && viewModel.users.isNotEmpty ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == viewModel.users.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator(color: Colors.black)),
                                );
                              }
                              return UserCard(user: viewModel.users[index]);
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(context: context, builder: (_) => const AddUserDialog());
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
