/*
Abstract:
Contextual toolbar that adapts based on text selection and cursor position.
*/

import SwiftUI

struct ContextualFormattingToolbar: View {
    let viewModel: NoteEditorViewModel?
    @Binding var showingLocationPicker: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.extraLargeSpacing) {
                // Text formatting - always show, adapts to current selection
                FormatButton(
                    icon: "bold",
                    isActive: viewModel?.isBold ?? false
                ) {
                    viewModel?.toggleBold()
                }

                FormatButton(
                    icon: "italic",
                    isActive: viewModel?.isItalic ?? false
                ) {
                    viewModel?.toggleItalic()
                }

                FormatButton(
                    icon: "underline",
                    isActive: viewModel?.isUnderline ?? false
                ) {
                    viewModel?.toggleUnderline()
                }

                FormatButton(
                    icon: "strikethrough",
                    isActive: viewModel?.isStrikethrough ?? false
                ) {
                    viewModel?.toggleStrikethrough()
                }

                Divider()
                    .frame(height: 30)

                // Headings and structure
                FormatButton(
                    icon: "h1",
                    isActive: viewModel?.paragraphFormat == .heading1,
                    isCustomSymbol: true
                ) {
                    viewModel?.paragraphFormat = .heading1
                }

                FormatButton(
                    icon: "h2",
                    isActive: viewModel?.paragraphFormat == .heading2,
                    isCustomSymbol: true
                ) {
                    viewModel?.paragraphFormat = .heading2
                }

                FormatButton(
                    icon: "h3",
                    isActive: viewModel?.paragraphFormat == .heading3,
                    isCustomSymbol: true
                ) {
                    viewModel?.paragraphFormat = .heading3
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

                // Location - always available
                FormatButton(
                    icon: "mappin",
                    isActive: false
                ) {
                    showingLocationPicker = true
                }
            }
            .padding(.horizontal, Theme.smallSpacing)
        }
        .padding(.bottom, Theme.smallSpacing)
        .frame(height: 58)
    }
}

#Preview {
    VStack {
        ContextualFormattingToolbar(
            viewModel: nil,
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
