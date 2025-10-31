/*
Abstract:
The attribute scopes for note content editing and persistence.
*/

import Foundation
import SwiftUI

// MARK: - Attribute Scopes

extension AttributeScopes {
    /// Attributes that capture all encoded information in note text.
    struct NoteModelAttributes: AttributeScope {
        let custom: CustomNoteAttributes
        let font: AttributeScopes.SwiftUIAttributes.FontAttribute
        let underlineStyle: AttributeScopes.SwiftUIAttributes.UnderlineStyleAttribute
        let strikethroughStyle: AttributeScopes.SwiftUIAttributes.StrikethroughStyleAttribute
    }
}

extension AttributeScopes {
    /// Attributes that capture all information and formatting available in the note editor.
    struct NoteEditorAttributes: AttributeScope {
        let model: NoteModelAttributes
        let custom: CustomNoteAttributes
        let foregroundColor: AttributeScopes.SwiftUIAttributes.ForegroundColorAttribute
        let backgroundColor: AttributeScopes.SwiftUIAttributes.BackgroundColorAttribute
    }
}

extension AttributeScopes {
    struct CustomNoteAttributes: AttributeScope {
        let paragraphFormat: ParagraphFormattingAttribute
        let listFormat: ListFormattingAttribute
        let location: LocationAttribute
    }
}

// MARK: - Custom Attributes

/// The semantic format of a text paragraph.
enum ParagraphFormat: String, Codable {
    case body
    case heading1
    case heading2
    case heading3
}

/// The list format of a paragraph.
enum ListFormat: String, Codable {
    case none
    case bullet
    case numbered
}

/// An attribute for specifying the semantic format for a note text paragraph.
struct ParagraphFormattingAttribute: CodableAttributedStringKey {
    typealias Value = ParagraphFormat

    static let name = "PassantEditor.ParagraphFormattingAttribute"

    static let runBoundaries: AttributedString.AttributeRunBoundaries? = .paragraph
    static let inheritedByAddedText: Bool = false
}

/// An attribute for specifying list formatting.
struct ListFormattingAttribute: CodableAttributedStringKey {
    typealias Value = ListFormat

    static let name = "PassantEditor.ListFormattingAttribute"

    static let runBoundaries: AttributedString.AttributeRunBoundaries? = .paragraph
    static let inheritedByAddedText: Bool = false
}

/// An attribute for marking text as a reference to a location.
struct LocationAttribute: CodableAttributedStringKey {
    typealias Value = Location.ID

    static let name = "PassantEditor.LocationAttribute"

    static let inheritedByAddedText: Bool = false
    // swiftlint:disable:next discouraged_optional_collection
    static let invalidationConditions: Set<AttributedString.AttributeInvalidationCondition>? = [.textChanged]
}

// MARK: - Dynamic Lookup

extension AttributeDynamicLookup {
    subscript<T: AttributedStringKey>(
        dynamicMember keyPath: KeyPath<AttributeScopes.CustomNoteAttributes, T>
    ) -> T {
        self[T.self]
    }
}
