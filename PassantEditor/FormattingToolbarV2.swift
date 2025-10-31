/*
Abstract:
Version 2: Grouped sections with visual dividers.
*/

import SwiftUI

struct FormattingToolbarV2: View {
    let editableText: EditableNoteText?
    @Binding var showingLocationPicker: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.spacing) {
                // Text Style Group
                VStack(spacing: 2) {
                    Text("Style")
                        .font(.caption2)
                        .foregroundColor(ThemeColors.secondaryLabel)

                    HStack(spacing: Theme.smallSpacing) {
                        FormatButton(icon: "bold", isActive: editableText?.isBold ?? false) {
                            editableText?.toggleBold()
                        }

                        FormatButton(icon: "italic", isActive: editableText?.isItalic ?? false) {
                            editableText?.toggleItalic()
                        }

                        FormatButton(icon: "underline", isActive: editableText?.isUnderline ?? false) {
                            editableText?.toggleUnderline()
                        }

                        FormatButton(icon: "strikethrough", isActive: editableText?.isStrikethrough ?? false) {
                            editableText?.toggleStrikethrough()
                        }
                    }
                }
                .padding(Theme.smallSpacing)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: Theme.smallCornerRadius))

                // Headings Group
                VStack(spacing: 2) {
                    Text("Heading")
                        .font(.caption2)
                        .foregroundColor(ThemeColors.secondaryLabel)

                    HStack(spacing: Theme.smallSpacing) {
                        FormatButton(icon: "h1.square", isActive: editableText?.paragraphFormat == .heading1) {
                            editableText?.paragraphFormat = .heading1
                        }

                        FormatButton(icon: "h2.square", isActive: editableText?.paragraphFormat == .heading2) {
                            editableText?.paragraphFormat = .heading2
                        }

                        FormatButton(icon: "h3.square", isActive: editableText?.paragraphFormat == .heading3) {
                            editableText?.paragraphFormat = .heading3
                        }
                    }
                }
                .padding(Theme.smallSpacing)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: Theme.smallCornerRadius))

                // Lists Group
                VStack(spacing: 2) {
                    Text("Lists")
                        .font(.caption2)
                        .foregroundColor(ThemeColors.secondaryLabel)

                    HStack(spacing: Theme.smallSpacing) {
                        FormatButton(icon: "list.bullet", isActive: false) {
                            // TODO: Implement list formatting
                        }

                        FormatButton(icon: "list.number", isActive: false) {
                            // TODO: Implement numbered list formatting
                        }
                    }
                }
                .padding(Theme.smallSpacing)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: Theme.smallCornerRadius))

                // Location Group
                VStack(spacing: 2) {
                    Text("Location")
                        .font(.caption2)
                        .foregroundColor(ThemeColors.secondaryLabel)

                    FormatButton(icon: "mappin.circle.fill", isActive: false) {
                        showingLocationPicker = true
                    }
                }
                .padding(Theme.smallSpacing)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: Theme.smallCornerRadius))
            }
            .padding(.horizontal, Theme.smallSpacing)
        }
        .frame(height: 70)
    }
}

#Preview {
    VStack {
        FormattingToolbarV2(
            editableText: nil,
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
