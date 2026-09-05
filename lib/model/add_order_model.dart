class AddOrderModel {
  String? name;
  String? owner;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? namingSeries;
  String? customer;
  String? customerName;
  String? orderType;
  String? transactionDate;
  String? deliveryDate;
  String? terms;

  int? skipDeliveryNote;
  int? isReverseCharge;
  int? isExportWithGst;
  String? currency;
  double? conversionRate;
  String? sellingPriceList;
  String? priceListCurrency;
  double? plcConversionRate;
  int? ignorePricingRule;
  String? setWarehouse;
  double? totalQty;
  double? totalNetWeight;
  double? baseTotal;
  double? baseNetTotal;
  double? total;
  double? netTotal;
  String? taxCategory;
  String? taxesAndCharges;
  double? baseTotalTaxesAndCharges;
  double? totalTaxesAndCharges;
  double? baseGrandTotal;
  double? baseRoundingAdjustment;
  double? baseRoundedTotal;
  String? baseInWords;
  double? grandTotal;
  double? roundingAdjustment;
  double? roundedTotal;
  String? inWords;
  double? advancePaid;
  int? disableRoundedTotal;
  String? applyDiscountOn;
  double? baseDiscountAmount;
  double? additionalDiscountPercentage;
  double? discountAmount;
  String? otherChargesCalculation;
  String? customerAddress;
  String? addressDisplay;
  String? billingAddressGstin;
  String? gstCategory;
  String? placeOfSupply;
  String? customerGroup;
  String? territory;
  String? companyAddress;
  String? companyGstin;
  String? companyAddressDisplay;
  String? status;
  String? deliveryStatus;
  String? billingStatus;
  double? amountEligibleForCommission;
  String? language;
  int? isInternalCustomer;
  String? doctype;
  List<PaymentSchedule>? paymentSchedule;
  List<Items>? items;
  List<Taxes>? taxes;

  AddOrderModel(
      {this.name,
      this.owner,
      this.modifiedBy,
      this.docstatus,
      this.idx,
      this.namingSeries,
      this.customer,
      this.customerName,
      this.orderType,
      this.transactionDate,
      this.deliveryDate,
        this.terms,
      this.skipDeliveryNote,
      this.isReverseCharge,
      this.isExportWithGst,
      this.currency,
      this.conversionRate,
      this.sellingPriceList,
      this.priceListCurrency,
      this.plcConversionRate,
      this.ignorePricingRule,
      this.setWarehouse,
      this.totalQty,
      this.totalNetWeight,
      this.baseTotal,
      this.baseNetTotal,
      this.total,
      this.netTotal,
      this.taxCategory,
      this.taxesAndCharges,
      this.baseTotalTaxesAndCharges,
      this.totalTaxesAndCharges,
      this.baseGrandTotal,
      this.baseRoundingAdjustment,
      this.baseRoundedTotal,
      this.baseInWords,
      this.grandTotal,
      this.roundingAdjustment,
      this.roundedTotal,
      this.inWords,
      this.advancePaid,
      this.disableRoundedTotal,
      this.applyDiscountOn,
      this.baseDiscountAmount,
      this.additionalDiscountPercentage,
      this.discountAmount,
      this.otherChargesCalculation,
      this.customerAddress,
      this.addressDisplay,
      this.billingAddressGstin,
      this.gstCategory,
      this.placeOfSupply,
      this.customerGroup,
      this.territory,
      this.companyAddress,
      this.companyGstin,
      this.companyAddressDisplay,
      this.status,
      this.deliveryStatus,
      this.billingStatus,
      this.amountEligibleForCommission,
      this.language,
      this.isInternalCustomer,
      this.doctype,
      this.paymentSchedule,
      this.items,
      this.taxes});

  AddOrderModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    namingSeries = json['naming_series'];
    customer = json['customer'];
    customerName = json['customer_name'];
    orderType = json['order_type'];
    transactionDate = json['transaction_date'];
    deliveryDate = json['delivery_date'];
    terms = json['terms'];

    skipDeliveryNote = json['skip_delivery_note'];
    isReverseCharge = json['is_reverse_charge'];
    isExportWithGst = json['is_export_with_gst'];
    currency = json['currency'];
    conversionRate = json['conversion_rate'];
    sellingPriceList = json['selling_price_list'];
    priceListCurrency = json['price_list_currency'];
    plcConversionRate = json['plc_conversion_rate'];
    ignorePricingRule = json['ignore_pricing_rule'];
    setWarehouse = json['set_warehouse'];
    totalQty = json['total_qty'];
    totalNetWeight = json['total_net_weight'];
    baseTotal = json['base_total'];
    baseNetTotal = json['base_net_total'];
    total = json['total'];
    netTotal = json['net_total'];
    taxCategory = json['tax_category'];
    taxesAndCharges = json['taxes_and_charges'];
    baseTotalTaxesAndCharges = json['base_total_taxes_and_charges'];
    totalTaxesAndCharges = json['total_taxes_and_charges'];
    baseGrandTotal = json['base_grand_total'];
    baseRoundingAdjustment = json['base_rounding_adjustment'];
    baseRoundedTotal = json['base_rounded_total'];
    baseInWords = json['base_in_words'];
    grandTotal = json['grand_total'];
    roundingAdjustment = json['rounding_adjustment'];
    roundedTotal = json['rounded_total'];
    inWords = json['in_words'];
    advancePaid = json['advance_paid'];
    disableRoundedTotal = json['disable_rounded_total'];
    applyDiscountOn = json['apply_discount_on'];
    baseDiscountAmount = json['base_discount_amount'];
    additionalDiscountPercentage = json['additional_discount_percentage'];
    discountAmount = json['discount_amount'];
    otherChargesCalculation = json['other_charges_calculation'];
    customerAddress = json['customer_address'];
    addressDisplay = json['address_display'];
    billingAddressGstin = json['billing_address_gstin'];
    gstCategory = json['gst_category'];
    placeOfSupply = json['place_of_supply'];
    customerGroup = json['customer_group'];
    territory = json['territory'];
    companyAddress = json['company_address'];
    companyGstin = json['company_gstin'];
    companyAddressDisplay = json['company_address_display'];
    status = json['status'];
    deliveryStatus = json['delivery_status'];
    billingStatus = json['billing_status'];
    amountEligibleForCommission = json['amount_eligible_for_commission'];
    language = json['language'];
    isInternalCustomer = json['is_internal_customer'];
    doctype = json['doctype'];
    if (json['payment_schedule'] != null) {
      paymentSchedule = <PaymentSchedule>[];
      json['payment_schedule'].forEach((v) {
        paymentSchedule!.add(PaymentSchedule.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    if (json['taxes'] != null) {
      taxes = <Taxes>[];
      json['taxes'].forEach((v) {
        taxes!.add(Taxes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['owner'] = owner;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['naming_series'] = namingSeries;
    data['customer'] = customer;
    data['customer_name'] = customerName;
    data['order_type'] = orderType;
    data['transaction_date'] = transactionDate;
    data['delivery_date'] = deliveryDate;
    data['terms'] = terms;
    data['skip_delivery_note'] = skipDeliveryNote;
    data['is_reverse_charge'] = isReverseCharge;
    data['is_export_with_gst'] = isExportWithGst;
    data['currency'] = currency;
    data['conversion_rate'] = conversionRate;
    data['selling_price_list'] = sellingPriceList;
    data['price_list_currency'] = priceListCurrency;
    data['plc_conversion_rate'] = plcConversionRate;
    data['ignore_pricing_rule'] = ignorePricingRule;
    data['set_warehouse'] = setWarehouse;
    data['total_qty'] = totalQty;
    data['total_net_weight'] = totalNetWeight;
    data['base_total'] = baseTotal;
    data['base_net_total'] = baseNetTotal;
    data['total'] = total;
    data['net_total'] = netTotal;
    data['tax_category'] = taxCategory;
    data['taxes_and_charges'] = taxesAndCharges;
    data['base_total_taxes_and_charges'] = baseTotalTaxesAndCharges;
    data['total_taxes_and_charges'] = totalTaxesAndCharges;
    data['base_grand_total'] = baseGrandTotal;
    data['base_rounding_adjustment'] = baseRoundingAdjustment;
    data['base_rounded_total'] = baseRoundedTotal;
    data['base_in_words'] = baseInWords;
    data['grand_total'] = grandTotal;
    data['rounding_adjustment'] = roundingAdjustment;
    data['rounded_total'] = roundedTotal;
    data['in_words'] = inWords;
    data['advance_paid'] = advancePaid;
    data['disable_rounded_total'] = disableRoundedTotal;
    data['apply_discount_on'] = applyDiscountOn;
    data['base_discount_amount'] = baseDiscountAmount;
    data['additional_discount_percentage'] = additionalDiscountPercentage;
    data['discount_amount'] = discountAmount;
    data['other_charges_calculation'] = otherChargesCalculation;
    data['customer_address'] = customerAddress;
    data['address_display'] = addressDisplay;
    data['billing_address_gstin'] = billingAddressGstin;
    data['gst_category'] = gstCategory;
    data['place_of_supply'] = placeOfSupply;
    data['customer_group'] = customerGroup;
    data['territory'] = territory;
    data['company_address'] = companyAddress;
    data['company_gstin'] = companyGstin;
    data['company_address_display'] = companyAddressDisplay;
    data['status'] = status;
    data['delivery_status'] = deliveryStatus;
    data['billing_status'] = billingStatus;
    data['amount_eligible_for_commission'] = amountEligibleForCommission;
    data['language'] = language;
    data['is_internal_customer'] = isInternalCustomer;
    data['doctype'] = doctype;
    if (paymentSchedule != null) {
      data['payment_schedule'] =
          paymentSchedule!.map((v) => v.toJson()).toList();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentSchedule {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? dueDate;
  double? invoicePortion;
  double? discount;
  double? paymentAmount;
  double? outstanding;
  double? paidAmount;
  double? discountedAmount;
  double? basePaymentAmount;
  String? parent;
  String? parentfield;
  String? parenttype;
  String? doctype;

  PaymentSchedule(
      {this.name,
      this.creation,
      this.modified,
      this.modifiedBy,
      this.docstatus,
      this.idx,
      this.dueDate,
      this.invoicePortion,
      this.discount,
      this.paymentAmount,
      this.outstanding,
      this.paidAmount,
      this.discountedAmount,
      this.basePaymentAmount,
      this.parent,
      this.parentfield,
      this.parenttype,
      this.doctype});

  PaymentSchedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    dueDate = json['due_date'];
    invoicePortion = json['invoice_portion'];
    discount = json['discount'];
    paymentAmount = json['payment_amount'];
    outstanding = json['outstanding'];
    paidAmount = json['paid_amount'];
    discountedAmount = json['discounted_amount'];
    basePaymentAmount = json['base_payment_amount'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['due_date'] = dueDate;
    data['invoice_portion'] = invoicePortion;
    data['discount'] = discount;
    data['payment_amount'] = paymentAmount;
    data['outstanding'] = outstanding;
    data['paid_amount'] = paidAmount;
    data['discounted_amount'] = discountedAmount;
    data['base_payment_amount'] = basePaymentAmount;
    data['parent'] = parent;
    data['parentfield'] = parentfield;
    data['parenttype'] = parenttype;
    data['doctype'] = doctype;
    return data;
  }
}

class Items {
  String? name;
  String? owner;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? itemCode;
  int? ensureDeliveryBasedOnProducedSerialNo;
  String? deliveryDate;
  String? itemName;
  String? description;
  String? gstHsnCode;
  String? itemGroup;
  String? image;
  double? qty;
  String? stockUom;
  String? uom;
  double? conversionFactor;
  double? stockQty;
  double? priceListRate;
  double? discountPercentage;
  double? discountAmount;
  double? distributedDiscountAmount;
  double? baseRateWithMargin;
  double? rate;
  double? amount;
  String? itemTaxTemplate;
  double? baseRate;
  double? baseAmount;
  double? stockUomRate;
  int? isFreeItem;
  int? grantCommission;
  double? netRate;
  double? netAmount;
  double? baseNetRate;
  double? baseNetAmount;
  double? billedAmt;
  double? valuationRate;
  double? grossProfit;
  int? deliveredBySupplier;
  double? weightPerUnit;
  double? totalWeight;
  String? warehouse;
  int? againstBlanketOrder;
  double? blanketOrderRate;
  double? projectedQty;
  double? actualQty;
  double? orderedQty;
  double? plannedQty;
  double? productionPlanQty;
  double? workOrderQty;
  double? deliveredQty;
  double? producedQty;
  double? returnedQty;
  String? itemTaxRate;
  String? transactionDate;
  String? parent;
  String? parentfield;
  String? parenttype;
  String? doctype;

  Items(
      {this.name,
      this.owner,
      this.modifiedBy,
      this.docstatus,
      this.idx,
      this.itemCode,
      this.ensureDeliveryBasedOnProducedSerialNo,
      this.deliveryDate,
      this.itemName,
      this.description,
      this.gstHsnCode,
      this.itemGroup,
      this.image,
      this.qty,
      this.stockUom,
      this.uom,
      this.conversionFactor,
      this.stockQty,
      this.priceListRate,
      this.discountPercentage,
      this.discountAmount,
      this.distributedDiscountAmount,
      this.baseRateWithMargin,
      this.rate,
      this.amount,
      this.itemTaxTemplate,
      this.baseRate,
      this.baseAmount,
      this.stockUomRate,
      this.isFreeItem,
      this.grantCommission,
      this.netRate,
      this.netAmount,
      this.baseNetRate,
      this.baseNetAmount,
      this.billedAmt,
      this.valuationRate,
      this.grossProfit,
      this.deliveredBySupplier,
      this.weightPerUnit,
      this.totalWeight,
      this.warehouse,
      this.againstBlanketOrder,
      this.blanketOrderRate,
      this.projectedQty,
      this.actualQty,
      this.orderedQty,
      this.plannedQty,
      this.productionPlanQty,
      this.workOrderQty,
      this.deliveredQty,
      this.producedQty,
      this.returnedQty,
      this.itemTaxRate,
      this.transactionDate,
      this.parent,
      this.parentfield,
      this.parenttype,
      this.doctype});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    itemCode = json['item_code'];
    ensureDeliveryBasedOnProducedSerialNo =
        json['ensure_delivery_based_on_produced_serial_no'];
    deliveryDate = json['delivery_date'];
    itemName = json['item_name'];
    description = json['description'];
    gstHsnCode = json['gst_hsn_code'];
    itemGroup = json['item_group'];
    image = json['image'];
    qty = json['qty'];
    stockUom = json['stock_uom'];
    uom = json['uom'];
    conversionFactor = json['conversion_factor'];
    stockQty = json['stock_qty'];
    priceListRate = json['price_list_rate'];
    discountPercentage = json['discount_percentage'];
    discountAmount = json['discount_amount'];
    distributedDiscountAmount = json['distributed_discount_amount'];
    baseRateWithMargin = json['base_rate_with_margin'];
    rate = json['rate'];
    amount = json['amount'];
    itemTaxTemplate = json['item_tax_template'];
    baseRate = json['base_rate'];
    baseAmount = json['base_amount'];
    stockUomRate = json['stock_uom_rate'];
    isFreeItem = json['is_free_item'];
    grantCommission = json['grant_commission'];
    netRate = json['net_rate'];
    netAmount = json['net_amount'];
    baseNetRate = json['base_net_rate'];
    baseNetAmount = json['base_net_amount'];
    billedAmt = json['billed_amt'];
    valuationRate = json['valuation_rate'];
    grossProfit = json['gross_profit'];
    deliveredBySupplier = json['delivered_by_supplier'];
    weightPerUnit = json['weight_per_unit'];
    totalWeight = json['total_weight'];
    warehouse = json['warehouse'];
    againstBlanketOrder = json['against_blanket_order'];
    blanketOrderRate = json['blanket_order_rate'];
    projectedQty = json['projected_qty'];
    actualQty = json['actual_qty'];
    orderedQty = json['ordered_qty'];
    plannedQty = json['planned_qty'];
    productionPlanQty = json['production_plan_qty'];
    workOrderQty = json['work_order_qty'];
    deliveredQty = json['delivered_qty'];
    producedQty = json['produced_qty'];
    returnedQty = json['returned_qty'];
    itemTaxRate = json['item_tax_rate'];
    transactionDate = json['transaction_date'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['owner'] = owner;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['item_code'] = itemCode;
    data['ensure_delivery_based_on_produced_serial_no'] =
        ensureDeliveryBasedOnProducedSerialNo;
    data['delivery_date'] = deliveryDate;
    data['item_name'] = itemName;
    data['description'] = description;
    data['gst_hsn_code'] = gstHsnCode;
    data['item_group'] = itemGroup;
    data['image'] = image;
    data['qty'] = qty;
    data['stock_uom'] = stockUom;
    data['uom'] = uom;
    data['conversion_factor'] = conversionFactor;
    data['stock_qty'] = stockQty;
    data['price_list_rate'] = priceListRate;
    data['discount_percentage'] = discountPercentage;
    data['discount_amount'] = discountAmount;
    data['distributed_discount_amount'] = distributedDiscountAmount;
    data['base_rate_with_margin'] = baseRateWithMargin;
    data['rate'] = rate;
    data['amount'] = amount;
    data['item_tax_template'] = itemTaxTemplate;
    data['base_rate'] = baseRate;
    data['base_amount'] = baseAmount;
    data['stock_uom_rate'] = stockUomRate;
    data['is_free_item'] = isFreeItem;
    data['grant_commission'] = grantCommission;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['base_net_rate'] = baseNetRate;
    data['base_net_amount'] = baseNetAmount;
    data['billed_amt'] = billedAmt;
    data['valuation_rate'] = valuationRate;
    data['gross_profit'] = grossProfit;
    data['delivered_by_supplier'] = deliveredBySupplier;
    data['weight_per_unit'] = weightPerUnit;
    data['total_weight'] = totalWeight;
    data['warehouse'] = warehouse;
    data['against_blanket_order'] = againstBlanketOrder;
    data['blanket_order_rate'] = blanketOrderRate;
    data['projected_qty'] = projectedQty;
    data['actual_qty'] = actualQty;
    data['ordered_qty'] = orderedQty;
    data['planned_qty'] = plannedQty;
    data['production_plan_qty'] = productionPlanQty;
    data['work_order_qty'] = workOrderQty;
    data['delivered_qty'] = deliveredQty;
    data['produced_qty'] = producedQty;
    data['returned_qty'] = returnedQty;
    data['item_tax_rate'] = itemTaxRate;
    data['transaction_date'] = transactionDate;
    data['parent'] = parent;
    data['parentfield'] = parentfield;
    data['parenttype'] = parenttype;
    data['doctype'] = doctype;
    return data;
  }
}

class Taxes {
  String? name;
  String? owner;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? chargeType;
  String? accountHead;
  String? description;
  String? costCenter;
  double? rate;
  double? taxAmount;
  double? total;
  double? taxAmountAfterDiscountAmount;
  double? baseTaxAmount;
  double? baseTotal;
  double? baseTaxAmountAfterDiscountAmount;
  String? itemWiseTaxDetail;
  int? dontRecomputeTax;
  String? parent;
  String? parentfield;
  String? parenttype;
  String? doctype;

  Taxes(
      {this.name,
      this.owner,
      this.modifiedBy,
      this.docstatus,
      this.idx,
      this.chargeType,
      this.accountHead,
      this.description,
      this.costCenter,
      this.rate,
      this.taxAmount,
      this.total,
      this.taxAmountAfterDiscountAmount,
      this.baseTaxAmount,
      this.baseTotal,
      this.baseTaxAmountAfterDiscountAmount,
      this.itemWiseTaxDetail,
      this.dontRecomputeTax,
      this.parent,
      this.parentfield,
      this.parenttype,
      this.doctype});

  Taxes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    chargeType = json['charge_type'];
    accountHead = json['account_head'];
    description = json['description'];
    costCenter = json['cost_center'];
    rate = json['rate'];
    taxAmount = json['tax_amount'];
    total = json['total'];
    taxAmountAfterDiscountAmount = json['tax_amount_after_discount_amount'];
    baseTaxAmount = json['base_tax_amount'];
    baseTotal = json['base_total'];
    baseTaxAmountAfterDiscountAmount =
        json['base_tax_amount_after_discount_amount'];
    itemWiseTaxDetail = json['item_wise_tax_detail'];
    dontRecomputeTax = json['dont_recompute_tax'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['owner'] = owner;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['charge_type'] = chargeType;
    data['account_head'] = accountHead;
    data['description'] = description;
    data['cost_center'] = costCenter;
    data['rate'] = rate;
    data['tax_amount'] = taxAmount;
    data['total'] = total;
    data['tax_amount_after_discount_amount'] = taxAmountAfterDiscountAmount;
    data['base_tax_amount'] = baseTaxAmount;
    data['base_total'] = baseTotal;
    data['base_tax_amount_after_discount_amount'] =
        baseTaxAmountAfterDiscountAmount;
    data['item_wise_tax_detail'] = itemWiseTaxDetail;
    data['dont_recompute_tax'] = dontRecomputeTax;
    data['parent'] = parent;
    data['parentfield'] = parentfield;
    data['parenttype'] = parenttype;
    data['doctype'] = doctype;
    return data;
  }
}

class Masters {
  List<String>? customers;
  List<Items>? items;
  List<String>? warehouses;

  Masters({this.customers, this.items, this.warehouses});

  Masters.fromJson(Map<String, dynamic> json) {
    customers = json['customers'].cast<String>();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    warehouses = json['warehouses'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customers'] = this.customers;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['warehouses'] = this.warehouses;
    return data;
  }
}
