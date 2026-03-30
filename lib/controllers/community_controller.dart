import 'package:car_care/all_export.dart';
import 'package:car_care/models/profile_model.dart';
import 'package:car_care/models/comment_model.dart';
import 'package:car_care/models/garage_offer_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_care/controllers/profile_controller.dart';

import '../models/community_model.dart';
import '../service/api_constants.dart';
import '../service/dio_api_client.dart';

class CommunityController extends GetxController {
  CommunityController();

  final ApiClient _apiClient = Get.put(ApiClient());
  final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();
  final ProfileController _profileCtrl =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  static const String _savedPostsPrefKey = 'community_saved_posts_v1';

  TextEditingController titleTextCtrl = TextEditingController();
  TextEditingController descriptionTextCtrl = TextEditingController();
  TextEditingController locationTextCtrl = TextEditingController();
  TextEditingController hasTagTextCtrl = TextEditingController();
  TextEditingController issueTextCtrl = TextEditingController();
  TextEditingController budgetTextCtrl = TextEditingController();
  TextEditingController carTypeTextCtrl = TextEditingController();
  TextEditingController commentTextCtrl = TextEditingController();

  var selectedPostType = ''.obs;
  var selectedUrgencyType = ''.obs;
  var selectedFeedFilter = 'All'.obs;
  var searchQuery = ''.obs;

  var offerAddLoading = false.obs;
  var communityLoading = false.obs;
  var myPostLoading = false.obs;
  var isLoading = false.obs;
  var garageOfferLoading = false.obs;
  var commentLoading = false.obs;
  var addCommentLoading = false.obs;

  RxList<CommunityModel> communityList = <CommunityModel>[].obs;
  RxList<CommunityModel> myPostList = <CommunityModel>[].obs;
  RxList<GarageOfferModel> garageOfferList = <GarageOfferModel>[].obs;
  RxList<CommentModel> commentList = <CommentModel>[].obs;

  final RxSet<String> savedPostIds = <String>{}.obs;

  DateTime? selectedDateObject;

  final List<String> feedFilters = const [
    'All',
    'Jobs',
    'Nearby',
    'Trending',
    'Saved',
    'Garages',
    'Mechanics',
    'Verified',
  ];

