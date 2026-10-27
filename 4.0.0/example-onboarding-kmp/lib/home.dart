import 'dart:convert';
import 'package:example/models/selphid_result.dart';
import 'package:example/models/selphid_widget.dart';
import 'package:example/providers/core.dart';
import 'package:example/providers/selphi.dart';
import 'package:example/providers/selphid.dart';
import 'package:example/widgets/action_card.dart';
import 'package:example/widgets/extra_data_button.dart';
import 'package:example/widgets/home_hero.dart';
import 'package:example/widgets/menu_divider.dart';
import 'package:example/widgets/menu_tile.dart';
import 'package:example/widgets/section_title.dart';
import 'package:example/widgets/selphi_image.dart';
import 'package:example/widgets/selphid_config_sheet.dart';
import 'package:example/widgets/selphid_image.dart';
import 'package:example/widgets/selphid_list.dart';
import 'package:example/widgets/status_banner.dart';
import 'package:example/widgets/surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_configuration.dart';
import 'models/flows_result.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.notifier});

  final String title;
  final ValueNotifier<ThemeMode> notifier;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<Uint8List?> _bestImage          = ValueNotifier(null);
  final ValueNotifier<SelphIDResult?> _selphIDResult  = ValueNotifier(null);
  final ValueNotifier<String> _message                = ValueNotifier("");
  final ValueNotifier<List<FlowsResult>?> _flows      = ValueNotifier(null);
  final ValueNotifier<String> _flow                   = ValueNotifier("");
  final SelphIDConfiguration _selphidConfig           = SelphIDWidget().createStandardConfiguration();

  @override
  void initState() {
    super.initState();
    launchInitSession(setState, _message);
    launchListenerTrackingError();
  }

  @override
  void dispose() {
    _bestImage.dispose();
    _selphIDResult.dispose();
    _message.dispose();
    _flows.dispose();
    _flow.dispose();
    super.dispose();
  }

  bool _filled(String? value) => value != null && value.trim().isNotEmpty;

  Map<String, dynamic>? get _documentData
  {
    final raw = _selphIDResult.value?.documentData;
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = json.decode(raw);
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context)
  {
    final ColorScheme scheme          = Theme.of(context).colorScheme;
    final SelphIDResult? result       = _selphIDResult.value;
    final Map<String, dynamic>? data  = _documentData;
    final bool hasResults             = _bestImage.value != null || _filled(result?.frontDocumentImage) || _filled(result?.backDocumentImage) || _filled(result?.faceImage) || data != null;
    final double bottom               = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: Theme.of(context).brightness == Brightness.dark ? 'Tema claro' : 'Tema oscuro',
            onPressed: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              widget.notifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 28 + bottom),
        children: [
          const HomeHero(),
          const SizedBox(height: 20),
          if (_message.value.isNotEmpty) ...[
            StatusBanner(text: _message.value),
            const SizedBox(height: 16),
          ],
          const SectionTitle('Captura', 'Elige el paso que quieres lanzar.'),
          ActionCard(
            icon: Icons.face_retouching_natural_outlined,
            title: 'Selphi',
            subtitle: 'Captura facial y prueba de vida',
            done: _bestImage.value != null,
            onTap: () => launchSelphiAuthenticate(setState, _message, _bestImage),
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.badge_outlined,
            title: 'SelphID',
            subtitle: 'Anverso, reverso y lectura del documento',
            done: _filled(result?.frontDocumentImage) || _filled(result?.backDocumentImage),
            onTap: () => launchSelphIDCapture(setState, _message, _selphIDResult, _selphidConfig),
            onLongPress: () {
              HapticFeedback.mediumImpact();
              showSelphidConfigSheet(context, _selphidConfig);
            },
          ),
          const SizedBox(height: 12),
          ExtraDataButton(
            enabled: _bestImage.value != null && _filled(result?.tokenFaceImage),
            onPressed: () => launchGetExtraData(
              setState,
              _message,
              _bestImage,
              result?.tokenFaceImage,
            ),
          ),
          if (hasResults) ...[
            const SizedBox(height: 28),
            const SectionTitle('Resultados', 'Lo que devolvió la última captura.'),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_bestImage.value != null) SelphiImage(_bestImage.value),
                  if (_bestImage.value != null && (_filled(result?.frontDocumentImage) || _filled(result?.backDocumentImage) || _filled(result?.faceImage)))
                    const SizedBox(height: 20),
                  SelphIDImage('Anverso', result?.frontDocumentImage),
                  if (_filled(result?.frontDocumentImage) && (_filled(result?.backDocumentImage) || _filled(result?.faceImage) || data != null)) const SizedBox(height: 16),
                  SelphIDImage('Reverso', result?.backDocumentImage),
                  if (_filled(result?.backDocumentImage) && (_filled(result?.faceImage) || data != null)) const SizedBox(height: 16),
                  SelphIDImage('Foto', result?.faceImage, portrait: true),
                  if (_filled(result?.faceImage) && data != null) const SizedBox(height: 16),
                  if (data != null)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => showDocumentDataSheet(context, data),
                      icon: const Icon(Icons.article_outlined),
                      label: const Text('Datos del documento'),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          const SectionTitle('Sesión', 'La sesión se abre sola al entrar.'),
          SurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                MenuTile(
                  icon: Icons.play_circle_outline,
                  title: 'Init Session',
                  onTap: () => launchInitSession(setState, _message),
                ),
                MenuDivider(color: scheme.outline.withValues(alpha: 0.2)),
                MenuTile(
                  icon: Icons.flag_outlined,
                  title: 'Init Operation',
                  onTap: () => launchInitOperation(setState, _message),
                ),
                MenuDivider(color: scheme.outline.withValues(alpha: 0.2)),
                MenuTile(
                  icon: Icons.logout_rounded,
                  title: 'Close Session',
                  tint: scheme.error,
                  onTap: () => launchCloseSession(setState, _message, _selphIDResult, _bestImage, _flow),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionTitle('Flujos', 'O lanza un flujo ya configurado.'),
          SurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuTile(
                  icon: Icons.account_tree_outlined,
                  title: 'Get Flows',
                  onTap: () => launchGetFlowIntegrationData(context, setState, _message, _flows, _flow),
                ),
                if (_flow.value.isNotEmpty) ...[
                  MenuDivider(color: scheme.outline.withValues(alpha: 0.2)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Flujo seleccionado',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: scheme.onSurface.withValues(alpha: 0.62),
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(_flow.value, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => launchFlow(setState, _message, _flow),
                          icon: const Icon(Icons.bolt_outlined),
                          label: const Text('Launch Flow'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

