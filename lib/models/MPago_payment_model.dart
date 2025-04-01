class MPagoPaymentModel {
  String? accountsInfo;
  String? authorizationCode;
  int? collectorId;
  double? couponAmount;
  String? currencyId;
  String? description;
  String? externalReference;
  int? id;
  int? marketplaceOwner;
  String? moneyReleaseStatus;
  String? operationType;
  String? paymentMethodId;
  String? paymentTypeId;
  String? posId;
  double? shippingAmount;
  String? statementDescriptor;
  String? status;
  String? statusDetail;
  String? storeId;
  double? taxesAmount;
  double? transactionAmount;
  double? transactionAmountRefunded;

  MPagoPaymentModel(
      {required this.accountsInfo,
      required this.authorizationCode,
      required this.collectorId,
      required this.couponAmount,
      required this.currencyId,
      required this.description,
      required this.externalReference,
      required this.id,
      required this.marketplaceOwner,
      required this.moneyReleaseStatus,
      required this.operationType,
      required this.paymentMethodId,
      required this.paymentTypeId,
      required this.posId,
      required this.shippingAmount,
      required this.statementDescriptor,
      required this.status,
      required this.statusDetail,
      required this.storeId,
      required this.taxesAmount,
      required this.transactionAmount,
      required this.transactionAmountRefunded});

  MPagoPaymentModel copyWith(
          {String? accountsInfo,
          String? authorizationCode,
          int? collectorId,
          double? couponAmount,
          String? currencyId,
          String? description,
          String? externalReference,
          int? id,
          int? marketplaceOwner,
          String? moneyReleaseStatus,
          String? operationType,
          String? paymentMethodId,
          String? paymentTypeId,
          String? posId,
          double? shippingAmount,
          String? statementDescriptor,
          String? status,
          String? statusDetail,
          String? storeId,
          double? taxesAmount,
          double? transactionAmount,
          double? transactionAmountRefunded}) =>
      MPagoPaymentModel(
          accountsInfo: accountsInfo ?? this.accountsInfo,
          authorizationCode: authorizationCode ?? this.authorizationCode,
          collectorId: collectorId ?? this.collectorId,
          couponAmount: couponAmount ?? this.couponAmount,
          currencyId: currencyId ?? this.currencyId,
          description: description ?? this.description,
          externalReference: externalReference ?? this.externalReference,
          id: id ?? this.id,
          marketplaceOwner: marketplaceOwner ?? this.marketplaceOwner,
          moneyReleaseStatus: moneyReleaseStatus ?? this.moneyReleaseStatus,
          operationType: operationType ?? this.operationType,
          paymentMethodId: paymentMethodId ?? this.paymentMethodId,
          paymentTypeId: paymentTypeId ?? this.paymentTypeId,
          posId: posId ?? this.posId,
          shippingAmount: shippingAmount ?? this.shippingAmount,
          statementDescriptor: statementDescriptor ?? this.statementDescriptor,
          status: status ?? this.status,
          statusDetail: statusDetail ?? this.statusDetail,
          storeId: storeId ?? this.storeId,
          taxesAmount: taxesAmount ?? this.taxesAmount,
          transactionAmount: transactionAmount ?? this.transactionAmount,
          transactionAmountRefunded:
              transactionAmountRefunded ?? this.transactionAmountRefunded);

  factory MPagoPaymentModel.fromJson(Map<String, dynamic> json) =>
      MPagoPaymentModel(
          accountsInfo: json["accounts_info"],
          authorizationCode: json["authorization_code"],
          collectorId: json["collector_id"],
          couponAmount: json["coupon_amount"].toDouble(),
          currencyId: json["currency_id"],
          description: json["description"],
          externalReference: json["external_reference"],
          id: json["id"],
          marketplaceOwner: json["marketplace_owner"],
          moneyReleaseStatus: json["money_release_status"],
          operationType: json["operation_type"],
          paymentMethodId: json["payment_method_id"],
          paymentTypeId: json["payment_type_id"],
          posId: json["pos_id"],
          shippingAmount: json["shipping_amount"].toDouble(),
          statementDescriptor: json["statement_descriptor"],
          status: json["status"],
          statusDetail: json["status_detail"],
          storeId: json["store_id"],
          taxesAmount: json["taxes_amount"].toDouble(),
          transactionAmount: json["transaction_amount"].toDouble(),
          transactionAmountRefunded:
              json["transaction_amount_refunded"].toDouble());

  Map<String, dynamic> toJson() => {
        "accounts_info": accountsInfo,
        "authorization_code": authorizationCode,
        "collector_id": collectorId,
        "coupon_amount": couponAmount,
        "currency_id": currencyId,
        "description": description,
        "external_reference": externalReference,
        "id": id,
        "marketplace_owner": marketplaceOwner,
        "money_release_status": moneyReleaseStatus,
        "operation_type": operationType,
        "payment_method_id": paymentMethodId,
        "payment_type_id": paymentTypeId,
        "pos_id": posId,
        "shipping_amount": shippingAmount,
        "statement_descriptor": statementDescriptor,
        "status": status,
        "status_detail": statusDetail,
        "store_id": storeId,
        "taxes_amount": taxesAmount,
        "transaction_amount": transactionAmount,
        "transaction_amount_refunded": transactionAmountRefunded
      };
}
