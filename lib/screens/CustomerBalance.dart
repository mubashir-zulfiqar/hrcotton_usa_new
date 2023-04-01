import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hrcotton_usa_new/screens/pdf_viewer.dart';

import '../api/api.dart';
import '../misc/routes.dart';
import '../styles/customer_balances_styles.dart';

class CustomerBalanceScreen extends StatefulWidget {
  const CustomerBalanceScreen({Key? key}) : super(key: key);

  @override
  State<CustomerBalanceScreen> createState() => _CustomerBalanceScreenState();
}

class _CustomerBalanceScreenState extends State<CustomerBalanceScreen> {
  Api instance = Api();

  @override
  void initState() {
    instance.getCustomers([]);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(instance.customers.isNotEmpty) {
      return custTable(instance.customers);
    } else {
      return custFutureTable([]);
    }
  }

  Widget custTable(List<dynamic> customers) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Balances"),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/custBalanceFiltersScreen', arguments: {"instance": instance});
              },
              style: CustomerBalancesStyles.filtersButtonStyle,
              icon: const Icon(Icons.filter_list)
          ),
        ],
        backgroundColor: const Color(0xFF0061A6),
      ),
      body: Scaffold(
        body: SingleChildScrollView(
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
        ),
      ),
    );
  }

  Widget custFutureTable(List<dynamic> customers) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Balances"),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/custBalanceFiltersScreen', arguments: {"instance": instance});
              },
              style: CustomerBalancesStyles.filtersButtonStyle,
              icon: const Icon(Icons.filter_list)
          ),
        ],
        backgroundColor: const Color(0xFF0061A6),
      ),
      body: Scaffold(
        body: FutureBuilder<String>(
          future: instance.getCustomers(customers),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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
            }
            return Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0061A6),
                  ),
                  child: Dialog(
                    child: SizedBox(
                      height: 150,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SpinKitRing(
                            color: Colors.blueAccent,
                            size: 50.0,
                          ),
                          SizedBox(height: 10),
                          Text("Please wait loading!!!"),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
