import '../models/job_application.dart';
import '../services/job_services.dart';
import 'package:flutter/material.dart';
import '../services/job_services.dart';

class JobProvider extends ChangeNotifier {
  final JobService _jobService = JobService();

  List<JobApplication> _jobsList = [];
  bool _isLoading = false;
  String _activeFilter = 'All';

  String get activeFilter => _activeFilter; 

  List<JobApplication> get jobsList => _jobsList;
  bool get isLoading => _isLoading;

  // Computed stats for the dashboard cards - calculate from jobList and not stored seperately
  int get appliedCount => _jobsList.where((j) => j.status == 'APPLIED').length;
  int get interviewCount =>
      _jobsList.where((j) => j.status == 'INTERVIEW').length;
  int get offerCount => _jobsList.where((j) => j.status == 'OFFER').length;

  // -------------------------fetchJobs()----------------------------------|
  Future<void> fetchJobs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _jobsList = await _jobService.getJobs(
        statusFilter: _activeFilter == 'All' ? null : _activeFilter,
      );
    } catch (e) {
      _jobsList = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _activeFilter = filter;
    fetchJobs();
  }

  Future<void> addJob(JobApplication job) async {
    final created = await _jobService.createJob(job);
    _jobsList.insert(0, created); // show the newest job at the top instantly
    notifyListeners();
  }

  Future<void> updateJob(String id, JobApplication job) async {
    final updated = await _jobService.updateJob(id, job);
    final index = _jobsList.indexWhere((j) => j.id == id);
    if (index != -1) {
      _jobsList[index] = updated;
      notifyListeners();
    }
  }


  Future<void> deleteJob(String id) async {
    await _jobService.deleteJob(id);
    _jobsList.removeWhere((j) => j.id == id);
    notifyListeners();
  }
}
