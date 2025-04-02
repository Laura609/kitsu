import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test1/router/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Главная страница
        AutoRoute(page: AuthRoute.page, initial: false),
        AutoRoute(page: MainRoute.page, initial: true),

        // Страницы авторизации
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),

        // Диалоговые окна (Dialogs)
        AutoRoute(page: MentorProfileRoute.page),
        AutoRoute(page: StudentProfileRoute.page),
        AutoRoute(page: EditUserInfoDialog.page),

        // Выбор навыков
        AutoRoute(page: SkillMentorOrStudentRoute.page),
        AutoRoute(page: MentorLevelSelectionRoute.page),
        AutoRoute(page: MentorSkillSelectionRoute.page),
        AutoRoute(page: StudentSkillSelectionRoute.page),

        // Вводные экраны (Intro Pages)
        AutoRoute(page: OnBoardingRoute.page),
        AutoRoute(page: IntroRoute1.page),
        AutoRoute(page: IntroRoute2.page),
        AutoRoute(page: IntroRoute3.page),

        // Другие экраны
        AutoRoute(page: PersonalMessageRoute.page),
        AutoRoute(page: TrainingRoute.page),

        // Страницы для BottomNavigationBar
        CustomRoute(
          page: HomeRoute.page,
          transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: FriendsRoute.page,
          transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: ChatsRoute.page,
          transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 300),
        ),
        CustomRoute(
          page: MentorOrStudentProfileRoute.page,
          transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 300),
        ),
      ];
}
