import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  bool isDateTimePicker;
  String hintText;

  static DateTime selectedDate;
  static DateTime selectedTime;

  DateTimePicker(this.isDateTimePicker) {
    this.hintText = isDateTimePicker ? 'Escolha o Horário' : 'Escolha a Data';
  }
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        width: double.infinity,
        child: FlatButton(
            color: Color.fromRGBO(245, 245, 245, 1),
            onPressed: () {
              widget.isDateTimePicker
                  ? DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                          doneStyle:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onChanged: (date) {}, onConfirm: (date) {
                      var formatter = new DateFormat('HH:mm');

                      setState(() {
                        widget.hintText = formatter.format(date);
                        DateTimePicker.selectedTime = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.pt)
                  : DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                          doneStyle:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onChanged: (date) {}, onConfirm: (date) {
                      var formatter = new DateFormat('dd/MM/yyyy');

                      setState(() {
                        widget.hintText = formatter.format(date);
                        DateTimePicker.selectedDate = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.pt);
            },
            child: Text(widget.hintText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w400,
                    fontSize: 16))));
  }
}
