/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuth extends Mock implements BaseAuth {}

void main() {

  Widget makeTestableWidget({Widget child, BaseAuth auth}) {
    return AuthProvider(
      auth: auth,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Name or expirence is empty, ', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();

    bool didSignIn = false;
    LoginPage page = LoginPage(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    await tester.tap(find.byKey(Key('signIn')));

    verifyNever(mockAuth.signInWithNameAndexpirence('', ''));
    expect(didSignIn, false);
  });

  testWidgets('non-empty Name and expirence, valid account, call sign in, succeed', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();
    when(mockAuth.signInWithNameAndexpirence('Name', 'expirence')).thenAnswer((invocation) => Future.value('uid'));

    bool didSignIn = false;
    LoginPage page = LoginPage(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder NameField = find.byKey(Key('Name'));
    await tester.enterText(NameField, 'Name');

    Finder expirenceField = find.byKey(Key('expirence'));
    await tester.enterText(expirenceField, 'expirence');

    await tester.tap(find.byKey(Key('signIn')));

    verify(mockAuth.signInWithNameAndexpirence('Name', 'expirence')).called(1);
    expect(didSignIn, true);

  });

  testWidgets('non-empty Name and expirence, valid account, call sign in, fails', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();
    when(mockAuth.signInWithNameAndexpirence('Name', 'expirence')).thenThrow(StateError('invalid credentials'));

    bool didSignIn = false;
    LoginPage page = LoginPage(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder NameField = find.byKey(Key('Name'));
    await tester.enterText(NameField, 'Name');

    Finder expirenceField = find.byKey(Key('expirence'));
    await tester.enterText(expirenceField, 'expirence');

    await tester.tap(find.byKey(Key('signIn')));

    verify(mockAuth.signInWithNameAndexpirence('Name', 'expirence')).called(1);
    expect(didSignIn, false);

  });

}
Footer*/