  @override
  void onInit() {
    _loadSavedPosts();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCommunity();
    });
    super.onInit();
  }

  List<CommunityModel> get filteredCommunityList {
    final String filter = selectedFeedFilter.value;
    final String query = searchQuery.value.trim().toLowerCase();

    List<CommunityModel> list = List<CommunityModel>.from(communityList);

    if (query.isNotEmpty) {
      list =
          list.where((post) {
            final String desc = (post.postDescription ?? '').toLowerCase();
            final String tag = (post.hasTag ?? '').toLowerCase();
            final String user = (post.user?.fullName ?? '').toLowerCase();
            final String carType =
                (post.carType?.toString() ?? '').toLowerCase();
            return desc.contains(query) ||
                tag.contains(query) ||
                user.contains(query) ||
                carType.contains(query);
          }).toList();
    }

    switch (filter) {
      case 'Jobs':
        list = list.where((post) => post.postType == 'helpost').toList();
        break;
      case 'Nearby':
        list.sort(
          (a, b) => (a.distanceInKm ?? a.distance ?? 9999).compareTo(
            b.distanceInKm ?? b.distance ?? 9999,
          ),
        );
        break;
      case 'Trending':
        list.sort((a, b) => _trendingScore(b).compareTo(_trendingScore(a)));
        break;
      case 'Saved':
        list = list.where((post) => savedPostIds.contains(post.id)).toList();
        break;
      case 'Garages':
        list =
            list
                .where(
                  (post) =>
                      (post.user?.role.toLowerCase().contains('garage') ??
                          false),
                )
                .toList();
        break;
      case 'Mechanics':
        list =
            list
                .where(
                  (post) =>
                      (post.user?.role.toLowerCase().contains('mechanic') ??
                          false) ||
                      (post.user?.role.toLowerCase().contains('macanic') ??
                          false),
                )
                .toList();
        break;
      case 'Verified':
        list = list.where((post) => post.user?.isVerified == true).toList();
        break;
      default:
        list.sort(
          (a, b) => (b.createdAt ?? DateTime(1970)).compareTo(
            a.createdAt ?? DateTime(1970),
          ),
        );
    }

    return list;
  }

  int _trendingScore(CommunityModel post) {
    final int likes = post.likeCount;
    final int comments = post.commentCount;
    final int freshnessHours =
        DateTime.now().difference(post.createdAt ?? DateTime.now()).inHours;
    final int freshnessBoost = freshnessHours <= 0 ? 48 : (48 - freshnessHours);
    return (likes * 2) + (comments * 3) + freshnessBoost.clamp(0, 48);
  }

  void setFeedFilter(String filter) {
    selectedFeedFilter.value = filter;
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  Future<void> _loadSavedPosts() async {
    final List<String> ids =
        _sharedPreferences.getStringList(_savedPostsPrefKey) ?? <String>[];
    savedPostIds.addAll(ids);
  }

  Future<void> _persistSavedPosts() async {
    await _sharedPreferences.setStringList(
      _savedPostsPrefKey,
      savedPostIds.toList(),
    );
  }

  void _applyLocalFlags(List<CommunityModel> list) {
    for (final post in list) {
      post.isSaved = savedPostIds.contains(post.id);
    }
  }

  void _updatePostInBothLists(
    String id,
    void Function(CommunityModel post) updater,
  ) {
    bool updated = false;

    for (final post in communityList) {
      if (post.id == id) {
        updater(post);
        updated = true;
      }
    }

    for (final post in myPostList) {
      if (post.id == id) {
        updater(post);
        updated = true;
      }
    }

    if (updated) {
      communityList.refresh();
      myPostList.refresh();
    }
  }

  Future<void> createCommunity(String imageUrl) async {
    offerAddLoading.value = true;

    try {
      final String title = titleTextCtrl.text.trim();
      final String description = descriptionTextCtrl.text.trim();
      final String taggedLocation = locationTextCtrl.text.trim();

      final Map<String, dynamic> body = {
        'postType': selectedPostType.value,
        'postTitle': title,
        'postDescription': description,
        'postImage': imageUrl,
        'hasTag': hasTagTextCtrl.text,
        'locationTag': taggedLocation,
        'location': taggedLocation,
      };

      if (selectedPostType.value == 'helpost') {
        body.addAll({
          'carType': carTypeTextCtrl.text,
          'issueType': issueTextCtrl.text,
          'budget': budgetTextCtrl.text,
          'urgencyType': selectedUrgencyType.value,
        });
      }

      final response = await _apiClient.postData(
        ApiConstants.communityCreateEndPoint,
        data: body,
      );

      if (response.isSuccess) {
        final currentUser = _profileCtrl.effectiveProfile;
        final createdPost = CommunityModel(
          id:
              response.data['data']?['attributes']?['result']?['_id'] ??
              'local_${DateTime.now().millisecondsSinceEpoch}',
          user: currentUser,
          postType: selectedPostType.value,
          postDescription: _composeLocalPostDescription(
            title: title,
            description: description,
            taggedLocation: taggedLocation,
          ),
          postImage: imageUrl,
          hasTag: hasTagTextCtrl.text,
          issueType: issueTextCtrl.text,
          carType: carTypeTextCtrl.text,
          budget: budgetTextCtrl.text,
          urgencyType: selectedUrgencyType.value,
          createdAt: DateTime.now(),
          likeCount: 0,
          commentCount: 0,
        );
        communityList.insert(0, createdPost);
        communityList.refresh();

        titleTextCtrl.clear();
        descriptionTextCtrl.clear();
        locationTextCtrl.clear();
        hasTagTextCtrl.clear();
        carTypeTextCtrl.clear();
        issueTextCtrl.clear();
        budgetTextCtrl.clear();
        selectedPostType.value = '';
        selectedUrgencyType.value = '';

        Get.back();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add offer: $e');
      debugPrint('Add Offer Error: $e');
    } finally {
      offerAddLoading.value = false;
    }
  }

  String _composeLocalPostDescription({
    required String title,
    required String description,
    required String taggedLocation,
  }) {
    final StringBuffer buffer = StringBuffer();
    if (title.isNotEmpty) {
      buffer.writeln(title);
      if (description.isNotEmpty) {
        buffer.writeln();
      }
    }
    if (description.isNotEmpty) {
      buffer.write(description);
    }
    if (taggedLocation.isNotEmpty) {
      if (buffer.isNotEmpty) {
        buffer.writeln();
        buffer.writeln();
      }
      buffer.write('Location: $taggedLocation');
    }
    return buffer.toString().trim();
  }

  Future<void> getCommunity() async {
    communityLoading(true);
    try {
      final response = await _apiClient.getData(
        ApiConstants.communityCreateEndPoint,
      );
      if (response.isSuccess) {
        final List<CommunityModel> posts = List<CommunityModel>.from(
          response.data['data']['attributes']['results'].map(
            (x) => CommunityModel.fromJson(x),
          ),
        );
        _applyLocalFlags(posts);
        communityList.value = posts;
      } else {
        // INJECT DUMMY DATA FOR TESTING SINCE TOKEN IS FAKE
        final currentUser = _profileCtrl.effectiveProfile;
        communityList.value = [
          CommunityModel(
            id: 'dummy1',
            user: currentUser,
            postType: 'onlypost',
            postDescription:
                'Just washed my car! Looking shiny and new for the weekend road trip catching some good weather.',
            postImage:
                'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?q=80&w=600&auto=format&fit=crop',
            createdAt: DateTime.now().subtract(Duration(hours: 2)),
            likeCount: 42,
            commentCount: 12,
          ),
          CommunityModel(
            id: 'dummy2',
            user: ProfileModel(
              myLocation: MyLocation(type: 'Point', coordinates: [0, 0]),
              fullName: 'Torqon Garage',
              userName: 'garage1',
              email: 'garage@test.com',
              authProvider: '',
              googleId: '',
              image: 'https://i.pravatar.cc/150?u=garage',
              role: 'garage',
              callingCode: '',
              phoneNumber: '',
              myWallet: 0,
              mySaving: 0,
              dateOfBirth: DateTime.now(),
              address: 'Manchester',
              oneTimeCodeExpiry: DateTime.now(),
              isGarageAproved: true,
              isMacanicAproved: false,
              isVerified: true,
              isProfileCompleted: true,
              createdAt: DateTime.now(),
              stripeCustomerId: '',
              id: 'u2',
            ),
            postType: 'helpost',
            postDescription:
                'Anyone experiencing weird rattling noises from their exhaust on the 2019 models?',
            carType: 'BMW M3 2019',
            budget: 150.0,
            issueType: 'Exhaust rattle',
            urgencyType: 'medium',
            isSolved: false,
            createdAt: DateTime.now().subtract(Duration(minutes: 45)),
            likeCount: 5,
            commentCount: 3,
          ),
        ];
      }
    } catch (e) {
      debugPrint('Get Community Error: $e');
      // Fallback dummy data
      communityList.value = [
        CommunityModel(
          id: 'dummy3',
          user: ProfileModel(
            myLocation: MyLocation(type: 'Point', coordinates: [0, 0]),
            fullName: 'Test User',
            userName: 'test',
            email: 'test@test.com',
            authProvider: '',
            googleId: '',
            image: '',
            role: 'user',
            callingCode: '',
            phoneNumber: '',
            myWallet: 0,
            mySaving: 0,
            dateOfBirth: DateTime.now(),
            address: 'UK',
            oneTimeCodeExpiry: DateTime.now(),
            isGarageAproved: false,
            isMacanicAproved: false,
            isVerified: false,
            isProfileCompleted: true,
            createdAt: DateTime.now(),
            stripeCustomerId: '',
            id: 'u3',
          ),
          postType: 'onlypost',
          postDescription: 'Testing the community feed!',
          createdAt: DateTime.now(),
          likeCount: 1,
          commentCount: 0,
        ),
      ];
    } finally {
      communityLoading.value = false;
    }
  }

  Future<void> myCommunityGet() async {
    myPostLoading(true);
    try {
      final response = await _apiClient.getData(
        ApiConstants.myCommunityEndPoint,
      );
      if (response.isSuccess) {
        final List<CommunityModel> posts = List<CommunityModel>.from(
          response.data['data']['attributes']['results'].map(
            (x) => CommunityModel.fromJson(x),
          ),
        );
        _applyLocalFlags(posts);
        myPostList.value = posts;
      }
    } catch (e) {
      debugPrint('Get My Posts Error: $e');
    } finally {
      myPostLoading.value = false;
    }
  }

  Future<void> likeCommunity(String id) async {
    try {
      final response = await _apiClient.postData(
        ApiConstants.likeCommunityEndPoint(id),
      );
      if (response.isSuccess) {
        _updatePostInBothLists(id, (post) {
          post.isLiked = !post.isLiked;
          if (post.isLiked) {
            post.likeCount++;
          } else if (post.likeCount > 0) {
            post.likeCount--;
          }
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to like post: $e');
      debugPrint('Like Post Error: $e');
    }
  }

  Future<void> toggleSavePost(String id) async {
    final bool wasSaved = savedPostIds.contains(id);

    if (wasSaved) {
      savedPostIds.remove(id);
    } else {
      savedPostIds.add(id);
    }

    await _persistSavedPosts();

    _updatePostInBothLists(id, (post) {
      post.isSaved = !wasSaved;
    });

    try {
      await _apiClient.postData(
        ApiConstants.saveCommunityEndPoint(id),
        data: {'saved': !wasSaved},
      );
    } catch (_) {
      // Keep local state for now. Backend endpoint may not exist yet.
    }
  }

  Future<void> toggleSolvedPost(String id) async {
    bool? currentState;

    _updatePostInBothLists(id, (post) {
      currentState ??= post.isSolved;
      post.isSolved = !post.isSolved;
    });

    try {
      await _apiClient.patchData(
        ApiConstants.solvedCommunityEndPoint(id),
        data: {'isSolved': !(currentState ?? false)},
      );
    } catch (_) {
      // Keep local optimistic state even if endpoint is not available yet.
    }
  }

  Future<void> deletePost(String categoryId, int index) async {
    isLoading.value = true;

    try {
      final response = await _apiClient.deleteData(
        '${ApiConstants.communityCreateEndPoint}/$categoryId',
      );
      if (response.isSuccess) {
        myPostList.removeAt(index);
        myPostList.refresh();
      }
    } catch (e) {
      debugPrint('Errr>>>$e');
      Get.snackbar('Error', 'Failed to update service: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> garageOfferGet(String id) async {
    myPostLoading(true);
    try {
      final response = await _apiClient.getData(
        '${ApiConstants.garageOfferCommunityEndPoint}/$id',
      );

      if (response.isSuccess) {
        garageOfferList.value = List<GarageOfferModel>.from(
          response.data['data']['attributes']['results'].map(
            (x) => GarageOfferModel.fromJson(x),
          ),
        );
      }
    } catch (e) {
      debugPrint('Get Garage Offer  Error: $e');
    } finally {
      myPostLoading.value = false;
    }
  }

  Future<void> getComments(String postId) async {
    commentLoading.value = true;
    try {
      final response = await _apiClient.getData(
        ApiConstants.commentCommunityEndPoint(postId),
      );

      if (response.isSuccess) {
        commentList.value = List<CommentModel>.from(
          response.data['data']['attributes']['results'].map(
            (x) => CommentModel.fromJson(x),
          ),
        );
      }
    } catch (e) {
      debugPrint('Get Comments Error: $e');
    } finally {
      commentLoading.value = false;
    }
  }

  Future<void> addComment(String postId) async {
    if (commentTextCtrl.text.trim().isEmpty) return;

    addCommentLoading.value = true;
    try {
      final response = await _apiClient.postData(
        ApiConstants.commentCommunityEndPoint(postId),
        data: {'comment': commentTextCtrl.text.trim()},
      );

      if (response.isSuccess) {
        final newComment = CommentModel.fromJson(
          response.data['data']['attributes'],
        );
        commentList.insert(0, newComment);
        commentList.refresh();
        commentTextCtrl.clear();

        _updatePostInBothLists(postId, (post) {
          post.commentCount++;
        });
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      debugPrint('Add Comment Error: $e');
      Get.snackbar('Error', 'Failed to add comment');
    } finally {
      addCommentLoading.value = false;
    }
  }

  Future<void> deleteComment(String postId, String commentId, int index) async {
    try {
      final response = await _apiClient.deleteData(
        '${ApiConstants.commentCommunityEndPoint(postId)}/$commentId',
      );

      if (response.isSuccess) {
        commentList.removeAt(index);
        commentList.refresh();

        _updatePostInBothLists(postId, (post) {
          if (post.commentCount > 0) {
            post.commentCount--;
          }
        });
      }
    } catch (e) {
      debugPrint('Delete Comment Error: $e');
      Get.snackbar('Error', 'Failed to delete comment');
    }
  }

  @override
  void onClose() {
    titleTextCtrl.dispose();
    descriptionTextCtrl.dispose();
    locationTextCtrl.dispose();
    hasTagTextCtrl.dispose();
    issueTextCtrl.dispose();
    budgetTextCtrl.dispose();
    carTypeTextCtrl.dispose();
    commentTextCtrl.dispose();
    super.onClose();
  }
}
