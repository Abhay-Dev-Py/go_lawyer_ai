import 'package:get/get.dart';
import 'package:go_lawyer_ai/modules/auth/view/login_view.dart';
import 'package:go_lawyer_ai/modules/auth/view/register_view.dart';
import 'package:go_lawyer_ai/modules/chat/view/chat_view.dart';
import 'package:go_lawyer_ai/modules/chat/view/conversation_list_view.dart';
import 'package:go_lawyer_ai/modules/dashboard/view/dashboard_view.dart';

class AppRoutes {
  // Route Names
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String conversations = '/conversations';
  static const String chat = '/chat/:id';
  static const String dashboard = '/dashboard';

  // Get Pages
  static final List<GetPage> pages = [
    GetPage(
      name: initial,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: conversations,
      page: () => const ConversationListView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chat,
      page: () => const ChatView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardView(),
      transition: Transition.fadeIn,
    ),
  ];
}
