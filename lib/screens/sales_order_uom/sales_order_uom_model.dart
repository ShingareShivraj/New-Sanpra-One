class UomOption {
  final String uom;
  final double conversionFactor;

  UomOption({
    required this.uom,
    required this.conversionFactor,
  });

  factory UomOption.fromJson(Map<String, dynamic> json) {
    return UomOption(
      uom: json['uom']?.toString() ?? '',
      conversionFactor:
      double.tryParse(json['conversion_factor']?.toString() ?? '') ?? 1,
    );
  }
}

class UomItem {
  final String itemCode;
  final String itemName;
  final String? image;
  final String stockUom;
  final List<UomOption> uoms;

  UomItem({
    required this.itemCode,
    required this.itemName,
    this.image,
    required this.stockUom,
    required this.uoms,
  });

  factory UomItem.fromJson(Map<String, dynamic> json) {
    return UomItem(
      itemCode: json['item_code']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      image: json['image']?.toString(),
      stockUom: json['stock_uom']?.toString() ?? '',
      uoms: (json['uoms'] as List? ?? [])
          .map(
            (e) => UomOption.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
    );
  }
}

class UomOrderItem {
  final UomItem item;

  UomOption? selectedUom;
  double quantity;

  UomOrderItem({
    required this.item,
    this.selectedUom,
    this.quantity = 1,
  });

  String get displayUom {
    return selectedUom?.uom ?? item.stockUom;
  }

  double get conversionFactor {
    return selectedUom?.conversionFactor ?? 1;
  }
}