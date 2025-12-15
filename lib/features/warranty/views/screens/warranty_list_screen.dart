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
          title: _searchQuery.isEmpty
              ? const Text(
                  'Bóveda de Garantías',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Buscar...',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
          ),
          actions: [
            IconButton(
              icon: Icon(_searchQuery.isEmpty ? Icons.search_rounded : Icons.close_rounded),
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
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Activas', icon: Icon(Icons.check_circle_outline_rounded)),
              Tab(text: 'Vencidas', icon: Icon(Icons.history_rounded)),
            ],
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CaptureWarrantyScreen()),
                );
                // Refrescar la lista cuando vuelve de crear
                ref.read(warrantyListProvider.notifier).refresh();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Escanear',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          onDelete: () => _confirmDelete(context, warranty.id),
          onEdit: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CaptureWarrantyScreen(warrantyToEdit: warranty),
              ),
            );
            // Refrescar la lista cuando vuelve de editar
            ref.read(warrantyListProvider.notifier).refresh();
          },
        );
      },
    );
  }
}
