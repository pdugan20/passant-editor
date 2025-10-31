/*
Abstract:
View model for note editing with rich text formatting support.
*/

import SwiftData
import SwiftUI

@MainActor
@Observable
final class NoteEditorViewModel: Identifiable {
    let model: Note

    var text: AttributedString {
        get {
            if lastModified >= model.lastModified {
                editedText
            } else {
                model.content
            }
        }
        set {
            model.content = newValue
            editedText = newValue
        }
    }

    private var editedText: AttributedString {
        didSet {
            lastModified = .now
        }
    }
    private var lastModified: Date

    var selection: AttributedTextSelection

    init(note: Note) {
        self.model = note
        self.selection = AttributedTextSelection()
        self.editedText = model.content
        self.lastModified = model.lastModified
    }
}

// MARK: - Formatting Helpers

extension NoteEditorViewModel {
    /// Check if current selection has bold formatting
    var isBold: Bool {
        let containers = selection.attributes(in: text)
        let fonts = containers[\.font]
        return fonts.contains { font in
            guard let font = font else { return false }
            let resolved = font.resolve(in: EnvironmentValues().fontResolutionContext)
            return resolved.isBold
        }
    }

    /// Check if current selection has italic formatting
    var isItalic: Bool {
        let containers = selection.attributes(in: text)
        let fonts = containers[\.font]
        return fonts.contains { font in
            guard let font = font else { return false }
            let resolved = font.resolve(in: EnvironmentValues().fontResolutionContext)
            return resolved.isItalic
        }
    }

    /// Check if current selection has underline formatting
    var isUnderline: Bool {
        let containers = selection.attributes(in: text)
        let underlines = containers[\.underlineStyle]
        return underlines.contains(.single)
    }

    /// Check if current selection has strikethrough formatting
    var isStrikethrough: Bool {
        let containers = selection.attributes(in: text)
        let strikethroughs = containers[\.strikethroughStyle]
        return strikethroughs.contains(.single)
    }

    /// Get paragraph format for current selection
    var paragraphFormat: ParagraphFormat {
        get {
            let containers = selection.attributes(in: text)
            let formats = containers[\.paragraphFormat]

            if formats.contains(.heading1) {
                return .heading1
            } else if formats.contains(.heading2) {
                return .heading2
            } else if formats.contains(.heading3) {
                return .heading3
            } else {
                return .body
            }
        }
        set {
            text.transformAttributes(in: &selection) {
                $0.paragraphFormat = newValue
            }
        }
    }

    /// Toggle bold formatting
    func toggleBold() {
        let shouldBeBold = !isBold
        text.transformAttributes(in: &selection) { attributes in
            if shouldBeBold {
                let current = attributes.font ?? .default
                attributes.font = current.bold()
            } else {
                if let font = attributes.font {
                    let resolved = font.resolve(in: EnvironmentValues().fontResolutionContext)
                    if resolved.isItalic {
                        attributes.font = .default.italic()
                    } else {
                        attributes.font = nil
                    }
                }
            }
        }
    }

    /// Toggle italic formatting
    func toggleItalic() {
        let shouldBeItalic = !isItalic
        text.transformAttributes(in: &selection) { attributes in
            if shouldBeItalic {
                let current = attributes.font ?? .default
                attributes.font = current.italic()
            } else {
                if let font = attributes.font {
                    let resolved = font.resolve(in: EnvironmentValues().fontResolutionContext)
                    if resolved.isBold {
                        attributes.font = .default.bold()
                    } else {
                        attributes.font = nil
                    }
                }
            }
        }
    }

    /// Toggle underline formatting
    func toggleUnderline() {
        let shouldBeUnderlined = !isUnderline
        text.transformAttributes(in: &selection) { attributes in
            attributes.underlineStyle = shouldBeUnderlined ? .single : nil
        }
    }

    /// Toggle strikethrough formatting
    func toggleStrikethrough() {
        let shouldBeStrikethrough = !isStrikethrough
        text.transformAttributes(in: &selection) { attributes in
            attributes.strikethroughStyle = shouldBeStrikethrough ? .single : nil
        }
    }

    /// Insert a location pill at the current cursor position
    func insertLocation(_ location: Location) {
        var locationText = AttributedString(location.name)
        locationText.location = location.id

        // For now, append with space at the end of text
        // In a production app, would insert at cursor/selection position
        text.append(AttributedString(" "))
        text.append(locationText)
        text.append(AttributedString(" "))

        // Add location to note if not already present
        if !model.locations.contains(where: { $0.id == location.id }) {
            model.locations.append(location)
        }
    }

    /// Extract all location IDs from the attributed text content
    func locationIDsFromContent() -> Set<Location.ID> {
        var locationIDs = Set<Location.ID>()

        for run in text.runs {
            if let locationID = run.location {
                locationIDs.insert(locationID)
            }
        }

        return locationIDs
    }
}
