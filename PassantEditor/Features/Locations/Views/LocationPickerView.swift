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

    var filteredLocations: [Location] {
        if searchText.isEmpty {
            return locations
        }
        return locations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredLocations) { location in
                    Button {
                        onSelect(location)
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(location.name)
                                    .foregroundColor(ThemeColors.label)

                                if let latitude = location.latitude, let longitude = location.longitude {
                                    Text("lat: \(String(format: "%.2f", latitude)), " +
                                         "long: \(String(format: "%.2f", longitude))")
                                        .font(.caption)
                                        .foregroundColor(ThemeColors.secondaryLabel)
                                } else {
                                    Text("No location data")
                                        .font(.caption)
                                        .foregroundColor(ThemeColors.secondaryLabel)
                                }
                            }

                            Spacer()
                        }
                        .padding(.vertical, Theme.smallSpacing)
                    }
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

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewLocationSheet = true
                    } label: {
                        Image(systemName: "plus")
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
