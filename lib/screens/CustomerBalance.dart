import 'package:flutter/material.dart';
import 'package:hrcotton_usa_new/screens/pdf_viewer.dart';
import 'package:lottie/lottie.dart';

import '../api/api.dart';
import '../api/storageSharedPreferences.dart';
import '../misc/routes.dart';
import '../styles/default_styles.dart';
import '../widgets/multi_select.dart';

class CustomerBalanceScreen extends StatefulWidget {
  const CustomerBalanceScreen({Key? key}) : super(key: key);

  @override
  State<CustomerBalanceScreen> createState() => _CustomerBalanceScreenState();
}

class _CustomerBalanceScreenState extends State<CustomerBalanceScreen> {
  Api instance = Api();
  List<dynamic> filters = [], customerBalances = [];
  List<Widget> widgets = [], tempWidgets = [];
  Map<String, String> customers = {};
  int count = 0;
  List<int> cIds = [];
  List<String> sCIds = [];
  String date = "";
  bool isLoaded = false,
      disableFilterBtn = false,
      isReset = false;


  void initializeFilters() async {
    await instance.getCustBalanceFilters();
    filters = instance.customers;

    for (dynamic filter in filters) {
      customers[filter['CustomerId']] = filter['CustomerName'];
    }

    isLoaded = true;
    setState(() {});
  }

  void initializeInventories() async {
    if(!isReset){
      await SPStorage.getSavedFilters("sCIds").then((value) {
        sCIds = value;
        cIds = value.map(int.parse).toList();
      });

      isReset = false;
      customerBalances = [cIds, date];
      setState(() {});
    }
  }

  @override
  void initState() {
    initializeFilters();
    initializeInventories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Balances", style: TextStyle(
          fontSize: 18
        )),
        // centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: isLoaded ? () async {
              widgets = [];
              customerBalances = [];
              disableFilterBtn = false;
              isReset = true;
              SPStorage.resetSavedFilters();
              sCIds = []; cIds =  [];
              customerBalances = [];
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
        future: instance.getCustomers(customerBalances),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            disableFilterBtn = true;
            return Center(
              child: SizedBox(width: 200, child: Lottie.asset('assets/lottie/loading_circle_1.json')),
            );
          } else if(snapshot.hasData) {
            disableFilterBtn = false;
            List<DataRow> dataRows = [];
            for (var customer in instance.customers) {
              dataRows.add(
                  DataRow(
                      cells: [
                        DataCell(Text(customer['CustomerName'], style: const TextStyle(fontSize: 12))),
                        DataCell(Text(customer['Receivable'], style: const TextStyle(fontSize: 12))),
                        DataCell(
                            IconButton(
                              icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.blueAccent),
                              onPressed: () {
                                RoutingPage.goToNextPage(context: context, navigateTo: PdfViewer(
                                    title: "Open Statement",
                                    documentUrl: customer['OpenStatementUrl']),
                                );
                              },
                            )
                        ),
                        //
                      ]
                  )
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                columns: const[
                  DataColumn(label: Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Receivable", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("")),
                ],
                rows: dataRows,
              ),
            );
          } else {
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
                    SPStorage.saveFilters("sCIds", sCIds);
                    SPStorage.saveFilters("date", [date]);

                    customerBalances = [
                      cIds.isNotEmpty ? cIds : null,
                      date.isNotEmpty ? date : null
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
                    title: "Customers",
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
                  ElevatedButton(
                      onPressed: () async {
                        int currYear = DateTime.now().year;
                        DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(currYear - 5),
                            lastDate: DateTime(currYear + 5),
                            confirmText: "Save",
                            cancelText: "Cancel",
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
                            }
                        );
                        setModalState(() {
                          date = "'${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}'";
                        });
                        print(date);
                      },
                      child: const Text("As Of")
                  ),
                ],
              )
          ),
        ],
      ),
    ),
  );
}
