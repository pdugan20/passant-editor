/*
Abstract:
Sheet for selecting or creating locations to insert as pills.
*/

import SwiftData
import SwiftUI

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var locations: [Location]

    @State private var searchText = ""
    @State private var showingNewLocationSheet = false

    let onSelect: (Location) -> Void

    // Reference location (Pike Place Market)
    private let referenceLatitude = 47.6097
    private let referenceLongitude = -122.3425

    // Emoji pools by location type
    private let emojiPools: [String: [String]] = [
        "Bar": ["🍺", "🍻", "🥃", "🍸", "🎱"],
        "Music Venue": ["🎵", "🎸", "🎤", "🎹", "🎷"],
        "Restaurant": ["🍽️", "🍕", "🍝", "🥘", "🍜"],
        "Cafe": ["☕", "🫖", "🥐", "🧁"]
    ]
    private let defaultEmojis = ["📍", "🏠", "🏢", "🗺️"]

    private func emojiForLocation(_ location: Location) -> String {
        let pool = location.type.flatMap { emojiPools[$0] } ?? defaultEmojis
        // Use location name hash for consistent random selection
        let index = abs(location.name.hashValue) % pool.count
        return pool[index]
    }

    var filteredLocations: [Location] {
        if searchText.isEmpty {
            return locations
        }
        return locations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private func calculateDistance(to location: Location) -> String {
        guard let lat = location.latitude, let lon = location.longitude else {
            return "? mi"
        }

        let latDiff = (lat - referenceLatitude) * 69.0
        let lonDiff = (lon - referenceLongitude) * 54.6
        let distance = sqrt(latDiff * latDiff + lonDiff * lonDiff)

        return String(format: "%.1f mi", distance)
    }

    private func formatLocationDetails(_ location: Location) -> String {
        var parts: [String] = []

        if let type = location.type {
            parts.append(type)
        }

        parts.append(calculateDistance(to: location))

        if let address = location.address {
            parts.append(address)
        }

        return parts.joined(separator: " • ")
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(filteredLocations.enumerated()), id: \.element.id) { index, location in
                    Button {
                        onSelect(location)
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            // Emoji icon box
                            Text(emojiForLocation(location))
                                .font(.title2)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(ThemeColors.secondaryBackground)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(location.name)
                                    .foregroundColor(ThemeColors.label)

                                Text(formatLocationDetails(location))
                                    .font(.caption)
                                    .foregroundColor(ThemeColors.secondaryLabel)
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                    }
                    .listRowSeparator(index == 0 ? .hidden : .automatic, edges: .top)
                }

                // Quick add from search
                if !searchText.isEmpty &&
                   !filteredLocations.contains(where: { $0.name.lowercased() == searchText.lowercased() }) {
                    Button {
                        addNewLocation(name: searchText)
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(ThemeColors.primary)

                            Text("Add \"\(searchText)\"")
                                .foregroundColor(ThemeColors.primary)

                            Spacer()
                        }
                        .padding(.vertical, Theme.smallSpacing)
                    }
                }
            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .searchable(text: $searchText, prompt: "Search locations")
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .background(ThemeColors.background)
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .sheet(isPresented: $showingNewLocationSheet) {
                NewLocationView { newLocation in
                    onSelect(newLocation)
                    showingNewLocationSheet = false
                    dismiss()
                }
            }
        }
    }

    private func addNewLocation(name: String) {
        let newLocation = Location(name: name)
        modelContext.insert(newLocation)
        onSelect(newLocation)
        dismiss()
    }
}

// MARK: - New Location View

struct NewLocationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var locationName = ""

    let onAdd: (Location) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.spacing) {
                TextField("Location Name", text: $locationName)
                    .font(.title3)
                    .padding(Theme.spacing)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    .padding(Theme.spacing)

                Spacer()
            }
            .background(ThemeColors.background)
            .navigationTitle("New Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        addLocation()
                    }
                    .disabled(locationName.isEmpty)
                }
            }
        }
    }

    private func addLocation() {
        let newLocation = Location(name: locationName)
        modelContext.insert(newLocation)
        onAdd(newLocation)
    }
}

#Preview("Location Picker") {
    LocationPickerView { _ in }
        .modelContainer(for: Location.self, inMemory: true)
        .preferredColorScheme(.dark)
}

#Preview("New Location Sheet") {
    NewLocationView { _ in }
        .modelContainer(for: Location.self, inMemory: true)
        .preferredColorScheme(.dark)
}
