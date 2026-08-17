import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/app_store.dart';

const snoonLanguageCodes = ['tr', 'en', 'de', 'es', 'fr', 'it', 'pt'];

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key, required this.store});

  final AppStore store;

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late String _selectedCode = widget.store.localeCode;
  bool _saving = false;

  Future<void> _continue() async {
    if (_saving) return;
    setState(() => _saving = true);
    await widget.store.selectLanguage(
      languageCode: _selectedCode,
      workGroupName: localizedWorkGroupName(_selectedCode),
      personalGroupName: localizedPersonalGroupName(_selectedCode),
    );
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final deviceCode = View.of(context).platformDispatcher.locale.languageCode;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
              children: [
                Align(
                  child: Image.asset(
                    'assets/branding/snoon-icon-source.png',
                    width: 104,
                    height: 104,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.languageTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.languageSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: RadioGroup<String>(
                    groupValue: _selectedCode,
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedCode = value);
                    },
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < snoonLanguageCodes.length;
                          index++
                        ) ...[
                          RadioListTile<String>(
                            value: snoonLanguageCodes[index],
                            title: Text(
                              languageNativeName(snoonLanguageCodes[index]),
                            ),
                            subtitle: snoonLanguageCodes[index] == deviceCode
                                ? Text(l10n.languageRecommended)
                                : null,
                          ),
                          if (index != snoonLanguageCodes.length - 1)
                            const Divider(height: 1),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saving ? null : _continue,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_forward_rounded),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(l10n.languageContinue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showSnoonLanguagePicker(
  BuildContext context,
  AppStore store,
) async {
  var selectedCode = store.localeCode;
  final chosen = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setModalState) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.languageSetting,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              RadioGroup<String>(
                groupValue: selectedCode,
                onChanged: (value) {
                  if (value != null) setModalState(() => selectedCode = value);
                },
                child: Column(
                  children: [
                    for (final code in snoonLanguageCodes)
                      RadioListTile<String>(
                        dense: true,
                        value: code,
                        title: Text(languageNativeName(code)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(sheetContext, selectedCode),
                  child: Text(context.l10n.apply),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  if (chosen == null || chosen == store.localeCode || !context.mounted) return;
  await store.selectLanguage(
    languageCode: chosen,
    workGroupName: localizedWorkGroupName(chosen),
    personalGroupName: localizedPersonalGroupName(chosen),
  );
}
