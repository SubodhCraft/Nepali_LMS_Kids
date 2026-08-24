# Nepali Kids LMS

A highly interactive, offline-first educational app designed for kids under 5 to learn Nepali.

## Project Overview

This app offers a fun, engaging, and interactive way for young children to learn foundational Nepali language concepts. It uses gamified learning modules, interactive mascots, and native audio support. 

## Architecture (Feature-First DDD)

The project is structured using a Feature-First Domain-Driven Design (DDD) approach. This ensures high cohesion, loose coupling, and scalability.

### Directory Structure

- `lib/core/`: Application-wide configurations including themes, routing, and utils.
- `lib/features/`: Contains feature modules, each strictly separated by Domain, Data, and Presentation layers:
  - `learning_modules/`: Core educational games and content.
  - `parent_dashboard/`: Analytics and progress tracking for parents.
  - `mascot_engine/`: Logic and UI for the interactive digital buddy.
- `lib/shared/`: Reusable widgets (animated buttons, progress bars, etc.).
- `lib/services/`: External integrations such as audio playback (`audio_service`) and local offline storage (`local_storage`).

## State Management (Riverpod)

The application utilizes `flutter_riverpod` for safe, declarative, and highly testable state management. ProviderScope is initialized at the root of the application, and ConsumerWidgets are utilized for reactivity.

## Core Features
- **Offline-First Capabilities**: Track progress locally using robust caching (SQLite/Hive).
- **Interactive UI/UX**: Engaging micro-animations and intuitive navigation powered by `go_router`.
- **Native Audio Support**: Text-to-Speech (TTS) and embedded audio for correct pronunciation.
- **Strict Clean Code**: CI/CD pipelines enforcing `flutter_lints` and `flutter test`.

## Setup Instructions

1. **Install Flutter**: Ensure you have the latest stable Flutter SDK.
2. **Clone the Repository**:
   ```bash
   git clone <your_repo_url>
   cd nepali_kids_lms
   ```
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the App**:
   ```bash
   flutter run
   ```
