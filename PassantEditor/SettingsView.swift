/*
Abstract:
Settings view for configuring toolbar versions and resetting prototype data.
*/

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @AppStorage("toolbarVersion") private var toolbarVersion: Int = 1

    @State private var showingResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: Theme.spacing) {
                        Text("Toolbar Version")
                            .font(.headline)

                        Picker("Toolbar Version", selection: $toolbarVersion) {
                            Text("Simple").tag(1)
                            Text("Grouped").tag(2)
                            Text("Compact").tag(3)
                        }
                        .pickerStyle(.segmented)

                        Text("Switch between different keyboard toolbar layouts to test which works best.")
                            .font(.caption)
                            .foregroundColor(ThemeColors.secondaryLabel)
                    }
                    .padding(.vertical, Theme.smallSpacing)
                } header: {
                    Text("Editor")
                }

                Section {
                    Text("Version 1: Simple")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Horizontal scrolling toolbar with all formatting options visible as icons.")
                        .font(.caption)
                        .foregroundColor(ThemeColors.secondaryLabel)

                    Text("Version 2: Grouped")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.top, Theme.smallSpacing)
                    Text("Formatting options organized into visual groups (Style, Heading, Lists, Location).")
                        .font(.caption)
                        .foregroundColor(ThemeColors.secondaryLabel)

                    Text("Version 3: Compact")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.top, Theme.smallSpacing)
                    Text("Most common actions visible, with less-used options in an overflow menu.")
                        .font(.caption)
                        .foregroundColor(ThemeColors.secondaryLabel)
                } header: {
                    Text("About Toolbar Versions")
                }

                Section {
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset Prototype Data")
                        }
                    }
                } header: {
                    Text("Data")
                } footer: {
                    Text("This will delete all notes and regenerate the 3 sample notes.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }
            }
            .alert("Reset Prototype Data?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    resetData()
                }
            } message: {
                Text("This will delete all existing notes and restore the 3 sample notes.")
            }
        }
    }

    @MainActor
    private func resetData() {
        SampleDataGenerator.generateSampleData(context: modelContext)
        dismiss()
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Note.self, inMemory: true)
        .preferredColorScheme(.dark)
}
