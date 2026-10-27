import 'package:example/models/selphid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_capture_mode.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_compress_format.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_configuration.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_document_type.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_extractor_selector_mode.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_timeout.dart';

Future<void> showSelphidConfigSheet(BuildContext context, SelphIDConfiguration config) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (sheetContext) {
      final double height = MediaQuery.sizeOf(sheetContext).height * 0.88;
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
        child: SizedBox(
          height: height,
          child: _SelphidConfigSheet(config: config),
        ),
      );
    },
  );
}

class _Choice<T> {
  const _Choice(this.value, this.label);

  final T? value;
  final String label;
}

class _SelphidConfigSheet extends StatefulWidget {
  const _SelphidConfigSheet({required this.config});

  final SelphIDConfiguration config;

  @override
  State<_SelphidConfigSheet> createState() => _SelphidConfigSheetState();
}

class _SelphidConfigSheetState extends State<_SelphidConfigSheet> {
  static const List<_Choice<SelphIDDocumentType>> _documentTypes = [
    _Choice(SelphIDDocumentType.DT_IDCARD, 'IDCARD'),
    _Choice(SelphIDDocumentType.DT_PASSPORT, 'PASSPORT'),
    _Choice(SelphIDDocumentType.DT_DRIVERSLICENSE, 'DRIVERSLICENSE'),
    _Choice(SelphIDDocumentType.DT_FOREIGNCARD, 'FOREIGNCARD'),
    _Choice(SelphIDDocumentType.DT_CREDITCARD, 'CREDITCARD'),
    _Choice(SelphIDDocumentType.DT_CUSTOM, 'CUSTOM'),
    _Choice(SelphIDDocumentType.DT_VISA, 'VISA'),
    _Choice(SelphIDDocumentType.DT_All, 'ALL'),
  ];

  static const List<_Choice<SelphIDCaptureMode>> _captureModes = [
    _Choice(null, 'Default'),
    _Choice(SelphIDCaptureMode.STANDARD, 'STANDARD'),
    _Choice(SelphIDCaptureMode.FRONT, 'FRONT'),
    _Choice(SelphIDCaptureMode.MRZ, 'MRZ'),
  ];

  static const List<_Choice<SelphIDTimeout>> _timeouts = [
    _Choice(null, 'DEFAULT'),
    _Choice(SelphIDTimeout.T_SHORT, 'SHORT'),
    _Choice(SelphIDTimeout.T_MEDIUM, 'MEDIUN'),
    _Choice(SelphIDTimeout.T_LONG, 'LONG'),
    _Choice(SelphIDTimeout.T_VERY_LONG, 'VERYLONG'),
  ];

  static const List<_Choice<SelphIDCompressFormat>> _formats = [
    _Choice(null, 'DEFAULT'),
    _Choice(SelphIDCompressFormat.T_JPEG, 'JPEG'),
    _Choice(SelphIDCompressFormat.T_PNG, 'PNG'),
  ];

  static const List<_Choice<SelphIDExtractorSelectorMode>> _modes = [
    _Choice(null, 'Por defecto'),
    _Choice(SelphIDExtractorSelectorMode.INTERNAL_WEIGHTED, 'INTERNAL_WEIGHTED'),
    _Choice(SelphIDExtractorSelectorMode.PARALLEL_ALL, 'PARALLEL_ALL'),
    _Choice(SelphIDExtractorSelectorMode.PARALLEL_FIRST, 'PARALLEL_FIRST'),
    _Choice(SelphIDExtractorSelectorMode.CUSTOM_ORDER, 'CUSTOM_ORDER'),
  ];

  late final TextEditingController _countries = TextEditingController(text: _join(widget.config.enabledCountries).toUpperCase());
  late final TextEditingController _jpgQuality = TextEditingController(text: _text(widget.config.jpgQuality));
  late final TextEditingController _attemptTimeout = TextEditingController(text: _text(widget.config.perAttemptTimeoutMs));
  late final TextEditingController _maxAttempts = TextEditingController(text: _text(widget.config.maxAttempts));

