/*
Abstract:
Reusable formatting button component used across all toolbar variants.
*/

import SwiftUI

// MARK: - Custom Symbol Helper

extension Image {
    static func customSymbol(
        _ name: String,
        pointSize: CGFloat = 18,
        weight: UIImage.SymbolWeight = .medium
    ) -> Image {
        if let configuredImage = UIImage(named: name)?
            .applyingSymbolConfiguration(
                UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
            ) {
            let templateImage = configuredImage.withRenderingMode(.alwaysTemplate)
            return Image(uiImage: templateImage)
        }
        // Fallback to system symbol if custom symbol not found
        return Image(systemName: name)
    }
}

// MARK: - Format Button

struct FormatButton: View {
    let icon: String
    let isActive: Bool
    let isCustomSymbol: Bool
    let action: () -> Void

    init(icon: String, isActive: Bool, isCustomSymbol: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.isActive = isActive
        self.isCustomSymbol = isCustomSymbol
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            if isCustomSymbol {
                Image.customSymbol(icon, pointSize: 18, weight: .medium)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .toolbarButtonStyle(isActive: isActive)
        .frame(minWidth: 44, minHeight: 44)
        .contentShape(Rectangle())
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
