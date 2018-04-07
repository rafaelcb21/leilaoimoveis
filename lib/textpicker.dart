import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TextPicker extends StatelessWidget {
  static const double DEFAULT_ITEM_EXTENT = 50.0;
  static const double DEFUALT_LISTVIEW_WIDTH = 100.0;

  TextPicker({
    Key key,
    @required int initialValue,
    @required this.listName,
    @required this.onChanged,
    this.itemExtent = DEFAULT_ITEM_EXTENT,
    this.listViewWidth = DEFUALT_LISTVIEW_WIDTH,
  })
      : assert(initialValue != null),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = new ScrollController(
          initialScrollOffset: (initialValue - 0) * itemExtent,
        ),
        decimalScrollController = null,
        _listViewHeight = 3 * itemExtent,
        super(key: key);

  final ValueChanged<num> onChanged;
  final int minValue = 0;
  final int decimalPlaces;
  final List listName;
  final double itemExtent;
  final double _listViewHeight;
  final double listViewWidth;
  final ScrollController intScrollController;
  final ScrollController decimalScrollController;
  final int selectedIntValue;
  final int selectedDecimalValue;

  //
  //----------------------------- PUBLIC ------------------------------
  //

  animateInt(int valueToSelect) {
    _animate(intScrollController, (valueToSelect - minValue) * itemExtent);
  }

  //
  //----------------------------- VIEWS -----------------------------
  //

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
      return _integerListView(themeData);
  }

  Widget _integerListView(ThemeData themeData) {
    TextStyle defaultStyle = themeData.textTheme.body1;
    TextStyle selectedStyle = 
      themeData.textTheme.subhead.copyWith(color: themeData.accentColor);

    int itemCount = this.listName.length - minValue + 2;
    
    return new NotificationListener(
      child: new Container(
        height: _listViewHeight,
        width: listViewWidth,
        child: new ListView.builder(
          controller: intScrollController,
          itemExtent: itemExtent,
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            final int value = minValue + index - 1;
            final TextStyle itemStyle =
            value == selectedIntValue ? selectedStyle : defaultStyle;

            bool isExtra = index == 0 || index == itemCount - 1;

            return isExtra
              ? new Container()
              : new Center(
                  child: new Text(listName[value], style: itemStyle),
                );
          },
        ),
      ),
      onNotification: _onIntegerNotification,
    );
  }

  //
  // ----------------------------- LOGIC -----------------------------
  //

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int intIndexOfMiddleElement =
          (notification.metrics.pixels + _listViewHeight / 2) ~/ itemExtent;
      int intValueInTheMiddle = minValue + intIndexOfMiddleElement - 1;

      if (_userStoppedScrolling(notification, intScrollController)) {
        animateInt(intValueInTheMiddle);
      }

      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;
        if (decimalPlaces == 0) {
          newValue = (intValueInTheMiddle);
        }
        onChanged(newValue);
      }
    }
    return true;
  }

  bool _userStoppedScrolling(Notification notification,
    ScrollController scrollController) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(value,
        duration: new Duration(seconds: 1), curve: new ElasticOutCurve());
  }
}

class TextPickerDialog extends StatefulWidget {
  final List listName;
  final int initialIntegerValue;
  final double initialDoubleValue;
  final int decimalPlaces;
  final Widget title;
  final EdgeInsets titlePadding;
  final Widget confirmWidget;
  final Widget cancelWidget;

  TextPickerDialog({
    @required this.listName,
    @required this.initialIntegerValue,
    this.title,
    this.titlePadding,
    Widget confirmWidget,
    Widget cancelWidget,
  })
      : confirmWidget = confirmWidget ?? new Text("OK"),
        cancelWidget = cancelWidget ?? new Text("CANCEL"),
        decimalPlaces = 0,
        initialDoubleValue = -1.0;

  @override
  State<TextPickerDialog> createState() =>
      new _TextPickerDialogControllerState(
          initialIntegerValue, initialDoubleValue, this.listName);
}

class _TextPickerDialogControllerState extends State<TextPickerDialog> {
  int selectedIntValue;
  double selectedDoubleValue;
  List listName;

  _TextPickerDialogControllerState(this.selectedIntValue,
      this.selectedDoubleValue, this.listName);

  _handleValueChanged(num value) {
    if (value is int) {
      setState(() => selectedIntValue = value);
    } else {
      setState(() => selectedDoubleValue = value);
    }
  }

  TextPicker _buildTextPicker() {
    return new TextPicker(
      listName: this.listName,
      initialValue: selectedIntValue,
      onChanged: _handleValueChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: _buildTextPicker(),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(widget.decimalPlaces > 0
              ? selectedDoubleValue
              : selectedIntValue),
          child: widget.confirmWidget),
      ],
    );
  }
}
