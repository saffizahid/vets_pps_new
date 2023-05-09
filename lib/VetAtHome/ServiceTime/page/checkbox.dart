import 'package:flutter/material.dart';

class DaysCheckboxWidget extends StatefulWidget {
  final List<String>? selectedDays;
  final List<int>? unselectedDays;

  DaysCheckboxWidget({this.selectedDays, this.unselectedDays});

  @override
  _DaysCheckboxWidgetState createState() => _DaysCheckboxWidgetState();
}

class _DaysCheckboxWidgetState extends State<DaysCheckboxWidget> {
  List<bool> _isCheckedList = [true,false, false, false, false, false, false, false];
  List<String> _daysList = [" ","Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  void initState() {
    super.initState();

    if (widget.selectedDays != null) {
      for (int i = 0; i < widget.selectedDays!.length; i++) {
        int index = _daysList.indexOf(widget.selectedDays![i]);
        if (index >= 0) {
          _isCheckedList[index] = true;
        }
      }
    }

    if (widget.unselectedDays != null) {
      for (int i = 0; i < widget.unselectedDays!.length; i++) {
        int index = widget.unselectedDays![i];
        if (index >= 0 && index < _isCheckedList.length) {
          _isCheckedList[index] = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("Select Days"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(_daysList.length, (int index) {
            if (index == 0) {
              // Skip the empty string at index 0
              return SizedBox.shrink();
            }
            return CheckboxListTile(
              title: Text(_daysList[index]),
              value: _isCheckedList[index],
              onChanged: (bool? value) {
                setState(() {
                  _isCheckedList[index] = value!;
                });
              },
            );
          }),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("CANCEL"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("SAVE"),
          onPressed: () {
            List<String> selectedDays = [];
            List<int> unselectedDays = [];

            for (int i = 0; i < _isCheckedList.length; i++) {
              if (_isCheckedList[i]) {
                selectedDays.add(_daysList[i]);
              } else {
                unselectedDays.add(i);
              }
            }

            Navigator.pop(context, {"selectedDays": selectedDays, "unselectedDays": unselectedDays});
          },
        ),
      ],
    );
  }
}