  @override
  void dispose() {
    _countries.dispose();
    _jpgQuality.dispose();
    _attemptTimeout.dispose();
    _maxAttempts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SelphIDConfiguration config = widget.config;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: scheme.outline.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Text('Configuración SelphID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
          child: Text(
            'Estos valores se usan al pulsar SelphID.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.62)),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + MediaQuery.paddingOf(context).bottom),
            children: [
              _chips<SelphIDDocumentType>(
                label: 'DocumentTypes',
                options: _documentTypes,
                selected: config.documentTypes ?? const [],
                onToggle: (type) => _toggleDocumentType(config, type),
              ),
              _dropdown<SelphIDCaptureMode>(
                label: 'Capture Mode',
                value: config.captureMode,
                options: _captureModes,
                onChanged: (value) => setState(() => config.captureMode = value),
              ),
              _dropdown<SelphIDTimeout>(
                label: 'Timeout',
                value: config.timeout,
                options: _timeouts,
                onChanged: (value) => setState(() => config.timeout = value),
              ),
              _switch('ShowTutorial', config.showTutorial, (value) => setState(() => config.showTutorial = value)),
              _switch('ShowPreviousTips', config.showPreviousTip, (value) => setState(() => config.showPreviousTip = value)),
              _switch('ShowResultAfterCapture', config.showResultAfterCapture, (value) {
                setState(() => config.showResultAfterCapture = value);
              }),
              _switch('ShowDiagnostic', config.showDiagnostic, (value) => setState(() => config.showDiagnostic = value)),
              _switch('VibrationEnabled', config.vibrationEnabled, (value) => setState(() => config.vibrationEnabled = value)),
              _switch('GenerateRawImages', config.generateRawImages, (value) => setState(() => config.generateRawImages = value)),
              _switch('DebugMode', config.debugMode, (value) => setState(() => config.debugMode = value)),
              _switch('Show Document Selector', config.showDocumentSelector, (value) {
                setState(() => config.showDocumentSelector = value);
              }),
              if (config.showDocumentSelector == true) ...[
                _chips<SelphIDDocumentType>(
                  label: 'EnabledDocumentTypes',
                  options: _documentTypes,
                  selected: config.enabledDocumentTypes ?? const [],
                  onToggle: (type) => setState(() {
                    config.enabledDocumentTypes = _toggle(config.enabledDocumentTypes, type);
                  }),
                ),
                _field(
                  _countries,
                  'EnabledCountries',
                  'Separados por coma. Vacío usa el valor del SDK.',
                      (value) => config.enabledCountries = _list(value),
                  uppercase: true,
                ),
              ],
              _dropdown<SelphIDCompressFormat>(
                label: 'CompressFormat',
                value: config.compressFormat,
                options: _formats,
                onChanged: (value) => setState(() => config.compressFormat = value),
              ),
              _field(_jpgQuality, 'JPG Quality(integer).', null, (value) => config.jpgQuality = _number(value), digits: true),
              _dropdown<SelphIDExtractorSelectorMode>(
                label: 'ExtractorMode',
                value: config.mode,
                options: _modes,
                onChanged: (value) => setState(() => config.mode = value),
              ),
              _field(_attemptTimeout, 'PerAttemptToMs(ms)', null, (value) => config.perAttemptTimeoutMs = _number(value), digits: true),
              _field(_maxAttempts, 'MaxAttempts', null, (value) => config.maxAttempts = _number(value), digits: true),
              const SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _restore,
                child: const Text('Restaurar valores'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleDocumentType(SelphIDConfiguration config, SelphIDDocumentType type) {
    final List<SelphIDDocumentType> next = List<SelphIDDocumentType>.from(config.documentTypes ?? const []);
    if (next.contains(type)) {
      if (next.length == 1) return;
      next.remove(type);
    } else {
      next.add(type);
    }
    setState(() => config.documentTypes = next);
  }

  List<T>? _toggle<T>(List<T>? current, T value) {
    final List<T> next = List<T>.from(current ?? const []);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    return next.isEmpty ? null : next;
  }

  void _restore() {
    final SelphIDConfiguration standard = SelphIDWidget().createStandardConfiguration();
    final SelphIDConfiguration config = widget.config;
    config.preferredVendors = null;
    config.documentTypes = standard.documentTypes;
    config.enabledDocumentTypes = null;
    config.enabledCountries = null;
    config.documentModels = null;
    config.params = null;
    config.captureMode = standard.captureMode;
    config.timeout = standard.timeout;
    config.compressFormat = null;
    config.bitRate = null;
    config.mode = null;
    config.generateRawImages = null;
    config.debugMode = null;
    config.showResultAfterCapture = standard.showResultAfterCapture;
    config.showTutorial = null;
    config.showDiagnostic = standard.showDiagnostic;
    config.showPreviousTip = null;
    config.showDocumentSelector = null;
    config.vibrationEnabled = null;
    config.videoFilename = null;
    config.defaultCountry = null;
    config.format = null;
    config.jpgQuality = null;
    config.notifyTimeMs = null;
    config.customBitRate = null;
    config.perAttemptTimeoutMs = null;
    config.maxAttempts = null;
    _countries.clear();
    _jpgQuality.clear();
    _attemptTimeout.clear();
    _maxAttempts.clear();
    setState(() {});
  }

  Widget _chips<T>({
    required String label,
    required List<_Choice<T>> options,
    required List<T> selected,
    required ValueChanged<T> onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final _Choice<T> option in options)
                if (option.value != null)
                  FilterChip(
                    label: Text(option.label),
                    selected: selected.contains(option.value as T),
                    onSelected: (_) => onToggle(option.value as T),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<_Choice<T>> options,
    required ValueChanged<T?> onChanged,
  }) {
    final _Choice<T> selected = options.firstWhere((option) => identical(option.value, value));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: InputDecorator(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<_Choice<T>>(
                  value: selected,
                  isExpanded: true,
                  isDense: true,
                  items: [
                    for (final _Choice<T> option in options)
                      DropdownMenuItem<_Choice<T>>(value: option, child: Text(option.label)),
                  ],
                  onChanged: (option) {
                    if (option != null) onChanged(option.value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switch(String label, bool? value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value ?? false,
      onChanged: onChanged,
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String? helper,
    ValueChanged<String> onChanged, {
    bool digits = false,
    bool uppercase = false,
    int lines = 1,
  }) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: lines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: lines > 1 ? 12 : 0),
                  child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  keyboardType: digits ? TextInputType.number : TextInputType.text,
                  textCapitalization: uppercase ? TextCapitalization.characters : TextCapitalization.none,
                  inputFormatters: [
                    if (digits) FilteringTextInputFormatter.digitsOnly,
                    if (uppercase) _UpperCaseTextFormatter(),
                  ],
                  minLines: lines,
                  maxLines: lines,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          if (helper != null && helper.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                helper,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.62)),
              ),
            ),
        ],
      ),
    );
  }

  String _join(List<String>? values) => values?.join(', ') ?? '';

  String _text(int? value) => value?.toString() ?? '';

  int? _number(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }

  List<String>? _list(String value) {
    final List<String> items = value.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
    return items.isEmpty ? null : items;
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
