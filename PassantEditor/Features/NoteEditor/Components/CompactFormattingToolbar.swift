/*
Abstract:
Compact toolbar with overflow menu for less-used options.
*/

import SwiftUI

struct CompactFormattingToolbar: View {
    let viewModel: NoteEditorViewModel?
    @Binding var showingLocationPicker: Bool
    @State private var showingMoreOptions = false

    var body: some View {
        HStack(spacing: Theme.spacing) {
            // Primary actions (always visible)
            HStack(spacing: Theme.extraLargeSpacing) {
                FormatButton(icon: "bold", isActive: viewModel?.isBold ?? false) {
                    viewModel?.toggleBold()
                }

                FormatButton(icon: "italic", isActive: viewModel?.isItalic ?? false) {
                    viewModel?.toggleItalic()
                }

                FormatButton(icon: "list.bullet", isActive: false) {
                    // TODO: Implement list formatting
                }

                FormatButton(icon: "mappin", isActive: false) {
                    showingLocationPicker = true
                }
            }

            Spacer()

            // More options menu
            Menu {
                Button {
                    viewModel?.toggleUnderline()
                } label: {
                    Label("Underline", systemImage: "underline")
                }

                Button {
                    viewModel?.toggleStrikethrough()
                } label: {
                    Label("Strikethrough", systemImage: "strikethrough")
                }

                Divider()

                Button {
                    viewModel?.paragraphFormat = .heading1
                } label: {
                    Label("Heading 1", systemImage: "1.square.fill")
                }

                Button {
                    viewModel?.paragraphFormat = .heading2
                } label: {
                    Label("Heading 2", systemImage: "2.square.fill")
                }

                Button {
                    viewModel?.paragraphFormat = .heading3
                } label: {
                    Label("Heading 3", systemImage: "3.square.fill")
                }

                Divider()

                Button {
                    // TODO: Implement numbered list formatting
                } label: {
                    Label("Numbered List", systemImage: "list.number")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
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
        CompactFormattingToolbar(
            viewModel: nil,
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
