import 'dart:convert';

import 'package:http/http.dart';

class Api {
  late String username, password;
  late bool isAuthorized;
  late List<List<dynamic>> inventoriesFilters, saleInvoicesFilters, poListFilters, custBalanceFilters;
  bool isFiltersInitialized = false;
  bool isInventoriesPage = false;
  late List<dynamic> inventories = [], saleInvoices = [], poLists = [], customers = [];
  late List<dynamic> warehouses, foodServices, healthcare, hospitality, automotive, ymca, promotionalTowel, vendors, itemCodes;

  Future<void> getUser(String username, String password) async {
    await read(Uri.parse( 'https://hrcottonbooks.com/mobile/api/login.php?username=$username&password=$password'))
        .then((contents) {
      isAuthorized = (contents == "loggedin" ? true : false);
      print(isAuthorized);
    });
  }

  String createUrlParameters(String name, List data) {
    String url = "";
    url += "$name=";
    if(data.isNotEmpty) {
      url += "'";
      for (int i = 0; i <= data.length-1; i++) {
        url += data[i].toString();
        if(i < data.length-1) {
          url += ",";
        }
        /*if (i <= data.length-1) {
          url += "${data[i].toString()},";
        } else {
          url += data[i].toString();
        }*/
      }
      url += "'";
    } else {
      url += "null";
    }
    return url;
  }

  Future<String> getInventoriesFilters() async {
    Response response = await get(Uri.parse(
        "https://hrcottonbooks.com/mobile/api/getinventoriesfilters.php"));
    Map data = jsonDecode(response.body);

    List<dynamic> warehouses = data["Data"][0]['warehouses'];
    List<dynamic> foodServices = data["Data"][0]['foodservices'];
    List<dynamic> healthcare = data["Data"][0]['healthcare'];
    List<dynamic> hospitality = data["Data"][0]['hospitality'];
    List<dynamic> automotive = data["Data"][0]['automative'];
    List<dynamic> ymca = data["Data"][0]['ymca'];
    List<dynamic> promotionalTowel = data["Data"][0]['promotionaltowel'];
    List<dynamic> vendors = data["Data"][0]['vendors'];
    List<dynamic> itemCodes = data["Data"][0]['itemcodes'];

    inventoriesFilters = [
      warehouses,
      foodServices,
      healthcare,
      hospitality,
      automotive,
      ymca,
      promotionalTowel,
      vendors,
      itemCodes
    ];

    return "loaded";
  }

  Future<String> getInventories(List<dynamic> args) async {
    List<int> whIds, fsIds, hcIds, hiIds, aIds, ymcaIds, ptIds, vIds, icIds;
    String description, isStockOnly, isStockOnlyAllItems, allItemsOnWater;
    String url = "https://hrcottonbooks.com/mobile/api/inventories.php?";

    if (args.isNotEmpty) {
      whIds = args[0] ?? [];
      fsIds = args[1] ?? [];
      hcIds = args[2] ?? [];
      hiIds = args[3] ?? [];
      aIds = args[4] ?? [];
      ymcaIds = args[5] ?? [];
      ptIds = args[6] ?? [];
      vIds = args[7] ?? [];
      icIds = args[8] ?? [];
      description = args[9] ?? "";
      isStockOnly = args[10];
      isStockOnlyAllItems = args[11];
      allItemsOnWater = args[12];

      // whIds in url
      url += createUrlParameters("WhIds", whIds);
      /*if(whIds.isNotEmpty) {
        for (int i = 0; i <= whIds.length; i++) {
          if (i <= whIds.length) {
            url += "${whIds[i].toString()},";
          } else {
            url += whIds[i].toString();
          }
        }
      } else {
        url += "null";
      }*/

      url += createUrlParameters("&FsIds", fsIds);
      url += createUrlParameters("&HcIds", hcIds);
      url += "&HIds=null";
      // url += createUrlParameters("&HiIds", hiIds);
      url += createUrlParameters("&AIds", aIds);
      url += createUrlParameters("&YmcaIds", ymcaIds);
      url += createUrlParameters("&PtlIds", ptIds);
      url += createUrlParameters("&VIds", vIds);
      url += createUrlParameters("&IIds", icIds);
      url += "&PtIds=null&description='$description'&isstockonly=$isStockOnly&isstockonlyallitems=$isStockOnlyAllItems&allitemsonwater=$allItemsOnWater";

    }else {
      url += createUrlParameters("WhIds", []);
      url += createUrlParameters("&FsIds", []);
      url += createUrlParameters("&HcIds", []);
      url += "&HIds=null";
      // url += createUrlParameters("&HiIds", []);
      url += createUrlParameters("&AIds", []);
      url += createUrlParameters("&YmcaIds", []);
      url += createUrlParameters("&PtlIds", []);
      url += createUrlParameters("&VIds", []);
      url += createUrlParameters("&IIds", []);
      url += "&PtIds=null&description=''&isstockonly=0&isstockonlyallitems=0&allitemsonwater=0&bgrade=0";
    }

    Response response = await get(Uri.parse(url));
    inventories = await jsonDecode(response.body);

    return "loaded";
  }

