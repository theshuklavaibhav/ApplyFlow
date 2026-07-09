class JobApplication {
  final String id;
  final String company;
  final String roleTitle;
  final String status;
  final String? jobUrl;
  final String? notes;
  final String? location;
  final DateTime? appliedDate;
  final DateTime createdAt;

  JobApplication({
    required this.id,
    required this.company,
    required this.roleTitle,
    required this.status,
    this.jobUrl,
    this.notes,
    this.location,
    this.appliedDate,
    required this.createdAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] ?? '',
      company: json['company'] ?? '',
      roleTitle: json['role_title'] ?? '',
      status: json['status'] ?? 'WISHLIST',
      jobUrl: json['job_url'],
      notes: json['notes'],
      location: json['location'],
      appliedDate: json['applied_date'] != null
          ? DateTime.tryParse(json['applied_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role_title': roleTitle,
      'status': status,
      'job_url': jobUrl?.isEmpty == true ? null : jobUrl,
      'notes': notes?.isEmpty == true ? null : notes,
      'location': location?.isEmpty == true ? null : location,
      'applied_date': appliedDate?.toIso8601String().split('T').first,
    };
  }
}
