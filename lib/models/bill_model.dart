
class BillServiceDescriptionModel {
  int slno;
  String description;
  String proposedToSolve;
  int quantity;
  double rate;
  double total;

  BillServiceDescriptionModel(
      {this.slno,
        this.description,
        this.proposedToSolve,
        this.quantity,
        this.rate,
        this.total});
}

class ServiceBillModel {
  int userId;
  int orderId;
  List<BillServiceDescriptionModel> serviceDescriptions;
  String serviceCharge;
  String partsCharge;
  String extraHourCharge;
  String miscellaneousCharge;
  String totalCharges;
  String grandTotalCharges;
  ServiceBillModel(
      {this.userId,
        this.orderId,
        this.serviceDescriptions,
        this.serviceCharge,
        this.partsCharge,
        this.extraHourCharge,
        this.miscellaneousCharge,
        this.totalCharges,
        this.grandTotalCharges});
}