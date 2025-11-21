# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Run

Open in Xcode and build (⌘R):
```bash
open PassantEditor.xcodeproj
```

Requirements: Xcode 26.0+, iOS 26.0 SDK

## Code Quality

Run SwiftLint:
```bash
swiftlint lint PassantEditor --config .swiftlint.yml
```

Auto-fix violations:
```bash
swiftlint --fix PassantEditor --config .swiftlint.yml
```

Pre-commit hooks (if installed):
```bash
pre-commit run --all-files
```

## Architecture

### Data Layer

**SwiftData Models** (`Core/Models/`):
- `Note` - Main note model with title, locations, and content (AttributedString)
- `Location` - Place references that can be mentioned in notes
- `AttributedStringModel` - Generic SwiftData wrapper for AttributedString persistence using JSON encoding with configurable attribute scopes

### Rich Text System

The app uses iOS 26's native `AttributedTextFormattingDefinition` system for rich text:

**Attribute Scopes** (`Core/Utilities/NoteAttributeScopes.swift`):
- `NoteModelAttributes` - Persisted attributes (font, underline, strikethrough, custom attributes)
- `NoteEditorAttributes` - Editor attributes including derived styles (foreground/background colors)
- `CustomNoteAttributes` - App-specific: `ParagraphFormat` (body, h1-h3), `ListFormat`, `LocationAttribute`

**Formatting Definition** (`Core/Utilities/NoteFormattingDefinition.swift`):
- `NormalizeFonts` - Constrains fonts based on paragraph format and text styles
- `ApplyHeadingStyles` - Applies colors for headings
- `LocationPillBackground/Foreground` - Styles location mentions as colored pills

**View Model** (`Features/NoteEditor/ViewModels/NoteEditorViewModel.swift`):
- Wraps `Note` model with `@Observable`
- Exposes formatting state (isBold, isItalic, etc.) via `AttributedTextSelection`
- Toggle methods use `transformAttributes(in:)` for selection-based formatting

### Keyboard Toolbars

Two toolbar variants for UX testing (`Features/NoteEditor/Components/`):
- `SimpleFormattingToolbar` - Horizontal scrolling, all options visible
- `CompactFormattingToolbar` - Primary actions with overflow menu

Switch between them in Settings.

## Key Patterns

- Views access data through ViewModels, not directly via `@Environment(\.modelContext)`
- AttributedString changes automatically update `lastModified` on Note
- Sample data generates only on first launch when no notes exist
- Dark mode only (`.preferredColorScheme(.dark)`)
