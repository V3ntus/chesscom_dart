# chesscom_dart
A work-in-progress Chess.com API wrapper for Dart.

## Installation
1. Add `chesscom_dart` as a Git dependency to your `pubspec`:
```yaml
dependencies:
 chesscom_dart:
   git: https://github.com/V3ntus/chesscom_dart.git
```

2. Instantiate the client:
```dart
import 'package:chesscom_dart/chesscom_dart.dart';

void main() {
  final client = ChessFactory.createClient();

  final profile = await client.fetchProfile("erik");
  print(profile.username);
}
```
3. Done!