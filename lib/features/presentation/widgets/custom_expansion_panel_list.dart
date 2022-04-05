import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

late double _kPanelHeaderCollapsedHeight = 0;
late double _kPanelHeaderExpandedHeight = 0;

class CustomExpansionPanel extends ExpansionPanel {
  CustomExpansionPanel({
    required this.headerBuilder,
    required this.body,
    this.isExpanded = false,
    this.canTapOnHeader = true,
    this.backgroundColor,
    this.kPanelHeaderCollapsedHeight = 45.0,
    this.kPanelHeaderExpandedHeight = 45.0,
  })  : assert(headerBuilder != null),
        assert(body != null),
        assert(isExpanded != null),
        assert(canTapOnHeader != null),
        super(
            body: body,
            headerBuilder: headerBuilder,
            isExpanded: isExpanded,
            canTapOnHeader: canTapOnHeader,
            backgroundColor: backgroundColor) {
    _kPanelHeaderCollapsedHeight = kPanelHeaderCollapsedHeight;
    _kPanelHeaderExpandedHeight = kPanelHeaderExpandedHeight;
  }

  final ExpansionPanelHeaderBuilder headerBuilder;
  final Widget body;
  final bool isExpanded;
  final bool canTapOnHeader;
  final Color? backgroundColor;
  final double kPanelHeaderCollapsedHeight;
  final double kPanelHeaderExpandedHeight;
}

class CustomExpansionPanelList extends StatelessWidget {
  const CustomExpansionPanelList(
      {Key? key,
      this.children: const <CustomExpansionPanel>[],
      required this.expansionCallback,
      this.animationDuration: kThemeAnimationDuration,
      required this.dividerColor})
      : assert(children != null),
        assert(animationDuration != null),
        super(key: key);

  final List<CustomExpansionPanel> children;

  final ExpansionPanelCallback expansionCallback;

  final Duration animationDuration;

  final Color dividerColor;

  bool _isChildExpanded(int index) {
    return children[index].isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    EdgeInsets kExpandedEdgeInsets = EdgeInsets.symmetric(
        vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

    for (int index = 0; index < children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
        items.add(new Divider(
          key: new _SaltedKey<BuildContext, int>(context, index * 2 - 1),
          height: 15.0,
          color: Colors.transparent,
        ));

      final Row header = new Row(
        children: <Widget>[
          new Expanded(
            child: new AnimatedContainer(
              duration: animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index)
                  ? kExpandedEdgeInsets
                  : EdgeInsets.zero,
              child: new SizedBox(
                height: _kPanelHeaderCollapsedHeight * 2.3,
                child: children[index].headerBuilder(
                  context,
                  children[index].isExpanded,
                ),
              ),
            ),
          ),
        ],
      );

      double _radiusValue = _isChildExpanded(index) ? 8.0 : 8.0;
      items.add(
        new Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: new GestureDetector(
            onTap: () {
              if (expansionCallback != null)
                expansionCallback(index, children[index].isExpanded);
            },
            child: Container(
              key: new _SaltedKey<BuildContext, int>(context, index * 2),
              child: new Material(
                shadowColor: ColorHelper().colorFromHex('#989cb8'),
                elevation: 2.0,
                borderRadius: new BorderRadius.all(
                  new Radius.circular(
                    SharedController().getAdaptiveTextSize(context, 17),
                  ),
                ),
                child: new Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                        Radius.circular(
                          SharedController().getAdaptiveTextSize(context, 17),
                        ),
                      )),
                      child: header,
                    ),
                    new AnimatedCrossFade(
                      firstChild: new Container(height: 0.0),
                      secondChild: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                            SharedController().getAdaptiveTextSize(context, 17),
                          )),
                        ),
                        child: children[index].body,
                      ),
                      firstCurve:
                          const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                      secondCurve:
                          const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                      sizeCurve: Curves.fastOutSlowIn,
                      crossFadeState: _isChildExpanded(index)
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: animationDuration,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      if (_isChildExpanded(index) && index != children.length - 1)
        items.add(new Divider(
          key: new _SaltedKey<BuildContext, int>(context, index * 2 + 1),
          height: 15.0,
        ));
    }

    return new Column(
      children: items,
    );
  }
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}
