/*
Abstract:
Main formatting toolbar with three modes: main icons, text styles, and block formats.
*/

import SwiftUI

// MARK: - Toolbar Mode

enum ToolbarMode {
    case main
    case textStyles
    case blockFormats
}

// MARK: - Main Formatting Toolbar

struct MainFormattingToolbar: View {
    let viewModel: NoteEditorViewModel?
    @Binding var toolbarMode: ToolbarMode
    @Binding var showingLocationPicker: Bool

    private func log(_ message: String) {
        print("[Toolbar] \(message)")
    }

    var body: some View {
        HStack(spacing: 6) {
            switch toolbarMode {
            case .main:
                mainModeContent
            case .textStyles:
                textStylesModeContent
            case .blockFormats:
                blockFormatsModeContent
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 49)
        .animation(Theme.smoothAnimation, value: toolbarMode)
    }

    // MARK: - Main Mode

    @ViewBuilder
    private var mainModeContent: some View {
        // Plus button - opens block format picker
        FormatButton(
            icon: "plus",
            isActive: false
        ) {
            log("Plus button tapped, setting toolbarMode to blockFormats")
            toolbarMode = .blockFormats
        }

        // Text format button - shows text styles
        FormatButton(
            icon: "textformat.size",
            isActive: false
        ) {
            log("Text format button tapped, setting toolbarMode to textStyles")
            toolbarMode = .textStyles
        }

        // Location button
        FormatButton(
            icon: "location.fill",
            isActive: false
        ) {
            log("Location button tapped")
            showingLocationPicker = true
        }

        // Photo button
        FormatButton(
            icon: "photo",
            isActive: false
        ) {
            log("Photo button tapped")
            // TODO: Implement photo picker
        }
    }

    // MARK: - Text Styles Mode

    @ViewBuilder
    private var textStylesModeContent: some View {
        // Back button
        FormatButton(
            icon: "chevron.left",
            isActive: false
        ) {
            toolbarMode = .main
        }

        Divider()
            .frame(height: 30)

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
    }

    // MARK: - Block Formats Mode (plus is selected)

    @ViewBuilder
    private var blockFormatsModeContent: some View {
        // Plus button - selected state, tap to close
        FormatButton(
            icon: "plus",
            isActive: true
        ) {
            log("Plus button tapped (close), setting toolbarMode to main")
            toolbarMode = .main
        }

        // Text format button - disabled/dimmed while in block mode
        FormatButton(
            icon: "textformat.size",
            isActive: false
        ) {
            log("Text format button tapped from block mode")
            toolbarMode = .textStyles
        }

        // Location button
        FormatButton(
            icon: "location.fill",
            isActive: false
        ) {
            log("Location button tapped from block mode")
            showingLocationPicker = true
            toolbarMode = .main
        }

        // Photo button
        FormatButton(
            icon: "photo",
            isActive: false
        ) {
            log("Photo button tapped from block mode")
            toolbarMode = .main
            // TODO: Implement photo picker
        }
    }
}

#Preview {
    VStack {
        MainFormattingToolbar(
            viewModel: nil,
            toolbarMode: .constant(.main),
            showingLocationPicker: .constant(false)
        )

        MainFormattingToolbar(
            viewModel: nil,
            toolbarMode: .constant(.textStyles),
            showingLocationPicker: .constant(false)
        )

        MainFormattingToolbar(
            viewModel: nil,
            toolbarMode: .constant(.blockFormats),
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
