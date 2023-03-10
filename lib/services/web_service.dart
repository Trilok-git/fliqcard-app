import 'dart:convert';
import 'dart:io';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class WebService {
  Future registerAccount(
      String fullname,
      String phone,
      String country,
      String email,
      String password,
      String refcode,
      String title,
      String company,
      String isVerified) async {
    try {
      Map data = {
        "fullname": fullname,
        "phone": phone,
        "country": country,
        "email": email,
        "password": password,
        "refcode": refcode,
        "title": title,
        "company": company,
        "isVerified": isVerified
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(registerSEPT09),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future loginAccount(String email, String password) async {
    try {
      Map data = {"email": email, "password": password};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(login),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);


      if (response.statusCode == 200) {
        print(response.body);
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future loginWithGoogleAccount(String email) async {
    try {
      Map data = {"email": email};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(loginWithGoogle),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getAppVersion() async {
    try {
      final response = await http.get(
        Uri.parse(appversion),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getData(String id, [year]) async {
    try {
      Map data = {"id": id, "year": year?? "2023", "source": Platform.isAndroid ? "android" : "ios"};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(getdata),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.body);
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateContact(String type, String id, String tags, String notes,
      String category, String phone) async {
    try {
      Map data = {
        "type": type,
        "id": id,
        "tags": tags,
        "notes": notes,
        "category": category,
        "phone": phone
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateContact),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future deleteContact(String id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(deletecontact),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future updateStaff(String id, String parent_id, String fullname,
      String department, String position, String phone, String email, String password) async {
    try {
      Map data = {
        "id": id,
        "fullname": fullname,
        "parent_id": parent_id,
        "department": department,
        "position": position,
        "phone": phone,
        "email": email,
        "password": password
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updatestaff),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future ChangePassword(String id, String password) async {
    try {
      Map data = {"id": id, "password": password};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(changepassword),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeletStaff(String id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(deletestaff),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future updateVcard(
      String operation,
      String slug,
      String user_id,
      String title,
      String subtitle,
      String description,
      String email,
      String company,
      String wt_phone,
      String website,
      String address,
      String address_link,
      String twitter_link,
      String facebook_link,
      String linkedin_link,
      String ytb_link,
      String pin_link,
      String snapchat_link,
      String telegram_link,
      String skype_link,
      String wechat_link,
      String tiktok_link,
      String pinterest_link,
      String phone,
      String phone2,
      String telephone,
      String materialFilePath,
      String bgcolor,
      String cardcolor,
      String fontcolor,
      File bannerImage,
      File logoImage,
      File profileImage) async {
    try {
      var uri = Uri.parse(addeditcard);
      var request = new http.MultipartRequest("POST", uri);

      if (bannerImage != null) {
        var _bannerFront =
            new http.ByteStream(Stream.castFrom(bannerImage.openRead()));
        var _bannerLength = await bannerImage.length();

        var multipartBannerFront = new http.MultipartFile(
            "bannerImage", _bannerFront, _bannerLength,
            filename: basename(bannerImage.path));
        request.files.add(multipartBannerFront);
      }

      if (logoImage != null) {
        var _logoFront =
            new http.ByteStream(Stream.castFrom(logoImage.openRead()));
        var _logoLength = await logoImage.length();

        var multipartLogoFront = new http.MultipartFile(
            "logoImage", _logoFront, _logoLength,
            filename: basename(logoImage.path));
        request.files.add(multipartLogoFront);
      }

      if (profileImage != null) {
        var _profileFront =
            new http.ByteStream(Stream.castFrom(profileImage.openRead()));
        var _profileLength = await profileImage.length();

        var multipartProfileFront = new http.MultipartFile(
            "profileImage", _profileFront, _profileLength,
            filename: basename(profileImage.path));
        request.files.add(multipartProfileFront);
      }

      request.fields['operation'] = operation;
      request.fields['user_id'] = user_id;
      request.fields['slug'] = slug;
      request.fields['title'] = title;
      request.fields['subtitle'] = subtitle;
      request.fields['description'] = description;
      request.fields['email'] = email;
      request.fields['company'] = company;
      request.fields['wt_phone'] = wt_phone;
      request.fields['website'] = website;
      request.fields['address'] = address;
      request.fields['address_link'] = address_link;
      request.fields['twitter_link'] = twitter_link;
      request.fields['facebook_link'] = facebook_link;
      request.fields['linkedin_link'] = linkedin_link;
      request.fields['ytb_link'] = ytb_link;
      request.fields['pin_link'] = pin_link;

      request.fields['snapchat_link'] = snapchat_link;
      request.fields['telegram_link'] = telegram_link;

      request.fields['skype_link'] = skype_link;
      request.fields['wechat_link'] = wechat_link;
      request.fields['tiktok_link'] = tiktok_link;
      request.fields['pinterest_link'] = pinterest_link;

      request.fields['phone'] = phone;
      request.fields['phone2'] = phone2;
      request.fields['telephone'] = telephone;
      request.fields['materialFilePath'] = materialFilePath;
      request.fields['bgcolor'] = bgcolor;
      request.fields['cardcolor'] = cardcolor;
      request.fields['fontcolor'] = fontcolor;

      print("**************");
      print(request.fields);
      var response = await request.send();

      print(response.stream.bytesToString());
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future themeToogle(String user_id, String theme_number) async {
    try {
      Map data = {"user_id": user_id, "theme_number": theme_number};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(theme_toggle),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateLocation(String id, String lat, String lng) async {
    try {
      Map data = {"id": id, "lat": lat, "lng": lng};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateLocation),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateAttendance(id, email, fullname, lat, lng, comment) async {
    try {
      Map data = {
        "id": id,
        "email": email,
        "fullname": fullname,
        "lat": lat,
        "lng": lng,
        "comment": comment
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateattendance),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetSharedCards(String id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(getsharedcards),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetDistinctSharedCards(String id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(getdistinctcards),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateStatus(int status, String user_id, String id) async {
    try {
      Map data = {"status": status.toString(), "user_id": user_id, "id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(acceptcard),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future SendCard(String id, String name, String email, lat, lng) async {
    try {
      Map data = {
        "id": id,
        "name": name,
        "email": email,
        "lat": lat,
        "lng": lng
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(sendcard),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future ForgotPassword(String email) async {
    try {
      Map data = {"email": email};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(forgot),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future ActivatePlan(
      String id, String trans_id, String plan, String plan_id, method) async {
    try {
      Map data = {
        "id": id,
        "trans_id": trans_id,
        "plan": plan,
        "plan_id": plan_id,
        "method": method
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(activateplan),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future deleteBanner(String user_id) async {
    try {
      Map data = {"user_id": user_id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(deletebanner),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future deleteLogo(String user_id) async {
    try {
      Map data = {"user_id": user_id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(deletelogo),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future deleteProfile(String user_id) async {
    try {
      Map data = {"user_id": user_id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(deleteprofile),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future SetBanner(String user_id, String serno) async {
    try {
      Map data = {"user_id": user_id, "serno": serno};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(setBanner),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getFollowup(String id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getfollowup),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getComments(String email) async {
    try {
      Map data = {"email": email};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getcomments),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future CancelFollowup(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(cancelFollowup),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future CompleteFollowup(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(completeFollowup),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future RescheduleFollowup(
      id, user_id, created_at, person_email, comment) async {
    try {
      Map data = {
        "id": id,
        "user_id": user_id,
        "created_at": created_at,
        "email": person_email,
        "comment": comment
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(rescheduleFollowup),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future AddFollowup(user_id, name, email, phone, created_at, about) async {
    try {
      Map data = {
        "user_id": user_id,
        "name": name,
        "email": email,
        "phone": phone,
        "created_at": created_at,
        "about": about
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(addFollowup),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getEvents(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getevents),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeleteEvent(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(deleteEvent),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateFcmToken(id, fcmtoken) async {
    try {
      Map data = {"id": id, "fcmtoken": fcmtoken};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateFcmToken),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getInvites(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(events_invites),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future centralizedToggle(String user_id, String centralized_on) async {
    try {
      Map data = {"user_id": user_id, "centralized_on": centralized_on};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(centralized_toggle),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateBgcolor(id, bgcolor) async {
    try {
      Map data = {"id": id, "bgcolor": bgcolor};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateBgcolor),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateCardcolor(id, cardcolor) async {
    try {
      Map data = {"id": id, "cardcolor": cardcolor};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateCardcolor),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateFontcolor(id, fontcolor) async {
    try {
      Map data = {"id": id, "fontcolor": fontcolor};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateFontcolor),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UploadBanner(id, File file) async {
    try {
      var uri = Uri.parse(uploadBanner);
      var request = new http.MultipartRequest("POST", uri);

      if (file != null) {
        var _bannerFront =
            new http.ByteStream(Stream.castFrom(file.openRead()));
        var _bannerLength = await file.length();

        var multipartBannerFront = new http.MultipartFile(
            "file", _bannerFront, _bannerLength,
            filename: basename(file.path));
        request.files.add(multipartBannerFront);
      }

      request.fields['id'] = id;

      print(request.fields);
      var response = await request.send();
      print(response.stream.first);
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UploadLogo(id, File file) async {
    try {
      var uri = Uri.parse(uploadLogo);
      var request = new http.MultipartRequest("POST", uri);

      if (file != null) {
        var _bannerFront =
            new http.ByteStream(Stream.castFrom(file.openRead()));
        var _bannerLength = await file.length();

        var multipartBannerFront = new http.MultipartFile(
            "file", _bannerFront, _bannerLength,
            filename: basename(file.path));
        request.files.add(multipartBannerFront);
      }

      request.fields['id'] = id;

      print(request.fields);
      var response = await request.send();
      print(response.stream.first);
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UploadProfile(id, File file) async {
    try {
      var uri = Uri.parse(uploadProfile);
      var request = new http.MultipartRequest("POST", uri);

      if (file != null) {
        var _bannerFront =
            new http.ByteStream(Stream.castFrom(file.openRead()));
        var _bannerLength = await file.length();

        var multipartBannerFront = new http.MultipartFile(
            "file", _bannerFront, _bannerLength,
            filename: basename(file.path));
        request.files.add(multipartBannerFront);
      }

      request.fields['id'] = id;

      print(request.fields);
      var response = await request.send();
      print(response.stream.first);
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future allServices(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(allservices),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future allProducts(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(allproducts),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future allPaymentOptions(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(allpaymentoptions),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeletService(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(deleteService),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeleteProduct(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(deleteProducts),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeletePaymentOptions(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(deletePaymentOption),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future AddEditService(String operation, id, String user_id, String title,
      String description, File bannerImage, File logoImage) async {
    try {
      var uri = Uri.parse(addEditService);
      var request = new http.MultipartRequest("POST", uri);

      if (bannerImage != null) {
        var _bannerFront =
            new http.ByteStream(Stream.castFrom(bannerImage.openRead()));
        var _bannerLength = await bannerImage.length();

        var multipartBannerFront = new http.MultipartFile(
            "imagePath", _bannerFront, _bannerLength,
            filename: basename(bannerImage.path));
        request.files.add(multipartBannerFront);
      }

      if (logoImage != null) {
        var _logoFront =
            new http.ByteStream(Stream.castFrom(logoImage.openRead()));
        var _logoLength = await logoImage.length();

        var multipartLogoFront = new http.MultipartFile(
            "videoPath", _logoFront, _logoLength,
            filename: basename(logoImage.path));
        request.files.add(multipartLogoFront);
      }
      if (id != null) {
        request.fields['id'] = id.toString();
      }

      request.fields['operation'] = operation;
      request.fields['user_id'] = user_id;
      request.fields['title'] = title;
      request.fields['description'] = description;

      print(request.fields);
      var response = await request.send();
      print(response.stream.first);
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future AddEditProduct(
      String operation,
      id,
      String user_id,
      String title,
      String price,
      String description,
      File bannerImage,
      File logoImage) async {
    try {
      var uri = Uri.parse(addEditProduct);
      var request = new http.MultipartRequest("POST", uri);

      if (bannerImage != null) {
        var _bannerFront =
            new http.ByteStream(Stream.castFrom(bannerImage.openRead()));
        var _bannerLength = await bannerImage.length();

        var multipartBannerFront = new http.MultipartFile(
            "imagePath", _bannerFront, _bannerLength,
            filename: basename(bannerImage.path));
        request.files.add(multipartBannerFront);
      }

      if (logoImage != null) {
        var _logoFront =
            new http.ByteStream(Stream.castFrom(logoImage.openRead()));
        var _logoLength = await logoImage.length();

        var multipartLogoFront = new http.MultipartFile(
            "videoPath", _logoFront, _logoLength,
            filename: basename(logoImage.path));
        request.files.add(multipartLogoFront);
      }
      if (id != null) {
        request.fields['id'] = id.toString();
      }

      request.fields['operation'] = operation;
      request.fields['user_id'] = user_id;
      request.fields['price'] = price;
      request.fields['title'] = title;
      request.fields['description'] = description;

      print(request.fields);
      var response = await request.send();
      print(response.stream.first);
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future AddEditPaymentOptions(String operation, id, String user_id,
      String title, String link, String description, File bannerImage) async {
    try {
      var uri = Uri.parse(addEditPaymentOption);
      var request = new http.MultipartRequest("POST", uri);

      if (bannerImage != null) {
        var _bannerFront =
            new http.ByteStream(Stream.castFrom(bannerImage.openRead()));
        var _bannerLength = await bannerImage.length();

        var multipartBannerFront = new http.MultipartFile(
            "imagePath", _bannerFront, _bannerLength,
            filename: basename(bannerImage.path));
        request.files.add(multipartBannerFront);
      }

      if (id != null) {
        request.fields['id'] = id.toString();
      }

      request.fields['operation'] = operation;
      request.fields['user_id'] = user_id;
      request.fields['link'] = link;
      request.fields['title'] = title;
      request.fields['description'] = description;

      print(request.fields);
      var response = await request.send();
      print(response.stream.first);
      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeleteServiceImage(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(deleteServiceImage),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeleteProductImage(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(deleteProductImage),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeletePaymentOptionImage(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(deletePaymentOptionImage),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeleteServiceVideo(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(deleteServiceVideo),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future DeleteProductVideo(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(deleteProductVideo),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future allInterested(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(allinterested),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future allOrders(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(allorders),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future CompleteInterest(id) async {
    try {
      Map data = {"id": id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(completeInterest),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future UpdateCurrency(id, currency) async {
    try {
      Map data = {"id": id, "currency": currency};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateCurrency),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future AddPaperScanToReceive(
      name, email, phone, company, nameFQ, emailFQ, phoneFQ, companyFQ) async {
    try {
      Map data = {
        "name": name,
        "email": email,
        "phone": phone,
        "company": company,
        "nameFQ": nameFQ,
        "emailFQ": emailFQ,
        "phoneFQ": phoneFQ,
        "companyFQ": companyFQ
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(addPaperScanToReceive),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future AddContactFromDevice(
      name, email, phone, company, nameFQ, emailFQ, phoneFQ, companyFQ) async {
    try {
      Map data = {
        "name": name,
        "email": email,
        "phone": phone,
        "company": company,
        "nameFQ": nameFQ,
        "emailFQ": emailFQ,
        "phoneFQ": phoneFQ,
        "companyFQ": companyFQ
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(addContactFromDevice),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future Findnearbyusers(id, lat, long) async {
    try {
      Map data = {"id": id, "lat": lat, "lng": long};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(findnearbyusers),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future SendOneByOne(
      String user_id, String id, String name, String email) async {
    try {
      Map data = {"user_id": user_id, "id": id, "name": name, "email": email};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(sendonebyone),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getAllappointment(id) async {
    try {
      Map data = {"user_id": id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getallappointment),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getSlotsByDate(appointmentID) async {
    try {
      Map data = {"appointmentID": appointmentID};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(slots_by_date),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future toggleAppointmentday(operation, slotID) async {
    try {
      Map data = {"operation": operation, "slotID": slotID};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(toggleAppointmentDay),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future updateDayHoursInUTC(slot_start_time, slot_end_time, slotID) async {
    try {
      Map data = {
        "slot_start_time": slot_start_time,
        "slot_end_time": slot_end_time,
        "slotID": slotID
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateDayHoursinUTC),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future cancelAppointMent(appointmentID, user_id) async {
    try {
      Map data = {"appointmentID": appointmentID, "user_id": user_id};

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(cancelAppointment),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future addAppointMent(
      confirm_appointment_date,
      confirm_appointment_enddate,
      title,
      appointmentType,
      meeting_link,
      meeting_place,
      map_link,
      description,
      confirm_slot_start_time,
      confirm_slot_end_time,
      appointment_duration,
      host_offset,
      user_id,
      my_email) async {
    try {
      Map data = {
        "confirm_appointment_date": confirm_appointment_date,
        "confirm_appointment_enddate": confirm_appointment_enddate,
        "title": title,
        "appointmentType": appointmentType,
        "meeting_link": meeting_link,
        "meeting_place": meeting_place,
        "map_link": map_link,
        "description": description,
        "confirm_slot_start_time": confirm_slot_start_time,
        "confirm_slot_end_time": confirm_slot_end_time,
        "appointment_duration": appointment_duration,
        "host_offset": host_offset,
        "user_id": user_id,
        "my_email": my_email,
        "operation": "insert"
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(addAppointment),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future updateAppointMent(
      appointmentID,
      confirm_appointment_date,
      confirm_appointment_enddate,
      title,
      appointmentType,
      meeting_link,
      meeting_place,
      map_link,
      description,
      appointment_duration,
      host_offset,
      user_id,
      my_email) async {
    try {
      Map data = {
        "appointmentID": appointmentID,
        "confirm_appointment_date": confirm_appointment_date,
        "confirm_appointment_enddate": confirm_appointment_enddate,
        "title": title,
        "appointmentType": appointmentType,
        "meeting_link": meeting_link,
        "meeting_place": meeting_place,
        "map_link": map_link,
        "description": description,
        "appointment_duration": appointment_duration,
        "host_offset": host_offset,
        "user_id": user_id,
        "my_email": my_email,
        "operation": "save"
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(addAppointment),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  updatePosition(String id, String position, int insert, int delete) async {
    try {
      Map data = {};
      if(delete == 1) {
        data = {
          "parent_id": id,
          "id": position,
          "insert": insert,
          "delete": delete,
        };
      }else {
        data = {
          "parent_id": id,
          "position": position,
          "insert": insert,
          "delete": delete,
        };
      }

      var body = json.encode(data);
      print("aaaaaaaaaaaaaaaaaaaaa");
      print(body);

      final response = await http.post(Uri.parse(updateposition),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  getPosition(String id, int insert, int delete, int get) async {
    try {
      Map data = {
        "parent_id": id,
        "insert": insert,
        "delete": delete,
        "get": get
      };

      var body = json.encode(data);
      print(body);

      final response = await http.post(Uri.parse(updateposition),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

}
