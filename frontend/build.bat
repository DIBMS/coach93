@echo off
echo Building Coach93 for production...

REM Clean the build
flutter clean

REM Get dependencies
flutter pub get

REM Build web app with production configuration
flutter build web --release --dart-define=ENVIRONMENT=prod

echo Build complete! The production files are in build/web directory
pause
