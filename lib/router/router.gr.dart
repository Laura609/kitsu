// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i22;
import 'package:flutter/material.dart' as _i23;
import 'package:test1/Pages/Auth/auth_page.dart' as _i1;
import 'package:test1/Pages/Auth/login_page.dart' as _i9;
import 'package:test1/Pages/Auth/main_page.dart' as _i10;
import 'package:test1/Pages/Auth/register_page.dart' as _i17;
import 'package:test1/Pages/Chat/chat_page.dart' as _i2;
import 'package:test1/Pages/Dialogs/edit_info_dialog.dart' as _i3;
import 'package:test1/Pages/Friend/friend_page.dart' as _i4;
import 'package:test1/Pages/Home/home_page.dart' as _i5;
import 'package:test1/Pages/Chat/personal_message_page.dart' as _i16;
import 'package:test1/Pages/Profiels/mentor/mentor_profile_page.dart' as _i13;
import 'package:test1/Pages/Profiels/student/student_profile_page.dart' as _i19;
import 'package:test1/Pages/Questions/level.dart' as _i11;
import 'package:test1/Pages/Questions/mentor_skill.dart' as _i14;
import 'package:test1/Pages/Questions/student_skill.dart' as _i20;
import 'package:test1/Pages/Routs/mentor_or_student_profile_page.dart' as _i12;
import 'package:test1/Pages/Routs/skill_mentor_or_student_page.dart' as _i18;
import 'package:test1/Pages/Screens/intro_page_1.dart' as _i6;
import 'package:test1/Pages/Screens/intro_page_2.dart' as _i7;
import 'package:test1/Pages/Screens/intro_page_3.dart' as _i8;
import 'package:test1/Pages/Screens/onboarding_screen.dart' as _i15;
import 'package:test1/Pages/Course/course_page.dart' as _i21;

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i22.PageRouteInfo<void> {
  const AuthRoute({List<_i22.PageRouteInfo>? children})
      : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthPage();
    },
  );
}

/// generated route for
/// [_i2.ChatPage]
class ChatsRoute extends _i22.PageRouteInfo<ChatsRouteArgs> {
  ChatsRoute({_i23.Key? key, List<_i22.PageRouteInfo>? children})
      : super(
          ChatsRoute.name,
          args: ChatsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChatsRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatsRouteArgs>(
        orElse: () => const ChatsRouteArgs(),
      );
      return _i2.ChatPage(key: args.key);
    },
  );
}

class ChatsRouteArgs {
  const ChatsRouteArgs({this.key});

  final _i23.Key? key;

  @override
  String toString() {
    return 'ChatsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.EditUserInfoDialog]
class EditUserInfoDialog extends _i22.PageRouteInfo<EditUserInfoDialogArgs> {
  EditUserInfoDialog({
    _i23.Key? key,
    required _i23.TextEditingController usernameController,
    required _i23.TextEditingController bioController,
    required String userEmail,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          EditUserInfoDialog.name,
          args: EditUserInfoDialogArgs(
            key: key,
            usernameController: usernameController,
            bioController: bioController,
            userEmail: userEmail,
          ),
          initialChildren: children,
        );

  static const String name = 'EditUserInfoDialog';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditUserInfoDialogArgs>();
      return _i3.EditUserInfoDialog(
        key: args.key,
        usernameController: args.usernameController,
        bioController: args.bioController,
        userEmail: args.userEmail,
      );
    },
  );
}

class EditUserInfoDialogArgs {
  const EditUserInfoDialogArgs({
    this.key,
    required this.usernameController,
    required this.bioController,
    required this.userEmail,
  });

  final _i23.Key? key;

  final _i23.TextEditingController usernameController;

  final _i23.TextEditingController bioController;

  final String userEmail;

  @override
  String toString() {
    return 'EditUserInfoDialogArgs{key: $key, usernameController: $usernameController, bioController: $bioController, userEmail: $userEmail}';
  }
}

/// generated route for
/// [_i4.FriendPage]
class FriendsRoute extends _i22.PageRouteInfo<void> {
  const FriendsRoute({List<_i22.PageRouteInfo>? children})
      : super(FriendsRoute.name, initialChildren: children);

