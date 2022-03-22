all: clean ipa apk

clean:
	flutter clean

ipa:
	flutter build ipa --export-options-plist=ios/ExportOptionsDev.plist --release
	open build/ios/ipa/Apps

apk:
	flutter build apk --release
	open build/app/outputs/apk/release

web_build:
	flutter build web --web-renderer html --release
	open build/web

#macos:
#	flutter build macos --release
#	open build/mac os/Build/Products/Release



