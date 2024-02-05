import 'package:onesignal_flutter/onesignal_flutter.dart';


 oneSignalInAppMessagingTriggerExamples () async{
  /// Example addTrigger call for IAM
  /// This will add 1 trigger so if there are any IAM satisfying it, it
  /// will be shown to the user
  OneSignal.InAppMessages.addTrigger("trigger_1", "one");

  /// Example addTriggers call for IAM
  /// This will add 2 triggers so if there are any IAM satisfying these, they
  /// will be shown to the user
  Map<String, String> triggers = new Map<String, String>();
  triggers["trigger_2"] = "two";
  triggers["trigger_3"] = "three";
  OneSignal.InAppMessages.addTriggers(triggers);

  // Removes a trigger by its key so if any future IAM are pulled with
  // these triggers they will not be shown until the trigger is added back
  OneSignal.InAppMessages.removeTrigger("trigger_2");

  // Create a list and bulk remove triggers based on keys supplied
  List<String> keys = ["trigger_1", "trigger_3"];
  OneSignal.InAppMessages.removeTriggers(keys);

  // Toggle pausing (displaying or not) of IAMs
  OneSignal.InAppMessages.paused(true);
  var arePaused = await OneSignal.InAppMessages.arePaused();
  print('Notifications paused ${arePaused}');
}

oneSignalOutcomeExamples() async {
  OneSignal.Session.addOutcome("normal_1");
  OneSignal.Session.addOutcome("normal_2");

  OneSignal.Session.addUniqueOutcome("unique_1");
  OneSignal.Session.addUniqueOutcome("unique_2");

  OneSignal.Session.addOutcomeWithValue("value_1", 3.2);
  OneSignal.Session.addOutcomeWithValue("value_2", 3.9);
}

bool _requireConsent = false;

String _debugLabelString = "";
String? _emailAddress;
String? _smsNumber;
String? _externalUserId;
String? _language;
bool _enableConsentButton = false;
Future<void> initPlatformState() async {

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.consentRequired(_requireConsent);

  // NOTE: Replace with your own app ID from https://www.onesignal.com
  OneSignal.initialize("73b1bad5-af87-4520-8806-ca13d4457063");

  // AndroidOnly stat only
  // OneSignal.Notifications.removeNotification(1);
  // OneSignal.Notifications.removeGroupedNotifications("group5");

  OneSignal.Notifications.clearAll();
  OneSignal.User.pushSubscription.addObserver((state) {
    print(OneSignal.User.pushSubscription.optedIn);
    print(OneSignal.User.pushSubscription.id);
    print(OneSignal.User.pushSubscription.token);
    print(state.current.jsonRepresentation());
  });

  OneSignal.Notifications.addPermissionObserver((state) {
    print("Has permission " + state.toString());
  });

  OneSignal.Notifications.addClickListener((event) {
    print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
  });

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print(
        'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

    /// Display Notification, preventDefault to not display
    event.preventDefault();

    /// Do async work

    /// notification.display() to display after preventing default
    event.notification.display();
    print('Notification received in foreground notification:');

  });

  OneSignal.InAppMessages.addClickListener((event) {

    print('In App Message Clicked');

    /*setState(() {
      _debugLabelString =
      "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}";
    });*/
  });
  OneSignal.InAppMessages.addWillDisplayListener((event) {
    print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
  });
  OneSignal.InAppMessages.addDidDisplayListener((event) {
    print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
  });
  OneSignal.InAppMessages.addWillDismissListener((event) {
    print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
  });
  OneSignal.InAppMessages.addDidDismissListener((event) {
    print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
  });

  /*setState(() {
    _enableConsentButton = _requireConsent;
  });*/

  // Some examples of how to use In App Messaging public methods with OneSignal SDK
  oneSignalInAppMessagingTriggerExamples();

  // Some examples of how to use Outcome Events public methods with OneSignal SDK
  oneSignalOutcomeExamples();

  OneSignal.InAppMessages.paused(true);
}