import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../models/warranty_model.dart';

class WarrantyCard extends StatelessWidget {
  final WarrantyModel warranty;
  final VoidCallback? onTap;

  const WarrantyCard({
    super.key,
    required this.warranty,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: warranty.receiptPath.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(warranty.receiptPath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.receipt_long, color: Colors.grey);
              },
            ),
          )
              : const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
        title: Text(
          warranty.productName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Vence: ${DateFormatter.format(warranty.expiryDate)}',
              style: TextStyle(
                  color: warranty.expiryDate.isBefore(DateTime.now())
                      ? Colors.red
                      : Colors.green[700],
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${warranty.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}