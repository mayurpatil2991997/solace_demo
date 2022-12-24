import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:solace_task/base_url/common_base_url.dart';
import 'package:solace_task/model/data/data_model.dart';
import 'package:http/http.dart' as http;

class ListDataScreen extends StatefulWidget {
  const ListDataScreen({Key key}) : super(key: key);

  @override
  _ListDataScreenState createState() => _ListDataScreenState();
}

class _ListDataScreenState extends State<ListDataScreen> {
  DataModel listData;

  Future<DataModel> displaydata() async {
    try {
      final response = await http.get(
        Uri.parse('${BaseUrl.Url}/users?delay=3'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        listData = DataModel.fromJson(responseJson);
        return listData;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<DataModel>(
                  future: displaydata(),
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      return customCard(snapShot.data);
                    } else if (snapShot.hasError) {
                      return const Center(
                          child: Text(
                            "Something went wrong",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget customCard(DataModel item) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: ListView.builder(
          padding: EdgeInsets.all(2.0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: item.data.length,
          itemBuilder: (BuildContext context, index) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              margin: EdgeInsets.all(4.0),
              alignment: Alignment.topLeft,
              // height: height * 0.15,
              width: width * 1,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.network(
                              item.data[index].avatar
                          ),
                        ),
                        radius: 18.0,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.data[index].firstName,
                                style: TextStyle(
                                    color: Color.fromRGBO(13, 13, 13, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                item.data[index].lastName,
                                style: TextStyle(
                                    color: Color.fromRGBO(13, 13, 13, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            item.data[index].email,
                            style: TextStyle(
                                color: Color.fromRGBO(67, 69, 69, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Chip(
                    elevation: 0,
                    // padding: EdgeInsets.all(8),
                    backgroundColor: Color.fromRGBO(191, 218, 208, 1),
                    shadowColor: Colors.black,
                    label: Text(
                      'Celloip',
                      style: TextStyle(fontSize: 10),
                    ), //Text
                  ),
                ],
              ),
            );
          }),
    );
  }
}
