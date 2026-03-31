import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthViewModel extends ChangeNotifier {
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  String _otp = '';
  String get otp => _otp;

  int _resendTimer = 59;
  int get resendTimer => _resendTimer;
  Timer? _timer;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Replace with your MSG91 Auth details
  final String _msg91AuthKey = '504657AujfklDN69cb5bd1P1'; 
  final String _templateId = '69cb5cead261a29daa0d3d22'; 

  void setPhoneNumber(String number) {
    _phoneNumber = number;
    notifyListeners();
  }

  void setOtp(String otp) {
    _otp = otp;
    notifyListeners();
  }

  void startResendTimer() {
    _resendTimer = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
      } else {
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  Future<void> getOtp(BuildContext context) async {
    if (_phoneNumber.isEmpty || _phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number'), backgroundColor: Colors.red),
      );
      return;
    }
    
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://control.msg91.com/api/v5/otp?template_id=$_templateId&mobile=91$_phoneNumber&authkey=$_msg91AuthKey');
      final response = await http.get(url);
      
      print('HTTP STATUS: ${response.statusCode}');
      print('MSG91 RESPONSE: ${response.body}');
      
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['type'] == 'success') {
          startResendTimer();
          Navigator.pushNamed(context, '/otp');
        } else {
          print('MSG91 API Auth Error. Using Mock Backend.');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('MSG91 Error: Using Mock OTP (123456)')));
          startResendTimer();
          Navigator.pushNamed(context, '/otp');
        }
      } else {
        print('MSG91 HTTP Error. Using Mock Backend.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('MSG91 Error ${response.statusCode}: Using Mock OTP (123456)')));
        startResendTimer();
        Navigator.pushNamed(context, '/otp');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP'), backgroundColor: Colors.red),
      );
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://control.msg91.com/api/v5/otp/verify?otp=$_otp&mobile=91$_phoneNumber&authkey=$_msg91AuthKey');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['type'] == 'success' || body['message'] == 'OTP verified success fully') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP Verified Successfully!'), backgroundColor: Colors.green));
          // TODO: Navigate to Home Screen
          // Navigator.pushReplacementNamed(context, '/home');
        } else {
          print('MSG91 Verify Error: ${body["message"]}. Using Mock fallback.');
          if (_otp == '123456') {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP Verified Successfully!'), backgroundColor: Colors.green));
             // TODO: Navigate to Home Screen
             // Navigator.pushReplacementNamed(context, '/home');
          } else {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['message'] ?? 'Invalid OTP')));
          }
        }
      } else {
        print('MSG91 HTTP Error during Verify. Using Mock fallback.');
        if (_otp == '123456') {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP Verified Successfully!'), backgroundColor: Colors.green));
             // TODO: Navigate to Home Screen
             // Navigator.pushReplacementNamed(context, '/home');
        } else {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Mock OTP. Use 123456.')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
