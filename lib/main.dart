import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/providers/authentication_provder.dart';
import 'package:p2p/providers/items_provider.dart';
import 'package:p2p/providers/map_provider.dart';
import 'package:p2p/providers/user_provider.dart';
import 'package:p2p/screens/admin/admin_home_screen.dart';
import 'package:p2p/screens/admin/manage_agent_status.dart';
import 'package:p2p/screens/agent/agent_home_screen.dart';
import 'package:p2p/screens/authentication/login_screen.dart';
import 'package:p2p/screens/authentication/newPassword.dart';
import 'package:p2p/screens/authentication/signup.dart';
import 'package:p2p/screens/authentication/signup_or_login_screen.dart';
import 'package:p2p/screens/authentication/verify_otp.dart';
import 'package:p2p/screens/authentication/forgot_password_screen.dart';
import 'package:p2p/screens/authentication/get_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:p2p/screens/user/delivery_request_screen.dart';
import 'package:p2p/screens/user/order_screen.dart';
import 'package:p2p/screens/user/user_home.dart';
import 'package:p2p/screens/user/map_screen.dart';
import 'package:p2p/screens/user/myorder.dart';
import 'package:p2p/screens/user/onboarding_screen.dart';
import 'package:p2p/service/agent_service.dart';
import 'package:p2p/service/authentication_service.dart';
import 'package:p2p/service/order_service.dart';
import 'package:p2p/service/profile_service.dart';
import 'package:p2p/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if onboarding has been completed
  bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

// Check if the user is signed in
  bool isSignedIn = prefs.getBool('isSignedIn') ?? false;

  // Check the time elapsed since the last sign-in
  String? lastSignInTime = prefs.getString('lastSignInTime');
  String? role = prefs.getString('role');
  DateTime now = DateTime.now();
  DateTime? lastSignIn =
      lastSignInTime != null ? DateTime.parse(lastSignInTime) : null;
  bool shouldSignInAgain =
      lastSignIn == null || now.difference(lastSignIn).inHours >= 4;
  String initialRoute = SignupOrLogin.routeName;
  // Determine the initial route based on whether onboarding is completed
  // String initialRoute = isOnboardingCompleted
  //     ? isSignedIn && !shouldSignInAgain && role == 'USER'
  //         ? DeliveryRequest.routeName
  //         : SignupOrLogin.routeName
  //     : Onboarding.routeName;
  if (!isOnboardingCompleted) {
    initialRoute = Onboarding.routeName;
  }
  //
  else if (!isSignedIn && shouldSignInAgain) {
    initialRoute = SignupOrLogin.routeName;
  }
  //
  else if (isSignedIn && !shouldSignInAgain) {
    if (role == 'USER') {
      initialRoute = User_Home.routeName;
    }
    //
    else if (role == 'ADMIN') {
      initialRoute = Admin_Home_Screen.routeName;
    }
    //
    else if (role == 'CANDIDATE' || role == 'AGENT') {
      initialRoute = Agent_Home_Screen.routeName;
    }
  }

  runApp(MyApp(initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp(this.initialRoute);

  // This widget is the root of ultiPryour application.
  @override
  Widget build(BuildContext context) {
    print(initialRoute);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthenticationProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: MapProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AuthService(),
        ),
        ChangeNotifierProvider.value(
          value: ItemsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrderService(),
        ),
        ChangeNotifierProvider.value(
          value: ProfileService(),
        ),
        ChangeNotifierProvider.value(
          value: AgentService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: P2pAppColors.blue),
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        routes: {
          '/signup_or_login': (context) => const SignupOrLogin(),
          '/getotp': (context) => const GetOtp(),
          '/forgot': (context) => const ForgotPassword(),
          '/otp': (context) => const OTPScreen(),
          '/newPassword': (context) => const NewPassword(),
          '/map': (context) => MapScreen(),
          ManageAgentStatus.routeName: (context) => ManageAgentStatus(),
          Agent_Home_Screen.routeName: (context) => Agent_Home_Screen(),
          Admin_Home_Screen.routeName: (context) => Admin_Home_Screen(),
          Login.routeName: (context) => Login(),
          NewPassword.routeName: (context) => NewPassword(),
          MyOrderScreen.routeName: (context) => MyOrderScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          SignUp.routeName: (context) => SignUp(),
          User_Home.routeName: (context) => User_Home(),
          SignupOrLogin.routeName: (context) => SignupOrLogin(),
          DeliveryRequest.routeName: (context) => DeliveryRequest(),
          Onboarding.routeName: (context) => Onboarding(),
        },
      ),
    );
  }
}
