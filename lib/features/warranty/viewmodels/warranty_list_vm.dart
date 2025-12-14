import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/providers.dart';
import '../models/warranty_model.dart';

part 'warranty_list_vm.g.dart';

@riverpod
class WarrantyList extends _$WarrantyList {
  @override
  FutureOr<List<WarrantyModel>> build() async {
    final repository = ref.watch(warrantyRepositoryProvider);
    final result = await repository.getWarranties();
    return result.fold(
          (failure) => [],
          (warranties) => warranties,
    );
  }

  Future<void> deleteWarranty(String id) async {
    final previousState = state;

    final currentList = state.valueOrNull ?? [];
    state = AsyncData(currentList.where((w) => w.id != id).toList());

    final repository = ref.read(warrantyRepositoryProvider);
    final result = await repository.deleteWarranty(id);

    result.fold(
          (failure) {
        state = previousState;
      },
          (_) {},
    );
  }
}