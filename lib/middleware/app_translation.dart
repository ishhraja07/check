import 'package:get/get.dart';

class Translate extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'mr': mr};
}

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "mr": mr,
  };
}

final Map<String, String> mr = {
  //Welcome Pape
  'User Login': "युझर लॉग-ईन",
  "Admin Login": "अॅडमिन लॉग-ईन",
  'Admin Code': 'अॅडमिन कोड',
  'Admin Code required': 'अॅडमिन कोड आवश्यक',
  'Wrong Admin Code': 'अवैध अॅडमिन कोड',
  'Try Again or login as user': 'पुन्हा प्रयत्न करा किंवा युझर लॉगिन करा',
  'Next': 'पुढे',
  'Get Started': 'प्रवेश करा',

  //login_signup page
  'Login': 'लॉग-ईन',
  'New Account': 'नवीन अकाउंट',

  //login page
  'Enter Your Password': 'तुमचा पासवर्ड enter करा',
  'Password': ' पासवर्ड',
  'Email Id': ' ई-मेल',

  //signup page
  'Enter Your Address': 'आपला निवासी पत्ता',
  'Address': ' पत्ता',
  'Full Name': ' पूर्ण नाव',
  'Enter Your Full Name': 'आपले पूर्ण नाव',
  'must be at least 6 characters': 'किमान ६ अक्षरी अपेक्षित',
  'min 6 characters': 'पासवर्ड ६ अक्षरी अपेक्षित',

  //snackbar
  'Something Went Wrong': 'पुढील प्रक्रिया करू शकत नाही',
  'Try Again Later After Sometime': 'थोडया वेळाने पुन्हा प्रयत्न करा',
  'Try Login as Admin': 'अॅडमिन म्हणून लॉगिन करून पहा',
  "Enter Full name & Address": "पूर्ण नाव आणि पत्ता भरा",
  'Login Sucessful...': 'लॉगिन पूर्ण...',
  'Welcome Back!': 'आपले स्वागत आहे!',
  'SignUp Sucessful...': 'साईन अप पूर्ण...',
  'Welcome!': 'आपले स्वागत आहे!',

  //Auth commom widgets
  'Login With Google': 'Google ने लॉगिन करा ',
  'Signup With Google': 'Google ने साईन अप करा ',
  'OR': 'किंवा',
  'Invalid Email': 'अवैध ई-मेल',
  'Enter Your Email': 'तुमचा ई-मेल enter करा ',
  'Enter Valid Info': 'बरोबर माहिती भरा',

  //home page
  "January": "जानेवारी",
  "February": "फेब्रुवारी",
  "March": "मार्च",
  "April": "एप्रिल",
  "May": "मे",
  "June": "जून",
  "July": "जुलै",
  "August": "ऑगस्ट",
  "September": "सप्टेंबर",
  "October": "ऑक्टोबर",
  "November": "नोव्हेंबर",
  "December": "डिसेंबर",

  "Swami.": "स्वामी.",
  "Today is": "आज आहे",
  "Calender": "कॅलेंडर",
  "Upcoming Events": "आगामी कार्यक्रम",
  "Events": "कार्यक्रम",
  "Time": "वेळ",
  "Venue": "ठिकाण",
  "Host": "आयोजक",
  "Date": "दिनांक",
  'From': 'पासून',
  'To': 'पर्यंत',

  //drawer
  'user Info': 'युझर माहिती',
  'LogOut': 'लॉग-ऑऊट',
  'admin Info': 'अॅडमिन माहिती',
  'open location in map': 'मॅप वर लोकेशन पहा',
  'Edit username': 'नाव edit करा',
  'Update live location': 'live लोकेशन अपडेट करा',

  //calender
  'Please select the date first': 'कृपया तारीख निवडा',
  'Click on the date to select the date':
      'तारीख निवडण्यासाठी तारखेवर क्लिक करा',
  'Event Name': 'कार्यक्रमाचे नाव',
  'Organiser': 'आयोजकाचे नाव',
  'Event Host': 'आयोजक',
  'Event Venue': 'कार्यक्रमाचे ठिकाण',
  'Description': 'अधिक माहिती',
  'Jap Count': 'जप Count',
  'Add Event': 'नवीन कार्यक्रम',
  'Please add jap count': 'जप count add करा',
  'click on the text box to edit': 'add करण्यासाठी text box वर क्लिक करा',
  "Today's Jap Count": 'आजचा जप count',
};
