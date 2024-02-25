// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CheckInterentWidget extends StatelessWidget {
  final Widget? noInternetWidget;
  final VoidCallback? onRefreshPressed;
  const CheckInterentWidget({
    Key? key,
    this.noInternetWidget,
    this.onRefreshPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        // initialData: ConnectivityResult.none,
        stream: Connectivity().onConnectivityChanged,
        builder: (c, snap) {
          if (snap.hasData) {
            bool internetAvaliable = [
              ConnectivityResult.mobile,
              ConnectivityResult.wifi
            ].contains(snap.data);

            if (internetAvaliable) {
              return SizedBox();
            } else {
              return _noInternetMessageButtonWidget();
            }
          }
          return _noInternetMessageButtonWidget();
        });
  }
}

Widget _noInternetMessageButtonWidget(
    {VoidCallback? onRefreshPressed, Widget? child}) {
  return FutureBuilder(
      future: Connectivity().checkConnectivity(),
      builder: (cc, sn) {
        if (!sn.hasData) {
          return SizedBox();
        }
        bool internetAvaliable = [
          ConnectivityResult.mobile,
          ConnectivityResult.wifi
        ].contains(sn.data);
        if (!internetAvaliable) {
          return child ??
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withAlpha(200),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Please Check Internet Connection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (onRefreshPressed != null) {
                            onRefreshPressed();
                          }
                        },
                        child: Text("Refresh")),
                  ],
                )),
              );
        }
        return SizedBox();
      });
}
