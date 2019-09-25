import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer2/mailer.dart';

class Email {

  Email._();

  static Future<dynamic> sendEmail(
      String bodyEmail, String sender, String recipient, String subject,
      {List<Attachment> attachment}) async {
    DocumentSnapshot emailConfig = await getEmailSettings();

    var options = new GmailSmtpOptions()
      ..username = emailConfig.data["username"]
      ..password = emailConfig.data["password"];

    var emailTransport = new SmtpTransport(options);

    var envelope = new Envelope()
      ..recipients.add(recipient)
      ..sender = sender
      ..subject = subject
      ..html = bodyEmail;

    if (attachment != null) {
      envelope.attachments = attachment;
    }

    return emailTransport.send(envelope);
  }

  static Future<DocumentSnapshot> getEmailSettings() async {
    return await Firestore.instance
        .collection("config")
        .document("generalConfig")
        .get();
  }
}
