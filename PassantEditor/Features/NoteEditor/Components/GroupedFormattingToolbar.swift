/*
Abstract:
Grouped sections with visual dividers.
*/

import SwiftUI

struct GroupedFormattingToolbar: View {
    let viewModel: NoteEditorViewModel?
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
                        FormatButton(icon: "bold", isActive: viewModel?.isBold ?? false) {
                            viewModel?.toggleBold()
                        }

                        FormatButton(icon: "italic", isActive: viewModel?.isItalic ?? false) {
                            viewModel?.toggleItalic()
                        }

                        FormatButton(icon: "underline", isActive: viewModel?.isUnderline ?? false) {
                            viewModel?.toggleUnderline()
                        }

                        FormatButton(icon: "strikethrough", isActive: viewModel?.isStrikethrough ?? false) {
                            viewModel?.toggleStrikethrough()
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
                        FormatButton(icon: "h1.square", isActive: viewModel?.paragraphFormat == .heading1) {
                            viewModel?.paragraphFormat = .heading1
                        }

                        FormatButton(icon: "h2.square", isActive: viewModel?.paragraphFormat == .heading2) {
                            viewModel?.paragraphFormat = .heading2
                        }

                        FormatButton(icon: "h3.square", isActive: viewModel?.paragraphFormat == .heading3) {
                            viewModel?.paragraphFormat = .heading3
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
        GroupedFormattingToolbar(
            viewModel: nil,
            showingLocationPicker: .constant(false)
        )
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
