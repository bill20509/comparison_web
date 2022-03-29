// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:before_after/before_after.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<List<List<dynamic>>> parse() async {
  List<List<dynamic>> ret = [];

  final myData = await rootBundle.loadString("assets/report.csv");
  List<List<dynamic>> reportCSV = const CsvToListConverter().convert(myData);
  for (int i = 7; i < reportCSV.length; i++) {
    String? pass = reportCSV[i][2];
    if (pass == "FAIL") {
      // print(reportCSV[i]);
      ret.add(reportCSV[i]);
    }
  }
  return ret;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final myCSV = await parse();
  runApp(MyApp(myCSV));
}

class MyApp extends StatefulWidget {
  const MyApp(
    this.data, {
    Key? key,
  }) : super(key: key);
  final List<List<dynamic>> data;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              bottom: const TabBar(tabs: [
                Text("Compare"),
                Text("Before-After"),
              ]),
              actions: [
                Container(
                    padding: const EdgeInsetsDirectional.all(15),
                    height: double.infinity,
                    child: Center(
                      child: Text((controller.hasClients
                              ? (controller.page!.toInt() + 1).toString()
                              : "1") +
                          "/" +
                          widget.data.length.toString()),
                    )),
                ElevatedButton(
                  onPressed: () => setState(() {
                    if (controller.page!.toInt() != 0) {
                      controller.jumpToPage(controller.page!.toInt() - 1);
                    }
                  }),
                  child: const Icon(
                    Icons.arrow_left_outlined,
                    size: 48,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    // print(widget.data.length);
                    // print(controller.page!.toInt());
                    if (controller.page!.toInt() != widget.data.length - 1) {
                      controller.jumpToPage(controller.page!.toInt() + 1);
                    }
                  }),
                  child: const Icon(
                    Icons.arrow_right_outlined,
                    size: 48,
                  ),
                ),
              ],
            ),
            body: PageView.builder(
              controller: controller,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return TabBarView(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width / 3,
                              child: Image.network(
                                  widget.data[index][5].toString(),
                                  fit: BoxFit.fitWidth),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width / 3,
                              child: Image.network(
                                  widget.data[index][6].toString(),
                                  fit: BoxFit.fitWidth),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width / 3,
                              child: Image.network(
                                  widget.data[index][7].toString(),
                                  fit: BoxFit.contain),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Text(
                            "Case: " +
                                widget.data[index][0].toString() +
                                "\nEffect: " +
                                widget.data[index][1].toString() +
                                "\nDescription: " +
                                widget.data[index][3].toString() +
                                "\nPhoto name: " +
                                widget.data[index][4].toString() +
                                "\nResult: " +
                                widget.data[index][8].toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: BeforeAfter(
                          beforeImage: Image.network(
                            widget.data[index][5].toString(),
                            fit: BoxFit.contain,
                          ),
                          afterImage: Image.network(
                            widget.data[index][6].toString(),
                            fit: BoxFit.contain,
                          )),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }
}
