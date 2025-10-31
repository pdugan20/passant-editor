/*
Abstract:
The rich text editor for note content.
*/

import SwiftData
import SwiftUI

struct NoteEditorView: View {
    @Bindable var note: Note
    @State private var editableText: EditableNoteText?
    @State private var showingLocationPicker = false
    @AppStorage("toolbarVersion") private var toolbarVersion: Int = 1
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            // Title field
            TextField("Title", text: $note.title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(Theme.spacing)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
                .padding([.horizontal, .top], Theme.spacing)

            Divider()
                .padding(.vertical, Theme.smallSpacing)

            // Content editor
            if let editableText = editableText {
                TextEditor(text: Binding(
                    get: { editableText.text },
                    set: { editableText.text = $0 }
                ), selection: Binding(
                    get: { editableText.selection },
                    set: { editableText.selection = $0 }
                ))
                .font(.body)
                .scrollContentBackground(.hidden)
                .padding(Theme.spacing)
            }
        }
        .background(ThemeColors.background)
        .attributedTextFormattingDefinition(
            NoteFormattingDefinition(
                locations: Set(note.locations.map { $0.id })
            )
        )
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                toolbarContent
            }
        }
        .onAppear {
            if editableText == nil {
                editableText = EditableNoteText(note: note)
            }
        }
        .sheet(isPresented: $showingLocationPicker) {
            LocationPickerView { location in
                editableText?.insertLocation(location)
                showingLocationPicker = false
            }
        }
    }

    @ViewBuilder
    private var toolbarContent: some View {
        switch toolbarVersion {
        case 1:
            FormattingToolbarV1(
                editableText: editableText,
                showingLocationPicker: $showingLocationPicker
            )
        case 2:
            FormattingToolbarV2(
                editableText: editableText,
                showingLocationPicker: $showingLocationPicker
            )
        case 3:
            FormattingToolbarV3(
                editableText: editableText,
                showingLocationPicker: $showingLocationPicker
            )
        default:
            FormattingToolbarV1(
                editableText: editableText,
                showingLocationPicker: $showingLocationPicker
            )
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    let note = Note(title: "Preview Note", content: "Sample content")
    container.mainContext.insert(note)

    return NavigationStack {
        NoteEditorView(note: note)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
