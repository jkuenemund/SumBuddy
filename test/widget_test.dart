import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sum_buddy/app.dart';
import 'package:sum_buddy/features/game/presentation/pages/game_page.dart';
import 'package:sum_buddy/features/game/presentation/widgets/sum_buddy_game_widget.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  testWidgets('App launches and displays GamePage', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SumBuddyApp());

    // Verify that GamePage is present.
    expect(find.byType(GamePage), findsOneWidget);

    // Verify that SumBuddyGameWidget is present.
    expect(find.byType(SumBuddyGameWidget), findsOneWidget);
  });
}
