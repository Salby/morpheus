import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:mockito/mockito.dart';

class MainScreen extends StatelessWidget {
  final _parentKey = GlobalKey();
  static const navigateToDetailsButtonKey = Key('navigateToDetails');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main screen')),
      body: Card(
        key: _parentKey,
        child: FlatButton(
          key: navigateToDetailsButtonKey,
          onPressed: () => _navigateToDetailsScreen(context),
          child: Text('Navigate to details screen!'),
        ),
      ),
    );
  }

  void _navigateToDetailsScreen(BuildContext context) {
    final route = MorpheusPageRoute(
        builder: (_) => DetailsScreen('Hello!'), parentKey: _parentKey);
    Navigator.of(context).push(route);
  }
}

class DetailsScreen extends StatelessWidget {
  DetailsScreen(this.message);

  final String message;
  static const popWithResultButtonKey = Key('popWithResult');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details screen'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            key: popWithResultButtonKey,
            onPressed: () => Navigator.pop(context, 'Popped.'),
            child: Text('Click me!'),
          ),
          Text(message),
        ],
      ),
    );
  }
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('MorpheusPageRoute navigation tests', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<Null> _buildMainScreen(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MainScreen(),

        /// This mocked observer will now receive all navigation events
        /// that happen in our app.
        navigatorObservers: [mockObserver],
      ));

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    Future<Null> _navigateToDetailsScreen(WidgetTester tester) async {
      /// Tap the button which should navigate to the details screen.
      /// By calling tester.pumpAndSettle(), we ensure that all animations
      /// have completed before we continue further.
      await tester.tap(find.byKey(MainScreen.navigateToDetailsButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets(
        'when tapping "navigate to details" button, should navigate to details screen',
        (WidgetTester tester) async {
      await _buildMainScreen(tester);
      await _navigateToDetailsScreen(tester);

      // By tapping the button, we should've now navigated to the details
      // screen. The didPush() method should've been called...
      verify(mockObserver.didPush(any, any));

      // ...and there should be a Detailsscreen present in the widget tree...
      expect(find.byType(DetailsScreen), findsOneWidget);

      // ...with the message we sent from main screen.
      expect(find.text('Hello!'), findsOneWidget);
    });

    testWidgets('tapping "click me" should pop with a result',
        (WidgetTester tester) async {
      /// We'll build the main page and navigate to details first.
      await _buildMainScreen(tester);
      await _navigateToDetailsScreen(tester);

      /// Then we'll verify that the details route was pushed again, but
      /// this time, we'll capture the pushed route.
      final Route pushedRoute =
          verify(mockObserver.didPush(captureAny, any)).captured.single;

      /// We declare a popResult variable and assign the result to it
      /// when the details route is popped.
      String popResult;
      pushedRoute.popped.then((result) => popResult = result);

      /// Pop the details route with a result by tapping the button.
      await tester.tap(find.byKey(DetailsScreen.popWithResultButtonKey));
      await tester.pumpAndSettle();

      /// popResult should now contain whatever the details page sent when
      /// calling `Navigator.pop()`. In this case, "Popped.".
      expect(popResult, 'Popped.');
    });
  });
}
