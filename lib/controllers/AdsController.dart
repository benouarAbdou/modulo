import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  BannerAd? bannerAd;
  RxBool isBannerAdLoaded = false.obs;
  InterstitialAd? interstitialAd;
  RxBool isInterstitialAdLoaded = false.obs;
  RewardedAd? rewardedAd;
  RxBool isRewardedAdLoaded = false.obs;

  // Use test IDs for now
  final String bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111'; // Test Banner ID
  final String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial ID
  final String rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // Test Rewarded Ad ID

  @override
  void onInit() {
    super.onInit();
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
  }

  // Load a new BannerAd instance
  void loadBannerAd() {
    // Dispose of the existing banner ad if it exists
    if (bannerAd != null) {
      bannerAd!.dispose();
      bannerAd = null;
    }

    bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdLoaded.value = true;
          print('Banner Ad Loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Failed to Load: $error');
          isBannerAdLoaded.value = false;
          ad.dispose();
          bannerAd = null;
          // Retry after a delay only if not already loading
          Future.delayed(const Duration(seconds: 30), () {
            if (bannerAd == null) loadBannerAd();
          });
        },
      ),
    );
    bannerAd!.load();
  }

  void loadInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.dispose();
      interstitialAd = null;
    }

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialAdLoaded.value = true;
          print('Interstitial Ad Loaded');
          interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              interstitialAd?.dispose();
              interstitialAd = null;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              interstitialAd?.dispose();
              interstitialAd = null;
              loadInterstitialAd();
              print('Interstitial Failed to Show: $error');
            },
          );
        },
        onAdFailedToLoad: (error) {
          isInterstitialAdLoaded.value = false;
          print('Interstitial Ad Failed to Load: $error');
          Future.delayed(const Duration(seconds: 30), loadInterstitialAd);
        },
      ),
    );
  }

  void loadRewardedAd() {
    if (rewardedAd != null) {
      rewardedAd!.dispose();
      rewardedAd = null;
    }

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          isRewardedAdLoaded.value = true;
          print('Rewarded Ad Loaded');
          rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              rewardedAd?.dispose();
              rewardedAd = null;
              isRewardedAdLoaded.value = false;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              rewardedAd?.dispose();
              rewardedAd = null;
              isRewardedAdLoaded.value = false;
              loadRewardedAd();
              print('Rewarded Ad Failed to Show: $error');
            },
          );
        },
        onAdFailedToLoad: (error) {
          isRewardedAdLoaded.value = false;
          print('Rewarded Ad Failed to Load: $error');
          Future.delayed(const Duration(seconds: 30), loadRewardedAd);
        },
      ),
    );
  }

  // Show rewarded ad with a callback for when reward is earned
  void showRewardedAd({required Function onRewardEarned}) {
    if (isRewardedAdLoaded.value && rewardedAd != null) {
      rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
          onRewardEarned();
        },
      );
    } else {
      print('Rewarded Ad not ready yet');
      loadRewardedAd(); // Attempt to load if not ready
    }
  }

  void showInterstitialAd() {
    if (isInterstitialAdLoaded.value && interstitialAd != null) {
      interstitialAd!.show();
    } else {
      print('Interstitial Ad not ready yet');
    }
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    rewardedAd?.dispose();
    super.onClose();
  }
}
