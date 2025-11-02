# Setting Up GitHub Repository

## Step 1: Create a New Repository on GitHub

1. Go to [GitHub](https://github.com) and sign in
2. Click the "+" icon in the top right corner
3. Select "New repository"
4. Fill in the repository details:
   - **Repository name**: `offerwall_flutter` (or your preferred name)
   - **Description**: "A Flutter plugin to integrate the offerwall web app into Flutter applications"
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click "Create repository"

## Step 2: Connect Local Repository to GitHub

After creating the repository on GitHub, you'll see instructions. Run these commands:

```bash
cd /Users/om/Desktop/offerwall/flutter_plugin

# Add the remote repository (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/offerwall_flutter.git

# Rename branch to main if needed
git branch -M main

# Push the code
git push -u origin main
```

## Step 3: Verify

1. Go to your GitHub repository page
2. You should see all your files there
3. The README.md will be automatically displayed on the repository homepage

## Using the Plugin in Your Flutter Project

Once the repository is on GitHub, you can use it in your Flutter project in several ways:

### Option 1: Using Git URL (Recommended for Development)

Add to your `pubspec.yaml`:

```yaml
dependencies:
  offerwall_flutter:
    git:
      url: https://github.com/YOUR_USERNAME/offerwall_flutter.git
      ref: main  # or use a specific tag like 'v0.1.0'
```

### Option 2: Using SSH URL

```yaml
dependencies:
  offerwall_flutter:
    git:
      url: git@github.com:YOUR_USERNAME/offerwall_flutter.git
      ref: main
```

### Option 3: Publishing to pub.dev (For Public Distribution)

If you want to publish to pub.dev so others can easily install it:

1. Make sure your code is on GitHub
2. Follow the [pub.dev publishing guide](https://dart.dev/tools/pub/publishing)
3. Run: `flutter pub publish --dry-run` to test
4. Run: `flutter pub publish` to publish

Then users can simply use:

```yaml
dependencies:
  offerwall_flutter: ^0.1.0
```

## Future Updates

When you make changes to the plugin:

```bash
cd /Users/om/Desktop/offerwall/flutter_plugin

# Make your changes, then:
git add .
git commit -m "Description of changes"
git push origin main
```

In your Flutter project that uses the plugin, update it with:

```bash
flutter pub upgrade offerwall_flutter
```

Or if using git dependency, just run:

```bash
flutter pub get
```

## Creating Releases/Tags

For versioning, create tags:

```bash
# Create a tag
git tag -a v0.1.0 -m "Version 0.1.0"

# Push the tag
git push origin v0.1.0
```

Then users can reference specific versions in their pubspec.yaml:

```yaml
dependencies:
  offerwall_flutter:
    git:
      url: https://github.com/YOUR_USERNAME/offerwall_flutter.git
      ref: v0.1.0
```
