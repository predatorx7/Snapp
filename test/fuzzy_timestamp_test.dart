import 'package:timeago/timeago.dart' as timeago;

main() {
  final timeDuration = new DateTime.now().subtract(new Duration(days: 1));
  final DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(1546553448639);

  print(timeago.format(timeDuration)); // 15 minutes ago
  print(timeago.format(timeDuration, locale: 'en_short')); // 15 min
  print(timeago.format(timeDuration, locale: 'es')); // hace 15 minutos
  print(timeago.format(timeStamp)); // 15 minutes ago
  print(timeago.format(timeStamp, locale: 'en_short')); // 15 min
  print(timeago.format(timeStamp, locale: 'es')); // hace 15 minutos
}
