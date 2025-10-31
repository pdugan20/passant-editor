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
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ThemeColors.secondaryLabel)

                    TextField("Search locations...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(Theme.spacing)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
                .padding(Theme.spacing)

                // Locations list
                List {
                    ForEach(filteredLocations) { location in
                        Button {
                            onSelect(location)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(ThemeColors.locationPillText)

                                Text(location.name)
                                    .foregroundColor(ThemeColors.label)

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
            }
            .background(ThemeColors.background)
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewLocationSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.glass)
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
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        addLocation()
                    }
                    .buttonStyle(.glass)
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

#Preview {
    LocationPickerView { _ in }
        .modelContainer(for: Location.self, inMemory: true)
        .preferredColorScheme(.dark)
}
