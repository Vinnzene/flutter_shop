class PurchaseHistoryItem {
  final String productId;
  final String productName;
  final String productPrice;
  final String productImage;
  final int quantity;
  final DateTime purchaseDate;

  PurchaseHistoryItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
    required this.purchaseDate,
  });
}
