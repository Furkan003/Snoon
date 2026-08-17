import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';

const weekdayShort = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
const weekdayLong = [
  'Pazartesi',
  'Salı',
  'Çarşamba',
  'Perşembe',
  'Cuma',
  'Cumartesi',
  'Pazar',
];
const monthNames = [
  'Ocak',
  'Şubat',
  'Mart',
  'Nisan',
  'Mayıs',
  'Haziran',
  'Temmuz',
  'Ağustos',
  'Eylül',
  'Ekim',
  'Kasım',
  'Aralık',
];

String twoDigits(int value) => value.toString().padLeft(2, '0');
String clockText(int hour, int minute) =>
    '${twoDigits(hour)}:${twoDigits(minute)}';

String rangeClockText(int minutes) =>
    clockText((minutes ~/ 60) % 24, minutes % 60);

String shortDate(DateTime date) =>
    '${date.day} ${monthNames[date.month - 1]} ${date.year}';

String dateTimeText(DateTime date) =>
    '${shortDate(date)} • ${clockText(date.hour, date.minute)}';

String weekdayShortLocalized(BuildContext context, int mondayBasedIndex) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.E(locale).format(DateTime(2024, 1, mondayBasedIndex + 1));
}

String shortDateLocalized(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.MMMd(locale).format(date);
}

String dateTimeTextLocalized(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return '${DateFormat.yMMMd(locale).format(date)} • ${DateFormat.Hm(locale).format(date)}';
}

String repeatSummary(List<int> days) {
  if (days.isEmpty) return 'Bir kez';
  if (days.length == 7) return 'Her gün';
  if (days.length == 5 && [1, 2, 3, 4, 5].every(days.contains)) {
    return 'Hafta içi';
  }
  if (days.length == 2 && [6, 7].every(days.contains)) return 'Hafta sonu';
  return days.map((day) => weekdayShort[day - 1]).join(', ');
}

String repeatSummaryLocalized(BuildContext context, List<int> days) {
  final l10n = context.l10n;
  if (days.isEmpty) return l10n.once;
  if (days.length == 7) return l10n.everyDay;
  if (days.length == 5 && [1, 2, 3, 4, 5].every(days.contains)) {
    return l10n.weekdays;
  }
  if (days.length == 2 && [6, 7].every(days.contains)) return l10n.weekend;
  return days.map((day) => weekdayShortLocalized(context, day - 1)).join(', ');
}

Future<TimeOfDay?> pickClockTime(BuildContext context, TimeOfDay initial) =>
    showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFFB7B9C5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

class SettingCard extends StatelessWidget {
  const SettingCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Column(children: children),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 34,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFA7A9B5), height: 1.45),
          ),
        ],
      ),
    ),
  );
}
