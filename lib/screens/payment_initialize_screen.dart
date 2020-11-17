

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:billGeneration/models/bill_model.dart';
import 'package:billGeneration/constants.dart';

class PaymentInitializeScreen extends StatefulWidget {
  final ServiceBillModel serviceBill;
  PaymentInitializeScreen({@required this.serviceBill});
  @override
  _PaymentInitializeScreenState createState() =>
      _PaymentInitializeScreenState(serviceBill);
}

class _PaymentInitializeScreenState extends State<PaymentInitializeScreen> {
  final ServiceBillModel serviceBill;
  _PaymentInitializeScreenState(this.serviceBill);

  ///Service description table header text style
  final descriptionTableHeaderTextStyle =
      TextStyle(fontWeight: FontWeight.bold);

  bool amountPaid = false;

  @override
  void initState() {
    super.initState();
    displayServiceBill();
  }

  void displayServiceBill() {
    print('userid : ${serviceBill.userId}');
    print('orderid : ${serviceBill.orderId}');
    print('servidesc list : ${serviceBill.serviceDescriptions}');
    print('totalCharges : ${serviceBill.totalCharges}');
    print('grandTotalCharges : ${serviceBill.grandTotalCharges}');
    print('serviceCharge : ${serviceBill.serviceCharge}');
    print('partsCharge : ${serviceBill.partsCharge}');
    print('extraHourCharge : ${serviceBill.extraHourCharge}');
    print('miscellaneousCharge : ${serviceBill.miscellaneousCharge}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              displayTotal(),
              displayPaymentOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayTotal() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Total to pay (Rs.) : '),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(serviceBill.grandTotalCharges),
          ),
        ],
      ),
    );
  }

  displayPaymentOptions(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal :20.0, vertical: 8.0),
            child: FlatButton(
              padding: EdgeInsets.all(15.0),
              color: foregroundColor,
              onPressed: () {},
              child: Text('Pay by wallet', style: buttonTextStyle.copyWith(fontSize: 14),),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal :20.0, vertical: 8.0),
            child: FlatButton(
              padding: EdgeInsets.all(15.0),
              color: foregroundColor,
              onPressed: () {},
              child: Text('Pay by UPI', style: buttonTextStyle.copyWith(fontSize: 14),),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal :20.0, vertical: 8.0),
            child: FlatButton(
              padding: EdgeInsets.all(15.0),
              color: foregroundColor,
              onPressed: () async{
                amountPaid = await Navigator.push(context, MaterialPageRoute(builder: (context)=>PayByCashScreen(serviceBill: serviceBill,),),);
              },
              child: Text('Pay by cash', style: buttonTextStyle.copyWith(fontSize: 14),),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayExtraCharges() {
    return Container(
      child: Column(
        children: [
          Table(
            children: [
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Total (Rs.) : '),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(serviceBill.totalCharges.toString()),
                ),
              ])
            ],
          ),
          Table(
            children: [
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Service Charge (Rs.) : ',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(serviceBill.serviceCharge.toString()),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Parts Charge (Rs.) : ',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(serviceBill.partsCharge.toString()),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Extra Hour charge (Rs.) : ',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(serviceBill.extraHourCharge.toString()),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Miscellaneous Charge (Rs.) : ',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    serviceBill.miscellaneousCharge.toString(),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Grand Total (Rs.) : ',
                    style: descriptionTableHeaderTextStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    serviceBill.grandTotalCharges.toString(),
                    style: descriptionTableHeaderTextStyle,
                  ),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }
}


class PayByCashScreen extends StatelessWidget {
  final ServiceBillModel serviceBill;
  PayByCashScreen({this.serviceBill});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay by cash'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.0),
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Total to pay (Rs.) : '),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(serviceBill.grandTotalCharges),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal :20.0, vertical: 8.0),
                child: FlatButton(
                  padding: EdgeInsets.all(15.0),
                  color: foregroundColor,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Cash Paid', style: buttonTextStyle.copyWith(fontSize: 14),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

