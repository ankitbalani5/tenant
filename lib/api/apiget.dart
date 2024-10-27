import 'package:roomertenant/screens/newhome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  static var dropdowndata;
  static List<String> dropdatalist = [];
  static var midvar;
  static var data;
  static var rent = 0.0;
  static apiget() async {
    final response = await http.post(
        Uri.parse('https://dashboard.btroomer.com/api/getHomeData'),
        body: {
          "user_id": "1",
          "pg_id": "1",
          "branch_id": "1",
          "role": "owner"
        });
    API.dropdowndata = json.decode(response.body);
    // dropdown button values go from here
    for (int i = 0; i < dropdowndata['branch'].length; i++) {
      API.dropdatalist.add(dropdowndata['branch'][i]['branch_name']);
    }
    API.data = json.decode(response.body);
    return json.decode(response.body);
  }

  static totaldues(value) async {
    API.midvar = API.data['branch'][value]['total_collections'];
    for (int i = 0;
        i < API.data['branch'][value]['upcoming_fees'].length;
        i++) {
      API.rent += (double.parse(data['branch'][value]['upcoming_fees'][i]
                      ['rent']
                  .toString()) +
              double.parse(API.data['branch'][value]['upcoming_fees'][i]
                      ['total_due']
                  .toString())) -
          double.parse(API.data['branch'][value]['upcoming_fees'][i]
                  ['total_advance']
              .toString());
      // data here

    }
    return API.rent;
  }
}
