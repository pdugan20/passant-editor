# PassantEditor - Rich Text Note Prototyping

An iOS prototype application for testing different rich text editing experiences and keyboard toolbar configurations for a note-taking app focused on tracking favorite places.

## Features

- **Native Rich Text Editing** - Uses AttributedString with AttributedTextFormattingDefinition for native formatting
- **Three Keyboard Toolbar Variants** - Test different UX approaches for text formatting:
  - Simple: Horizontal scrolling with all options visible
  - Grouped: Visual sections for different formatting types
  - Compact: Most-used actions with overflow menu
- **Location Mention Pills** - @mention places with styled pills that persist in notes
- **Sample Data** - Pre-populated with real Seattle venues (dive bars, pizza places, cafes)
- **Rich Formatting** - Bold, italic, underline, strikethrough, headings (H1-H3), lists
- **SwiftData Persistence** - All notes and formatting preserved between sessions
- **Dark Mode Only** - Optimized for dark theme

## Tech Stack

- SwiftUI
- SwiftData for persistence
- AttributedTextFormattingDefinition for rich text constraints
- AttributedString with custom attribute scopes

## Getting Started

### Prerequisites

- Xcode 26.0 or later
- iOS 26.0 SDK
- macOS with Apple Silicon or Intel processor

### Installation

1. Clone the repository:
```bash
git clone https://github.com/pdugan20/passant-editor.git
cd passant-editor/PassantEditor
```

2. Open the project in Xcode:
```bash
open PassantEditor.xcodeproj
```

3. Select a simulator or device with iOS 26.0+

4. Build and run (⌘R)

## Development

### Building

```bash
cd PassantEditor
xcodebuild -scheme PassantEditor \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  clean build
```

### Code Quality

This project uses SwiftLint for code quality and consistency.

**Run SwiftLint:**
```bash
cd PassantEditor
swiftlint lint
```

**Auto-fix violations:**
```bash
swiftlint --fix
```

### Pre-commit Hooks

The project uses pre-commit hooks to ensure code quality before commits.

**Install pre-commit:**
```bash
brew install pre-commit
```

**Install the git hooks:**
```bash
cd PassantEditor
pre-commit install
```

**Run hooks manually:**
```bash
pre-commit run --all-files
```

The pre-commit hooks will:
- Run SwiftLint in strict mode
- Check for trailing whitespace
- Validate YAML and JSON files
- Check for merge conflicts
- Warn on Xcode project file modifications

## Project Structure

```
PassantEditor/
├── App/                                    # App entry point
├── Core/
│   ├── Models/                             # SwiftData models (Note, Location, AttributedString)
│   ├── Utilities/                          # Sample data, attribute scopes, formatting definitions
│   └── Theme/                              # Theme styling and view modifiers
├── Features/
│   ├── NoteEditor/                         # Rich text editing (views, view models, toolbars)
│   ├── Locations/                          # Location picker and management
│   └── Settings/                           # App settings
├── Shared/Components/                      # Reusable UI components
├── .swiftlint.yml                          # Code quality rules
├── .pre-commit-config.yaml                 # Git hooks
└── .github/workflows/                      # CI/CD automation
```

## Features in Detail

### Rich Text Formatting

The app supports comprehensive text formatting using iOS 26's native AttributedTextFormattingDefinition system:

- **Text Styles:** Bold, italic, underline, strikethrough
- **Headings:** H1, H2, H3 with automatic styling
- **Lists:** Bullet points and numbered lists (UI ready, full implementation TBD)
- **Location Pills:** Inline mentions of places with custom styling

### Keyboard Toolbars

Three toolbar variants for UX testing:

**Simple**
- Horizontal scrolling strip
- All formatting options visible as icons
- Quick access to all features
- Best for: Users who want everything visible

**Grouped**
- Visual sections (Style | Heading | Lists | Location)
- Related actions grouped together
- Better visual organization
- Best for: Users who think in categories

**Compact**
- Most-used actions visible (Bold, Italic, List, Location)
- Overflow menu for less-common options
- Minimal keyboard footprint
- Best for: Users who want maximum screen space

Switch between toolbars in Settings.

### Sample Data

The app includes three pre-populated notes with realistic formatting:

1. **Favorite Dive Bars** - Bullets, location pills, italic descriptions
2. **Best Pizza** - Numbered list, subheadings, underlined text
3. **Favorite Cafes in Seattle** - H1 heading, strikethrough, bold+italic combo

All feature real Seattle venues as example data.

## Architecture

- **SwiftUI** for all UI
- **SwiftData** for persistence
- **Observable** pattern for view models
- **AttributedTextFormattingDefinition** for text formatting rules
- **Custom AttributeScopes** for location pills and formatting metadata

## CI/CD

The project uses GitHub Actions for continuous integration:

- **Code Quality Checks** - SwiftLint validation on every push/PR
- **Build Verification** - Ensures project builds successfully
- **macOS Latest** - Runs on GitHub-hosted macOS runners

## Future Enhancements

- [ ] Full list implementation (indentation, nested lists)
- [ ] Text color picker
- [ ] Link insertion
- [ ] Image attachment
- [ ] Export to Markdown/HTML
- [ ] iCloud sync
- [ ] Undo/redo stack
- [ ] Custom keyboard shortcuts
- [ ] VoiceOver accessibility improvements

## License

MIT License - See [LICENSE](LICENSE) for details.

Copyright (c) 2025 Patrick Dugan
