
import 'package:video/models/videos.dart';

class MailSubjectShortTextListDetails {
  List<Videos> videoList;

  MailSubjectShortTextListDetails({this.videoList});

//  void initializeContacts(List<Email> sentConversationsList) {
//    mailsList=sentConversationsList;
//    //print('~~~ initializeContacts: ${mailsList.length}');
//  }
  Future<List<Videos>> getSuggestions(
      String mailSubjectShortTextLetter) async {
    List<Videos> matchedMailsList = List<Videos>();

    for (Videos videos in videoList) {
      print(
         '~~~ 1st getSuggestions: $mailSubjectShortTextLetter ${videos.title} ${videos.description}');

      if ((videos.title
              .toLowerCase()
              .contains(mailSubjectShortTextLetter.toLowerCase())) ||
          (videos.description
              .toLowerCase()
              .contains(mailSubjectShortTextLetter.toLowerCase()))) {
        //print('~~~ matched ${email.fromUser.name} ');
        matchedMailsList.add(videos);
      }
    }
    return matchedMailsList;
  }
}
