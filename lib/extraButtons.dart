import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class MoreInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

// class ContactUs extends StatelessWidget {//use email thing
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//     );
//   }
// }

// class ReportIssue extends StatelessWidget {//same as contact us
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//     );
//   }
// }

//Mailer:
class SendEmail extends StatefulWidget {
  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.teal, Colors.indigo],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Write your comment in the line below:",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: myController,
                ),
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 60.0, right: 60.0, top: 30.0),
                      child: new OutlineButton(
                        padding: const EdgeInsets.all(18.0),
                        splashColor: Colors.white,
                        onPressed: () {
                        // code for something else
                        sendMail(myController.text);
                        },
                        // onPressed: () => {sendMail(myController.text)},
                        borderSide: BorderSide(width: 1.5, color: Colors.white),
                        child: new Text("Send Mail!",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 60.0, right: 60.0, top: 30.0),
                      child: new OutlineButton(
                        padding: const EdgeInsets.all(18.0),
                        splashColor: Colors.white,
                        onPressed: ()=>{
                          Navigator.pop(context)
                        },
                        borderSide: BorderSide(width: 1.5, color: Colors.white),
                        child: new Text("Go Back",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMail(String text) async {
    print(text);
    final MailOptions mailOptions = MailOptions(
      body: text,
      subject: 'Report from SCNNR user',
      recipients: ['anjum.k1999@gmail.com'],
      isHTML: true,
      // bccRecipients: ['other@example.com'],
      // ccRecipients: ['third@example.com'],
      // attachments: [ 'path/to/image.png', ],
    );
    await FlutterMailer.send(mailOptions);
  }
}
