/*
Abstract:
Reusable view modifiers for common UI patterns.
*/

import SwiftUI

// MARK: - TextField Modifiers

extension View {
    /// Applies glass effect styling to text fields with standard padding
    func glassTextFieldStyle() -> some View {
        self
            .padding(Theme.spacing)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .padding(Theme.spacing)
    }

    /// Applies glass effect styling for search bars
    func glassSearchBarStyle() -> some View {
        self
            .padding(Theme.spacing)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .padding(Theme.spacing)
    }
}

// MARK: - Navigation Modifiers

extension View {
    /// Applies consistent glass styling for navigation bars
    func glassNavigationStyle() -> some View {
        self
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Container Modifiers

extension View {
    /// Applies glass effect with rounded corners for container views
    func glassContainerStyle(cornerRadius: CGFloat = Theme.cornerRadius) -> some View {
        self
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius))
    }

    /// Applies interactive glass effect for tappable containers
    func glassInteractiveContainerStyle(cornerRadius: CGFloat = Theme.cornerRadius) -> some View {
        self
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: cornerRadius))
    }
}
