/*
Abstract:
Simple horizontal scrolling toolbar with icon buttons.
*/

import SwiftUI

struct SimpleFormattingToolbar: View {
    let viewModel: NoteEditorViewModel?
    @Binding var showingLocationPicker: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.extraLargeSpacing) {
                // Text formatting
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

                // Headings
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

                // Location
                FormatButton(
                    icon: "mappin",
                    isActive: false
                ) {
                    showingLocationPicker = true
                }
            }
        }
        .frame(maxWidth: .infinity)
        .scrollContentBackground(.hidden)
        .contentMargins(.horizontal, 0)
        .padding(.horizontal, 32)
        .frame(height: 58)
        }
    }
}

#Preview {
    VStack {
        SimpleFormattingToolbar(
            viewModel: nil,
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
