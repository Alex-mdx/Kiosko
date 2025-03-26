import 'package:flutter/material.dart';
import 'package:kiosko/utils/services/navigation_service.dart';
import 'package:sizer/sizer.dart';

class BannerView extends StatefulWidget {
  const BannerView({super.key});

  @override
  State<BannerView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BannerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Image.asset("assets/banner_example.jpg",
                fit: BoxFit.fill,
                height: double.infinity,
                gaplessPlayback: true,
                alignment: Alignment.center)),
        floatingActionButton: ElevatedButton.icon(
            onPressed: () async => await Navigation.pushNamed(route: 'home'),
            label: Text("Tocar para iniciar su pedido",
                style:
                    TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
