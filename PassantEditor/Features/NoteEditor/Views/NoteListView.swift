/*
Abstract:
The main list view showing all notes.
*/

import SwiftData
import SwiftUI

struct NoteListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Note.lastModified, order: .reverse) private var notes: [Note]
    @State private var showingSettings = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteEditorView(note: note)) {
                        NoteRowView(note: note)
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                    .buttonStyle(.glass)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addNote()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.glass)
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .buttonStyle(.glass)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        } detail: {
            Text("Select a note")
                .font(.largeTitle)
                .foregroundColor(ThemeColors.secondaryLabel)
        }
    }

    private func addNote() {
        withAnimation(Theme.springAnimation) {
            let newNote = Note()
            modelContext.insert(newNote)
        }
    }

    private func deleteNotes(offsets: IndexSet) {
        withAnimation(Theme.springAnimation) {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}

// MARK: - Note Row

struct NoteRowView: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallSpacing) {
            Text(note.title.isEmpty ? "Untitled" : note.title)
                .font(.headline)
                .foregroundColor(ThemeColors.label)

            if !note.content.characters.isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.secondaryLabel)
                    .lineLimit(2)
            }

            Text(note.lastModified, format: .relative(presentation: .named))
                .font(.caption)
                .foregroundColor(ThemeColors.tertiaryLabel)
        }
        .padding(.vertical, Theme.smallSpacing)
    }
}

#Preview("Note List") {
    NoteListView()
        .modelContainer(for: Note.self, inMemory: true)
        .preferredColorScheme(.dark)
}

#Preview("Note Row States") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)

    let noteWithContent = Note(title: "My Favorite Places", content: "A collection of amazing spots in Seattle")
    let noteEmpty = Note(title: "Untitled Note", content: "")
    let noteLongContent = Note(
        title: "Best Coffee Shops",
        content: """
        This is a longer note with more content to show how the preview handles text truncation. \
        It should show an ellipsis after two lines.
        """
    )

    container.mainContext.insert(noteWithContent)
    container.mainContext.insert(noteEmpty)
    container.mainContext.insert(noteLongContent)

    return List {
        NoteRowView(note: noteWithContent)
        NoteRowView(note: noteEmpty)
        NoteRowView(note: noteLongContent)
    }
    .modelContainer(container)
    .preferredColorScheme(.dark)
}
