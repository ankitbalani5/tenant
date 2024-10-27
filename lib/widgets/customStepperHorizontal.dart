import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomertenant/model/complain_model.dart';
// // import 'package:hexcolor/hexcolor.dart';
//
// class StepProgressView extends StatelessWidget {
//   final double _width;
//
//   final List<String> _titles;
//   final int _curStep;
//   final Color _activeColor;
//   final Color _inactiveColor = Color(0xffE6EEF3);
//   final double lineWidth = 3.0;
//
//   StepProgressView(
//       {
//         required int curStep,
//         required List<String> titles,
//         required double width,
//         required Color color})
//       : _titles = titles,
//         _curStep = curStep,
//         _width = width,
//         _activeColor = color,
//         assert(width > 0);
//
//   Widget build(BuildContext context) {
//     return Container(
//         width: this._width,
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: _iconViews(),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: _titleViews(),
//             ),
//           ],
//         ));
//   }
//
//   List<Widget> _iconViews() {
//     var list = <Widget>[];
//     _titles.asMap().forEach((i, icon) {
//       var circleColor = (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;
//       var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;
//       var iconColor = (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;
//
//       list.add(
//         Container(
//           width: 20.0,
//           height: 20.0,
//           padding: EdgeInsets.all(0),
//           decoration: new BoxDecoration(
//             /* color: circleColor,*/
//             borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
//             border: new Border.all(
//               color: circleColor,
//               width: 2.0,
//             ),
//           ),
//           child: Icon(
//             Icons.circle,
//             color: iconColor,
//             size: 12.0,
//           ),
//         ),
//       );
//
//       //line between icons
//       if (i != _titles.length - 1) {
//         list.add(Expanded(
//             child: Container(
//               height: lineWidth,
//               color: lineColor,
//             )));
//       }
//     });
//
//     return list;
//   }
//
//   List<Widget> _titleViews() {
//     var list = <Widget>[];
//     _titles.asMap().forEach((i, text) {
//       list.add(Text(text, style: TextStyle(color: Color(0xff000000))));
//     });
//     return list;
//   }
// }

/*class StepProgressView extends StatefulWidget {
  // String status;
  late List _page2item;
  late List _page2complist;
  late bool _isPending;
  StepProgressView({
    required page2item,
    required page2complist,
    required isPending})
      : _page2item = page2item,
  _page2complist = page2complist,
  _isPending = isPending;

  @override
  State<StepProgressView> createState() => _StepProgressViewState();
}
// my created
class _StepProgressViewState extends State<StepProgressView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('02 Jan 2024', style: TextStyle(color: Color(0xffABAFB8)),),
              Text(widget._page2complist[index]['trail'][index1]['status'], style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 18),)
            ],
          ),
          Row(
            children: [
              Container(
                height: 2,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.orange
                ),
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
              Container(
                height: 2,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.green
                ),
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 18)),
              Text('11 Jan 2024', style: TextStyle(color: Color(0xffABAFB8)),)
            ],
          ),

        ],
      ),
    );
  }
}*/

class StepProgressView extends StatelessWidget {
  late List<Trail>? _trail;
  late bool _isPending;

  StepProgressView({Key? key,
    required List<Trail>? trail,
    required bool isPending,
  })  : _trail = trail,
        _isPending = isPending, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _isPending ? 180 : 200,
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_trail!.first.remarkDate.toString(), style: const TextStyle(color: Color(0xffABAFB8)),),
              // Text(_trail.first['remark_date'], style: const TextStyle(color: Color(0xffABAFB8)),),
              _trail!.last.status == 'Pending'
              // _trail.last['status'] == 'Pending'
                  ? const SizedBox()
                  : Text(_trail!.last.status.toString(),
                  // : Text(_trail.last['status'],
                    style: TextStyle(color: _trail!.last.status == 'Completed' ? Colors.green : Colors.red,
                    // style: TextStyle(color: _trail.last['status'] == 'Completed' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500, fontSize: 18),)
            ],
          ),
          Row(
            children: [
              Container(
                height: 2,
                width: 80,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                ),
              ),
              _trail!.last.status == 'Pending'
              // _trail.last['status'] == 'Pending'
                  ? const SizedBox()
                  : Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                decoration: BoxDecoration(
                  color: _trail!.last.status == 'Completed' ? Colors.green : _trail!.last.status == 'Pending' ? Colors.orange : Colors.red,
                  // color: _trail.last['status'] == 'Completed' ? Colors.green : _trail.last['status'] == 'Pending' ? Colors.orange : Colors.red,
                ),
              ),
              _trail!.last.status == 'Completed'
              // _trail.last['status'] == 'Completed'
              ? Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
              ) : _trail!.last.status == 'Rejected' ?
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ) :
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 18)),
              Text(_trail!.last.status == 'Pending' ? '' : _trail!.last.remarkDate.toString(), style: const TextStyle(color: Color(0xffABAFB8)),)
              // Text(_trail.last['status'] == 'Pending' ? '' : _trail.last['remark_date'], style: const TextStyle(color: Color(0xffABAFB8)),)
            ],
          ),
        ],
      ),
    );
  }
}