  Future<String> getSaleInvoices(List<dynamic> args) async {
    List<int> cIds, whIds, iIds, hIds, pIds, icIds, cnIds, eIds, sIds;
    List<String> amIds = [], psIds = [];
    String fromDate, toDate, isInvoiceDeleted;
    String isDeleted = "0";
    String url = "https://hrcottonbooks.com/mobile/api/salesinvoices.php?";

    if (args.isNotEmpty) {
      cIds = args[0] ?? [];
      whIds = args[1] ?? [];
      iIds = args[2] ?? [];
      hIds = args[3] ?? [];
      pIds = args[4] ?? [];
      icIds = args[5] ?? [];
      cnIds = args[6] ?? [];
      eIds = args[7] ?? [];
      sIds = args[8] ?? [];
      amIds = args[9] ?? [];
      psIds = args[10] ?? [];
      fromDate = args[11] ?? "";
      toDate = args[12] ?? "";
      isInvoiceDeleted = args[13] ?? "";

      // if(sIds.indexOf(2, ))

      // whIds in url
      url += createUrlParameters("InIds", iIds);
      url += createUrlParameters("&CIds", cIds);
      url += createUrlParameters("&PoIds", pIds);
      url += createUrlParameters("&WIds", whIds);
      url += "&IIds=null";
      url += createUrlParameters("&PoNos", cnIds);
      url += createUrlParameters("&EIds", eIds);
      url += createUrlParameters("&status", sIds);
      url += createUrlParameters("&automanual", amIds);
      url += createUrlParameters("&paymentstatus", psIds);
      url += "&isdeleted=$isInvoiceDeleted";
      url += "&fromdate=${fromDate.isNotEmpty ? fromDate : 'null'}";
      url += "&todate=${toDate.isNotEmpty ? toDate : 'null'}";

    }
    else {
      url += createUrlParameters("InIds", []);
      url += createUrlParameters("&CIds", []);
      url += createUrlParameters("&PoIds", []);
      url += createUrlParameters("&WIds", []);
      url += "&IIds=null";
      url += createUrlParameters("&PoNos", []);
      url += createUrlParameters("&EIds", []);
      url += createUrlParameters("&status", []);
      url += createUrlParameters("&automanual", []);
      url += createUrlParameters("&paymentstatus", []);
      url += "&isdeleted=0";
      url += "&fromdate=null";
      url += "&todate=null";
    }

    print("url: $url");
    Response response = await get(Uri.parse(url));
    saleInvoices = await jsonDecode(response.body);

    print("saleInvoices: $saleInvoices");
    return "loaded";
  }

  Future<String> getSaleInvoicesFilters() async {
    Response response = await get(Uri.parse("https://hrcottonbooks.com/mobile/api/getsalesinvoicesfilters.php"));
    Map data = jsonDecode(response.body);

    List<dynamic> customers = data["Data"][0]['customers'];
    List<dynamic> warehouses = data["Data"][0]['warehouses'];
    List<dynamic> salesInvoices = data["Data"][0]['salesinvoices'];
    List<dynamic> poNumbers = data["Data"][0]['ponumbers'];
    List<dynamic> itemCodes = data["Data"][0]['itemcodes'];
    List<dynamic> contNos = data["Data"][0]['contnos'];
    List<dynamic> transactionPeriods = data["Data"][0]['transactionperiods'];
    List<dynamic> salesReps = data["Data"][0]['salesreps'];

    saleInvoicesFilters = [
      customers,
      warehouses,
      salesInvoices,
      poNumbers,
      itemCodes,
      contNos,
      transactionPeriods,
      salesReps
    ];
    return "loaded";
  }

  Future<String> getPoListFilters() async {
    Response response = await get(Uri.parse("https://hrcottonbooks.com/mobile/api/getpolistfilters.php"));
    Map data = jsonDecode(response.body);

    List<dynamic> vendors = data["Data"][0]['vendors'];
    List<dynamic> customers = data["Data"][0]['customers'];
    List<dynamic> ponumbers = data["Data"][0]['ponumbers'];
    List<dynamic> containernos = data["Data"][0]['containernos'];
    List<dynamic> shiptowarehouse = data["Data"][0]['shiptowarehouse'];
    List<dynamic> itemcodes = data["Data"][0]['itemcodes'];
    List<dynamic> potypes = data["Data"][0]['potypes'];

    poListFilters = [
      vendors,
      customers,
      ponumbers,
      containernos,
      shiptowarehouse,
      itemcodes,
      potypes
    ];
    return "loaded";
  }