  static const String name = 'FriendsRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i4.FriendPage();
    },
  );
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i22.PageRouteInfo<void> {
  const HomeRoute({List<_i22.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomePage();
    },
  );
}

/// generated route for
/// [_i6.IntroPage1]
class IntroRoute1 extends _i22.PageRouteInfo<void> {
  const IntroRoute1({List<_i22.PageRouteInfo>? children})
      : super(IntroRoute1.name, initialChildren: children);

  static const String name = 'IntroRoute1';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i6.IntroPage1();
    },
  );
}

/// generated route for
/// [_i7.IntroPage2]
class IntroRoute2 extends _i22.PageRouteInfo<void> {
  const IntroRoute2({List<_i22.PageRouteInfo>? children})
      : super(IntroRoute2.name, initialChildren: children);

  static const String name = 'IntroRoute2';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i7.IntroPage2();
    },
  );
}

/// generated route for
/// [_i8.IntroPage3]
class IntroRoute3 extends _i22.PageRouteInfo<void> {
  const IntroRoute3({List<_i22.PageRouteInfo>? children})
      : super(IntroRoute3.name, initialChildren: children);

  static const String name = 'IntroRoute3';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i8.IntroPage3();
    },
  );
}

/// generated route for
/// [_i9.LoginPage]
class LoginRoute extends _i22.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i23.Key? key,
    required _i23.VoidCallback showRegisterPage,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(key: key, showRegisterPage: showRegisterPage),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>();
      return _i9.LoginPage(
        key: args.key,
        showRegisterPage: args.showRegisterPage,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, required this.showRegisterPage});

  final _i23.Key? key;

  final _i23.VoidCallback showRegisterPage;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, showRegisterPage: $showRegisterPage}';
  }
}

/// generated route for
/// [_i10.MainPage]
class MainRoute extends _i22.PageRouteInfo<void> {
  const MainRoute({List<_i22.PageRouteInfo>? children})
      : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i10.MainPage();
    },
  );
}

/// generated route for
/// [_i11.MentorLevelSelectionPage]
class MentorLevelSelectionRoute extends _i22.PageRouteInfo<void> {
  const MentorLevelSelectionRoute({List<_i22.PageRouteInfo>? children})
      : super(MentorLevelSelectionRoute.name, initialChildren: children);

  static const String name = 'MentorLevelSelectionRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i11.MentorLevelSelectionPage();
    },
  );
}

/// generated route for
/// [_i12.MentorOrStudentProfilePage]
class MentorOrStudentProfileRoute extends _i22.PageRouteInfo<void> {
  const MentorOrStudentProfileRoute({List<_i22.PageRouteInfo>? children})
      : super(MentorOrStudentProfileRoute.name, initialChildren: children);

  static const String name = 'MentorOrStudentProfileRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i12.MentorOrStudentProfilePage();
    },
  );
}

/// generated route for
/// [_i13.MentorProfilePage]
class MentorProfileRoute extends _i22.PageRouteInfo<void> {
  const MentorProfileRoute({List<_i22.PageRouteInfo>? children})
      : super(MentorProfileRoute.name, initialChildren: children);

  static const String name = 'MentorProfileRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i13.MentorProfilePage();
    },
  );
}

/// generated route for
/// [_i14.MentorSkillSelectionPage]
class MentorSkillSelectionRoute extends _i22.PageRouteInfo<void> {
  const MentorSkillSelectionRoute({List<_i22.PageRouteInfo>? children})
      : super(MentorSkillSelectionRoute.name, initialChildren: children);

  static const String name = 'MentorSkillSelectionRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i14.MentorSkillSelectionPage();
    },
  );
}

/// generated route for
/// [_i15.OnBoardingScreen]
class OnBoardingRoute extends _i22.PageRouteInfo<void> {
  const OnBoardingRoute({List<_i22.PageRouteInfo>? children})
      : super(OnBoardingRoute.name, initialChildren: children);

