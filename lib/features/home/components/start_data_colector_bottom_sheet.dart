import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapnavigatorapp/shared/constants/constants.dart';
import 'package:mapnavigatorapp/shared/providers/location_provider.dart';
import 'package:mapnavigatorapp/shared/providers/sensor_provider.dart';
import 'package:mapnavigatorapp/shared/utils/format_utils.dart';
import 'package:mapnavigatorapp/shared/visual/app_colors.dart';
import 'package:mapnavigatorapp/shared/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

class StartDataColectorBottomSheet extends StatefulWidget {
  const StartDataColectorBottomSheet({super.key, required this.isColecting, this.onStartOverride, this.onStopOverride});

  final bool isColecting;
  final VoidCallback? onStartOverride;
  final VoidCallback? onStopOverride;

  @override
  State<StartDataColectorBottomSheet> createState() => _StartDataColectorBottomSheetState();
}

class _StartDataColectorBottomSheetState extends State<StartDataColectorBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer2<SensorProvider, LocationProvider>(
      builder: (context, sensorProvider, locationProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colorScheme.surface, colorScheme.surface]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: colorScheme.onSurface, borderRadius: BorderRadius.circular(2)),
              ),

              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: widget.isColecting ? [Colors.red.shade400, Colors.red.shade600] : [Colors.green.shade400, Colors.green.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: (widget.isColecting ? Colors.red : Colors.green).withAlpha(30), blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 8))],
                      ),
                      child: Icon(widget.isColecting ? Icons.stop_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 40),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      widget.isColecting ? 'Coletando Dados' : 'Iniciar Coleta',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.isColecting ? 'Monitorando sua localização e movimento em tempo real' : 'Comece a rastrear sua localização e dados dos sensores',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withAlpha(70), height: 1.4),
                    ),

                    const SizedBox(height: 32),

                    if (widget.isColecting) ...[
                      Row(
                        children: [
                          Expanded(
                            child: DataIndicator(isActive: widget.isColecting, icon: Icons.gps_fixed, label: 'GPS', value: locationProvider.isTracking ? 'Ativo' : 'Inativo', color: Colors.green),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DataIndicator(isActive: widget.isColecting, icon: Icons.sensors, label: 'Sensores', value: sensorProvider.isMonitoring ? 'Ativo' : 'Inativo', color: Colors.blue),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DataIndicator(isActive: widget.isColecting, icon: Icons.timer, label: 'Tempo', value: FormatUtils.formatDuration(sensorProvider.elapsedSeconds), color: Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(color: colorScheme.outline.withAlpha(50)),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),

                        const SizedBox(width: kSmallSize),

                        Expanded(
                          flex: 2,
                          child: PrimaryButton(
                            text: widget.isColecting ? 'Parar Coleta' : 'Iniciar Coleta',
                            icon: widget.isColecting ? Icons.stop_rounded : Icons.play_arrow_rounded,
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (locationProvider.isTracking) {
                                locationProvider.stopTracking();
                                sensorProvider.stopMonitoring();
                                widget.onStopOverride?.call();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coleta de dados parada.'), duration: Duration(seconds: 2), backgroundColor: kCancelColor));
                              } else {
                                locationProvider.startTracking();
                                sensorProvider.startMonitoring();
                                widget.onStartOverride?.call();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coleta de dados iniciada.'), duration: Duration(seconds: 2), backgroundColor: kDetailColor));
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DataIndicator extends StatelessWidget {
  const DataIndicator({super.key, required this.isActive, required this.icon, required this.label, required this.value, required this.color});

  final bool isActive;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(constraints.maxWidth < 120 ? 8 : 12),
          decoration: BoxDecoration(
            color: isActive ? color.withAlpha(40) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isActive ? color : Colors.grey.shade300, width: 2),
          ),
          child: constraints.maxWidth < 100
              ? Column(
                  children: [
                    Icon(icon, color: isActive ? color : Colors.grey, size: constraints.maxWidth < 80 ? 20 : 24),
                    SizedBox(height: constraints.maxWidth < 80 ? 4 : 6),
                    Text(
                      label,
                      style: TextStyle(fontSize: constraints.maxWidth < 80 ? 10 : 12, color: isActive ? color : Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(fontSize: constraints.maxWidth < 80 ? 12 : 14, fontWeight: FontWeight.bold, color: isActive ? color : Colors.grey.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Icon(icon, color: isActive ? color : Colors.grey, size: constraints.maxWidth < 150 ? 24 : 28),
                    SizedBox(width: constraints.maxWidth < 150 ? 8 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(fontSize: constraints.maxWidth < 150 ? 12 : 14, color: isActive ? color : Colors.grey.shade600),
                          ),
                          SizedBox(height: 4),
                          Text(
                            value,
                            style: TextStyle(fontSize: constraints.maxWidth < 150 ? 14 : 16, fontWeight: FontWeight.bold, color: isActive ? color : Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
