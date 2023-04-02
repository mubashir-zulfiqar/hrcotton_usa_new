import 'package:flutter/material.dart';
import 'package:hrcotton_usa_new/screens/pdf_viewer.dart';
import 'package:lottie/lottie.dart';

import '../api/api.dart';
import '../api/storageSharedPreferences.dart';
import '../misc/routes.dart';
import '../styles/default_styles.dart';
import '../styles/sale_invoices_styles.dart';
import '../widgets/multi_select.dart';

class SalesInvoicesScreen extends StatefulWidget {
  const SalesInvoicesScreen({Key? key}) : super(key: key);

  @override
  State<SalesInvoicesScreen> createState() => _SalesInvoicesScreenState();
}

class _SalesInvoicesScreenState extends State<SalesInvoicesScreen> {
  Api instance = Api();
  bool isClicked = false,
      isDateRangeSelected = false,
      isPending = false,
      isFinal = false,
      isDeleted = false,
      isAuto = false,
      isManual = false,
      isPaid = false,
      isUnpaid = false,
      isPartialPaid = false,
      isLoaded = false,
      disableFilterBtn = false,
      isReset = false;
  List<Widget> widgets = [], tempWidgets = [];
  List<List<dynamic>> filters = [];
  List<dynamic> invoices = [];
  int count = 0;
  Map<String, String> customers = {}, warehouses = {}, salesInvoices = {}, poNumbers = {}, itemCodes = {}, contNos = {}, transactionPeriods = {}, salesReps = {};
  List<int> amIds = [], psIds = [], cIds = [], whIds = [], iIds = [], hIds = [], pIds = [], icIds = [], cnIds = [], eIds = [], sIds = [];
  List<String> sAmIds = [], sPsIds = [], sCIds = [], sWhIds = [], sIIds = [], sHIds = [], sPIds = [], sIcIds = [], sCnIds = [], sEIds = [], sSIds = [];
  String fromDate = "", toDate = "", isInvoiceDeleted = "0";

  void initializeFilters() async {
    await instance.getInventoriesFilters();
    filters = instance.inventoriesFilters;

    for (List<dynamic> filter in filters) {
      for (dynamic filterType in filter) {
        if (count == 0) customers[filterType['WareHouseId']] = filterType['WareHouseCode'];
        if (count == 1) warehouses[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 2) salesInvoices[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 3) poNumbers[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 4) itemCodes[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 5) contNos[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 6) transactionPeriods[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 7) salesReps[filterType['VendorId']] = filterType['VendorName'];
      }
      count++;
    }

    isLoaded = true;
    setState(() {});
  }

  void initializeInvoices() async {
    if(!isReset){
      await SPStorage.getSavedFilters("sAmIds").then((value) {
        sAmIds = value;
        amIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sPsIds").then((value) {
        sPsIds = value;
        psIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sCIds").then((value) {
        sCIds = value;
        cIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sWhIds").then((value) {
        sWhIds = value;
        whIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sIIds").then((value) {
        sIIds = value;
        iIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sHIds").then((value) {
        sHIds = value;
        hIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sPIds").then((value) {
        sPIds = value;
        pIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sIcIds").then((value) {
        sIcIds = value;
        icIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sCnIds").then((value) {
        sCnIds = value;
        cnIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sEIds").then((value) {
        sEIds = value;
        eIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sSIds").then((value) {
        sSIds = value;
        sIds = value.map(int.parse).toList();
      });

      isReset = false;
      invoices = [amIds, psIds, cIds, whIds, iIds, hIds, pIds, icIds,
        cnIds, eIds, sIds, fromDate, toDate, isInvoiceDeleted];
      setState(() {});
    }
  }

