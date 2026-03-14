import 'package:dummyexpense/core/constants/colors.dart';
import 'package:dummyexpense/features/home/presentation/widgets/shimmer_loader.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:dummyexpense/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:dummyexpense/features/transaction/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const LoadTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transactions',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocListener<TransactionBloc, TransactionState>(
                  listener: (context, state) {
                    if (state is TransactionAdded ||
                        state is TransactionDeleted) {
                      context.read<TransactionBloc>().add(
                        const LoadTransactionsEvent(),
                      );
                    }
                  },
                  child: BlocBuilder<TransactionBloc, TransactionState>(
                    buildWhen: (previous, current) =>
                        current is TransactionLoading ||
                        current is TransactionLoaded ||
                        current is TransactionError,
                    builder: (context, state) {
                      if (state is TransactionLoading) {
                        return const ShimmerLoader(itemCount: 8);
                      }

                      if (state is TransactionLoaded) {
                        if (state.transactions.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<TransactionBloc>().add(
                              const LoadTransactionsEvent(),
                            );
                          },
                          color: AppColors.primaryBlue,
                          child: ListView.builder(
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {
                              final t = state.transactions[index];
                              return TransactionCard(
                                transaction: t,
                                onDelete: () {
                                  context.read<TransactionBloc>().add(
                                    DeleteTransactionEvent(id: t.id),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }

                      if (state is TransactionError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: GoogleFonts.inter(
                              color: AppColors.expenseRed,
                            ),
                          ),
                        );
                      }

                      return const ShimmerLoader();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
