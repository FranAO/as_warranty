import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../viewmodels/warranty_form_vm.dart';
import '../../viewmodels/warranty_list_vm.dart';
import '../../models/warranty_model.dart';

class CaptureWarrantyScreen extends ConsumerStatefulWidget {
  final WarrantyModel? warrantyToEdit;

  const CaptureWarrantyScreen({super.key, this.warrantyToEdit});

  @override
  ConsumerState<CaptureWarrantyScreen> createState() => _CaptureWarrantyScreenState();
}

class _CaptureWarrantyScreenState extends ConsumerState<CaptureWarrantyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  final List<String> categories = ['General', 'Electrónica', 'Hogar', 'Ropa', 'Vehículos', 'Otros'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _dateController = TextEditingController();

    if (widget.warrantyToEdit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(warrantyFormProvider.notifier).setWarrantyToEdit(widget.warrantyToEdit!);
      });
    }
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
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: photo.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar Recibo',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Recortar Recibo',
          ),
        ],
      );

      if (croppedFile != null) {
        ref.read(warrantyFormProvider.notifier).processImage(XFile(croppedFile.path));
      }
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
      if (previous?.productName != next.productName) {
        _nameController.text = next.productName;
      }
      if (previous?.amount != next.amount && next.amount > 0) {
        _amountController.text = next.amount.toStringAsFixed(2);
      }
      if (previous?.purchaseDate != next.purchaseDate) {
        _dateController.text = DateFormatter.format(next.purchaseDate);
      }

      if (next.status == WarrantyFormStatus.success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Guardado exitosamente!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.warrantyToEdit != null ? 'Editar Garantía' : 'Nueva Garantía',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
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
                      child: state.receiptPath != null && state.receiptPath!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: state.receiptPath!.startsWith('http')
                            ? Image.network(state.receiptPath!, fit: BoxFit.cover)
                            : Image.file(File(state.receiptPath!), fit: BoxFit.cover),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.crop_free,
                              size: 48, color: Colors.blue[700]),
                          const SizedBox(height: 8),
                          Text(
                            'Toca para escanear y recortar',
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  DropdownButtonFormField<String>(
                    value: state.category.isNotEmpty ? state.category : 'General',
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    items: categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) ref.read(warrantyFormProvider.notifier).updateCategory(val);
                    },
                  ),
                  const SizedBox(height: 16),

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
                              initialDate: state.purchaseDate,
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
                    text: widget.warrantyToEdit != null ? 'ACTUALIZAR' : 'GUARDAR EN BÓVEDA',
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
              color: Colors.black87,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        state.status == WarrantyFormStatus.processing
                            ? 'Analizando recibo con IA...'
                            : 'Guardando garantía...',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.status == WarrantyFormStatus.processing
                            ? 'Detectando precio y fecha'
                            : 'Por favor espera un momento',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}