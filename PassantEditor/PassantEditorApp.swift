//
//  PassantEditorApp.swift
//  PassantEditor
//
//  Created by Patrick Dugan on 10/31/25.
//

import SwiftData
import SwiftUI

@main
struct PassantEditorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
            Location.self,
            AttributedStringModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var hasInitializedSampleData = false

    var body: some Scene {
        WindowGroup {
            NoteListView()
                .preferredColorScheme(.dark)
                .onAppear {
                    if !hasInitializedSampleData {
                        initializeSampleData()
                        hasInitializedSampleData = true
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }

    @MainActor
    private func initializeSampleData() {
        let context = sharedModelContainer.mainContext

        // Check if we already have notes
        let descriptor = FetchDescriptor<Note>()
        let existingNotes = (try? context.fetch(descriptor)) ?? []

        // Only generate sample data if empty
        if existingNotes.isEmpty {
            SampleDataGenerator.generateSampleData(context: context)
        }
    }
}
