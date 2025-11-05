# Life Countdown & Motivation Widget ⏳

A sleek, minimalistic widget that displays your life countdown with motivational elements to inspire mindfulness and purpose.

## Features

### Core Functionality
- **Real-time Countdown**: Years, months, weeks, days, hours, minutes, and seconds
- **Toggle Modes**: Switch between time remaining and time already lived
- **Progress Visualization**: Circular progress bar showing life percentage
- **Motivational Quotes**: Auto-rotating inspirational messages

### Design
- **Glassmorphism UI**: Modern frosted glass aesthetic
- **Dual Themes**: Light and dark mode support
- **Responsive Design**: Works on mobile and desktop
- **Smooth Animations**: Subtle glow effects and transitions

### Interactive Features
- **Motivation Screen**: Tap widget to open detailed view
- **Settings Panel**: Configure birth date and life expectancy
- **Daily Actions**: "Start Something Today" suggestions
- **Theme Toggle**: Switch between light/dark modes

## Setup

1. Open `index.html` in a web browser
2. Click the settings button (⚙️) to configure:
   - Your birth date
   - Expected life expectancy (default: 80 years)
3. Save settings to start the countdown

## Usage

### Widget Interface
- **Main Display**: Shows countdown in grid format
- **Progress Circle**: Visual representation of life lived
- **Quote Area**: Rotating motivational messages
- **Toggle Button**: Switch between remaining/lived time

### Motivation Screen
- Tap anywhere on the widget to open
- Shows current date/time
- Displays life summary
- Provides daily reflection quote
- Offers actionable suggestions

### Customization
- **Themes**: Use 🌙/☀️ button to switch themes
- **Settings**: Configure personal details via ⚙️ button
- **Quotes**: Automatically rotate every 10 seconds

## Technical Details

### Files Structure
```
├── index.html      # Main widget interface
├── styles.css      # Glassmorphism styling & themes
├── script.js       # Core functionality & calculations
└── README.md       # Documentation
```

### Browser Compatibility
- Modern browsers with CSS Grid support
- Mobile-responsive design
- Local storage for settings persistence

### Customization Options
- Modify quotes array in `script.js`
- Adjust rotation timing (currently 10s for demo)
- Customize color schemes in CSS variables
- Add new motivational actions in `startSomething()` method

## Inspiration
Combines aesthetics from Nothing OS widgets, iOS 18 lock screen, and Zen digital minimalism principles.

## Purpose
Inspire mindfulness, purpose, and gratitude by visualizing the finite nature of time while providing daily motivation and actionable insights.