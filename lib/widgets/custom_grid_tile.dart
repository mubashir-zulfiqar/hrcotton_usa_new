import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../api/storageSharedPreferences.dart';
import '../misc/routes.dart';

class CustomGridTile extends StatelessWidget {
  final String svgImage, title;
  final Widget route;
  final Color color;
  const CustomGridTile({Key? key, required this.svgImage, required this.title, required this.route, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = LocalStorage('hr_cotton_app');

    return Container(
        margin: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
            alignment: Alignment.center,
            // backgroundColor: const MaterialStatePropertyAll(AppColors.baseWhiteColor),
            backgroundColor: const MaterialStatePropertyAll(Color(0xFFEFF6FF)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () async {
            if (title == "Logout"){
              SPStorage.setIsLoggedIn(false);
              Navigator.pushReplacementNamed(context, "/loginScreen");
              // Navigator.pop(context);
            } else {
              RoutingPage.goToNextPage(
                context: context,
                navigateTo: route,
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WebsafeSvg.asset(
                svgImage,
                width: 45,
                color: color
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.2,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700],
                  fontFamily: "poppins",
                ),
              ),
            ],
          ),
        ));
  }
}
