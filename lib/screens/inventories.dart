import 'package:flutter/material.dart';
import 'package:hrcotton_usa_new/api/storageSharedPreferences.dart';
import 'package:hrcotton_usa_new/misc/app_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcotton_usa_new/styles/default_styles.dart';
import 'package:hrcotton_usa_new/styles/inventories_screen_styles.dart';

import '../api/api.dart';
import '../widgets/multi_select.dart';

class InventoriesScreen extends StatefulWidget {
  const InventoriesScreen({Key? key}) : super(key: key);

  @override
  State<InventoriesScreen> createState() => _InventoriesScreenState();
}

class _InventoriesScreenState extends State<InventoriesScreen> {
  Api instance = Api();
  bool isClicked = false,
      isStockOnly = false,
      isStockOnlyAllItems = false,
      allItemsOnWater = false,
      isLoaded = false,
      diableFilterBtn = false, isReset = false;
  List<String> itemInfo = [];
  List<Widget> widgets = [], tempWidgets = [];
  List<List<dynamic>> filters = [];
  int count = 0;
  Map<String, String> warehouses = {}, foodServices = {}, healthCare = {}, hospitality = {}, automotive = {}, ycmaGymGt = {}, promotionalTowel = {}, vendors = {}, itemCodes = {};
  List<int> whIds = [], fsIds = [], hcIds = [], hIds = [], aIds = [], ycmaIds = [], ptIds = [], vIds = [], icIds = [];
  List<String> sWhIds = [], sFsIds = [], sHcIds = [], sHIds = [], sAIds = [], sYcmaIds = [], sPtIds = [], sVIds = [], sIcIds = [];
  List<dynamic> inventories = [];
  String description = "";
  final _controller = TextEditingController();

  void initializeFilters() async {
    await instance.getInventoriesFilters();
    filters = instance.inventoriesFilters;

    for (List<dynamic> filter in filters) {
      for (dynamic filterType in filter) {
        if (count == 0) warehouses[filterType['WareHouseId']] = filterType['WareHouseCode'];
        if (count == 1) foodServices[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 2) healthCare[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 3) hospitality[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 4) automotive[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 5) ycmaGymGt[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 6) promotionalTowel[filterType['ItemCategoryId']] = filterType['ItemCategory'];
        if (count == 7) vendors[filterType['VendorId']] = filterType['VendorName'];
        if (count == 8) itemCodes[filterType['ItemId']] = filterType['ItemCode'];
      }
      count++;
    }

    isLoaded = true;
    setState(() {});
  }

  void initializeInventories() async {
    if(!isReset){
      await SPStorage.getSavedFilters("sWhIds").then((value) {
        sWhIds = value;
        whIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sFsIds").then((value) {
        sFsIds = value;
        fsIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sHcIds").then((value) {
        sHcIds = value;
        hcIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sHIds").then((value) {
        sHIds = value;
        hIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sAIds").then((value) {
        sAIds = value;
        aIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sYcmaIds").then((value) {
        sYcmaIds = value;
        ycmaIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sPtIds").then((value) {
        sPtIds = value;
        ptIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sVIds").then((value) {
        sVIds = value;
        vIds = value.map(int.parse).toList();
      });
      await SPStorage.getSavedFilters("sIcIds").then((value) {
        sIcIds = value;
        icIds = value.map(int.parse).toList();
      });

      isReset = false;
      inventories = [whIds, fsIds, hcIds, hIds, aIds, ycmaIds, ptIds, vIds, icIds, description,
        isStockOnly == false ? '0' : '1',
        isStockOnlyAllItems == false ? '0' : '1',
        allItemsOnWater == false ? '0' : '1'
      ];
      setState(() {});
    }
  }

  @override
  void initState(){
    initializeFilters();
    initializeInventories();

    // SPStorage.resetSharedPrefs();
    super.initState();
  }

