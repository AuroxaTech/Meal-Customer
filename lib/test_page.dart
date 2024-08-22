import 'package:flutter/material.dart';
import 'dart:math';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xff222222),
            title: const Text("JazzCash"),
            elevation: 0,
            actions: const [Icon(Icons.info), Icon(Icons.notifications)]),
        body: CustomScrollView(
          slivers: <Widget>[
            // persistent header
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: SliverAppBarDelegate(
                minHeight: 60.0,
                maxHeight: 60.0,
                child: Container(
                    color: const Color(0xff222222),
                    child: Row(children: const [
                      SizedBox(width: 10),
                      CircleAvatar(),
                      SizedBox(width: 10),
                      Text("Muhammad",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ])),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // first sliver
                  Container(
                      color: const Color(0xff222222),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Login -->",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                            const Text("to Make Payments",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Row(children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Add money")),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Add account"))
                            ])
                          ])),
                  Container(color: Colors.purple, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                  Container(color: Colors.purple, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                  Container(color: Colors.purple, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                  Container(color: Colors.purple, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                  Container(color: Colors.purple, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                  Container(color: Colors.purple, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// defining delegate for sliverpersistendheader
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double? minHeight;
  final double? maxHeight;
  final Widget? child;

  @override
  double get minExtent => minHeight!;

  @override
  double get maxExtent => max(maxHeight!, minHeight!);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
