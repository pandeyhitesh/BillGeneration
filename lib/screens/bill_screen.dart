import 'package:billGeneration/screens/payment_initialize_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:billGeneration/models/bill_model.dart';
import 'package:billGeneration/constants.dart';
// import 'package:flutter/foundation.dart';

class BillScreen extends StatefulWidget {
  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final companyInfoTextStyle = TextStyle(
    fontSize: 10,
  );

  final tableHeaderStyle = TextStyle(
    fontSize: 12,
  );

  ///Bill service description

  BillServiceDescriptionModel serviceDescription =
      BillServiceDescriptionModel();
  List<BillServiceDescriptionModel> serviceDescriptions = [];
  ServiceBillModel serviceBill = ServiceBillModel();

  ///Focus nodes
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode propSolveFocusNode = FocusNode();
  FocusNode quantityFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();
  FocusNode totalFocusNode = FocusNode();
  FocusNode addChargesFocusNode = FocusNode();

  ///text editing controllers
  TextEditingController descriptionController = TextEditingController();
  TextEditingController propSolveController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '0');
  TextEditingController rateController = TextEditingController(text: '0.0');
  TextEditingController totalController = TextEditingController(text:  '0.0');
  TextEditingController addChargesController = TextEditingController(text: '0.0');

  ///display the input description when addServiceDescription button is pressed
  bool showInputServiceDescriptionForm = false;
  bool showInputServiceDescriptionButton = true;

  ///Service description table header text style
  final descriptionTableHeaderTextStyle =
      TextStyle(fontWeight: FontWeight.bold);

  ///additional charges category
  Map<String, double> chargesTypes = {
    'Service Charge': 0.0,
    'New Part Charge': 0.0,
    'Extra Hour Charge': 0.0,
    'Miscellaneous Charge': 0.0,
  };
  String dropdownValue = 'Service Charge';
  String chargeToAdd;

  List<TableRow> additionalChargesTableRows = [];

  ///total charge and grand total charge
  double total = 0.0;
  double grandTotal = 0.0;

  @override
  void initState() {
    super.initState();
    tableRows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Bill',
          style: buttonTextStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// display the company header
                displayBillHeader(),

                /// display customer and order details
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      displayPersonalInfoTable(),
                      displayOrderInfoTable(),
                      displayCustomerInfoTable(),
                    ],
                  ),
                ),

                /// display header saying 'To Be filled by the Professional'
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'To Be filled by the Professional',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),

                /// if there are serviceDescriptions present in the list, display the Service Description header
                serviceDescriptions.length >= 1
                    ? serviceDescriptionHeaderRow()
                    : Container(),

                /// if there are serviceDescriptions present in the list, display the Service Description table
                serviceDescriptionDataTable(),

                /// display input service description form on clicking AddServiceDescription button
                showInputServiceDescriptionForm
                    ? inputServicesDescription(context)
                    : Container(),

                /// display AddServiceDescription button
                showInputServiceDescriptionButton
                    ? addServiceDescriptionButton()
                    : Container(),

                SizedBox(
                  height: 30.0,
                ),

                ///add additional charges to the service
                addAdditionalChargesSection(),

                /// display the additional charges
                displayExtraCharges(),

                /// display the payment button
                paymentButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget displayBillHeader(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MKD Consultancy Services Pvt. Ltd. (MCS)',
                    style: companyInfoTextStyle.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sub-19, Plot.No-195, ',
                    style: companyInfoTextStyle,
                  ),
                  Text(
                    'COSMO Estate, Kalarahanga',
                    style: companyInfoTextStyle,
                  ),
                  Text(
                    'Patia, Bhubaneswar, Odisha-751024',
                    style: companyInfoTextStyle,
                  ),
                  Text(
                    'Phone N0. : +91 7682912202',
                    style: companyInfoTextStyle,
                  ),
                  Text(
                    'Email : care@uprikindia.com',
                    style: companyInfoTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 150,
                    // child: Image.asset('assets/uprik-logo.png'),
                  ),
                  Text(
                    'www.uprik.com',
                    style: companyInfoTextStyle,
                  ),
                  Text(
                    'www.mcsind.com',
                    style: companyInfoTextStyle,
                  ),
                  Text(
                    'GSTIN No.: 21AAKCM2602F1Z2',
                    style: companyInfoTextStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget displayPersonalInfoTable() {
    return Container(
      // color: Colors.grey,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Table(
        columnWidths: {1: FractionColumnWidth(.75), 2: FractionColumnWidth(.3)},
        textDirection: TextDirection.ltr,
        border: TableBorder.all(
          width: 2.0,
          color: foregroundColor, 
          style: BorderStyle.solid,
        ),
        children: [
          TableRow(
            children: [
              rowHeaderText('Bill to : '),
              Container(),
            ],
          ),
          TableRow(
            children: [
              rowHeaderText('Name: '),
              rowContentText('..................'),
            ],
          ),
          TableRow(
            children: [
              rowHeaderText('Address:'),
              rowContentText('...................'),
            ],
          ),
          TableRow(
            children: [
              rowHeaderText('Phone No.: '),
              rowContentText('...........'),
            ],
          ),
        ],
      ),
    );
  }

  Widget rowHeaderText(String text){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: tableHeaderStyle,
      ),
    );
  }

  Widget rowContentText(String text){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget displayOrderInfoTable() {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Table(
              columnWidths: {
                1: FractionColumnWidth(.55),
                2: FractionColumnWidth(.2)
              },
              textDirection: TextDirection.ltr,
              border: TableBorder.all(
                width: 2.0,
                color: foregroundColor,
                style: BorderStyle.solid,
              ),
              children: [
                TableRow(
                  children: [
                    rowHeaderText('InVoice No.:'),
                    rowContentText('............'),
                  ],
                ),
                TableRow(
                  children: [
                    rowHeaderText('Order No.:'),
                    rowContentText('........'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Table(
              columnWidths: {
                1: FractionColumnWidth(.6),
                2: FractionColumnWidth(.2)
              },
              textDirection: TextDirection.ltr,
              border: TableBorder.all(
                width: 2.0,
                color: foregroundColor,
                style: BorderStyle.solid,
              ),
              children: [
                TableRow(
                  children: [
                    rowHeaderText('Date:'),
                    rowContentText('.....'),
                  ],
                ),
                TableRow(
                  children: [
                    rowHeaderText('Date:'),
                    rowContentText('.....'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget displayCustomerInfoTable() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Table(
        columnWidths: {1: FractionColumnWidth(.65), 2: FractionColumnWidth(.2)},
        textDirection: TextDirection.ltr,
        border: TableBorder.all(
          width: 2.0,
          color: foregroundColor,
          style: BorderStyle.solid,
        ),
        children: [
          TableRow(
            children: [
              rowHeaderText('Customer ID No.:'),
              rowContentText('.....'),
            ],
          ),
          TableRow(
            children: [
              rowHeaderText('Phone No.:'),
              rowContentText('.........'),
            ],
          ),
        ],
      ),
    );
  }


  Widget serviceDescriptionHeaderRow() {
    return Container(
      child: Table(
        columnWidths: {
          1: FractionColumnWidth(.25),
          2: FractionColumnWidth(.14),
          3: FractionColumnWidth(.14),
          4: FractionColumnWidth(.20),
          5: FractionColumnWidth(.16),
          6: FractionColumnWidth(.16),
        },
        textDirection: TextDirection.ltr,
        border: TableBorder.all(
          width: 2.0,
          color: foregroundColor,
          style: BorderStyle.solid,
        ),
        children: [
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Sl No.',
                  style: descriptionTableHeaderTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Desc/Item',
                  style: descriptionTableHeaderTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Proposed to solve',
                  style: descriptionTableHeaderTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Qnty.',
                  style: descriptionTableHeaderTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Rate(Rs.)',
                  style: descriptionTableHeaderTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Total(Rs.)',
                  style: descriptionTableHeaderTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget serviceDescriptionDataTable() {
    return serviceDescriptions.length >= 1
    ? Container(
      height: 200.0,
      width: double.infinity,
      child: ListView.builder(
          itemCount: serviceDescriptions.length,
          itemBuilder: (context, index) {
            return Container(
              child: Table(
                columnWidths: {
                  1: FractionColumnWidth(.25),
                  2: FractionColumnWidth(.14),
                  3: FractionColumnWidth(.14),
                  4: FractionColumnWidth(.20),
                  5: FractionColumnWidth(.16),
                  6: FractionColumnWidth(.16),
                },
                textDirection: TextDirection.ltr,
                border: TableBorder.all(
                  width: 2.0,
                  color: foregroundColor,
                  style: BorderStyle.solid,
                ),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        serviceDescriptions[index].slno.toString(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        serviceDescriptions[index].description.toString(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        serviceDescriptions[index].proposedToSolve.toString(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        serviceDescriptions[index].quantity.toString(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        serviceDescriptions[index].rate.toString(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        serviceDescriptions[index].total.toString(),
                      ),
                    ),
                  ])
                ],
              ),
            );
          }),
    )
    :Container();
  }


  Widget addServiceDescriptionButton() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: () {
          /// on pressing the button the button will disappear and the add description form will display
          setState(() {
            showInputServiceDescriptionButton = false;
            showInputServiceDescriptionForm = true;
          });
        },
        child: Text(
          'Add Service Description',
          style: buttonTextStyle.copyWith(fontSize: 14.0),
        ),
        color: Colors.black38,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
    );
  }


  void addCharges(String chargeToAdd) {
    setState(() {
      chargesTypes[chargeToAdd] = double.parse(addChargesController.text);
    });
    calculateGrandTotal();
    tableRows();
  }

  void calculateGrandTotal(){
    double gTotal = 0.0;
    setState(() {
      gTotal += total;
      for (String i in chargesTypes.keys) {
        gTotal += chargesTypes[i];
      }
      grandTotal = gTotal;
    });
  }


  Widget calculateTotal() {
    if (serviceDescriptions.length > 0) {
      for (int i; i < serviceDescriptions.length; i++) {
        total += serviceDescriptions[i].total;
      }
    }
    return Text(total.toString());
  }

  // Widget calculateGrandTotal(){
  //
  //   return Text(grandTotal.toString(), style: descriptionTableHeaderTextStyle,);
  // }


  void tableRows() {
    List<TableRow> tableRows = [];
    for (String i in chargesTypes.keys) {
      tableRows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(i + ' : '),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(chargesTypes[i].toString()),
            ),
          ],
        ),
      );
    }
    setState(() {
      additionalChargesTableRows = tableRows;
    });
  }


  Widget inputServicesDescription(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Table(
            columnWidths: {1: FractionColumnWidth(0.7)},
            children: [
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Sl no.: '),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('${serviceDescriptions.length + 1}'),
                ),
              ]),
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text('Description/Item: '),
                  ),
                  inputTextFormField(
                      context,
                      descriptionController,
                      descriptionFocusNode,
                      propSolveFocusNode,
                      'Description/Items : ',
                      TextInputType.text
                  ),
                ],
              ),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Proposed to solve: '),
                ),
                inputTextFormField(
                    context,
                    propSolveController,
                    propSolveFocusNode,
                    quantityFocusNode,
                    'Proposed to solve : ',
                    TextInputType.text,
                ),
              ],),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Quantity: '),
                ),
                inputTextFormField(context, quantityController,
                    quantityFocusNode, rateFocusNode, 'Qanty : ',TextInputType.number,),
              ],),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Rate (Rs.) : '),
                ),
                inputTextFormField(context, rateController, rateFocusNode,
                    totalFocusNode, 'Rate(Rs.) : ', TextInputType.number,),
              ],),
              TableRow(
                children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('Total (Rs.) : '),
                ),
                inputTextFormField(context, totalController, totalFocusNode,
                    null, 'Total(Rs.) : ', TextInputType.number,),
              ],),
            ],
          ),
        ),

        /// Display buttons
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// submit button
              Container(
                margin: EdgeInsets.all(10.0),
                child: FlatButton(
                  color: foregroundColor,
                  onPressed: () {
                    addServiceDescription();
                    calculateGrandTotal();
                    setState(() {
                      showInputServiceDescriptionButton = true;
                      showInputServiceDescriptionForm = false;
                      descriptionController.clear();
                      propSolveController.clear();
                      quantityController.text = '0';
                      rateController.text = '0.0';
                      totalController.text = '0.0';
                    });
                  },
                  child: Text(
                    'Submit',
                    style: buttonTextStyle.copyWith(fontSize: 14.0),
                  ),
                ),
              ),

              ///cancel button
              Container(
                margin: EdgeInsets.all(10.0),
                child: FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      showInputServiceDescriptionButton = true;
                      showInputServiceDescriptionForm = false;
                      descriptionController.clear();
                      propSolveController.clear();
                      quantityController.text = '0';
                      rateController.text = '0.0';
                      totalController.text = '0.0';
                    });
                    // addServiceDescription();
                  },
                  child: Text(
                    'Cancel',
                    style: buttonTextStyle.copyWith(fontSize: 14.0),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget displayExtraCharges(){
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
                  child: Text(total.toString()),
                ),
              ])
            ],
          ),
          Container(
            height: chargesTypes.keys.length * 40.0,
            child: Table(
              children: additionalChargesTableRows,
            ),
          ),
          Table(
            children: [
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
                  child: Text(grandTotal.toString(), style: descriptionTableHeaderTextStyle,),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }

  // void inputServiceDescriptionForm() {
  //   setState(() {
  //     showInputServiceDescriptionButton = false;
  //     showInputServiceDescriptionForm = true;
  //   });
  // }

  Widget inputTextFormField(
      BuildContext context,
      TextEditingController controller,
      FocusNode currentFocusNode,
      FocusNode nextFocusNode,
      String hintText,
          TextInputType textInputType) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        cursorWidth: 5.0,
        enabled: true,
        autofocus: true,
        controller: controller,
        focusNode: currentFocusNode,
        keyboardType: textInputType,
        onFieldSubmitted: (v) {
          if (nextFocusNode != null) {
            _fieldFocusChange(context, currentFocusNode, nextFocusNode);
          } else {
            currentFocusNode.unfocus();
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintTextStyle,
          // labelText: 'Enter Name As On Driving liecense',
          // labelStyle: labelTextStyle,
          // focusedBorder: focusBorder,
          // enabledBorder: enableBorder,
          // disabledBorder: disableBorder,
          // border: border,
          // errorBorder: errorBorder,
          isDense: true,
        ),
      ),
    );
  }


  void addServiceDescription() {
    BillServiceDescriptionModel serviceDes = BillServiceDescriptionModel(
      slno: serviceDescriptions.length + 1,
      description: descriptionController.text ?? '',
      proposedToSolve: propSolveController.text ?? '',
      quantity: int.parse(quantityController.text),
      rate: double.parse(rateController.text),
      total: double.parse(totalController.text),
    );

    setState(() {
      total += double.parse(totalController.text);
      serviceDescriptions.add(serviceDes);
    });
  }

  Widget addAdditionalChargesSection() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Add additional charges:',
              style: descriptionTableHeaderTextStyle,
            ),
          ),
          addAdditionalChargesDropdown(),
          SizedBox(
            height: 10.0,
          ),
          inputFormAdditionalCharges(),
        ],
      ),
    );
  }



  Widget addAdditionalChargesDropdown() {
    return Container(
      margin: EdgeInsets.all(10),
      // width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: foregroundColor, width: 3.0),
          borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(
            Icons.arrow_downward,
            color: foregroundColor,
          ),
          iconSize: 24,
          elevation: 16,
          style: dropdownTextStyle,
          underline: Container(
            height: 40,
            // color: backgroundColor,
            decoration: BoxDecoration(),
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              chargeToAdd = newValue;
            });
          },
          items:
              chargesTypes.keys.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget inputFormAdditionalCharges() {
    return chargeToAdd != null
        ? Container(
            child: Column(
              children: [
                Table(
                  columnWidths: {1: FractionColumnWidth(0.6)},
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(chargeToAdd + ' : '),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextFormField(
                            cursorWidth: 5.0,
                            enabled: true,
                            autofocus: true,
                            controller: addChargesController,
                            focusNode: addChargesFocusNode,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (v) {
                              addChargesFocusNode.unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: chargesTypes[chargeToAdd].toString(),
                              hintStyle: hintTextStyle,
                              // labelText: 'Enter Name As On Driving liecense',
                              // labelStyle: labelTextStyle,
                              // focusedBorder: focusBorder,
                              // enabledBorder: enableBorder,
                              // disabledBorder: disableBorder,
                              // border: border,
                              // errorBorder: errorBorder,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                ///Submit Button for add extra charges
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: FlatButton(
                    color: foregroundColor,
                    onPressed: () {
                      addCharges(chargeToAdd);
                      setState(() {
                        ///changes done here///
                        addChargesController.clear();
                        chargeToAdd = null;

                      });
                    },
                    child: Text(
                      'Confirm',
                      style: buttonTextStyle.copyWith(fontSize: 14.0),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget paymentButton(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(30.0),
      child: FlatButton(
        padding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        color: foregroundColor,
        onPressed: () {
          payButtonPressed();
        },
        child: Text(
          'Pay',
          style: buttonTextStyle,
        ),
      ),
    );
  }

  void feedServiceBillModelObject(){
    setState(() {
      serviceBill = ServiceBillModel(
        userId: 264,
        orderId: 180,
        serviceDescriptions: serviceDescriptions,
        totalCharges: total.toString(),
        grandTotalCharges: grandTotal.toString(),
        serviceCharge: chargesTypes['Service Charge'].toString(),
        partsCharge: chargesTypes['New Part Charge'].toString(),
        extraHourCharge: chargesTypes['Extra Hour Charge'].toString(),
        miscellaneousCharge: chargesTypes['Miscellaneous Charge'].toString(),
      );
    });
  }

  payButtonPressed() {
    feedServiceBillModelObject();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentInitializeScreen(serviceBill: serviceBill,),
      ),
    );
  }


  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

