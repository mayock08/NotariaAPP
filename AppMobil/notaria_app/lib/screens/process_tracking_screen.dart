import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expediente.dart';

class ProcessTrackingScreen extends StatelessWidget {
  final Expediente expediente;

  const ProcessTrackingScreen({
    super.key,
    required this.expediente,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notaría Pública 9'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Download Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement download
                },
                icon: const Icon(Icons.download),
                label: const Text('Descargar escritura'),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Total a pagar',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${expediente.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: Colors.grey[700],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Abonado',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${expediente.paidAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Process Timeline
            ...expediente.processStages.map((stage) {
              final isLast = stage.stageOrder == expediente.processStages.length;
              return _TimelineItem(
                stage: stage,
                isLast: isLast,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ProcessStage stage;
  final bool isLast;

  const _TimelineItem({
    required this.stage,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = stage.isCompleted;
    final color = isCompleted ? const Color(0xFF4A9ECC) : Colors.grey[700]!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? const Color(0xFF4A9ECC) : Colors.transparent,
                  border: Border.all(
                    color: color,
                    width: 3,
                  ),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    color: color,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Stage info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage.stageName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  if (stage.completedDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Completado: ${DateFormat('dd/MM/yyyy').format(stage.completedDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