  Future<void> getPoLists(List<dynamic> args) async {
    List<int> vIds, cIds, pIds, cnIds, swIds, icIds, ptIds;
    String status, fromDate, toDate;
    String url = "https://hrcottonbooks.com/mobile/api/polist.php?";

    if (args.isNotEmpty) {
      vIds = args[0] ?? [];
      cIds = args[1] ?? [];
      pIds = args[2] ?? [];
      cnIds = args[3] ?? [];
      swIds = args[4] ?? [];
      icIds = args[5] ?? [];
      ptIds = args[6] ?? [];
      status = args[7] ?? "";
      fromDate = args[8] ?? "";
      toDate = args[9] ?? "";

      // if(sIds.indexOf(2, ))

      // whIds in url
      url += createUrlParameters("VIds", vIds);
      url += createUrlParameters("&CIds", cIds);
      url += createUrlParameters("&PoIds", pIds);
      url += createUrlParameters("&PocIds", cnIds); // containers no's
      url += createUrlParameters("&PoNos", cnIds);
      url += createUrlParameters("&WIds", swIds);
      url += createUrlParameters("&IIds", icIds);
      url += createUrlParameters("&PtIds", ptIds);
      url += "&status='${status.isNotEmpty ? status : 'null'}'";
      url += "&fromdate=${fromDate.isNotEmpty ? fromDate : 'null'}";
      url += "&todate=${toDate.isNotEmpty ? toDate : 'null'}";

    } else {
      url += createUrlParameters("VIds", []);
      url += createUrlParameters("&CIds", []);
      url += createUrlParameters("&PIds", []);
      url += createUrlParameters("&CnIds", []);
      url += createUrlParameters("&PoNos", []);
      url += createUrlParameters("&SwIds", []);
      url += createUrlParameters("&IcIds", []);
      url += createUrlParameters("&PtIds", []);
      url += "&status=null";
      url += "&fromdate=null";
      url += "&todate=null";
    }

    print("url: $url");
    Response response = await get(Uri.parse(url));
    poLists = await jsonDecode(response.body); // TODO
  }

  Future<String> getCustBalanceFilters() async {
    Response response = await get(Uri.parse("https://hrcottonbooks.com/mobile/api/getcustomerbalancefilters.php"));
    Map data = jsonDecode(response.body);

    List<dynamic> customers = data["Data"][0]['customers'];

    this.customers = customers;
    /*custBalanceFilters = [
      customers,
    ];*/
    return "loaded";
  }

  Future<String> getCustomers(List<dynamic> args) async {
    List<int> cIds;
    String date;
    String url = "https://hrcottonbooks.com/mobile/api/customerbalance.php?";

    if (args.isNotEmpty) {
      cIds = args[0] ?? [];
      date = args[1] ?? "";

      url += createUrlParameters("&CIds", cIds);
      url += "&date=${date.isNotEmpty ? date : 'null'}";

    } else {
      url += createUrlParameters("CIds", []);
      url += "&date=null";
    }

    Response response = await get(Uri.parse(url));
    customers = await jsonDecode(response.body);

    return "loaded";
  }

  // local storage
/*Future<void> getFilters() async {
    Map data = {};
    print("Data: ${storage.getItem("data")}");

    if (storage.getItem("data") == null){
      Response response = await get(Uri.parse(
          "https://hrcottonbooks.com/mobile/api/getinventoriesfilters.php"));
      data = jsonDecode(response.body);
      storage.setItem("data", data);

      warehouses = data["Data"][0]['warehouses'];
      foodServices = data["Data"][0]['foodservices'];
      healthcare = data["Data"][0]['healthcare'];
      hospitality = data["Data"][0]['hospitality'];
      automotive = data["Data"][0]['automative'];
      ymca = data["Data"][0]['ymca'];
      promotionalTowel = data["Data"][0]['promotionaltowel'];
      vendors = data["Data"][0]['vendors'];
      itemCodes = data["Data"][0]['itemcodes'];
    } else {
      print("getting from local storage");
      data = storage.getItem("data");

      warehouses = data["Data"][0]['warehouses'];
      foodServices = data["Data"][0]['foodservices'];
      healthcare = data["Data"][0]['healthcare'];
      hospitality = data["Data"][0]['hospitality'];
      automotive = data["Data"][0]['automative'];
      ymca = data["Data"][0]['ymca'];
      promotionalTowel = data["Data"][0]['promotionaltowel'];
      vendors = data["Data"][0]['vendors'];
      itemCodes = data["Data"][0]['itemcodes'];
    }

    filters = [
      warehouses,
      foodServices,
      healthcare,
      hospitality,
      automotive,
      ymca,
      promotionalTowel,
      vendors,
      itemCodes
    ];

    print("filters: $filters");
  }*/

}
