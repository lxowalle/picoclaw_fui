import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:picoclaw_flutter_ui/src/core/service_manager.dart';
import 'package:picoclaw_flutter_ui/src/generated/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:picoclaw_flutter_ui/src/core/app_theme.dart';
import 'package:remixicon/remixicon.dart';
import 'package:picoclaw_flutter_ui/src/core/picoclaw_channel.dart';

const String _githubRepoUrl = 'https://github.com/sipeed/picoclaw_fui';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _pathController = TextEditingController();
  final _argsController = TextEditingController();

  // Focus nodes for TV navigation
  final _githubFocusNode = FocusNode();
  final _publicModeFocusNode = FocusNode();
  final _hostFocusNode = FocusNode();
  final _portFocusNode = FocusNode();
  final _pathFocusNode = FocusNode();
  final _browseFocusNode = FocusNode();
  final _checkFocusNode = FocusNode();
  final _argsFocusNode = FocusNode();
  final _saveFocusNode = FocusNode();
  final List<FocusNode> _themeFocusNodes = [];

  @override
  void initState() {
    super.initState();
    final service = context.read<ServiceManager>();
    _hostController.text = service.webUrl.split('://').last.split(':').first;
    _portController.text = service.webUrl.split(':').last;
    _pathController.text = service.binaryPath;
    _argsController.text = service.arguments;
    _loadConfig();

    // Initialize theme focus nodes
    _themeFocusNodes.addAll(
      List.generate(AppThemeMode.values.length, (_) => FocusNode()),
    );
  }

  Future<void> _loadConfig() async {
    try {
      String configStr;
      if (Platform.isAndroid) {
        configStr = await PicoClawChannel.getConfig();
      } else {
        final file = File('config.json');
        if (await file.exists()) {
          configStr = await file.readAsString();
        } else {
          configStr = '';
        }
      }

      if (configStr.isEmpty) {
        return;
      }

      jsonDecode(configStr) as Map<String, dynamic>;
    } catch (e) {
      // Ignore config loading errors
    }
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _pathController.dispose();
    _argsController.dispose();

    _githubFocusNode.dispose();
    _publicModeFocusNode.dispose();
    _hostFocusNode.dispose();
    _portFocusNode.dispose();
    _pathFocusNode.dispose();
    _browseFocusNode.dispose();
    _checkFocusNode.dispose();
    _argsFocusNode.dispose();
    _saveFocusNode.dispose();
    for (final node in _themeFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['exe', 'bat', 'sh'],
    );

    if (result != null) {
      _pathController.text = result.files.single.path ?? '';
    }
  }

  Future<void> _togglePublicMode(bool value) async {
    final service = context.read<ServiceManager>();

    await service.updateConfig(
      value ? '0.0.0.0' : '127.0.0.1',
      int.tryParse(_portController.text) ?? 18800,
      arguments: _argsController.text,
      publicMode: value,
    );

    setState(() {
      _hostController.text = value ? '0.0.0.0' : '127.0.0.1';
    });
  }

  void _togglePublicModeFromFocus() {
    final service = context.read<ServiceManager>();
    _togglePublicMode(!service.publicMode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final service = context.watch<ServiceManager>();

    return FocusTraversalGroup(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('服务配置', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  tooltip: 'GitHub',
                  focusNode: _githubFocusNode,
                  icon: Icon(Remix.github_line),
                  onPressed: () async {
                    final uri = Uri.parse(_githubRepoUrl);
                    try {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (_) {}
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Public mode switch with focus - using button style for TV remote support
            StatefulBuilder(
              builder: (context, setLocalState) {
                bool isFocused = false;
                return Focus(
                  focusNode: _publicModeFocusNode,
                  onFocusChange: (focused) {
                    setLocalState(() => isFocused = focused);
                  },
                  child: GestureDetector(
                    onTap: _togglePublicModeFromFocus,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isFocused
                            ? Theme.of(
                                context,
                              ).colorScheme.secondary.withAlpha(20)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isFocused
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).dividerColor,
                          width: isFocused ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            service.publicMode
                                ? Icons.public
                                : Icons.public_off,
                            color: service.publicMode
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(150),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.publicMode,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: isFocused
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.secondary
                                            : null,
                                      ),
                                ),
                                Text(
                                  l10n.publicModeHint,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: service.publicMode
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: service.publicMode
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(30),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Host text field
            TextField(
              controller: _hostController,
              focusNode: _hostFocusNode,
              decoration: InputDecoration(labelText: l10n.address),
              enabled: !service.publicMode,
            ),
            const SizedBox(height: 16),

            // Port text field
            TextField(
              controller: _portController,
              focusNode: _portFocusNode,
              decoration: InputDecoration(labelText: l10n.port),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            if (!Platform.isWindows && !Platform.isAndroid)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pathController,
                      focusNode: _pathFocusNode,
                      decoration: InputDecoration(labelText: l10n.binaryPath),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Builder(
                        builder: (ctx) {
                          final cs = Theme.of(ctx).colorScheme;
                          return ElevatedButton.icon(
                            focusNode: _browseFocusNode,
                            onPressed: _pickFile,
                            icon: const Icon(Icons.folder_open),
                            label: Text(l10n.browse),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (ctx) {
                          final messenger = ScaffoldMessenger.of(context);
                          final local = AppLocalizations.of(context)!;
                          return OutlinedButton(
                            focusNode: _checkFocusNode,
                            onPressed: () async {
                              final code = await service.validateBinary(
                                _pathController.text,
                              );
                              String msg;
                              if (code) {
                                msg = local.coreValid;
                              } else {
                                final ec = service.lastErrorCode;
                                if (ec == 'core.binary_missing') {
                                  msg = local.coreBinaryMissing;
                                } else if (ec == 'core.invalid_binary') {
                                  msg = local.coreInvalidBinary;
                                } else if (ec == 'core.start_failed') {
                                  msg = local.coreStartFailed;
                                } else {
                                  msg = local.coreUnknownError(ec ?? '');
                                }
                              }
                              messenger.showSnackBar(
                                SnackBar(content: Text(msg)),
                              );
                            },
                            child: Text('Check'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 16),

            // Arguments text field
            TextField(
              controller: _argsController,
              focusNode: _argsFocusNode,
              decoration: InputDecoration(
                labelText: l10n.arguments,
                hintText: l10n.argumentsHint,
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            Builder(
              builder: (ctx) {
                final cs = Theme.of(ctx).colorScheme;
                return ElevatedButton(
                  focusNode: _saveFocusNode,
                  onPressed: () async {
                    final port = int.tryParse(_portController.text);
                    if (port != null) {
                      final messenger = ScaffoldMessenger.of(context);
                      final savedL10n = AppLocalizations.of(context)!;
                      final String? binaryArg =
                          (Platform.isWindows || Platform.isAndroid)
                          ? null
                          : _pathController.text;

                      await service.updateConfig(
                        _hostController.text,
                        port,
                        binaryPath: binaryArg,
                        arguments: _argsController.text,
                        publicMode: service.publicMode,
                      );

                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(savedL10n.save)),
                        );
                        final code = service.lastErrorCode;
                        if (code != null) {
                          String msg;
                          final l = savedL10n;
                          if (code == 'core.binary_missing') {
                            msg = l.coreBinaryMissing;
                          } else if (code == 'core.start_failed') {
                            msg = l.coreStartFailed;
                          } else if (code == 'core.stop_failed') {
                            msg = l.coreStopFailed;
                          } else {
                            msg = l.coreUnknownError(code);
                          }
                          messenger.showSnackBar(SnackBar(content: Text(msg)));
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.secondary,
                    foregroundColor: cs.onSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Text(l10n.save),
                );
              },
            ),

            // Theme selection
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Theme Selection',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppThemeMode.values.asMap().entries.map((entry) {
                final index = entry.key;
                final mode = entry.value;
                final isSelected = service.currentThemeMode == mode;
                final theme = AppTheme.getTheme(mode);
                return GestureDetector(
                  onTap: () => service.setTheme(mode),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.secondary
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.secondary.withAlpha(
                                    ((0.3).clamp(0.0, 1.0) * 255).round(),
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.palette_outlined,
                            size: 18,
                            color: isSelected
                                ? theme.colorScheme.onSecondary
                                : theme.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            mode.name.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? theme.colorScheme.onSecondary
                                  : theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
