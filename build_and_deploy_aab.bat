
call bundletool build-apks --bundle mmgo_android.aab --output=mmgo_android-release.apks --overwrite
call bundletool install-apks --apks=mmgo_android-release.apks
