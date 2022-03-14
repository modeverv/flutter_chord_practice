#!/usr/bin/env bash

flutter clean
flutter build ipa --export-options-plist=ios/ExportOptionsDev.plist --release
open build/ios/ipa/Apps
flutter build apk --release
open build/app/outputs/apk/release
flutter build web --web-renderer html --release
open build/web
flutter build macos --release
open build/mac os/Build/Products/Release