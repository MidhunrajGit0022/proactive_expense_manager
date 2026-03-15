import 'package:dummyexpense/core/constants/colors.dart';
import 'package:dummyexpense/core/utils/constants.dart';
import 'package:dummyexpense/features/home/presentation/widgets/shimmer_loader.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:dummyexpense/features/transaction/presentation/widgets/add_transaction_modal.dart';
import 'package:dummyexpense/features/transaction/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    _loadNickname();
    context.read<TransactionBloc>().add(const LoadDashboardEvent());
  }

  Future<void> _loadNickname() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nickname = prefs.getString(AppConstants.nicknameKey) ?? 'User';
    });
  }

  void _showAddTransaction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddTransactionModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF20DE39), Color(0xFF147721)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF20DE39).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddTransaction,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<TransactionBloc>().add(const LoadDashboardEvent());
          },
          color: AppColors.primaryBlue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionAdded || state is TransactionDeleted) {
                  context.read<TransactionBloc>().add(
                    const LoadDashboardEvent(),
                  );
                } else if (state is TransactionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.expenseRed,
                    ),
                  );
                }
              },
              buildWhen: (previous, current) {
                return current is TransactionLoading ||
                    current is DashboardLoaded ||
                    current is TransactionInitial;
              },
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      const ShimmerLoader(itemCount: 6),
                    ],
                  );
                }

                if (state is DashboardLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildSummaryCards(state),
                      const SizedBox(height: 20),
                      _buildMonthlyLimit(state),
                      const SizedBox(height: 24),
                      _buildRecentTransactions(state),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 60),
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            color: AppColors.textGrey,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions yet',
                            style: GoogleFonts.inter(
                              color: AppColors.textGrey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap + to add your first transaction',
                            style: GoogleFonts.inter(
                              color: AppColors.textGrey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      '👋 Welcome, $_nickname!',
      style: GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildSummaryCards(DashboardLoaded state) {
    final incomeFormatted = NumberFormat(
      '#,##0',
      'en_IN',
    ).format(state.totalIncome);
    final expenseFormatted = NumberFormat(
      '#,##0',
      'en_IN',
    ).format(state.totalExpense);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F8300), Color(0xFF031C00)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0x4D0F8300), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Income',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.incomeGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_downward,
                      color: AppColors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '₹$incomeFormatted',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB50303), Color(0xFF250000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0x4DB50303), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expense',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.expenseRed,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: AppColors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '₹$expenseFormatted',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyLimit(DashboardLoaded state) {
    final limit = state.budgetLimit;
    final spent = state.monthlyExpense;
    final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final remaining = ((1 - progress) * 100).toInt();
    final spentFormatted = NumberFormat('#,##0', 'en_IN').format(spent);
    final limitFormatted = NumberFormat('#,##0', 'en_IN').format(limit);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF191919),
        border: Border.all(color: AppColors.lightCardGrey),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONTHLY LIMIT',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹$spentFormatted / ₹$limitFormatted',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.lightCardGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.9
                    ? AppColors.expenseRed
                    : progress > 0.7
                    ? Colors.orange
                    : AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$remaining% Remaining',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(DashboardLoaded state) {
    if (state.recentTransactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Text(
            'No recent transactions',
            style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 14),
        ...state.recentTransactions.map(
          (t) => TransactionCard(
            transaction: t,
            onDelete: () {
              context.read<TransactionBloc>().add(
                DeleteTransactionEvent(id: t.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
