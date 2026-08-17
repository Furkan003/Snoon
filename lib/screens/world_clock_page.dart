import 'dart:async';

import 'package:flutter/material.dart';

import '../models/alarm_models.dart';
import '../l10n/l10n.dart';
import '../services/app_store.dart';
import '../ui/ui_helpers.dart';

class WorldClockPage extends StatefulWidget {
  const WorldClockPage({super.key, required this.store});
  final AppStore store;

  @override
  State<WorldClockPage> createState() => _WorldClockPageState();
}

class _WorldClockPageState extends State<WorldClockPage> {
  late Timer _timer;
  DateTime _now = DateTime.now().toUtc();

  static const presets = [
    WorldCity(
      name: 'İstanbul',
      offsetMinutes: 180,
      timeZoneId: 'Europe/Istanbul',
    ),
    WorldCity(name: 'Londra', offsetMinutes: 0, timeZoneId: 'Europe/London'),
    WorldCity(name: 'Paris', offsetMinutes: 60, timeZoneId: 'Europe/Paris'),
    WorldCity(name: 'Berlin', offsetMinutes: 60, timeZoneId: 'Europe/Berlin'),
    WorldCity(name: 'Moskova', offsetMinutes: 180, timeZoneId: 'Europe/Moscow'),
    WorldCity(name: 'Roma', offsetMinutes: 60, timeZoneId: 'Europe/Rome'),
    WorldCity(name: 'Madrid', offsetMinutes: 60, timeZoneId: 'Europe/Madrid'),
    WorldCity(
      name: 'Amsterdam',
      offsetMinutes: 60,
      timeZoneId: 'Europe/Amsterdam',
    ),
    WorldCity(name: 'Atina', offsetMinutes: 120, timeZoneId: 'Europe/Athens'),
    WorldCity(name: 'Kahire', offsetMinutes: 120, timeZoneId: 'Africa/Cairo'),
    WorldCity(
      name: 'Cape Town',
      offsetMinutes: 120,
      timeZoneId: 'Africa/Johannesburg',
    ),
    WorldCity(name: 'Dubai', offsetMinutes: 240, timeZoneId: 'Asia/Dubai'),
    WorldCity(name: 'Riyad', offsetMinutes: 180, timeZoneId: 'Asia/Riyadh'),
    WorldCity(name: 'Tahran', offsetMinutes: 210, timeZoneId: 'Asia/Tehran'),
    WorldCity(
      name: 'Yeni Delhi',
      offsetMinutes: 330,
      timeZoneId: 'Asia/Kolkata',
    ),
    WorldCity(name: 'Pekin', offsetMinutes: 480, timeZoneId: 'Asia/Shanghai'),
    WorldCity(name: 'Tokyo', offsetMinutes: 540, timeZoneId: 'Asia/Tokyo'),
    WorldCity(name: 'Seul', offsetMinutes: 540, timeZoneId: 'Asia/Seoul'),
    WorldCity(
      name: 'Singapur',
      offsetMinutes: 480,
      timeZoneId: 'Asia/Singapore',
    ),
    WorldCity(name: 'Bangkok', offsetMinutes: 420, timeZoneId: 'Asia/Bangkok'),
    WorldCity(name: 'Cakarta', offsetMinutes: 420, timeZoneId: 'Asia/Jakarta'),
    WorldCity(
      name: 'Hong Kong',
      offsetMinutes: 480,
      timeZoneId: 'Asia/Hong_Kong',
    ),
    WorldCity(
      name: 'Sidney',
      offsetMinutes: 600,
      timeZoneId: 'Australia/Sydney',
    ),
    WorldCity(
      name: 'New York',
      offsetMinutes: -300,
      timeZoneId: 'America/New_York',
    ),
    WorldCity(
      name: 'Chicago',
      offsetMinutes: -360,
      timeZoneId: 'America/Chicago',
    ),
    WorldCity(
      name: 'Los Angeles',
      offsetMinutes: -480,
      timeZoneId: 'America/Los_Angeles',
    ),
    WorldCity(
      name: 'Toronto',
      offsetMinutes: -300,
      timeZoneId: 'America/Toronto',
    ),
    WorldCity(
      name: 'Vancouver',
      offsetMinutes: -480,
      timeZoneId: 'America/Vancouver',
    ),
    WorldCity(
      name: 'Mexico City',
      offsetMinutes: -360,
      timeZoneId: 'America/Mexico_City',
    ),
    WorldCity(
      name: 'São Paulo',
      offsetMinutes: -180,
      timeZoneId: 'America/Sao_Paulo',
    ),
    WorldCity(
      name: 'Buenos Aires',
      offsetMinutes: -180,
      timeZoneId: 'America/Argentina/Buenos_Aires',
    ),
    WorldCity(
      name: 'Honolulu',
      offsetMinutes: -600,
      timeZoneId: 'Pacific/Honolulu',
    ),
    WorldCity(
      name: 'Auckland',
      offsetMinutes: 720,
      timeZoneId: 'Pacific/Auckland',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now().toUtc());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _addCity() async {
    var query = '';
    final city = await showModalBottomSheet<WorldCity>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final filtered = presets
              .where(
                (item) => _cityName(
                  context,
                  item,
                ).toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.75,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.addCity,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: context.l10n.searchCity,
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (value) =>
                              setSheetState(() => query = value.trim()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? EmptyState(
                            icon: Icons.search_off,
                            title: context.l10n.cityNotFound,
                            message: context.l10n.tryDifferentCity,
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              return ListTile(
                                leading: const Icon(
                                  Icons.location_city_outlined,
                                ),
                                title: Text(_cityName(context, item)),
                                subtitle: Text(
                                  _offsetText(
                                    item.offsetAt(DateTime.now().toUtc()),
                                  ),
                                ),
                                onTap: () => Navigator.pop(context, item),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (city != null &&
        !widget.store.cities.any(
          (item) => item.timeZoneId == city.timeZoneId,
        )) {
      await widget.store.addCity(city);
    }
  }

  String _offsetText(int minutes) {
    final sign = minutes >= 0 ? '+' : '-';
    final absolute = minutes.abs();
    return 'UTC$sign${twoDigits(absolute ~/ 60)}:${twoDigits(absolute % 60)}';
  }

  String _cityName(BuildContext context, WorldCity city) {
    const english = {
      'Europe/Istanbul': 'Istanbul',
      'Europe/London': 'London',
      'Europe/Paris': 'Paris',
      'Europe/Berlin': 'Berlin',
      'Europe/Moscow': 'Moscow',
      'Europe/Rome': 'Rome',
      'Europe/Madrid': 'Madrid',
      'Europe/Amsterdam': 'Amsterdam',
      'Europe/Athens': 'Athens',
      'Africa/Cairo': 'Cairo',
      'Africa/Johannesburg': 'Cape Town',
      'Asia/Dubai': 'Dubai',
      'Asia/Riyadh': 'Riyadh',
      'Asia/Tehran': 'Tehran',
      'Asia/Kolkata': 'New Delhi',
      'Asia/Shanghai': 'Beijing',
      'Asia/Tokyo': 'Tokyo',
      'Asia/Seoul': 'Seoul',
      'Asia/Singapore': 'Singapore',
      'Asia/Bangkok': 'Bangkok',
      'Asia/Jakarta': 'Jakarta',
      'Asia/Hong_Kong': 'Hong Kong',
      'Australia/Sydney': 'Sydney',
      'America/New_York': 'New York',
      'America/Chicago': 'Chicago',
      'America/Los_Angeles': 'Los Angeles',
      'America/Toronto': 'Toronto',
      'America/Vancouver': 'Vancouver',
      'America/Mexico_City': 'Mexico City',
      'America/Sao_Paulo': 'São Paulo',
      'America/Argentina/Buenos_Aires': 'Buenos Aires',
      'Pacific/Honolulu': 'Honolulu',
      'Pacific/Auckland': 'Auckland',
    };
    const turkish = {
      'Europe/Istanbul': 'İstanbul',
      'Europe/London': 'Londra',
      'Europe/Moscow': 'Moskova',
      'Europe/Rome': 'Roma',
      'Europe/Athens': 'Atina',
      'Africa/Cairo': 'Kahire',
      'Asia/Riyadh': 'Riyad',
      'Asia/Tehran': 'Tahran',
      'Asia/Kolkata': 'Yeni Delhi',
      'Asia/Shanghai': 'Pekin',
      'Asia/Seoul': 'Seul',
      'Asia/Singapore': 'Singapur',
      'Asia/Jakarta': 'Cakarta',
      'Australia/Sydney': 'Sidney',
    };
    final locale = Localizations.localeOf(context).languageCode;
    return (locale == 'tr' ? turkish[city.timeZoneId] : null) ??
        english[city.timeZoneId] ??
        city.name;
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.worldClock)),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: widget.store.cities.length,
        itemBuilder: (context, index) {
          final city = widget.store.cities[index];
          final time = city.timeAt(_now);
          final effectiveOffset = city.offsetAt(_now);
          final localDifference =
              effectiveOffset - DateTime.now().timeZoneOffset.inMinutes;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Dismissible(
              key: ValueKey('${city.name}-${city.offsetMinutes}'),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(Icons.delete_outline),
              ),
              onDismissed: (_) => widget.store.removeCity(index),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _cityName(context, city),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localDifference == 0
                                  ? context.l10n.localTime
                                  : context.l10n.localTimeDifference(
                                      localDifference.abs() ~/ 60,
                                      localDifference.abs() % 60,
                                      localDifference > 0
                                          ? context.l10n.forward
                                          : context.l10n.backward,
                                    ),
                              style: const TextStyle(color: Color(0xFFA7A9B5)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            clockText(time.hour, time.minute),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            _offsetText(effectiveOffset),
                            style: const TextStyle(color: Color(0xFFA7A9B5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'world-clock-add',
        onPressed: _addCity,
        child: const Icon(Icons.add),
      ),
    ),
  );
}
