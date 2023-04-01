import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../api/storageSharedPreferences.dart';
import '../misc/svg_images.dart';
import '../widgets/custom_grid_tile.dart';
import 'CustomerBalance.dart';
import 'inventories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF212224),
      statusBarIconBrightness: Brightness.light,
    ));
  }

  Widget customizedAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0061A6), // 0xFF1F9978
        // borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontFamily: "poppins",
                      ),
                    ),
                    Text(
                      "Last Login: ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now()).toString()}",
                      style: const TextStyle(
                        color: Color(0xFFC3C3C3),
                        fontWeight: FontWeight.normal,
                        fontSize: 11,
                        fontFamily: "poppins",
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<int>(
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.logout),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Logout"),
                        ],
                      ),
                    ),
                  ],
                  iconSize: 30,
                  // offset: const Offset(-25, 0),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onSelected: (value) {
                    if(value == 1) {
                      Navigator.pushReplacementNamed(context, "/");
                    }
                  },
                ),
              ],
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SPStorage.printIsLoggedIn("Home Screen");
    var tilesData = [
      {
        "color": const Color(0xFFF0715E),
        "svgImage": SvgImages.inventories,
        "title": "Inventories",
        "route": const InventoriesScreen(),
      },
      {
        "color": const Color(0xFF1F9978),
        "svgImage": SvgImages.customerCenter2,
        "title": "Cust. Balance",
        "route": const CustomerBalanceScreen(),
      },
      {
        "color": const Color(0xFF344A5F),
        "svgImage": SvgImages.invoice2,
        "title": "Invoice List",
        "route": const Text("Testing"),
        // "route": const SaleInvoicesScreen(),
      },
      {
        "color": const Color(0xFFFEB453),
        "svgImage": SvgImages.customerPoList2,
        "title": "PO List",
        "route": const Text("Testing"),
        // "route": const PoListScreen(),
      },
      /*{
        "svgImage": SvgImages.poList,
        "title": "PO Lists",
        "route": const FilterPanel(),
      },*/
      {
        "color": const Color(0xFF579ED6),
        "svgImage": SvgImages.logout2,
        "title": "Logout",
        "route": const Text("Testing"),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0061A6),
      body: Center(
        child: SafeArea(
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: Column(
              children: [
                customizedAppBar(),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, -3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              color: Colors.black12
                          )
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            primary: true,
                            itemCount: tilesData.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2.2), // Change the height of the tiles
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              return CustomGridTile(
                                color: tilesData[index]['color'] as Color,
                                title: tilesData[index]['title'].toString(),
                                svgImage: tilesData[index]['svgImage'].toString(),
                                route: tilesData[index]["route"] as Widget,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
