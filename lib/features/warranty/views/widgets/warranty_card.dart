import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../models/warranty_model.dart';

class WarrantyCard extends StatelessWidget {
  final WarrantyModel warranty;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const WarrantyCard({
    super.key,
    required this.warranty,
    this.onDelete,
    this.onEdit,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Electrónica': return Icons.devices_rounded;
      case 'Hogar': return Icons.home_rounded;
      case 'Ropa': return Icons.checkroom_rounded;
      case 'Vehículos': return Icons.directions_car_rounded;
      default: return Icons.category_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Electrónica': return const Color(0xFF3B82F6);
      case 'Hogar': return const Color(0xFF10B981);
      case 'Ropa': return const Color(0xFFEC4899);
      case 'Vehículos': return const Color(0xFFF59E0B);
      default: return AppTheme.primaryPurple;
    }
  }

  int _getDaysRemaining() {
    final now = DateTime.now();
    return warranty.expiryDate.difference(now).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final daysRemaining = _getDaysRemaining();
    final isExpired = daysRemaining < 0;
    final isExpiringSoon = daysRemaining <= 30 && !isExpired;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isExpired 
            ? [Colors.red.shade50, Colors.red.shade100]
            : isExpiringSoon
              ? [Colors.orange.shade50, Colors.orange.shade100]
              : [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isExpired ? Colors.red : _getCategoryColor(warranty.category))
                .withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Receipt Image
                Hero(
                  tag: 'warranty_${warranty.id}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          _getCategoryColor(warranty.category).withOpacity(0.2),
                          _getCategoryColor(warranty.category).withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: _getCategoryColor(warranty.category).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: warranty.receiptPath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              File(warranty.receiptPath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.receipt_long_rounded,
                                  color: _getCategoryColor(warranty.category),
                                  size: 36,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.receipt_long_rounded,
                            color: _getCategoryColor(warranty.category),
                            size: 36,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(warranty.category).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getCategoryIcon(warranty.category),
                              size: 14,
                              color: _getCategoryColor(warranty.category),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              warranty.category,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _getCategoryColor(warranty.category),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Product Name
                      Text(
                        warranty.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      
                      // Price
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Bs ${warranty.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      // Expiry info
                      Row(
                        children: [
                          Icon(
                            isExpired 
                              ? Icons.error_rounded
                              : isExpiringSoon
                                ? Icons.warning_rounded
                                : Icons.check_circle_rounded,
                            size: 14,
                            color: isExpired
                              ? AppTheme.errorRed
                              : isExpiringSoon
                                ? AppTheme.accentOrange
                                : AppTheme.successGreen,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isExpired
                                ? 'Vencida hace ${-daysRemaining} días'
                                : isExpiringSoon
                                  ? 'Vence en $daysRemaining días'
                                  : 'Vence: ${DateFormatter.format(warranty.expiryDate)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isExpired
                                  ? AppTheme.errorRed
                                  : isExpiringSoon
                                    ? AppTheme.accentOrange
                                    : AppTheme.successGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit button
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: onEdit,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Delete button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.errorRed.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: onDelete,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.delete_rounded,
                              color: AppTheme.errorRed,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
