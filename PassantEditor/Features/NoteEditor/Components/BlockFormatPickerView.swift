/*
Abstract:
Grid picker for block-level formatting options (headings, lists, quote, divider).
Displays in keyboard area when plus button is tapped.
*/

import SwiftUI

// MARK: - Block Format Type

enum BlockFormatType: String, CaseIterable, Identifiable {
    case heading1
    case heading2
    case heading3
    case bulletList
    case numberedList
    case quote
    case divider

    var id: String { rawValue }

    var label: String {
        switch self {
        case .heading1: "Heading 1"
        case .heading2: "Heading 2"
        case .heading3: "Heading 3"
        case .bulletList: "Bulleted List"
        case .numberedList: "Numbered List"
        case .quote: "Quote"
        case .divider: "Divider"
        }
    }

    var icon: String {
        switch self {
        case .heading1: "h1"
        case .heading2: "h2"
        case .heading3: "h3"
        case .bulletList: "list.bullet"
        case .numberedList: "list.number"
        case .quote: "text.quote"
        case .divider: "minus"
        }
    }

    var isCustomSymbol: Bool {
        switch self {
        case .heading1, .heading2, .heading3: true
        default: false
        }
    }

    var ghostText: String {
        switch self {
        case .heading1: "Heading 1"
        case .heading2: "Heading 2"
        case .heading3: "Heading 3"
        case .bulletList: "List item"
        case .numberedList: "List item"
        case .quote: "Quote"
        case .divider: ""
        }
    }
}

// MARK: - Block Format Picker View

struct BlockFormatPickerView: View {
    let onSelect: (BlockFormatType) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: Theme.spacing),
        GridItem(.flexible(), spacing: Theme.spacing)
    ]

    var body: some View {
        VStack(spacing: Theme.spacing) {
            LazyVGrid(columns: columns, spacing: Theme.spacing) {
                ForEach(BlockFormatType.allCases) { format in
                    BlockFormatPill(format: format) {
                        onSelect(format)
                    }
                }
            }
            .padding(.horizontal, Theme.spacing)
            .padding(.top, Theme.spacing)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThemeColors.background)
    }
}

// MARK: - Block Format Pill

struct BlockFormatPill: View {
    let format: BlockFormatType
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.smallSpacing) {
                if format.isCustomSymbol {
                    Image.customSymbol(format.icon, pointSize: 16, weight: .medium)
                } else {
                    Image(systemName: format.icon)
                        .font(.system(size: 16, weight: .medium))
                }

                Text(format.label)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()
            }
            .foregroundColor(ThemeColors.label)
            .padding(.horizontal, Theme.spacing)
            .padding(.vertical, Theme.smallSpacing + 4)
            .frame(maxWidth: .infinity)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.pillCornerRadius))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BlockFormatPickerView { format in
        print("Selected: \(format.label)")
    }
    .frame(height: 300)
    .preferredColorScheme(.dark)
}
