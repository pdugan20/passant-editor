/*
Abstract:
Reusable formatting button component used across all toolbar variants.
*/

import SwiftUI

struct FormatButton: View {
    let icon: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
        }
        .toolbarButtonStyle(isActive: isActive)
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Inactive State")
            .font(.caption)
            .foregroundColor(ThemeColors.secondaryLabel)

        HStack(spacing: 12) {
            FormatButton(icon: "bold", isActive: false) {}
            FormatButton(icon: "italic", isActive: false) {}
            FormatButton(icon: "underline", isActive: false) {}
            FormatButton(icon: "strikethrough", isActive: false) {}
        }

        Text("Active State")
            .font(.caption)
            .foregroundColor(ThemeColors.secondaryLabel)
            .padding(.top)

        HStack(spacing: 12) {
            FormatButton(icon: "bold", isActive: true) {}
            FormatButton(icon: "italic", isActive: true) {}
            FormatButton(icon: "underline", isActive: true) {}
            FormatButton(icon: "strikethrough", isActive: true) {}
        }
    }
    .padding()
    .background(ThemeColors.background)
    .preferredColorScheme(.dark)
}
