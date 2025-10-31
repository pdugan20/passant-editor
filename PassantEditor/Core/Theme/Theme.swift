/*
Abstract:
Theme constants and styling helpers for dark mode with Liquid Glass effects.
*/

import SwiftUI

enum Theme {
    // MARK: - Spacing
    static let smallSpacing: CGFloat = 8
    static let spacing: CGFloat = 16
    static let largeSpacing: CGFloat = 24
    static let extraLargeSpacing: CGFloat = 32

    // MARK: - Corner Radius
    static let smallCornerRadius: CGFloat = 8
    static let cornerRadius: CGFloat = 12
    static let largeCornerRadius: CGFloat = 16
    static let pillCornerRadius: CGFloat = 8

    // MARK: - Animations
    static let springAnimation: Animation = .spring(response: 0.3, dampingFraction: 0.7)
    static let smoothAnimation: Animation = .smooth(duration: 0.3)
}

// MARK: - Theme Colors

enum ThemeColors {
    static let background = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let tertiaryBackground = Color(uiColor: .tertiarySystemBackground)

    static let label = Color(uiColor: .label)
    static let secondaryLabel = Color(uiColor: .secondaryLabel)
    static let tertiaryLabel = Color(uiColor: .tertiaryLabel)

    static let primary = Color.red
    static let accent = Color.red

    static let locationPill = Color.red.opacity(0.2)
    static let locationPillText = Color.red

    static let glassStroke = Color.white.opacity(0.2)
}

// MARK: - View Modifiers

struct GlassCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
}

struct GlassInteractiveCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
}

struct NoteCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Theme.spacing)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
}

struct ToolbarButtonStyle: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeColors.label)
            .padding(6)
            .background {
                if isActive {
                    Circle()
                        .fill(ThemeColors.primary)
                }
            }
    }
}

// MARK: - View Extensions

extension View {
    func glassCardStyle() -> some View {
        modifier(GlassCardStyle())
    }

    func glassInteractiveCardStyle() -> some View {
        modifier(GlassInteractiveCardStyle())
    }

    func noteCardStyle() -> some View {
        modifier(NoteCardStyle())
    }

    func toolbarButtonStyle(isActive: Bool = false) -> some View {
        modifier(ToolbarButtonStyle(isActive: isActive))
    }
}
