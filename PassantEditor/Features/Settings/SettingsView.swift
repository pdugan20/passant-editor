/*
Abstract:
Settings view for resetting prototype data.
*/

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var showingResetAlert = false

    var body: some View {
        NavigationStack {
            List {
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
