import 'package:dummyexpense/core/constants/colors.dart';
import 'package:dummyexpense/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onDelete;

  const TransactionCard({super.key, required this.transaction, this.onDelete});

  IconData _getCategoryIcon(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'food':
        return Icons.shopping_cart;
      case 'bills':
        return Icons.receipt_long;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDebit = transaction.isDebit;
    final amountColor = isDebit ? AppColors.expenseRed : AppColors.incomeGreen;
    final amountPrefix = isDebit ? '-' : '+';
    final formattedAmount = NumberFormat(
      '#,##0',
      'en_IN',
    ).format(transaction.amount);
    final formattedDate = DateFormat(
      'd MMM yyyy',
    ).format(transaction.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardGrey),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightCardGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getCategoryIcon(transaction.categoryName),
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Title & Category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.categoryName ?? 'Uncategorized',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          // Date & Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedDate,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$amountPrefix₹$formattedAmount',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
            ],
          ),
          // Delete Button
          if (onDelete != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.expenseRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.expenseRed,
                  size: 18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