  List<Widget> getWarehouses(List<dynamic> warehouses) {
    List<Widget> warehousesCards = [];

    warehousesCards.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                "WAREHOUSE",
                style: TextStyle(
                    color: Color(0xFF438A98),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                "QTY",
                style: TextStyle(
                    color: Color(0xFF438A98),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline
                ),
              ),
            ),
          ),
        ],
      ),
    );

    warehouses.forEach((element) {
      warehousesCards.add(warehouseLayout(element['WareHouseCode'], element['QtyOnHand']));
    });

    return warehousesCards.length != 1 ? warehousesCards : [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(width: 5, height: 30),
        Text(
          "Stock not available",
          style: TextStyle(
            color: Colors.lightBlue,
          ),
        ),
      ],
    )];
  }

  Widget warehouseLayout(String warehouse, String qty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: Text(
              warehouse,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Text(
              qty,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build inventories: $inventories");
    return Scaffold(
      // backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text("Inventories"),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: isLoaded ? () async {
              widgets = [];
              inventories = [];
              diableFilterBtn = false;
              isReset = true;
              SPStorage.resetSavedFilters();
              sWhIds = []; sFsIds =  []; sHcIds =  []; sHIds =  []; sAIds =  []; sYcmaIds =  []; sPtIds =  []; sVIds = sIcIds = [];
              whIds =  []; fsIds =  []; hcIds =  []; hIds =  []; aIds =  []; ycmaIds =  []; ptIds =  []; vIds =  []; icIds = [];
              inventories = [];
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
        onPressed: () => diableFilterBtn ? null : showModalBottomSheet(
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
        future: instance.getInventories(inventories),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            diableFilterBtn = true;
            return Center(
              child: SizedBox(width: 200, child: Lottie.asset('assets/lottie/loading_circle_1.json')),
            );
          } else if(snapshot.hasData) {
            diableFilterBtn = false;
            widgets = [];
            for (var element in instance.inventories) {
              String itemCode = element['ItemCode'].toString();
              String um = element['U/M'].toString();
              String itemDesc = element['Description'].toString();
              String stockQty = element['QtyOnHand'].toString();
              String totalIncome = element['TotalIncoming'].toString();
              List<dynamic> warehousesQtyOnHand = element['Warehousesqtyonhand'];
              List<dynamic> incomingBreakup = element['IncomingBreakup'];
              List<TableRow> incomingBreakupRows = [];

              incomingBreakupRows.add(
                  const TableRow(
                      children: [
                        Center(
                          child: Text(
                            "PO#",
                            style: TextStyle(
                                color: Color(0xFFFF6600),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "ETA Date",
                            style: TextStyle(
                                color: Color(0xFFFF6600),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "QTY",
                            style: TextStyle(
                                color: Color(0xFFFF6600),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                            ),
                          ),
                        ),
                      ]
                  )
              );

              incomingBreakupRows.add(
                  const TableRow(
                      children: [
                        SizedBox(height: 5),
                        SizedBox(height: 5),
                        SizedBox(height: 5),
                      ]
                  )
              );

              incomingBreakupRows.addAll(
                  incomingBreakup.map((element) => TableRow(
                      children: [
                        Center(child: Text(element['PONo'] ?? "null", style: const TextStyle(fontSize: 12))),
                        Center(child: Text(element['ETADate'] ?? "null", style: const TextStyle(fontSize: 12))),
                        Center(child: Text(element['Qty'] ?? "null", style: const TextStyle(fontSize: 12))),
                      ]
                  )).toList()
              );

              widgets.add(
                Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF2F9FF),
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
                          color: Color(0xFF0C3880),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  itemCode,
                                  style: const TextStyle(
                                      fontFamily: "poppins",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white
                                  ),
                                ),
                                Text(
                                  "U/M: $um",
                                  style: const TextStyle(
                                      fontFamily: "poppins",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 3),
                            // Item Description
                            Text(
                              itemDesc,
                              style: const TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF747474)
                              ),
                            ),
                            const SizedBox(height: 3),
                            // QTY HAnd & Total Incoming
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    "Qty On Hand: $stockQty",
                                    style: const TextStyle(fontSize: 13)
                                ),
                                Text(
                                    "Total Incoming: $totalIncome",
                                    style: const TextStyle(fontSize: 13)
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            const Divider(
                              endIndent: 3,
                              indent: 5,
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: getWarehouses(warehousesQtyOnHand),
                      ),
                      const SizedBox(height: 10),
                      const Divider(endIndent: 3, indent: 5, thickness: 0),
                      const Center(
                        child: Text(
                          "INCOMING BREAKUP",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const Divider(endIndent: 3, indent: 5, thickness: 0),
                      const SizedBox(height: 10),
                      incomingBreakupRows.length != 2 ? Table(children: incomingBreakupRows) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(width: 5, height: 30),
                          Text(
                            "There are no Incoming Pos",
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                )
              );
              widgets.add(const SizedBox(height: 10));
            }
            return ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: widgets,
            );
          } else {
            diableFilterBtn = false;
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
              const Text("Filters", style: InventoriesScreenStyles.h1),
              ElevatedButton(
                  onPressed: () async {
                    diableFilterBtn = true;

                    SPStorage.resetSavedFilters();
                    SPStorage.saveFilters("sWhIds", sWhIds);
                    SPStorage.saveFilters("sFsIds", sFsIds);
                    SPStorage.saveFilters("sHcIds", sHcIds);
                    SPStorage.saveFilters("sHIds", sHIds);
                    SPStorage.saveFilters("sAIds", sAIds);
                    SPStorage.saveFilters("sYcmaIds", sYcmaIds);
                    SPStorage.saveFilters("sPtIds", sPtIds);
                    SPStorage.saveFilters("sVIds", sVIds);
                    SPStorage.saveFilters("sIcIds", sIcIds);

                    inventories = [
                      whIds.isNotEmpty ? whIds : null,
                      fsIds.isNotEmpty ? fsIds : null,
                      hcIds.isNotEmpty ? hcIds : null,
                      hIds.isNotEmpty ? hIds : null,
                      aIds.isNotEmpty ? aIds : null,
                      ycmaIds.isNotEmpty ? ycmaIds : null,
                      ptIds.isNotEmpty ? ptIds : null,
                      vIds.isNotEmpty ? vIds : null,
                      icIds.isNotEmpty ? icIds : null,
                      description.isNotEmpty ? description : null,
                      isStockOnly == false ? '0' : '1',
                      isStockOnlyAllItems == false ? '0' : '1',
                      allItemsOnWater == false ? '0' : '1'
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
                  items: foodServices,
                  title: "Food Services",
                  selectedValues: sFsIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sFsIds = foodServices.keys.toList();
                      fsIds = sFsIds.map(int.parse).toList();
                      sFsIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });

                      print(keys);
                      print("sFsIds: $sFsIds\nfsIds: $fsIds");
                    }
                  },
                  onConfirm: (results) {
                    sFsIds = [];
                    fsIds = [];
                    results.forEach((element) {
                      sFsIds.add(element.toString());
                      if(element != "all") {
                        fsIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: healthCare,
                  title: "Health Care",
                  selectedValues: sHcIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sHcIds = healthCare.keys.toList();
                      hcIds = sHcIds.map(int.parse).toList();
                      sHcIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sHcIds = [];
                    hcIds = [];
                    results.forEach((element) {
                      sHcIds.add(element.toString());
                      if(element != "all") {
                        hcIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: hospitality,
                  title: "Hospitality",
                  selectedValues: sHIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sHIds = hospitality.keys.toList();
                      hIds = sHIds.map(int.parse).toList();
                      sHIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sHIds = [];
                    hIds = [];
                    results.forEach((element) {
                      sHIds.add(element.toString());
                      if(element != "all") {
                        hIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: automotive,
                  title: "Automotive",
                  selectedValues: sAIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sAIds = automotive.keys.toList();
                      aIds = sAIds.map(int.parse).toList();
                      sAIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sAIds = [];
                    whIds = [];
                    results.forEach((element) {
                      sAIds.add(element.toString());
                      if(element != "all") {
                        whIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: ycmaGymGt,
                  title: "YMCA/ GYM/ Golf Towel",
                  selectedValues: sYcmaIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sYcmaIds = ycmaGymGt.keys.toList();
                      ycmaIds = sYcmaIds.map(int.parse).toList();
                      sYcmaIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sYcmaIds = [];
                    ycmaIds = [];
                    results.forEach((element) {
                      sYcmaIds.add(element.toString());
                      if(element != "all") {
                        ycmaIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: promotionalTowel,
                  title: "Promotional Towel",
                  selectedValues: sPtIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sPtIds = promotionalTowel.keys.toList();
                      ptIds = sPtIds.map(int.parse).toList();
                      sPtIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sPtIds = [];
                    whIds = [];
                    results.forEach((element) {
                      sPtIds.add(element.toString());
                      if(element != "all") {
                        ptIds.add(int.parse(element));
                      }
                    });
                  },
                ).multiSelectDdl(),
                const SizedBox(height: 10),
                MultiSelectDdl(
                  items: vendors,
                  title: "vendors",
                  selectedValues: sVIds,
                  setStateFunction: (keys) {
                    if(keys.contains("all")){
                      sVIds = vendors.keys.toList();
                      vIds = sVIds.map(int.parse).toList();
                      sVIds.insert(0, "all");

                      setModalState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  onConfirm: (results) {
                    sVIds = [];
                    vIds = [];
                    results.forEach((element) {
                      sVIds.add(element.toString());
                      if(element != "all") {
                        vIds.add(int.parse(element));
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
                TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    label: Text("Description"),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black, width: 1),
                        borderRadius:
                        BorderRadius.all(Radius.circular(5))),
                  ),
                  style: const TextStyle(height: 1),
                  onSubmitted: (result) {
                    description = result;
                  },
                ),
                Row(
                  children: [
                    const Text("Is Stock Only",
                        style: DefaultStyles.checkBoxTextStyles),
                    const SizedBox(width: 10),
                    Checkbox(
                        value: isStockOnly,
                        onChanged: (value) {
                          setState(() {
                            isStockOnly = value!;
                          });
                        })
                  ],
                ),
                Row(
                  children: [
                    const Text("Is Stock Only All Items",
                        style:
                        DefaultStyles.checkBoxTextStyles),
                    const SizedBox(width: 10),
                    Checkbox(
                        value: isStockOnlyAllItems,
                        onChanged: (value) {
                          setState(() {
                            isStockOnlyAllItems = value!;
                          });
                        })
                  ],
                ),
                Row(
                  children: [
                    const Text("All Items On Water",
                        style:
                        DefaultStyles.checkBoxTextStyles),
                    const SizedBox(width: 10),
                    Checkbox(
                        value: allItemsOnWater,
                        onChanged: (value) {
                          setState(() {
                            allItemsOnWater = value!;
                          });
                          print(
                              "allItemsOnWater: $allItemsOnWater");
                        })
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
