import 'user.dart';

class Videos {
  List<User> toUserList = List<User>(),
      ccUserList = List<User>(),
      bccUserList = List<User>();

  List<dynamic> data;

  List<dynamic> singleVideoId;

  User fromUser;
  String id,
      addedAt,
      description,
      thumbnail,
      title,
      channel,
      details,
      profileImage,
      logo,
      durationParsed,
      coverPicture,
      type,
      privacy,
      owner,
      userId,
      videos,
      channelId,
      name;
  int duration,
      repliesCount,
      views,
      likes,
      dateOfAddon,
      videoCount,
      videosCount,
      subscribers,
      x,
      updatedAt;
  bool subscribedChannel, hasLiked, hasUnliked;

  Videos(
      {this.toUserList,
      this.ccUserList,
      this.bccUserList,
      this.updatedAt,
      this.fromUser,
      this.id,
      this.userId,
      this.channelId,
      this.title,
      this.description,
      this.likes,
      this.dateOfAddon,
      this.thumbnail,
      this.hasUnliked,
      this.channel,
      this.videoCount,
      this.profileImage,
      this.durationParsed,
      this.videosCount,
      this.logo,
      this.subscribers,
      this.data,
      this.repliesCount,
      this.addedAt,
      this.subscribedChannel,
      this.details,
      this.views,
      this.owner,
      this.hasLiked,
      this.duration,
      this.name});

  Map<String, String> toJSON() {
    return {
      "title": this.title,
      "description": this.description,
      "thumbnail": this.thumbnail,
    };
  }

  Videos.fromJSON(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    thumbnail = map['thumbnail'];
    views = map['views'];
    name = map['channel']['name'];
    addedAt = map['addedAt'];
    x = map['duration'];

    String _printDuration(Duration duration) {
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    final now = Duration(seconds: x);
    durationParsed = (_printDuration(now));
  }

  Videos.fromJSONplayListVideos(Map<String, dynamic> map) {
    id = map['id'];
    videosCount = map['videosCount'];
    videoCount = map['videoCount'];
    name = map['name'];
    data = map['videos'];
    // singleVideoId = map[''];
  }

  Videos.fromCommentList(Map<String, dynamic> map) {
    // hasLiked = map[hasLiked];
    // print("~~~~~~~~~~~~~~~~${hasLiked}");
    // hasUnliked = map['hasUnliked'];
    // print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$hasUnliked");
    id = map['id'];
    name = map['addedBy']['name'];
    profileImage = map['addedBy']['profileImage'];
    details = map['details'];
    repliesCount = map['repliesCount'];
    likes = map['likes'];
    dateOfAddon = map['addedAt'];
    userId = map['addedBy']['userId'];
  }

  Videos.fromNastedCommentList(Map<String, dynamic> map) {
    id = map['id'];
    name = map['addedBy']['name'];
    profileImage = map['addedBy']['profileImage'];
    details = map['details'];
    repliesCount = map['repliesCount'];
    likes = map['likes'];
    dateOfAddon = map['addedAt'];
    userId = map['addedBy']['userId'];
  }

  Videos.fromChannelList(Map<String, dynamic> map) {
    name = map['name'];
    subscribers = map['subscribers'];
    logo = map['logo'];
    id = map['id'];
  }

  Videos.fromChannelVideoList(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    thumbnail = map['thumbnail'];
    addedAt = map['addedAt'];
    owner = map['owner'];
    views = map['views'];
    name = map['channel']['name'];
    x = map['duration'];
    String _printDuration(Duration duration) {
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    final now = Duration(seconds: x);
    durationParsed = (_printDuration(now));
  }

  Videos.playListChannel(Map<String, dynamic> map) {
    id = map['id'];
    coverPicture = map['coverPicture'];
    name = map['name'];
  }

  Videos.fromSubscriptionList(Map<String, dynamic> map) {
    updatedAt = map['updatedAt'];
    id = map['id'];
    // description = map['description'];
    logo = map['logo'];
    // owner = map['owner'];
    subscribers = map['subscribers'];
    // print(subscribers);
    name = map['name'];
    subscribedChannel = map['subscribedChannel'];
    // x = map['duration'];

    // String _printDuration(Duration duration) {
    //   String twoDigits(int n) {
    //     if (n >= 10) return "$n";
    //     return "0$n";
    //   }

    //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    //   return "$twoDigitMinutes:$twoDigitSeconds";
    // }

    // final now = Duration(seconds: x);
    // durationParsed = (_printDuration(now));
  }

  Videos.fromJSONVideos(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    thumbnail = map['thumbnail'];
    addedAt = map['addedAt'];
    name = map['channel']['name'];
    views = map['views'];
    channelId = map['channel']['id'];

    // print(
    //     "------------------------------print channel Id ${map['channel']['id']}");

    x = map['duration'];

    String _printDuration(Duration duration) {
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    final now = Duration(seconds: x);
    durationParsed = (_printDuration(now));
  }

  Videos.myVideosJSON(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    thumbnail = map['thumbnail'];
    addedAt = map['addedAt'];
  }

  Videos.fromJSONStarred(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    thumbnail = map['thumbnail'];
    addedAt = map['addedAt'];
  }

  Videos.fromJSONSentBox(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    thumbnail = map['thumbnail'];
    addedAt = map['addedAt'];
  }

  Videos.fromJSONDraftList(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    thumbnail = map['thumbnail'];
  }
}

class AddedBy {
  String name, profileImage;
  AddedBy({
    this.name,
    this.profileImage,
  });

  AddedBy.fromJSON(Map<String, dynamic> map) {
    name = map['name'];
    profileImage = map['profileImage'];
  }

  Map<String, String> toJson() {
    return {
      'name': name,
      'profileImage': profileImage,
    };
  }
}
