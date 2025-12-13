import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../viewmodels/warranty_form_vm.dart';
import '../../viewmodels/warranty_list_vm.dart';

class CaptureWarrantyScreen extends ConsumerStatefulWidget {
  const CaptureWarrantyScreen({super.key});

  @override
  ConsumerState<CaptureWarrantyScreen> createState() => _CaptureWarrantyScreenState();
}

class _CaptureWarrantyScreenState extends ConsumerState<CaptureWarrantyScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: source);
    if (photo != null) {
      ref.read(warrantyFormProvider.notifier).processImage(photo);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(warrantyFormProvider);

    ref.listen(warrantyFormProvider, (previous, next) {
      if (previous?.productName != next.productName && next.productName.isNotEmpty) {
        _nameController.text = next.productName;
      }
      if (previous?.amount != next.amount && next.amount > 0) {
        _amountController.text = next.amount.toStringAsFixed(2);
      }
      if (previous?.purchaseDate != next.purchaseDate) {
        _dateController.text = DateFormatter.format(next.purchaseDate);
      }

      if (next.status == WarrantyFormStatus.success) {
        ref.invalidate(warrantyListProvider);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Garantía guardada exitosamente!')),
        );
      }
      if (next.status == WarrantyFormStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Error desconocido'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Garantía')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: state.receiptPath != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(state.receiptPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 48, color: Colors.blue[700]),
                          const SizedBox(height: 8),
                          Text(
                            'Toca para escanear recibo',
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    controller: _nameController,
                    label: 'Nombre del Producto',
                    prefixIcon: Icons.shopping_bag_outlined,
                    validator: InputValidators.validateRequired,
                    onChanged: (val) => ref.read(warrantyFormProvider.notifier).updateName(val),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _amountController,
                          label: 'Monto',
                          prefixIcon: Icons.attach_money,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: InputValidators.validateAmount,
                          onChanged: (val) {
                            final number = double.tryParse(val) ?? 0.0;
                            ref.read(warrantyFormProvider.notifier).updateAmount(number);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          controller: _dateController,
                          label: 'Fecha',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              ref.read(warrantyFormProvider.notifier).updateDate(picked);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: 'GUARDAR EN BÓVEDA',
                    isLoading: state.status == WarrantyFormStatus.loading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (state.receiptPath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Falta la foto del recibo')),
                          );
                          return;
                        }
                        ref.read(warrantyFormProvider.notifier).submitWarranty();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          if (state.status == WarrantyFormStatus.processing ||
              state.status == WarrantyFormStatus.loading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      state.status == WarrantyFormStatus.processing
                          ? 'Analizando recibo con IA...'
                          : 'Guardando...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}