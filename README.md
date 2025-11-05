# Flutter Life Countdown & Motivation Widget ⏳

A Flutter app with home screen widget that displays your life countdown with motivational elements to inspire mindfulness and purpose.

## Features

### Core Functionality
- **Real-time Countdown**: Years, months, days, hours, minutes, and seconds
- **Toggle Modes**: Switch between time remaining and time already lived
- **Progress Visualization**: Circular progress bar showing life percentage
- **Motivational Quotes**: Auto-rotating inspirational messages
- **Home Screen Widget**: Native Android widget using Glance

### Design
- **Futuristic UI**: Gradient backgrounds and modern design
- **Dual Themes**: Light and dark mode support
- **Responsive Design**: Optimized for mobile devices
- **Smooth Animations**: Flutter's native animations

### Interactive Features
- **Widget Tap**: Opens full app from home screen widget
- **Theme Toggle**: Switch between light/dark modes
- **Live Updates**: Real-time countdown updates
- **Quote Rotation**: Auto-changing motivational quotes

## Setup

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Build and install: `flutter run`
4. Add widget to home screen from Android widget picker

## Technical Details

### Files Structure
```
lib/
├── main.dart           # Main app and UI
├── life_widget.dart    # Glance home screen widget
├── quote_service.dart  # Quote management and API
├── theme.dart          # Theme definitions
└── ...
```

### Dependencies
- **glance**: ^0.0.7 (Android home screen widgets)
- **provider**: ^6.1.1 (State management)
- **http**: ^1.1.0 (API calls for quotes)
- **shared_preferences**: ^2.2.2 (Local storage)

### Birth Date Configuration
- Hardcoded: November 13, 2003
- Life expectancy: 80 years
- Automatic calculations for remaining/lived time

## Widget Features
- **4x2 Grid Layout**: Years, Months, Days, Hours display
- **Progress Indicator**: Circular progress showing life percentage
- **Motivational Quote**: Rotating inspirational messages
- **Gradient Background**: Midnight blue to violet theme
- **Auto-refresh**: Updates every minute on home screen

## Purpose
Inspire mindfulness, purpose, and gratitude by visualizing the finite nature of time while providing daily motivation through a native Android widget experience.