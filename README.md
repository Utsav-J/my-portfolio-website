# Utsav's Portfolio Website 🎯

A modern, interactive portfolio website built with Flutter that replicates a macOS desktop experience. This project showcases my professional journey, skills, and projects through an engaging and intuitive interface.

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-enabled-orange.svg)](https://firebase.google.com/)

## 🚀 Features

### 🖥️ macOS-Inspired Desktop Experience
- **Authentic Boot-up Sequence**: Complete with loading animations and system initialization
- **Interactive Desktop**: Full macOS-style desktop with wallpaper, dock, and menu bar
- **Draggable App Windows**: Resizable and repositionable application windows
- **Smooth Animations**: Fluid transitions and interactive elements throughout

### 📱 Portfolio Sections
- **About Me**: Dynamic introduction with rotating titles and social links
- **Experience**: Professional work history with company details and achievements
- **Education**: Academic background with institutions and accomplishments
- **Projects**: Interactive project showcase with GitHub integration
- **Certifications**: Professional certifications and credentials
- **Skills**: Technology stack visualization

### 🎮 Interactive Elements
- **Snake Game**: "Help Utsav catch all of tech" - A custom snake game featuring tech stack icons
- **Weather Widget**: Real-time weather information
- **GitHub Integration**: Live GitHub profile and statistics
- **Music Player**: Spotify integration for personal touch

### 🔥 Technical Highlights
- **Firebase Integration**: Real-time data management for dynamic content
- **Responsive Design**: Optimized for various screen sizes
- **Modern UI/UX**: Glassmorphic design elements and smooth animations
- **Cross-Platform**: Built with Flutter for web deployment

## 🛠️ Tech Stack

### Frontend
- **Flutter** (v3.8.1) - Cross-platform UI framework
- **Dart** - Programming language
- **Flutter ScreenUtil** - Responsive design utilities

### Backend & Services
- **Firebase Core** - Backend infrastructure
- **Cloud Firestore** - NoSQL database for portfolio data
- **Firebase Hosting** - Web hosting platform

### Key Dependencies
- **Lottie** - Beautiful animations
- **Cached Network Image** - Optimized image loading
- **URL Launcher** - External link handling
- **Icons Plus** - Extended icon library
- **HTTP** - API requests for weather data
- **Glassmorphic UI Kit** - Modern UI components

## 📁 Project Structure

```
lib/
├── config/
│   └── app_design.dart          # Design system and theming
├── models/
│   └── models.dart              # Data models (Experience, Education, etc.)
├── screens/
│   ├── appscreen/               # Individual app windows
│   │   ├── about_me_screen.dart
│   │   ├── experience_screen.dart
│   │   ├── education_screen.dart
│   │   ├── projects_screen.dart
│   │   └── certifications_screen.dart
│   ├── bootup/                  # System boot sequence
│   ├── homepage/                # Main entry point
│   ├── homescreen/              # Desktop interface
│   │   ├── mac_desktop_apps.dart
│   │   ├── mac_dock.dart
│   │   └── mac_menu_bar.dart
│   ├── homescreen_widgets/      # Desktop widgets
│   │   ├── weather/
│   │   ├── github_profile/
│   │   ├── spotify/
│   │   └── skills_carousel/
│   ├── overlays/                # System overlays
│   └── snake/                   # Snake game implementation
├── utils/
│   ├── firebase_utils.dart      # Firebase utilities
│   └── url_launcher_utils.dart  # URL handling utilities
└── main.dart                    # Application entry point
```
