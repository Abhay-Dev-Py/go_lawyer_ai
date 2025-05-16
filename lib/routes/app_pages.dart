import 'package:get/get.dart';
import 'package:go_lawyer_ai/modules/auth/controller/auth_controller.dart';
import 'package:go_lawyer_ai/modules/auth/view/login_view.dart';
import 'package:go_lawyer_ai/modules/auth/view/register_view.dart';
import 'package:go_lawyer_ai/modules/chat/controller/chat_controller.dart';
import 'package:go_lawyer_ai/modules/chat/controller/conversation_list_controller.dart';
import 'package:go_lawyer_ai/modules/chat/view/chat_view.dart';
import 'package:go_lawyer_ai/modules/chat/view/conversation_list_view.dart';
import 'package:go_lawyer_ai/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.conversations,
      page: () => const ConversationListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
        Get.lazyPut(() => ConversationListController());
      }),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ChatController());
      }),
    ),
  ];
}
