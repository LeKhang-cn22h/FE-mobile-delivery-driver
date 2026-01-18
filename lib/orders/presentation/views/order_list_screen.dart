import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/order_list_viewmodel.dart';
import '../../domain/entities/order_entity.dart';
import 'widgets/order_item_card.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  OrderStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OrderListViewmodel>().loadOrders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đơn hàng'),
        elevation: 0,
      ),
      body: Consumer<OrderListViewmodel>(
        builder: (_, viewmodel, __) {
          if (viewmodel.loading && viewmodel.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewmodel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: ${viewmodel.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewmodel.loadOrders,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // ✅ Filter danh sách đơn
          final filteredOrders = _selectedFilter == null
              ? viewmodel.orders
              : viewmodel.orders
                  .where((o) => o.status == _selectedFilter)
                  .toList();

          if (filteredOrders.isEmpty) {
            return Center(
              child: Text(
                'Không có đơn hàng ${_getFilterLabel(_selectedFilter)}',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              // ✅ THÊM TAB FILTER
              _buildFilterTabs(),

              // Danh sách
              Expanded(
                child: RefreshIndicator(
                  onRefresh: viewmodel.loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredOrders.length,
                    itemBuilder: (_, index) {
                      final order = filteredOrders[index];
                      return OrderItemCard(
                        order: order,
                        disabled: viewmodel.updatingId == order.id,
                        onChangeStatus: (status, {note}) async{
                          if (status.name == 'cancelled') {
                            await viewmodel.cancelOrderWithNote(order.id, note ?? '');
                          } else {
                            viewmodel.completeOrder(order.id);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //  TAB FILTER
  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          _buildFilterButton(
            label: 'Tất cả',
            isSelected: _selectedFilter == null,
            onTap: () => setState(() => _selectedFilter = null),
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            label: 'Chờ giao',
            isSelected: _selectedFilter == OrderStatus.pending,
            onTap: () => setState(() => _selectedFilter = OrderStatus.pending),
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            label: 'Đã giao',
            isSelected: _selectedFilter == OrderStatus.completed,
            onTap: () =>
                setState(() => _selectedFilter = OrderStatus.completed),
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            label: 'Đã hủy',
            isSelected: _selectedFilter == OrderStatus.cancelled,
            onTap: () =>
                setState(() => _selectedFilter = OrderStatus.cancelled),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  //  BUTTON FILTER
  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey[200],
      selectedColor: color.withOpacity(0.3),
      side: BorderSide(
        color: isSelected ? color : Colors.transparent,
        width: 2,
      ),
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  //  LẤY LABEL FILTER
  String _getFilterLabel(OrderStatus? status) {
    if (status == null) return '';
    switch (status) {
      case OrderStatus.pending:
        return 'chờ giao';
      case OrderStatus.completed:
        return 'đã giao';
      case OrderStatus.cancelled:
        return 'đã hủy';
    }
  }
}
