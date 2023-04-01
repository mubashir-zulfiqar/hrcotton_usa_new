import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPStorage {
  static bool isLoggedIn = false;

  static void spIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool("isLoggedIn") == null ? true : false;

    if(firstTime) {
      await prefs.setBool("isLoggedIn", false);
    } else {
      SPStorage.isLoggedIn = (await prefs.getBool("isLoggedIn"))!;
    }
  }

  static void setIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", isLoggedIn);
    SPStorage.isLoggedIn = isLoggedIn;
    print("Set [${prefs.getBool("isLoggedIn")}] SPStorage Class");
  }

  static void printIsLoggedIn(String pageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? temp = await prefs.getBool("isLoggedIn");
    if (kDebugMode) {
      print("isLoggedIn [$temp] from $pageName");
    }
  }

  static void saveFilters(String key, List<String> filters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, filters);
  }

  static Future<List<String>> getSavedFilters(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getStringList(key) ?? [];
  }

  static void resetSavedFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("sWhIds");
    prefs.remove("sFsIds");
    prefs.remove("sHcIds");
    prefs.remove("sHIds");
    prefs.remove("sAIds");
    prefs.remove("sYcmaIds");
    prefs.remove("sPtIds");
    prefs.remove("sVIds");
    prefs.remove("sIcIds");
    // prefs.reload();
  }

  static void resetSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}