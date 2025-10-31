/*
Abstract:
Segmented toolbar with tabs to switch between formatting categories.
*/

import SwiftUI

struct SegmentedFormattingToolbar: View {
    let viewModel: NoteEditorViewModel?
    @Binding var showingLocationPicker: Bool
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // Segmented control
            Picker("Category", selection: $selectedTab) {
                Text("Text").tag(0)
                Text("Structure").tag(1)
                Text("Insert").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Theme.spacing)
            .padding(.vertical, Theme.smallSpacing)

            // Toolbar content based on selected tab
            HStack(spacing: Theme.extraLargeSpacing) {
                switch selectedTab {
                case 0:
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

                case 1:
                    // Structure - Headings and Lists
                    FormatButton(
                        icon: "1.square.fill",
                        isActive: viewModel?.paragraphFormat == .heading1
                    ) {
                        viewModel?.paragraphFormat = .heading1
                    }

                    FormatButton(
                        icon: "2.square.fill",
                        isActive: viewModel?.paragraphFormat == .heading2
                    ) {
                        viewModel?.paragraphFormat = .heading2
                    }

                    FormatButton(
                        icon: "3.square.fill",
                        isActive: viewModel?.paragraphFormat == .heading3
                    ) {
                        viewModel?.paragraphFormat = .heading3
                    }

                    Divider()
                        .frame(height: 30)

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

                case 2:
                    // Insert - Location
                    FormatButton(
                        icon: "mappin",
                        isActive: false
                    ) {
                        showingLocationPicker = true
                    }

                    Spacer()

                default:
                    EmptyView()
                }
            }
            .padding(.horizontal, Theme.spacing)
            .padding(.bottom, Theme.smallSpacing)
            .frame(height: 50)
        }
    }
}

#Preview {
    VStack {
        SegmentedFormattingToolbar(
            viewModel: nil,
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
