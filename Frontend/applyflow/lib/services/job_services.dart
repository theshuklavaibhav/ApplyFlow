import 'dart:convert';
import 'api_service.dart';
import '../models/job_application.dart';

class JobServices {
  final _apiService = ApiService();
  //--------------------GetJob()---------------------------|
  Future<List<JobApplication>> getJobs({String? statusFilter}) async {
    String endpoint = '/jobs';
    if (statusFilter != null && statusFilter != 'All') {
      endpoint += statusFilter;
    }
    final response = await _apiService.get(endpoint);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List jobsJson =
          data['data']; // matches your paginated response shape
      return jobsJson.map((j) => JobApplication.fromJsontoDartObj(j)).toList();
    } else {
      throw Exception("Failed to load Job Applications");
    }
  }

  //--------------------CreateJob()---------------------------|
  Future<JobApplication> createJob(JobApplication jobApplication) async {
    final response = await _apiService.post('/jobs', jobApplication.toJson());
    if (response.statusCode == 201) {
      return JobApplication.fromJsontoDartObj(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create job application");
    }
  }

  //--------------------UpdateJob()---------------------------|
  Future<JobApplication> updateJob(String id, JobApplication job) async {
    final response = await _apiService.put('/jobs/$id', job.toJson());
    if (response.statusCode == 200) {
      return JobApplication.fromJsontoDartObj(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update application');
    }
  }

  //--------------------DeleteJob()---------------------------|
  Future<void> deleteApplication(String id) async {
    final response = await _apiService.delete('/jobs/$id');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete application'); 
    }
  }
}
