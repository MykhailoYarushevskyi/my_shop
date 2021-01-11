import 'dart:convert';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Exceptions/http_exception.dart';
import '../models/Exceptions/common_Exception.dart';

class Auth with ChangeNotifier {
  String
      _token; //A Firebase Auth ID token generated from the provided custom token.
  String
      refreshToken; //A Firebase Auth refresh token generated from the provided custom token.
  DateTime _expiryDate;
  String _userId; //The uid of the newly created user.
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  /// Http operation that is common for [signUp()] and [signIn()] methods.
  ///
  /// [email] 	   string  The email for the user to create or is signing in with.
  ///
  /// [password] 	 string  The password for the user to create or for the account.
  ///
  /// [url]        string  Auth signupNewUser (for create) or signInWithPassword (for the account) ENDPOINT.
  ///
  Future<void> _authenticate(
    String email,
    String password,
    String urlWithoutApiKey,
  ) async {
    try {
      final String apiKey =
          await rootBundle.loadString('assets/text_files/fb_api_key.txt');
      apiKey.trim();
      if (apiKey == null) {
        throw CommonException('do not loaded Api Key from assets.');
      }
      final url = urlWithoutApiKey + apiKey;
      print('## Auth _authenticate() (apiKey): $apiKey; (url): $url');
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken':
              true, //Whether or not to return an ID and refresh token.Should always be true.
        }),
      );
      print(
          '## Auth _authenticate() response.statusCode(): ${response.statusCode}');
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('## Auth _authenticate() response.body(): $responseData');
      print(
          '## Auth _authenticate() response.body()[\'idToken\']: ${responseData['idToken']}');
      print(
          '## Auth _authenticate() response.body()[\'expiresIn\']: ${responseData['expiresIn']}');
      if (responseData.containsKey('error')) {
        throw HttpException(responseData['error']['message']);
      }
      // A Firebase Auth ID token for for the newly created user, or the authenticated user.
      _token = responseData['idToken'];
      // The uid of the authenticated user.
      _userId = responseData['localId'];
      //The number of seconds in which the ID token expires.
      int _expiresIn = int.tryParse(responseData['expiresIn'] as String);
      if (_expiresIn == null) {
        // throw CommonException('the time at which the ID token expires has not given');
        throw FormatException(
            'the time at which the ID token expires has not given',
            responseData['expiresIn'].toString());
      }
      //The date and time at which the ID token expires.
      _expiryDate = DateTime.now().add(Duration(seconds: _expiresIn));
      _autoLogout(); // set timer for autologout if was reached _expiryDate
      print('## Auth _authenticate() Exit ');
      notifyListeners();
      //Save token, userId, and expiryDate in the SharedPreferences storage at a disc
      final sharedPref = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        },
      );
      sharedPref.setString('userData', userData);
    } catch (error) {
      print('## Auth _authenticate() catch (error): $error');
      throw error;
    } finally {}
  }

  /// Sign up with email / password
  /// Create a new email and password user by issuing an HTTP POST request
  /// to the Auth signupNewUser endpoint.
  ///
  /// [email] 	             string 	The email for the user to create.
  ///
  /// [password] 	           string 	The password for the user to create.
  ///
  /// Method: POST
  ///
  /// Content-Type: application/json
  ///
  /// ENDPOINT:
  /// https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
  ///
  /// Request Body Payload:
  ///
  /// Property Name      -	Type  -   Description:
  ///
  /// email 	             string 	The email for the user to create.
  ///
  /// password 	           string 	The password for the user to create.
  ///
  /// returnSecureToken    boolean 	Whether or not to return an ID and refresh token.Should always be true.
  ///
  /// Response Payload:
  ///
  /// Property Name   -	Type  -   Description:
  ///
  /// idToken 	       string 	A Firebase Auth ID token for the newly created user.
  ///
  /// email            string 	The email for the newly created user.
  ///
  /// refreshToken 	   string 	A Firebase Auth refresh token for the newly created user.
  ///
  /// expiresIn 	     string 	The number of seconds in which the ID token expires.
  ///
  /// localId          string 	The uid of the newly created user.
  ///
  ///  Common error codes:
  ///
  ///  EMAIL_EXISTS: The email address is already in use by another account.
  ///  OPERATION_NOT_ALLOWED: Password sign-in is disabled for this project.
  ///  TOO_MANY_ATTEMPTS_TRY_LATER: We have blocked all requests from this device
  ///                               due to unusual activity. Try again later.
  ///
  ///  for more information: https://firebase.google.com/docs/reference/rest/auth
  ///
  Future<void> signUp({String email, String password}) async {
    //Auth signupNewUser endpoint without the API_KEY.
    const urlWithoutApiKey =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=';
    return _authenticate(
      email,
      password,
      urlWithoutApiKey,
    );
    //     .then((resp) {
    //   Map<String, dynamic> responseData = json.decode(resp.body);
    //   _token = responseData['idToken'];
    //   //The number of seconds in which the ID token expires.
    //   int _expiresIn = int.tryParse(responseData['expiresIn'] as String);
    //   //The date and time at which the ID token expires.
    //   _expiryDate = DateTime.now().add(
    //     Duration(seconds: _expiresIn),
    //   );
    // }).catchError(
    //   (error) => throw error,
    // );
  }

  /// Sign in with email / password
  /// sign in a user with an email and password by issuing an HTTP POST request
  ///
  /// [email] 	            string 	  The email the user is signing in with.
  ///
  /// [password] 	          string  	The password for the account.
  ///
  /// to the Auth verifyPassword endpoint.
  ///
  /// Method: POST
  ///
  /// Content-Type: application/json
  ///
  /// Endpoint: https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]
  ///
  /// Request Body Payload:
  ///
  /// Property Name 	-   Type   - 	Description:
  ///
  /// email 	            string 	  The email the user is signing in with.
  ///
  /// password 	          string  	The password for the account.
  ///
  /// returnSecureToken 	boolean 	Whether or not to return an ID and refresh token. Should always be true.
  ///
  /// Response Payload:
  ///
  /// Property Name -  Type   - 	Description:
  ///
  /// idToken 	      string 	A Firebase Auth ID token for the authenticated user.
  ///
  /// email 	        string 	The email for the authenticated user.
  ///
  /// refreshToken 	  string 	A Firebase Auth refresh token for the authenticated user.
  ///
  /// expiresIn      	string 	The number of seconds in which the ID token expires.
  ///
  /// localId       	string 	The uid of the authenticated user.
  ///
  /// registered    	boolean Whether the email is for an existing account.
  ///
  /// Common error codes:
  ///
  ///   EMAIL_NOT_FOUND: There is no user record corresponding to this identifier.
  ///                    The user may have been deleted.
  ///
  ///   INVALID_PASSWORD: The password is invalid or the user does not have a password.
  ///
  ///   USER_DISABLED: The user account has been disabled by an administrator.
  ///
  /// A successful request is indicated by a 200 OK HTTP status code.
  /// The response contains the Firebase ID token and refresh token
  /// associated with the existing email/password account.

  Future<void> signIn({String email, String password}) async {
    //Auth signInWithPassword endpoint without the API_KEY.
    const String urlWithoutApiKey =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=';
    return _authenticate(
      email,
      password,
      urlWithoutApiKey,
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    log('## log Auth EntrytryAutoLogin() _token.length: ${_token != null ? _token.length : null}');
    print(
        '## Auth Entry tryAutoLogin() _token: ${_token != null ? _token.length : null}');
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    print(
        '## Auth tryAutoLogin() _token.length: ${_token != null ? _token.length : null}');
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  /// Try whether a user token is actual at present.
  /// Returns either [Future\<true\>] if it is actual or [Future\<false\>] if it is not actual
  Future<bool> tryAutoLoginMy() async {
    // print('## Auth tryAutoLogin() _token.length: ${_token.length}');
    try {
      final sharedPref = await SharedPreferences.getInstance();
      if (!sharedPref.containsKey('userData')) {
        // print(
        //     '## Auth tryAutoLogin() sharedPref.containsKey(\'userData\): ${sharedPref.containsKey('userData')}');
        return false;
      }
      final extractedData =
          json.decode(sharedPref.get('userData')) as Map<String, Object>;
      // print('## Auth tryAutoLogin() extractedData: $extractedData');
      if (extractedData['expiryDate'] != null &&
          DateTime.parse(extractedData['expiryDate']).isAfter(DateTime.now()) &&
          extractedData['token'] != null &&
          extractedData['userId'] != null) {
        _token = extractedData['token'];
        _userId = extractedData['userId'];
        _expiryDate = DateTime.parse(extractedData['expiryDate']);
        // print('## Auth tryAutoLogin() _token.length: ${_token.length}');
        // print('## Auth tryAutoLogin() _userId: $userId');
        // print('## Auth tryAutoLogin() _expiryDate: $_expiryDate');

        notifyListeners();
        _autoLogout(); // set timer for autologout if was reached _expiryDate
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // print('## Auth tryAutoLogin() catch(error): $error');
      throw error;
    }
  }

  /// reset to null token, userId and expireDate
  Future<void> logout() async {
    print('## Auth.logout()');
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove('userData');
  }

  void _autoLogout() {
    print('## Auth._autoLogout() ');
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
