# TurboVets Flutter + Angular Assessment

This repository contains the implementation of the TurboVets coding assessment.  
It demonstrates a Flutter application with two main parts:

1. **Messaging Interface (Flutter-native)**
   - Built with Flutter widgets.
   - Implements messaging bubbles, timestamps, scroll-to-latest, input field, send button, and simulated agent responses.

2. **Dashboard (Angular + Tailwind)**
   - Hosted locally with Angular.
   - Embedded inside Flutter using a WebView.
   - Implements required modules:
     - Ticket Viewer
     - Knowledgebase Editor
     - Live Logs Panel
     - Simple navigation



## Project Structure
```bash
TurboVets_Project/
├── flutter_app/   # Flutter native application
└── webpage/       # Angular + Tailwind dashboard
```


## Requirements

- Flutter SDK (3.9.x or higher)
- Android Studio with Android Emulator, or a physical device (Android)
- Node.js (v18 or higher)
- Angular CLI (17+)
- Chrome / preferred modern browser for local testing of Angular




## Setup Instructions

### 1. Angular Dashboard

Install dependencies:
```bash
cd webpage
npm install
```
Run Angular dashboard:
```bash
ng serve --host 0.0.0.0 --port 4200
```
By default the Angular app will be available on:

```bash
- Host machine: http://localhost:4200
- Android Emulator: http://10.0.2.2:4200
```

### 2. Flutter App

Install dependencies:

```bash
cd flutter_app
flutter pub get
```
Find the Android Emulator:

```bash
flutter emulator
```
This should show a list of active emulators on your machine
if there are none, make sure Android Studios is properly downloaded and configured


Launch the Android Emulator:

Now this command would launch the emulator you have configured in Android Studios
```bash
flutter emulators --launch <emulator-id>
```


Run the app on Android Emulator:

```bash
flutter devices
flutter run -d <emulator-id>
```

# Features

Flutter: Messaging Interface
- Chat bubbles aligned left (agent) and right (user).
- Timestamps rendered under each message.
- Auto scrolls to latest message when sending or receiving.
- Input field to type messages and send.
- Simulated agent response after sending.

Flutter: Dashboard WebView
- Uses webview_flutter 4.x for embedding Angular app.
- Configured to load the locally served Angular dashboard.
- Android usesCleartextTraffic enabled for HTTP (development use).

Angular: Dashboard App

- Ticket Viewer
	- Displays a list of support tickets in a table.
	- Provides filter buttons to show All / Open / In Progress / Closed tickets.
	- Status displayed with colored labels (green, yellow, gray).


- Knowledgebase Editor
	- Split layout with Editor and Live Preview side by side.
	- Supports Markdown input rendered using marked.
	- Styled with Tailwind Typography for proper headings, lists, code blocks, etc.
	- Save button with temporary confirmation state.


- Live Logs Panel
	- Simulated logs generated every 2 seconds.
	- Auto-scrolls to bottom while new logs appear.
	- If user scrolls up, auto-scroll pauses and a "Scroll to bottom" button is shown.
	- Styled as a dark console panel with monospace font.


- Navigation
	- Top navbar with links to Tickets, Knowledgebase, and Live Logs.
	- Persistent dark mode toggle, state persisted in localStorage.
	- Responsive design using Tailwind.

