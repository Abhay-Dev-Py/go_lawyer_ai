import 'package:get/get.dart';
import 'package:go_lawyer_ai/modules/auth/controller/auth_controller.dart';
import 'package:go_lawyer_ai/modules/chat/controller/conversation_list_controller.dart';
import 'package:go_lawyer_ai/services/api_service.dart';
import 'package:go_lawyer_ai/services/firebase_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(FirebaseService(), permanent: true);
    Get.put(ApiService(), permanent: true);

    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.put(ConversationListController(), permanent: true);
  }
}
