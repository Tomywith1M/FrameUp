import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

enum DemoAppUser {
  ariana,
  jared,
  john,
  tomy,
}

extension DemoAppUserX on DemoAppUser {
  String? get id => {
        DemoAppUser.ariana: 'ariana-grande',
        DemoAppUser.jared: 'jared-letto',
        DemoAppUser.john: 'john-cena',
        DemoAppUser.tomy: 'tomy-tran',
      }[this];

  String? get name => {
        DemoAppUser.ariana: 'Ariana Grande',
        DemoAppUser.jared: 'Jared Letto',
        DemoAppUser.john: 'John Cena',
        DemoAppUser.tomy: 'Tomy Tran',
      }[this];

  Map<String, Object>? get data => {
        DemoAppUser.ariana: {
          'first_name': 'Ariana',
          'last_name': 'Grande',
          'full_name': 'Ariana Grande',
        },
        DemoAppUser.jared: {
          'first_name': 'Jared',
          'last_name': 'Letto',
          'full_name': 'Jared Letto',
        },
        DemoAppUser.john: {
          'first_name': 'John',
          'last_name': 'Cena',
          'full_name': 'John Cena',
        },
        DemoAppUser.tomy: {
          'first_name': 'Tomy',
          'last_name': 'Tran',
          'full_name': 'Tomy Tran',
        },
      }[this];

  Token? get token => <DemoAppUser, Token>{
        DemoAppUser.ariana: const Token(
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTA5NDI0NTksInVzZXJfaWQiOiJhcmlhbmEtZ3JhbmRlIn0.30jocLZbmm-MjJRvdI3O9Z49RazUqu6H7HKBcMQL-O4'),
        DemoAppUser.jared: const Token(
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTA5NDI0NjYsInVzZXJfaWQiOiJqYXJlZC1sZXR0byJ9.0ZiGUit-wjZsMHu5qy82JcLeUw46z1ZCY2PosSPj6us'),
        DemoAppUser.john: const Token(
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTA5NDI0NTMsInVzZXJfaWQiOiJqb2huLWNlbmEifQ.tAU0DHdb7KKDs18woAmNHqx9pCQpTTPB4KNt5Mvz0s8'),
        DemoAppUser.tomy: const Token(
            'yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTA5NDI0NDUsInVzZXJfaWQiOiJ0b215LXRyYW4ifQ.3uH1cmen92vLZRuWfR_pqaQFr7pAVL1v8kJjJ3EMlqQ'),
      }[this];
}
