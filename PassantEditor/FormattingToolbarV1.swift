/*
Abstract:
Version 1: Simple horizontal scrolling toolbar with icon buttons.
*/

import SwiftUI

struct FormattingToolbarV1: View {
    let editableText: EditableNoteText?
    @Binding var showingLocationPicker: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.smallSpacing) {
                // Text formatting
                FormatButton(
                    icon: "bold",
                    isActive: editableText?.isBold ?? false
                ) {
                    editableText?.toggleBold()
                }

                FormatButton(
                    icon: "italic",
                    isActive: editableText?.isItalic ?? false
                ) {
                    editableText?.toggleItalic()
                }

                FormatButton(
                    icon: "underline",
                    isActive: editableText?.isUnderline ?? false
                ) {
                    editableText?.toggleUnderline()
                }

                FormatButton(
                    icon: "strikethrough",
                    isActive: editableText?.isStrikethrough ?? false
                ) {
                    editableText?.toggleStrikethrough()
                }

                Divider()
                    .frame(height: 30)

                // Headings
                FormatButton(
                    icon: "h1.square",
                    isActive: editableText?.paragraphFormat == .heading1
                ) {
                    editableText?.paragraphFormat = .heading1
                }

                FormatButton(
                    icon: "h2.square",
                    isActive: editableText?.paragraphFormat == .heading2
                ) {
                    editableText?.paragraphFormat = .heading2
                }

                FormatButton(
                    icon: "h3.square",
                    isActive: editableText?.paragraphFormat == .heading3
                ) {
                    editableText?.paragraphFormat = .heading3
                }

                Divider()
                    .frame(height: 30)

                // Lists
                FormatButton(
                    icon: "list.bullet",
                    isActive: false
                ) {
                    // TODO: Implement list formatting
                }

                FormatButton(
                    icon: "list.number",
                    isActive: false
                ) {
                    // TODO: Implement numbered list formatting
                }

                Divider()
                    .frame(height: 30)

                // Location
                FormatButton(
                    icon: "mappin.circle.fill",
                    isActive: false
                ) {
                    showingLocationPicker = true
                }
            }
            .padding(.horizontal, Theme.smallSpacing)
        }
        .frame(height: 50)
    }
}

// MARK: - Format Button

struct FormatButton: View {
    let icon: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
        }
        .toolbarButtonStyle(isActive: isActive)
    }
}

#Preview("Toolbar") {
    VStack {
        FormattingToolbarV1(
            editableText: nil,
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}

#Preview("Format Button States") {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            FormatButton(icon: "bold", isActive: false) {}
            FormatButton(icon: "italic", isActive: false) {}
            FormatButton(icon: "underline", isActive: false) {}
        }

        HStack(spacing: 12) {
            FormatButton(icon: "bold", isActive: true) {}
            FormatButton(icon: "italic", isActive: true) {}
            FormatButton(icon: "underline", isActive: true) {}
        }
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
