/*
Abstract:
A SwiftData model for storing attributed strings, preserving all attributes
in a configurable attribute scope.
Based on WWDC25 session 280 sample code.
*/

import Foundation
import SwiftData

@Model
final class AttributedStringModel: Identifiable {
    @Transient
    lazy var value: AttributedString = initializeValue() {
        didSet {
            valueChanged = true
        }
    }

    @Transient
    private var valueChanged: Bool = false

    @Attribute(.externalStorage)
    private var data: Data

    private var scope: Scope

    init(value: AttributedString, scope: Scope) {
        self.data = Data()
        self.scope = scope
        self.value = value

        NotificationCenter.default.addObserver(
            self, selector: #selector(willSave),
            name: ModelContext.willSave, object: nil)
    }

    private func initializeValue() -> AttributedString {
        NotificationCenter.default.addObserver(
            self, selector: #selector(willSave),
            name: ModelContext.willSave, object: nil)

        do {
            let string = try JSONDecoder().decode(
                AttributedString.self,
                from: data,
                configuration: scope.decodingConfiguration)
            return string
        } catch {
            print("Error loading attributed string: \(error)")
            return ""
        }
    }

    @objc
    private func willSave() {
        guard valueChanged else {
            return
        }
        valueChanged = false

        do {
            self.data = try JSONEncoder().encode(
                value,
                configuration: scope.encodingConfiguration)
        } catch {
            print("Error saving attributed string: \(error)")
        }
    }
}

extension AttributedStringModel {
    enum Scope: String, Codable {
        case note

        // swiftlint:disable:next strict_fileprivate
        fileprivate var encodingConfiguration: AttributeScopeCodableConfiguration {
            switch self {
            case .note:
                AttributeScopes.NoteModelAttributes.encodingConfiguration
            }
        }

        // swiftlint:disable:next strict_fileprivate
        fileprivate var decodingConfiguration: AttributeScopeCodableConfiguration {
            switch self {
            case .note:
                AttributeScopes.NoteModelAttributes.decodingConfiguration
            }
        }
    }
}
