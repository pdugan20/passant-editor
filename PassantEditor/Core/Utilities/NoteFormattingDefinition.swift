/*
Abstract:
The attributed text formatting definition for rich text in notes.
*/

import SwiftUI

struct NoteFormattingDefinition: AttributedTextFormattingDefinition {
    typealias Scope = AttributeScopes.NoteEditorAttributes

    let locations: Set<Location.ID>

    var body: some AttributedTextFormattingDefinition<Scope> {
        NormalizeFonts()
        ApplyHeadingStyles()
        LocationPillBackground(locations: locations)
        LocationPillForeground(locations: locations)
    }
}

// MARK: - Font Normalization

/// Normalizes fonts to predefined styles based on paragraph format and text attributes.
struct NormalizeFonts: AttributedTextValueConstraint {
    typealias Scope = NoteFormattingDefinition.Scope
    typealias AttributeKey = AttributeScopes.SwiftUIAttributes.FontAttribute

    func constrain(_ container: inout Attributes) {
        // Check paragraph format first
        switch container.paragraphFormat {
        case .heading1:
            container.font = .title2.bold()
        case .heading2:
            container.font = .title3.weight(.semibold)
        case .heading3:
            container.font = .headline.weight(.medium)
        case .body, nil:
            // For body text, check for bold/italic
            guard let font = container.font else {
                return
            }

            let resolved = font.resolve(in: EnvironmentValues().fontResolutionContext)

            if resolved.isBold && resolved.isItalic {
                container.font = .default.bold().italic()
            } else if resolved.isBold {
                container.font = .default.bold()
            } else if resolved.isItalic {
                container.font = .default.italic()
            } else {
                container.font = nil
            }
        }
    }
}

// MARK: - Heading Styles

/// Applies appropriate styling for headings.
struct ApplyHeadingStyles: AttributedTextValueConstraint {
    typealias Scope = NoteFormattingDefinition.Scope
    typealias AttributeKey = AttributeScopes.SwiftUIAttributes.ForegroundColorAttribute

    func constrain(_ container: inout Attributes) {
        // Headings get accent color
        if let format = container.paragraphFormat, format != .body {
            container.foregroundColor = .primary
        } else if container.font == .default.bold() {
            // Bold text gets slightly emphasized
            container.foregroundColor = .primary
        } else {
            container.foregroundColor = nil
        }
    }
}

// MARK: - Location Pills

/// Sets background color for location pills.
struct LocationPillBackground: AttributedTextValueConstraint {
    typealias Scope = NoteFormattingDefinition.Scope
    typealias AttributeKey = AttributeScopes.SwiftUIAttributes.BackgroundColorAttribute

    let locations: Set<Location.ID>

    func constrain(_ container: inout Attributes) {
        if let locationID = container.location {
            let contains = locations.contains(locationID)
            print("[DEBUG] LocationPillBackground - locationID: \(locationID)")
            print("[DEBUG] LocationPillBackground - contains: \(contains)")
            print("[DEBUG] LocationPillBackground - locations count: \(locations.count)")
            if contains {
                container.backgroundColor = .red.opacity(0.2)
            } else {
                container.backgroundColor = nil
            }
        }
    }
}

/// Sets foreground color for location pills.
struct LocationPillForeground: AttributedTextValueConstraint {
    typealias Scope = NoteFormattingDefinition.Scope
    typealias AttributeKey = AttributeScopes.SwiftUIAttributes.ForegroundColorAttribute

    let locations: Set<Location.ID>

    func constrain(_ container: inout Attributes) {
        if let locationID = container.location {
            let contains = locations.contains(locationID)
            print("[DEBUG] LocationPillForeground - locationID: \(locationID)")
            print("[DEBUG] LocationPillForeground - contains: \(contains)")
            if contains {
                container.foregroundColor = .red
            } else {
                container.foregroundColor = nil
            }
        }
    }
}
