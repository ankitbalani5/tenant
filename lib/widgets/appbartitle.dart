import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/api/providerfuction.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/bill_bloc/bill_bloc.dart';
import '../screens/complain_bloc/complain_bloc.dart';
import '../screens/home_bloc/home_bloc.dart';
import '../screens/newhome.dart';
import '../utils/utils.dart';

class User {
  const User(this.name);
  final String name;
}

class Apptitle extends StatefulWidget {
  const Apptitle({Key? key}) : super(key: key);

  @override
  _ApptitleState createState() => _ApptitleState();
}

class _ApptitleState extends State<Apptitle> {
  static int dropdownvalue = 0;
  List<Residents>? _locations;
  Residents? _selectedLocation;
  String payment_from = '2023-01-01';
  String? payment_to ;
  String? name ;


  @override
  void initState() {
    fetchDate();
    // TODO: implement initState
    super.initState();
  }
  fetchDate() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name').toString();
    setState(() {

    });
    // BlocProvider.of<HomeBloc>(context).add(HomeRefreshEvent(prefs.getString('mobile_no').toString(), prefs.getString('branch_id').toString()));

    _locations = API.userdatalist;

    _selectedLocation = _locations![0];
    DateTime now = DateTime.now();
    payment_to = now.toString();
  }


  @override
  Widget build(BuildContext context) {

    return Row(

        children: [
          const SizedBox(width: 40),
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Text(
              'Hi, ',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // const SizedBox(width: 10),
          Container(
            width: 180,
            child: Text(name.toString(),
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
          )
          // Theme(
          //   data: Theme.of(context).copyWith(
          //     canvasColor: Constant.bgLight,
          //   ),
          //   child: DropdownButton<Residents>(
          //     value: _selectedLocation,
          //     icon: const Icon(Icons.arrow_drop_down),
          //     iconSize: 0,
          //     elevation: 16,
          //     style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          //     underline: Container(height: 0),
          //     onChanged: (Residents? newValue) async {
          //       _selectedLocation = newValue!;
          //       final SharedPreferences prefs = await SharedPreferences.getInstance();
          //       prefs.setString('selected_dropdown', newValue.toString());
          //       prefs.getString('branch_id');
          //       print("USER ID ${newValue.tenantId}");
          //       prefs.setString('tenant_id', newValue.tenantId.toString());
          //       // NewHomeApp.userBills = await API.bill(newValue.tenantId.toString());
          //       BlocProvider.of<BillBloc>(context).add(BillRefreshEvent('gatResidentPaymentData', prefs.getString('branch_id').toString(), newValue.tenantId.toString(), payment_from.toString(), payment_to.toString()));
          //       // NewHomeApp.userComplains = await API.complains(newValue.tenantId.toString());
          //       BlocProvider.of<ComplainBloc>(context).add(ComplainRefreshEvent(newValue.tenantId.toString()));
          //       setState(() {
          //         //apiprovider.userID=NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['tenant_id'];
          //         prefs.setString('id', newValue.tenantId.toString());
          //       });
          //       },
          //     items: _locations?.map((Residents value) {
          //       print('resident name.............${value.residentName.toString()}');
          //       return DropdownMenuItem(
          //         value: value,
          //         child: Text(value.residentName.toString()??""),
          //       );
          //     }).toList(),
          //     // selectedItemBuilder: (BuildContext context) {
          //     //   return Apptitle._locations.map((String value) {
          //     //     return Text(
          //     //       Apptitle._selectedLocation,
          //     //       style: const TextStyle(
          //     //         color: Colors.white,
          //     //       ),
          //     //     );
          //     //   }).toList();
          //     // },
          //   ),
          // ),
        ],
      );

  }
}
