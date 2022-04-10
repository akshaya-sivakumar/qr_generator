import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:qr_generator/model/lastlogin_model.dart';

import 'package:qr_generator/ui/widgets/scaffold.dart';
import 'package:qr_generator/ui/widgets/text_widget.dart';

class LastLogin extends StatefulWidget {
  const LastLogin(this.lastloginlist, {Key? key}) : super(key: key);
  final List<LastloginModel> lastloginlist;
  @override
  State<LastLogin> createState() => _LastLoginState();
}

class _LastLoginState extends State<LastLogin> with TickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController?.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        heading: "LAST LOGIN",
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTabController(
                  length: 3,
                  child: TabBar(
                    controller: _tabController,
                    indicatorWeight: 4,
                    indicatorColor: Colors.white,
                    isScrollable: true,
                    tabs: [
                      Tab(
                          icon: TextWidget(
                        _tabController?.index == 0 ? "TODAY" : "Today",
                        color: Colors.white,
                        fontSize: _tabController?.index == 0 ? 14 : 13,
                      )),
                      Tab(
                        icon: TextWidget(
                          _tabController?.index == 1
                              ? "YESTERDAY"
                              : "Yesterday",
                          color: Colors.white,
                          fontSize: _tabController?.index == 1 ? 14 : 13,
                        ),
                      ),
                      Tab(
                          icon: TextWidget(
                        _tabController?.index == 2 ? "OTHER" : "Other",
                        color: Colors.white,
                        fontSize: _tabController?.index == 2 ? 14 : 13,
                      )),
                    ],
                  ),
                ),
                listview(context),
              ],
            ),
          ),
        ));
  }

  List<LastloginModel> lastloginlist = [];
  Widget listview(BuildContext context) {
    lastloginlist = widget.lastloginlist
        .where((element) => _tabController?.index == 0
            ? DateFormat("dd-MM-yyyy")
                    .format(DateTime.parse(element.lastlogin)) ==
                DateFormat("dd-MM-yyyy").format(DateTime.now())
            : _tabController?.index == 1
                ? DateFormat("dd-MM-yyyy")
                        .format(DateTime.parse(element.lastlogin)) ==
                    DateFormat("dd-MM-yyyy").format(
                        DateTime.now().subtract(const Duration(days: 1)))
                : DateTime.now()
                        .difference(DateTime.parse(element.lastlogin))
                        .inDays >
                    2)
        .toList();
    return Container(
      child: lastloginlist.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: const TextWidget("No data found", color: Colors.white))
          : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: lastloginlist.length,
              itemBuilder: (BuildContext context, int index) {
                return listCard(lastloginlist[index]);
              }),
    );
  }

  Widget listCard(LastloginModel details) {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.82,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              height: 80,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(137, 46, 45, 45),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("hh:mm aa")
                              .format(DateTime.parse(details.lastlogin)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "IP:" + details.userip,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          details.location,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: MediaQuery.of(context).size.height * 0.0499,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                details.qrimage,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: child);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                },
                width: 85,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
