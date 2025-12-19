class Expediente {
  final int id;
  final String expedienteNumber;
  final DateTime startDate;
  final String currentStatus;
  final double totalAmount;
  final double paidAmount;
  final List<ProcessStage> processStages;
  final List<Document> documents;

  Expediente({
    required this.id,
    required this.expedienteNumber,
    required this.startDate,
    required this.currentStatus,
    required this.totalAmount,
    required this.paidAmount,
    required this.processStages,
    required this.documents,
  });

  factory Expediente.fromJson(Map<String, dynamic> json) {
    return Expediente(
      id: json['id'],
      expedienteNumber: json['expedienteNumber'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      currentStatus: json['currentStatus'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      processStages: (json['processStages'] as List?)
              ?.map((stage) => ProcessStage.fromJson(stage))
              .toList() ??
          [],
      documents: (json['documents'] as List?)
              ?.map((doc) => Document.fromJson(doc))
              .toList() ??
          [],
    );
  }

  double get remainingAmount => totalAmount - paidAmount;
  double get progressPercentage => (paidAmount / totalAmount) * 100;
}

class ProcessStage {
  final int id;
  final String stageName;
  final int stageOrder;
  final bool isCompleted;
  final DateTime? completedDate;

  ProcessStage({
    required this.id,
    required this.stageName,
    required this.stageOrder,
    required this.isCompleted,
    this.completedDate,
  });

  factory ProcessStage.fromJson(Map<String, dynamic> json) {
    return ProcessStage(
      id: json['id'],
      stageName: json['stageName'] ?? '',
      stageOrder: json['stageOrder'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
    );
  }
}

class Document {
  final int id;
  final String documentName;
  final String documentType;
  final bool isCompleted;
  final String? downloadUrl;
  final DateTime? uploadedDate;

  Document({
    required this.id,
    required this.documentName,
    required this.documentType,
    required this.isCompleted,
    this.downloadUrl,
    this.uploadedDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      documentName: json['documentName'] ?? '',
      documentType: json['documentType'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      downloadUrl: json['downloadUrl'],
      uploadedDate: json['uploadedDate'] != null
          ? DateTime.parse(json['uploadedDate'])
          : null,
    );
  }
}
