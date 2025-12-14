import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/warranty_model.dart';
import '../../viewmodels/warranty_list_vm.dart';
import '../widgets/warranty_card.dart';
import 'capture_warranty_screen.dart';

class WarrantyListScreen extends ConsumerStatefulWidget {
  const WarrantyListScreen({super.key});

  @override
  ConsumerState<WarrantyListScreen> createState() => _WarrantyListScreenState();
}

class _WarrantyListScreenState extends ConsumerState<WarrantyListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar'),
        content: const Text('¿Eliminar permanentemente?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              ref.read(warrantyListProvider.notifier).deleteWarranty(id);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final warrantyListAsync = ref.watch(warrantyListProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _searchQuery.isEmpty
              ? const Text('Bóveda de Garantías')
              : TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: 'Buscar...',
              border: InputBorder.none,
            ),
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
          ),
          actions: [
            IconButton(
              icon: Icon(_searchQuery.isEmpty ? Icons.search : Icons.close),
              onPressed: () {
                setState(() {
                  if (_searchQuery.isEmpty) {
                    _searchQuery = ' ';
                  } else {
                    _searchQuery = '';
                    _searchController.clear();
                  }
                });
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Activas', icon: Icon(Icons.check_circle_outline)),
              Tab(text: 'Vencidas', icon: Icon(Icons.history)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CaptureWarrantyScreen()),
            );
          },
          label: const Text('Escanear'),
          icon: const Icon(Icons.camera_alt_outlined),
        ),
        body: warrantyListAsync.when(
          data: (allWarranties) {
            final filtered = allWarranties.where((w) {
              return w.productName.toLowerCase().contains(_searchQuery.trim());
            }).toList();

            final now = DateTime.now();
            final active = filtered.where((w) => w.expiryDate.isAfter(now)).toList();
            final expired = filtered.where((w) => w.expiryDate.isBefore(now)).toList();

            return TabBarView(
              children: [
                _buildList(active),
                _buildList(expired),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildList(List<WarrantyModel> warranties) {
    if (warranties.isEmpty) return const Center(child: Text("Sin registros"));
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: warranties.length,
      itemBuilder: (ctx, i) {
        final warranty = warranties[i];
        return WarrantyCard(
          warranty: warranty,
          onTap: () => _confirmDelete(context, warranty.id),
        );
      },
    );
  }
}