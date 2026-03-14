import 'package:dummyexpense/core/constants/colors.dart';
import 'package:dummyexpense/core/utils/constants.dart';
import 'package:dummyexpense/features/category/presentation/bloc/category_bloc.dart';
import 'package:dummyexpense/features/category/presentation/bloc/category_event.dart';
import 'package:dummyexpense/features/category/presentation/bloc/category_state.dart';
import 'package:dummyexpense/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:dummyexpense/features/sync/presentation/bloc/sync_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _categoryController = TextEditingController();
  final _limitController = TextEditingController();
  final _nicknameController = TextEditingController();
  String _nickname = '';
  double _currentLimit = AppConstants.defaultBudgetLimit;
  bool _isEditingNickname = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    context.read<CategoryBloc>().add(const LoadCategoriesEvent());
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nickname = prefs.getString(AppConstants.nicknameKey) ?? 'User';
      _nicknameController.text = _nickname;
      _currentLimit =
          prefs.getDouble(AppConstants.budgetLimitKey) ??
          AppConstants.defaultBudgetLimit;
    });
  }

  Future<void> _saveLimit() async {
    final value = double.tryParse(_limitController.text.trim());
    if (value == null || value <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.budgetLimitKey, value);
    setState(() => _currentLimit = value);
    _limitController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Limit set to ₹${value.toStringAsFixed(0)}',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: AppColors.successGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _updateNickname() async {
    final name = _nicknameController.text.trim();
    if (name.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.nicknameKey, name);
    setState(() {
      _nickname = name;
      _isEditingNickname = false;
    });
  }

  void _addCategory() {
    final name = _categoryController.text.trim();
    if (name.isEmpty) return;
    context.read<CategoryBloc>().add(AddCategoryEvent(name: name));
    _categoryController.clear();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authTokenKey);
    await prefs.remove(AppConstants.nicknameKey);
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _limitController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile & Settings',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Nickname Section
              Text('NICKNAME', style: _sectionLabel),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textGrey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _isEditingNickname
                          ? TextField(
                              controller: _nicknameController,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _updateNickname(),
                            )
                          : Text(
                              _nickname,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                    IconButton(
                      icon: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isEditingNickname ? Icons.check : Icons.edit,
                          color: AppColors.textGrey,
                          size: 20,
                        ),
                      ),
                      onPressed: () {
                        if (_isEditingNickname) {
                          _updateNickname();
                        } else {
                          setState(() => _isEditingNickname = true);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Alert Limit Section
              _buildDivider(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textGrey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ALERT LIMIT (₹)', style: _sectionLabel),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _limitController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                            decoration: InputDecoration(
                              fillColor: AppColors.cardGrey,
                              filled: true,
                              hintText: 'Amount (₹)',
                              hintStyle: GoogleFonts.inter(
                                color: AppColors.textGrey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _saveLimit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Set',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Limit: ₹${_currentLimit.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Categories Section
              _buildDivider(), Text('CATEGORIES', style: _sectionLabel),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textGrey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add Category
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _categoryController,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'New category Name',
                                  hintStyle: GoogleFonts.inter(
                                    color: AppColors.textGrey,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _addCategory,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16), _buildDivider(),
                    // Category List
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoaded) {
                          return Column(
                            children: state.categories.map((cat) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cat.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.read<CategoryBloc>().add(
                                          DeleteCategoryEvent(id: cat.id),
                                        );
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.expenseRed
                                                .withOpacity(0.5),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: AppColors.expenseRed,
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sync Section
              _buildDivider(),
              Text('CLOUD SYNC', style: _sectionLabel),
              const SizedBox(height: 10),
              BlocConsumer<SyncBloc, SyncState>(
                listener: (context, state) {
                  if (state is SyncCompleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Synced ${state.result.totalSynced} items, cleaned ${state.result.totalDeleted} items',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: AppColors.successGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (state is SyncFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: AppColors.expenseRed,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isSyncing = state is SyncInProgress;
                  return GestureDetector(
                    onTap: isSyncing
                        ? null
                        : () => context.read<SyncBloc>().add(
                            const StartSyncEvent(),
                          ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF22236D),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sync To Cloud',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sync and update data to the backend',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isSyncing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.primaryBlue,
                                  ),
                                )
                              : SvgPicture.asset('assets/svg/cloud.svg'),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Logout Button
              Center(
                child: TextButton.icon(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout,
                    color: AppColors.expenseRed,
                    size: 18,
                  ),
                  label: Text(
                    'Log Out',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.expenseRed,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Divider(
        color: AppColors.lightCardGrey.withOpacity(0.5),
        height: 1,
      ),
    );
  }

  TextStyle get _sectionLabel => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textGrey,
    letterSpacing: 1,
  );
}
