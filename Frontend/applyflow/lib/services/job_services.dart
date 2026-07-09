import 'dart:convert';
import '../models/job_application.dart';
import 'api_service.dart';

class JobService {
  final ApiService _api = ApiService();

  Future<List<JobApplication>> getJobs({String? statusFilter}) async {
    String endpoint = '/jobs';
    if (statusFilter != null && statusFilter != 'All') {
      endpoint += '?status=$statusFilter';
    }
    final response = await _api.get(endpoint);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Handle both paginated {data:[]} and bare [] responses
      final List jobsJson = data is List ? data : (data['data'] ?? []);
      return jobsJson.map((j) => JobApplication.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<JobApplication> createJob(JobApplication job) async {
    final response = await _api.post('/jobs', job.toJson());
    if (response.statusCode == 201) {
      return JobApplication.fromJson(jsonDecode(response.body));
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Failed to create job');
    }
  }

  Future<JobApplication> updateJob(String id, JobApplication job) async {
    final response = await _api.put('/jobs/$id', job.toJson());
    if (response.statusCode == 200) {
      return JobApplication.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update job');
    }
  }

  Future<void> deleteJob(String id) async {
    final response = await _api.delete('/jobs/$id');
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete job');
    }
  }
}
