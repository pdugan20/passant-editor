/*
Abstract:
The SwiftData persistence model for notes.
*/

import Foundation
import SwiftData

@Model
final class Note: Identifiable {
    var lastModified: Date
    var title: String

    @Relationship(deleteRule: .cascade)
    var locations: [Location]

    var content: AttributedString {
        get {
            contentModel.value
        }
        set {
            contentModel.value = newValue
            lastModified = .now
        }
    }

    @Relationship(deleteRule: .cascade)
    private var contentModel: AttributedStringModel

    init(title: String, content: AttributedString, locations: [Location] = []) {
        self.title = title
        self.locations = locations
        self.lastModified = .now
        self.contentModel = AttributedStringModel(value: content, scope: .note)
    }

    convenience init() {
        self.init(title: "", content: "")
    }
}
