# Quick Start: Push to GitHub

Your Flutter plugin is ready to be pushed to GitHub! Follow these steps:

## 1. Create Repository on GitHub

1. Go to https://github.com/new
2. Repository name: `offerwall_flutter`
3. Description: "A Flutter plugin to integrate the offerwall web app into Flutter applications"
4. Choose Public or Private
5. **DO NOT** check "Add a README file" (we already have one)
6. Click "Create repository"

## 2. Connect and Push

Copy and run these commands (replace `YOUR_USERNAME` with your GitHub username):

```bash
cd /Users/om/Desktop/offerwall/flutter_plugin

git remote add origin https://github.com/YOUR_USERNAME/offerwall_flutter.git
git branch -M main
git push -u origin main
```

## 3. Use in Your Flutter Project

Add to your Flutter project's `pubspec.yaml`:

```yaml
dependencies:
  offerwall_flutter:
    git:
      url: https://github.com/YOUR_USERNAME/offerwall_flutter.git
      ref: main
```

Then run:
```bash
flutter pub get
```

That's it! 🎉
