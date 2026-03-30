

class DamageConversation {
  final DamageQuestion question;
  final DamageAnswer answer;

  DamageConversation({
    required this.question,
    required this.answer,
  });

  factory DamageConversation.fromJson(Map<String, dynamic> json) {
    return DamageConversation(
      question: DamageQuestion.fromJson(json['question'] as Map<String, dynamic>? ?? {}),
      answer: DamageAnswer.fromJson(json['answer'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question.toJson(),
      'answer': answer.toJson(),
    };
  }

  DamageConversation copyWith({
    DamageQuestion? question,
    DamageAnswer? answer,
  }) {
    return DamageConversation(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }
}

class DamageQuestion {
  final String content;
  final String? imageUrl;
  final DateTime timestamp;

  DamageQuestion({
    required this.content,
    this.imageUrl,
    required this.timestamp,
  });

  factory DamageQuestion.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return DamageQuestion(
      content: json['content'] is String ? json['content'] as String : '',
      imageUrl: json['imageUrl'] is String ? json['imageUrl'] as String : null,
      timestamp: json['timestamp'] is String
          ? DateTime.tryParse(json['timestamp']) ?? now
          : now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  DamageQuestion copyWith({
    String? content,
    String? imageUrl,
    DateTime? timestamp,
  }) {
    return DamageQuestion(
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class DamageAnswer {
  final ProbableVehicle probableVehicle;
  final String damage;
  final List<String> affectedParts;
  final String severity;
  final String solution;
  final EstimatedCost estimatedCost;
  final String repairUrgency;
  final String additionalNotes;
  final List<String> suggestedServiceTypes;
  final DateTime timestamp;

  DamageAnswer({
    required this.probableVehicle,
    required this.damage,
    required this.affectedParts,
    required this.severity,
    required this.solution,
    required this.estimatedCost,
    required this.repairUrgency,
    required this.additionalNotes,
    required this.suggestedServiceTypes,
    required this.timestamp,
  });

  factory DamageAnswer.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return DamageAnswer(
      probableVehicle: ProbableVehicle.fromJson(json['probableVehicle'] as Map<String, dynamic>? ?? {}),
      damage: json['damage'] is String ? json['damage'] as String : '',
      affectedParts: json['affectedParts'] is List
          ? List<String>.from((json['affectedParts'] as List).map((x) => x.toString()))
          : [],
      severity: json['severity'] is String ? json['severity'] as String : '',
      solution: json['solution'] is String ? json['solution'] as String : '',
      estimatedCost: EstimatedCost.fromJson(json['estimatedCost'] as Map<String, dynamic>? ?? {}),
      repairUrgency: json['repairUrgency'] is String ? json['repairUrgency'] as String : '',
      additionalNotes: json['additionalNotes'] is String ? json['additionalNotes'] as String : '',
      suggestedServiceTypes: json['suggestedServiceTypes'] is List
          ? List<String>.from((json['suggestedServiceTypes'] as List).map((x) => x.toString()))
          : [],
      timestamp: json['timestamp'] is String
          ? DateTime.tryParse(json['timestamp']) ?? now
          : now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'probableVehicle': probableVehicle.toJson(),
      'damage': damage,
      'affectedParts': affectedParts,
      'severity': severity,
      'solution': solution,
      'estimatedCost': estimatedCost.toJson(),
      'repairUrgency': repairUrgency,
      'additionalNotes': additionalNotes,
      'suggestedServiceTypes': suggestedServiceTypes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  DamageAnswer copyWith({
    ProbableVehicle? probableVehicle,
    String? damage,
    List<String>? affectedParts,
    String? severity,
    String? solution,
    EstimatedCost? estimatedCost,
    String? repairUrgency,
    String? additionalNotes,
    List<String>? suggestedServiceTypes,
    DateTime? timestamp,
  }) {
    return DamageAnswer(
      probableVehicle: probableVehicle ?? this.probableVehicle,
      damage: damage ?? this.damage,
      affectedParts: affectedParts ?? this.affectedParts,
      severity: severity ?? this.severity,
      solution: solution ?? this.solution,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      repairUrgency: repairUrgency ?? this.repairUrgency,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      suggestedServiceTypes: suggestedServiceTypes ?? this.suggestedServiceTypes,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class ProbableVehicle {
  final String? make;
  final String? model;
  final String? year;
  final String confidence;

  ProbableVehicle({
    this.make,
    this.model,
    this.year,
    required this.confidence,
  });

  factory ProbableVehicle.fromJson(Map<String, dynamic> json) {
    return ProbableVehicle(
      make: json['make'] is String ? json['make'] as String : null,
      model: json['model'] is String ? json['model'] as String : null,
      year: json['year'] is String ? json['year'] as String : null,
      confidence: json['confidence'] is String ? json['confidence'] as String : 'low',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'confidence': confidence,
    };
  }

  ProbableVehicle copyWith({
    String? make,
    String? model,
    String? year,
    String? confidence,
  }) {
    return ProbableVehicle(
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      confidence: confidence ?? this.confidence,
    );
  }
}

class EstimatedCost {
  final int min;
  final int max;
  final String currency;

  EstimatedCost({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory EstimatedCost.fromJson(Map<String, dynamic> json) {
    return EstimatedCost(
      min: json['min'] is int ? json['min'] as int : 0,
      max: json['max'] is int ? json['max'] as int : 0,
      currency: json['currency'] is String ? json['currency'] as String : 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'currency': currency,
    };
  }

  EstimatedCost copyWith({
    int? min,
    int? max,
    String? currency,
  }) {
    return EstimatedCost(
      min: min ?? this.min,
      max: max ?? this.max,
      currency: currency ?? this.currency,
    );
  }
}
