import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/qoffa_colors.dart';
import '../../../app/theme/qoffa_tokens.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/widgets/qoffa_button.dart';
import '../../insights/domain/services/typical_price_engine.dart';
import '../../products/data/product_repository.dart';
import '../../purchases/data/purchase_repository.dart';

class ProductDetailsModal extends ConsumerWidget {
  const ProductDetailsModal({required this.productId, super.key});

  final String productId;

  static void show(BuildContext context, {required String productId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailsModal(productId: productId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productRepo = ref.watch(productRepositoryProvider);
    final purchaseRepo = ref.watch(purchaseRepositoryProvider);

    final productFuture = productRepo.getProductById(productId);
    final purchasesFuture = purchaseRepo.getPurchasesForProduct(productId);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(QoffaTokens.radiusMajor)),
      ),
      child: FutureBuilder(
        future: Future.wait([productFuture, purchasesFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: QoffaColors.brandGreen));
          }

          final product = snapshot.data?[0];
          final purchases = (snapshot.data?[1] as List?) ?? [];

          if (product == null) {
            return const Center(child: Text('Product not found'));
          }

          final prices = purchases
              .map((p) => DzdAmount(p.priceDzd as int))
              .toList()
              .cast<DzdAmount>();
          final typicalRange = TypicalPriceEngine.calculate(prices);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name as String,
                          style: const TextStyle(
                            fontFamily: 'Hero Sandwich Pro',
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: QoffaColors.primaryNavy,
                          ),
                        ),
                        if (product.brand != null)
                          Text(
                            product.brand as String,
                            style: const TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 13,
                              color: QoffaColors.secondarySage,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: QoffaColors.secondarySage),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: QoffaColors.mintSurfaceTint,
                  borderRadius: BorderRadius.circular(QoffaTokens.radiusCompact),
                  border: Border.all(color: QoffaColors.softBorder, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('آخر سعر', style: TextStyle(fontFamily: 'Alexandria', fontSize: 12, color: QoffaColors.secondarySage)),
                        const SizedBox(height: 4),
                        Text(
                          product.lastPriceDzd != null ? '${product.lastPriceDzd} DA' : 'غير مسجل',
                          style: const TextStyle(fontFamily: 'Hero Sandwich Pro', fontSize: 20, fontWeight: FontWeight.w900, color: QoffaColors.brandGreen),
                        ),
                      ],
                    ),
                    Container(height: 36, width: 1, color: QoffaColors.softBorder),
                    Column(
                      children: [
                        const Text('النطاق المعتاد', style: TextStyle(fontFamily: 'Alexandria', fontSize: 12, color: QoffaColors.secondarySage)),
                        const SizedBox(height: 4),
                        Text(
                          typicalRange != null
                              ? '${typicalRange.minPrice.dinars} - ${typicalRange.maxPrice.dinars} DA'
                              : 'يحتاج 3 مشتريات',
                          style: const TextStyle(fontFamily: 'Hero Sandwich Pro', fontSize: 16, fontWeight: FontWeight.w800, color: QoffaColors.primaryNavy),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Purchase History List
              const Text(
                'تاريخ المشتريات السابقة',
                style: TextStyle(fontFamily: 'Hero Sandwich Pro', fontSize: 16, fontWeight: FontWeight.w800, color: QoffaColors.primaryNavy),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: purchases.isEmpty
                    ? const Center(child: Text('لا توجد مشتريات سابقة مسجلة', style: TextStyle(fontFamily: 'Alexandria', color: QoffaColors.secondarySage)))
                    : ListView.separated(
                        itemCount: purchases.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, color: QoffaColors.softBorder),
                        itemBuilder: (context, idx) {
                          final p = purchases[idx];
                          return Material(
                            color: Colors.transparent,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('${p.priceDzd} DA / ${p.unitId}', style: const TextStyle(fontFamily: 'Hero Sandwich Pro', fontWeight: FontWeight.w800)),
                              subtitle: Text('${p.quantity} ${p.unitId} · ${p.localDate}', style: const TextStyle(fontFamily: 'Alexandria', fontSize: 12, color: QoffaColors.secondarySage)),
                              trailing: Text('${p.totalDzd} DA', style: const TextStyle(fontFamily: 'Hero Sandwich Pro', fontSize: 16, fontWeight: FontWeight.bold, color: QoffaColors.brandGreen)),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 14),
              QoffaButton(
                label: 'تسجيل شراء لهذا المنتج',
                icon: Icons.add_shopping_cart_rounded,
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/add-purchase');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
