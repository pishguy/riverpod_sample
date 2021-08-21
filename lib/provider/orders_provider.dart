import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderStateNotifierProvider = StateNotifierProvider<OrderNotifier, OrderStructure>((ref) => OrderNotifier());

class OrderNotifier extends StateNotifier<OrderStructure> {
  OrderNotifier() : super(_initial);
  static OrderStructure _initial = OrderStructure('', []);

  void resetOrder() {
    _initial = const OrderStructure('', []);
  }

  void clearAll()=>state = OrderStructure('', []);

  List<SelectedProductServices> getServices({int productId = 1}) {
    final index = state.products.indexWhere((product) => product.id == productId);
    return index >= 0 ? state.products[index].services : <SelectedProductServices>[];
  }

  void increment({required int productId, required int serviceId, required int serviceCost}) {
    final newState = OrderStructure(state.title, []);
    for (final product in state.products) {
      if (product.id == productId) {
        if (product.services.any((s) => s.id == serviceId)) {
          final service = product.services.firstWhere((s) => s.id == serviceId);
          newState.products.add(SelectedProducts(productId, [
            ...product.services.where((s) => s.id != serviceId),
            SelectedProductServices(service.id, service.count + 1, service.cost)
          ]));
        } else {
          newState.products.add(
              SelectedProducts(productId, [...product.services, SelectedProductServices(serviceId, 1, serviceCost)]));
        }
      } else {
        newState.products.add(product);
      }
    }
    if (!newState.products.any((p) => p.id == productId) ||
        !newState.products.firstWhere((p) => p.id == productId).services.any((s) => s.id == serviceId)) {
      newState.products.add(SelectedProducts(productId, [SelectedProductServices(serviceId, 1, serviceCost)]));
    }
    state = newState;
  }

  void decrement({required int productId, required int serviceId}) {
    final newState = OrderStructure(state.title, [
      ...state.products,
      for (final product in state.products)
        if (product.id == productId)
          for (final service in product.services)
            if (service.id == serviceId)
              SelectedProducts(productId,
                  [...product.services, SelectedProductServices(service.id, service.count - 1, service.cost)])
            else
              product
    ]);

    state = newState;
  }
}

class OrderStructure {
  final String title;
  final List<SelectedProducts> products;

  const OrderStructure(this.title, this.products);
}

class SelectedProducts {
  final int id;
  final List<SelectedProductServices> services;

  SelectedProducts(this.id, this.services);
}

class SelectedProductServices {
  final int id;
  final int count;
  final int cost;

  const SelectedProductServices(this.id, this.count, this.cost);
}