  @override
  void initState(){
    initializeFilters();
    initializeInvoices();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sale Invoices"),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: isLoaded ? () async {
              widgets = [];
              invoices = [];
              disableFilterBtn = false;
              isReset = true;
              SPStorage.resetSavedFilters();
              sAmIds = []; sPsIds = []; sCIds = []; sWhIds = []; sIIds = []; sHIds = []; sPIds = []; sIcIds = []; sCnIds = []; sEIds = []; sSIds = [];
              amIds = []; psIds = []; cIds = []; whIds = []; iIds = []; hIds = []; pIds = []; icIds = []; cnIds = []; eIds = []; sIds = [];
              invoices = [];
              setState(() {});
            } : null,
            icon: const Icon(Icons.restart_alt_rounded, color: Colors.white),
            label: const Text("Reset", style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(0),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => disableFilterBtn ? null : showModalBottomSheet(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return buildFilters(context, setModalState);
              }
          ),
        ),
        tooltip: "Filters",
        elevation: 2.0,
        child: isLoaded ? const Icon(Icons.filter_list) : const Padding(
          padding: EdgeInsets.all(15.0),
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 5,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: FutureBuilder<String>(
        future: instance.getSaleInvoices(invoices),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            disableFilterBtn = true;
            return Center(
              child: SizedBox(width: 200, child: Lottie.asset('assets/lottie/loading_circle_1.json')),
            );
          }
          else if(snapshot.hasData) {
            disableFilterBtn = false;
            widgets = [];
            for (var element in instance.saleInvoices) {
              widgets.add(
                saleInvoiceLayout(
                  element['InvoiceNo'].toString(),
                  element['InvoiceDate'].toString(),
                  element['CustomerName'].toString(),
                  element['ShipToName'].toString(),
                  element['PONo'].toString(),
                  element['InvoiceAmount'].toString(),
                  element['InvoiceUrl'].toString(),
                  element['PackingListUrl'].toString(),
                  element['BillOfLadingUrl'].toString(),
                  element['ReleaseOrderUrl'].toString(),
                ),
              );
              widgets.add(const SizedBox(height: 10));
            }

            return Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Text("No of results: ${(widgets.length/2).round().toString()}", style: const TextStyle(
                      fontSize: 20,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      // children: getInventories(5),
                      children: widgets,
                    ),
                  )
                ],
              ),
            );
          }
          else {
            disableFilterBtn = false;
            return const Center(
              child:  Text("There is nothing to show."),
            );
          }
        },
      ),
    );
  }

  Widget buildFilters(BuildContext context, StateSetter setModalState) => FractionallySizedBox(
    heightFactor: 0.8,
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 30),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Filters", style: DefaultStyles.h1),
              ElevatedButton(
                  onPressed: () async {
                    disableFilterBtn = true;

                    SPStorage.resetSavedFilters();
                    SPStorage.saveFilters("sAmIds", sAmIds);
                    SPStorage.saveFilters("sPsIds", sPsIds);
                    SPStorage.saveFilters("sCIds", sCIds);
                    SPStorage.saveFilters("sWhIds", sWhIds);
                    SPStorage.saveFilters("sIIds", sIIds);
                    SPStorage.saveFilters("sHIds", sHIds);
                    SPStorage.saveFilters("sPIds", sPIds);
                    SPStorage.saveFilters("sIcIds", sIcIds);
                    SPStorage.saveFilters("sCnIds", sCnIds);
                    SPStorage.saveFilters("sEIds", sEIds);
                    SPStorage.saveFilters("sSIds", sSIds);

                    invoices = [
                      amIds.isNotEmpty ? amIds : null,
                      psIds.isNotEmpty ? psIds : null,
                      cIds.isNotEmpty ? cIds : null,
                      whIds.isNotEmpty ? whIds : null,
                      iIds.isNotEmpty ? iIds : null,
                      hIds.isNotEmpty ? hIds : null,
                      pIds.isNotEmpty ? pIds : null,
                      icIds.isNotEmpty ? icIds : null,
                      icIds.isNotEmpty ? icIds : null,
                      cnIds.isNotEmpty ? cnIds : null,
                      eIds.isNotEmpty ? eIds : null,
                      sIds.isNotEmpty ? sIds : null,
                      fromDate.isNotEmpty ? fromDate : null,
                      toDate.isNotEmpty ? toDate : null,
                      isInvoiceDeleted.isNotEmpty ? isInvoiceDeleted : null
                    ];
                    setState(() {Navigator.of(context).pop();});
                  },
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.zero)
                  ),
                  child: const Text("Fetch")
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                MultiSelectDdl(
                  items: customers,
                  title: "customers",
                  selectedValues: sCIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sCIds = customers.keys.toList();
                      cIds = sCIds.map(int.parse).toList();
                      sCIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sCIds = [];
                    cIds = [];
                    results.forEach((element) {
                      sCIds.add(element.toString());
                      if(element != "all") {
                        cIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: warehouses,
                  title: "Warehouses",
                  selectedValues: sWhIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sWhIds = warehouses.keys.toList();
                      whIds = sWhIds.map(int.parse).toList();
                      sWhIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sWhIds = [];
                    whIds = [];
                    results.forEach((element) {
                      sWhIds.add(element.toString());
                      if(element != "all") {
                        whIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: salesInvoices,
                  title: "Health Care",
                  selectedValues: sIIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sIIds = salesInvoices.keys.toList();
                      iIds = sIIds.map(int.parse).toList();
                      sIIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sIIds = [];
                    iIds = [];
                    results.forEach((element) {
                      sIIds.add(element.toString());
                      if(element != "all") {
                        iIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: poNumbers,
                  title: "Po Numbers",
                  selectedValues: sPIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sPIds = poNumbers.keys.toList();
                      pIds = sPIds.map(int.parse).toList();
                      sPIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sPIds = [];
                    pIds = [];
                    results.forEach((element) {
                      sPIds.add(element.toString());
                      if(element != "all") {
                        pIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: itemCodes,
                  title: "Item Codes",
                  selectedValues: sIcIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sIcIds = itemCodes.keys.toList();
                      icIds = sIcIds.map(int.parse).toList();
                      sIcIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sIcIds = [];
                    icIds = [];
                    results.forEach((element) {
                      sIcIds.add(element.toString());
                      if(element != "all") {
                        icIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: contNos,
                  title: "Cont Nos",
                  selectedValues: sCnIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sCnIds = contNos.keys.toList();
                      cnIds = sCnIds.map(int.parse).toList();
                      sCnIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sCnIds = [];
                    cnIds = [];
                    results.forEach((element) {
                      sCnIds.add(element.toString());
                      if(element != "all") {
                        cnIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: salesReps,
                  title: "Sales Reps",
                  selectedValues: sEIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sEIds = salesReps.keys.toList();
                      eIds = sEIds.map(int.parse).toList();
                      sEIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sEIds = [];
                    eIds = [];
                    results.forEach((element) {
                      sEIds.add(element.toString());
                      if(element != "all") {
                        eIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items:  const {
                    "0": "Pending",
                    "1": "Final",
                    "2": "Deleted",
                  },
                  title: "Status",
                  selectedValues: sSIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sSIds = const {
                        "0": "Pending",
                        "1": "Final",
                        "2": "Deleted",
                      }.keys.toList();
                      sIds = sSIds.map(int.parse).toList();
                      sSIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sSIds = [];
                    sIds = [];
                    results.forEach((element) {
                      sSIds.add(element.toString());
                      if(element != "all") {
                        if (element == '2') {
                          isInvoiceDeleted = "1";
                        } else {
                          sIds.add(int.parse(element));
                        }
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: const {
                    "auto": "Auto",
                    "manual": "Manual",
                  },
                  title: "Auto/Manual",
                  selectedValues: sAmIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sAmIds = const {
                        "auto": "Auto",
                        "manual": "Manual",
                      }.keys.toList();
                      amIds = sAmIds.map(int.parse).toList();
                      sAmIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sAmIds = [];
                    amIds = [];
                    results.forEach((element) {
                      sAmIds.add(element.toString());
                      if(element != "all") {
                        amIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: const {
                    "paid": "Paid",
                    "unpaid": "Unpaid",
                    "partialpaid": "Partial Paid",
                  },
                  title: "Payment Status",
                  selectedValues: sPsIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sPsIds = const {
                        "paid": "Paid",
                        "unpaid": "Unpaid",
                        "partialpaid": "Partial Paid",
                      }.keys.toList();
                      psIds = sPsIds.map(int.parse).toList();
                      sPsIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sPsIds = [];
                    psIds = [];
                    results.forEach((element) {
                      sPsIds.add(element.toString());
                      if(element != "all") {
                        psIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      int currYear = DateTime.now().year;
                      DateTimeRange? newDateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(currYear - 5),
                        lastDate: DateTime(currYear + 5),
                        confirmText: "Save",
                        cancelText: "Cancel",
                        currentDate: DateTime.now(),
                        builder: (context, child) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxWidth: 300.0,
                                    maxHeight: 500.0
                                ),
                                child: child,
                              )
                            ],
                          );
                        },
                      );
                      fromDate = "'${newDateRange?.start.year}-${newDateRange?.start.month}-${newDateRange?.start.day}'";
                      toDate = "'${newDateRange?.end.year}-${newDateRange?.end.month}-${newDateRange?.end.day}'";
                      setState(() {
                        isDateRangeSelected = true;
                      });
                    },
                    child: const Text("Invoice Period")
                ),
                Center(
                  child: isDateRangeSelected ? Text("$fromDate to $toDate") : const Text(""),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );

  Widget saleInvoiceLayout(String invoiceNo, String invoiceDate, String customerName, String shipToName, String poNo, String invoiceAmount,
      String InvoiceUrl, String PackingListUrl, String BillOfLadingUrl, String ReleaseOrderUrl) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF0C3880),
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            decoration: const BoxDecoration(
              color: Color(0xFFF2F9FF),
              // color: const Color(0xFF0C3880),
              borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // invoiceNo.toString()
                    RichText(text: TextSpan(
                        text: "INV # ",
                        style: const TextStyle(
                          fontFamily: "poppins",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0C3880),
                        ),
                        children: [
                          TextSpan(
                              text: invoiceNo.toString(),
                              style: const TextStyle(
                                fontFamily: "poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF6600),
                              )
                          ),
                        ]
                    )),
                    Text(
                      invoiceDate.toString(),
                      style: const TextStyle(
                          fontFamily: "poppins",
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0C3880)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: Color(0xFF0C3880)),
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 3),
                  Text(
                    customerName.toString(),
                    style: const TextStyle(
                        fontFamily: "poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF747474)
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Ship To Name: $shipToName",
                    style: const TextStyle(
                        fontFamily: "poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF747474)
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(text: TextSpan(
                          text: "Po No: ",
                          style: const TextStyle(
                              fontFamily: "poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black
                          ),
                          children: [
                            TextSpan(
                                text: poNo.toString(),
                                style: const TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                )
                            ),
                          ]
                      )),
                      RichText(text: TextSpan(
                          text: "Amount: ",
                          style: const TextStyle(
                              fontFamily: "poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black
                          ),
                          children: [
                            TextSpan(
                                text: invoiceAmount.toString(),
                                style: const TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                )
                            ),
                          ]
                      )),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Divider(thickness: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.white),
                            elevation: MaterialStatePropertyAll(0)
                        ),
                        onPressed: () {
                          RoutingPage.goToNextPage(context: context, navigateTo: PdfViewer(
                              title: "Sale Invoice",
                              documentUrl: InvoiceUrl),
                          );
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.picture_as_pdf_outlined, color: Colors.blueAccent, size: 20), // Color(0xFF0061A6)
                            Text("Sale Invoice", style: TextStyle(
                                fontSize: 7,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            )),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.white),
                            elevation: MaterialStatePropertyAll(0)
                        ),
                        onPressed: () {
                          RoutingPage.goToNextPage(context: context, navigateTo: PdfViewer(
                              title: "Packing List",
                              documentUrl: PackingListUrl)
                          );
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.picture_as_pdf_outlined, color: Colors.blueAccent, size: 20),// Color(0xFF0061A6)
                            Text("Packing List", style: TextStyle(
                                fontSize: 7,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            )),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.white),
                            elevation: MaterialStatePropertyAll(0)
                        ),
                        onPressed: () {
                          print("BillOfLadingUrl: $BillOfLadingUrl");
                          RoutingPage.goToNextPage(context: context, navigateTo: PdfViewer(
                              title: "Bill of lading",
                              documentUrl: BillOfLadingUrl)
                          );
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.picture_as_pdf_outlined, color: Colors.blueAccent, size: 20),// Color(0xFF0061A6)
                            Text("Bill of lading", style: TextStyle(
                                fontSize: 7,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            )),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.white),
                            elevation: MaterialStatePropertyAll(0)
                        ),
                        onPressed: () {
                          RoutingPage.goToNextPage(context: context, navigateTo: PdfViewer(
                              title: "Release Order",
                              documentUrl: ReleaseOrderUrl)
                          );
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.picture_as_pdf_outlined, color: Colors.blueAccent, size: 20), // Color(0xFF0061A6)
                            Text("Release Order", style: TextStyle(
                                fontSize: 7,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget saleInvoiceTableLayout (List<dynamic> elements) {
    List<Widget> invoiceNos = [], rightSideWidgets = [];
    invoiceNos.add(const Text(
      "Invoices",
      style: TextStyle(
        fontFamily: "poppins",
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    )
    );
    rightSideWidgets.add(
        Row(
          children: const [
            Text(
              "Invoice Date",
              style: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Customer Name",
              style: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Ship To Name",
              style: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "PO No",
              style: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Invoice Amount",
              style: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
    );

    List<DataRow> dataRows = [];

    /*for (int i = 0; i <= elements.length; i++) {
      dataRows.add(
          DataRow(
            cells: [
            DataCell(Text(elements[i]['InvoiceNo'].toString())),
            DataCell(Text(elements[i]['InvoiceDate'].toString())),
            DataCell(Text(elements[i]['CustomerName'].toString())),
            DataCell(Text(elements[i]['ShipToName'].toString())),
            DataCell(Text(elements[i]['PONo'].toString())),
            DataCell(Text(elements[i]['InvoiceAmount'].toString())),
          ],
            color: i %2 == 0 ? const MaterialStatePropertyAll(Colors.blueAccent) : const MaterialStatePropertyAll(Colors.grey),
          )
      );
    }*/

    for (var element in elements) {
      dataRows.add(
          DataRow(cells: [
            DataCell(Text(element['InvoiceNo'].toString(), style: SaleInvoicesStyles.tableRowsStyle)),
            DataCell(Text(element['InvoiceDate'].toString(), style: SaleInvoicesStyles.tableRowsStyle)),
            DataCell(Text(element['CustomerName'].toString(), style: SaleInvoicesStyles.tableRowsStyle)),
            DataCell(Text(element['ShipToName'].toString(), style: SaleInvoicesStyles.tableRowsStyle)),
            DataCell(Text(element['PONo'].toString(), style: SaleInvoicesStyles.tableRowsStyle)),
            DataCell(Text(element['InvoiceAmount'].toString(), style: SaleInvoicesStyles.tableRowsStyle)),
          ],
          )
      );
    }

    /*return Expanded(
       child: HorizontalDataTable(
         leftHandSideColumnWidth: 100,
         rightHandSideColumnWidth: 600,
         leftSideChildren: invoiceNos,
         rightSideChildren: rightSideWidgets,
         itemCount: elements.length,
         scrollPhysics: const BouncingScrollPhysics(),
       ),
     );*/
    return SingleChildScrollView (
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10,
        headingRowColor: const MaterialStatePropertyAll(Colors.blueAccent),
        columns: const [
          DataColumn(label: Text(
            "Invoices",
            style: SaleInvoicesStyles.tableHeadersStyle,
          )),
          DataColumn(label: Text(
            "Invoice Date",
            style: SaleInvoicesStyles.tableHeadersStyle,
          )),
          DataColumn(label: Text(
            "Customer Name",
            style: SaleInvoicesStyles.tableHeadersStyle,
          )),
          DataColumn(label: Text(
            "Ship To Name",
            style: SaleInvoicesStyles.tableHeadersStyle,
          )),
          DataColumn(label: Text(
            "PO No",
            style: SaleInvoicesStyles.tableHeadersStyle,
          )),
          DataColumn(label: Text(
            "Invoice Amount",
            style: SaleInvoicesStyles.tableHeadersStyle,
          )),
        ],
        rows: dataRows,
      ),
    );
  }
}
