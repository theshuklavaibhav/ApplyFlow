class JobApplication {
  final String id;
  final String company;
  final String roleTitle;
  final String status; // WISHLIST | APPLIED | INTERVIEW | REJECTED
  final String? jobUrl;
  final String? notes;
  final String? location;

  final DateTime? appliedDate;
  final DateTime createdAt;

  // Constructor
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

  // Converts the JSON your FastAPI backend sends into a Dart object
  factory JobApplication.fromJsontoDartObj(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      company: json['company'],
      roleTitle: json['role_title'],
      status: json['status'],
      jobUrl: json['job_url'],
      notes: json['notes'],
      location: json['location'],
      appliedDate: json['applied_date'] != null
          ? DateTime.parse(json['applied_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

    // Converts a Dart object back into JSON to send TO your backend
  Map<String,dynamic> toJson(){
    return {
      'company' : company ,
      'role_title' : roleTitle ,
      'status' : status , 
      'job_url' : jobUrl , 
      'notes' : notes , 
      'location' : location , 
      'applied_date' : appliedDate?.toIso8601String() ,
    } ; 
  }
}
