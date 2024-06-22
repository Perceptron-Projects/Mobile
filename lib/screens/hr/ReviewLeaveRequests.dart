import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/appColors.dart';
import 'package:ams/providers/leaveController.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HRReviewLeaveRequestsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveController = ref.read(leaveControllerProvider);
    final leaveRequests = useState<List<Map<String, dynamic>>>([]);
    final isLoading = useState<bool>(true);

    Future<void> fetchPendingLeaveRequests() async {
      final storage = FlutterSecureStorage();
      String? companyId = await storage.read(key: 'companyId');
      if (companyId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Company ID not found')),
        );
        isLoading.value = false;
        return;
      }

      try {
        leaveRequests.value = await leaveController.getPendingLeaveRequests(companyId);
      } catch (e) {
        // Handle the error
        print(e);
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> updateLeaveRequestStatus(String leaveId, String status, String createdAt) async {
      try {
        await leaveController.updateLeaveRequest(leaveId, status, createdAt);
        await fetchPendingLeaveRequests();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave request status updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update leave request status')),
        );
      }
    }

    useEffect(() {
      fetchPendingLeaveRequests();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Review Leave Requests',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading.value
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: leaveRequests.value.map((leaveRequest) {
              return LeaveApprovalTile(
                leaveRequest: leaveRequest,
                onApprove: () => updateLeaveRequestStatus(
                  leaveRequest['leaveId'],
                  'approved',
                  leaveRequest['createdAt'],
                ),
                onReject: () => updateLeaveRequestStatus(
                  leaveRequest['leaveId'],
                  'rejected',
                  leaveRequest['createdAt'],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