  static const String name = 'OnBoardingRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i15.OnBoardingScreen();
    },
  );
}

/// generated route for
/// [_i16.PersonalMessagePage]
class PersonalMessageRoute
    extends _i22.PageRouteInfo<PersonalMessageRouteArgs> {
  PersonalMessageRoute({
    _i23.Key? key,
    required String currentUserId,
    required String otherUserId,
    required String otherUserEmail,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          PersonalMessageRoute.name,
          args: PersonalMessageRouteArgs(
            key: key,
            currentUserId: currentUserId,
            otherUserId: otherUserId,
            otherUserEmail: otherUserEmail,
          ),
          initialChildren: children,
        );

  static const String name = 'PersonalMessageRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PersonalMessageRouteArgs>();
      return _i16.PersonalMessagePage(
        key: args.key,
        currentUserId: args.currentUserId,
        otherUserId: args.otherUserId,
        otherUserEmail: args.otherUserEmail,
      );
    },
  );
}

class PersonalMessageRouteArgs {
  const PersonalMessageRouteArgs({
    this.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserEmail,
  });

  final _i23.Key? key;

  final String currentUserId;

  final String otherUserId;

  final String otherUserEmail;

  @override
  String toString() {
    return 'PersonalMessageRouteArgs{key: $key, currentUserId: $currentUserId, otherUserId: $otherUserId, otherUserEmail: $otherUserEmail}';
  }
}

/// generated route for
/// [_i17.RegisterPage]
class RegisterRoute extends _i22.PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    _i23.Key? key,
    required _i23.VoidCallback showLoginPage,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(key: key, showLoginPage: showLoginPage),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>();
      return _i17.RegisterPage(
        key: args.key,
        showLoginPage: args.showLoginPage,
      );
    },
  );
}

class RegisterRouteArgs {
  const RegisterRouteArgs({this.key, required this.showLoginPage});

  final _i23.Key? key;

  final _i23.VoidCallback showLoginPage;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, showLoginPage: $showLoginPage}';
  }
}

/// generated route for
/// [_i18.SkillMentorOrStudentPage]
class SkillMentorOrStudentRoute
    extends _i22.PageRouteInfo<SkillMentorOrStudentRouteArgs> {
  SkillMentorOrStudentRoute({_i23.Key? key, List<_i22.PageRouteInfo>? children})
      : super(
          SkillMentorOrStudentRoute.name,
          args: SkillMentorOrStudentRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SkillMentorOrStudentRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SkillMentorOrStudentRouteArgs>(
        orElse: () => const SkillMentorOrStudentRouteArgs(),
      );
      return _i18.SkillMentorOrStudentPage(key: args.key);
    },
  );
}

class SkillMentorOrStudentRouteArgs {
  const SkillMentorOrStudentRouteArgs({this.key});

  final _i23.Key? key;

  @override
  String toString() {
    return 'SkillMentorOrStudentRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i19.StudentProfilePage]
class StudentProfileRoute extends _i22.PageRouteInfo<void> {
  const StudentProfileRoute({List<_i22.PageRouteInfo>? children})
      : super(StudentProfileRoute.name, initialChildren: children);

  static const String name = 'StudentProfileRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i19.StudentProfilePage();
    },
  );
}

/// generated route for
/// [_i20.StudentSkillSelectionPage]
class StudentSkillSelectionRoute extends _i22.PageRouteInfo<void> {
  const StudentSkillSelectionRoute({List<_i22.PageRouteInfo>? children})
      : super(StudentSkillSelectionRoute.name, initialChildren: children);

  static const String name = 'StudentSkillSelectionRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i20.StudentSkillSelectionPage();
    },
  );
}

/// generated route for
/// [_i21.CoursePage]
class TrainingRoute extends _i22.PageRouteInfo<void> {
  const TrainingRoute({List<_i22.PageRouteInfo>? children})
      : super(TrainingRoute.name, initialChildren: children);

  static const String name = 'TrainingRoute';

  static _i22.PageInfo page = _i22.PageInfo(
    name,
    builder: (data) {
      return const _i21.CoursePage();
    },
  );
}
