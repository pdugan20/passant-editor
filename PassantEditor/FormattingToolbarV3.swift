/*
Abstract:
Version 3: Compact toolbar with overflow menu for less-used options.
*/

import SwiftUI

struct FormattingToolbarV3: View {
    let editableText: EditableNoteText?
    @Binding var showingLocationPicker: Bool
    @State private var showingMoreOptions = false

    var body: some View {
        HStack(spacing: Theme.spacing) {
            // Primary actions (always visible)
            HStack(spacing: Theme.smallSpacing) {
                FormatButton(icon: "bold", isActive: editableText?.isBold ?? false) {
                    editableText?.toggleBold()
                }

                FormatButton(icon: "italic", isActive: editableText?.isItalic ?? false) {
                    editableText?.toggleItalic()
                }

                FormatButton(icon: "list.bullet", isActive: false) {
                    // TODO: Implement list formatting
                }

                FormatButton(icon: "mappin.circle.fill", isActive: false) {
                    showingLocationPicker = true
                }
            }

            Spacer()

            // More options menu
            Menu {
                Button {
                    editableText?.toggleUnderline()
                } label: {
                    Label("Underline", systemImage: "underline")
                }

                Button {
                    editableText?.toggleStrikethrough()
                } label: {
                    Label("Strikethrough", systemImage: "strikethrough")
                }

                Divider()

                Button {
                    editableText?.paragraphFormat = .heading1
                } label: {
                    Label("Heading 1", systemImage: "h1.square")
                }

                Button {
                    editableText?.paragraphFormat = .heading2
                } label: {
                    Label("Heading 2", systemImage: "h2.square")
                }

                Button {
                    editableText?.paragraphFormat = .heading3
                } label: {
                    Label("Heading 3", systemImage: "h3.square")
                }

                Divider()

                Button {
                    // TODO: Implement numbered list formatting
                } label: {
                    Label("Numbered List", systemImage: "list.number")
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 18, weight: .medium))
            }
            .toolbarButtonStyle(isActive: showingMoreOptions)
        }
        .padding(.horizontal, Theme.spacing)
        .frame(height: 50)
    }
}

#Preview {
    VStack {
        FormattingToolbarV3(
            editableText: nil,
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
