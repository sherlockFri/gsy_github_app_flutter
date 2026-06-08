import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsy_github_app_flutter/widget/gsy_tabs.dart' as gsy;

void main() {
  testWidgets('tab tap responds immediately while preserving double tap',
      (WidgetTester tester) async {
    final List<int> taps = <int>[];
    final List<int> doubleTaps = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Material(
            child: gsy.TabBar(
              tabs: const <Widget>[
                gsy.Tab(text: 'Dynamic'),
                gsy.Tab(text: 'Trend'),
              ],
              onTap: taps.add,
              onDoubleTap: doubleTaps.add,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Trend'));

    expect(taps, <int>[1]);
    expect(doubleTaps, isEmpty);

    await tester.tap(find.text('Trend'));

    expect(taps, <int>[1, 1]);
    expect(doubleTaps, <int>[1]);
  });
}
