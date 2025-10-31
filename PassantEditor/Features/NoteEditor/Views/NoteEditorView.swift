/*
Abstract:
The rich text editor for note content.
*/

import SwiftData
import SwiftUI

struct NoteEditorView: View {
    @Bindable var note: Note
    @State private var viewModel: NoteEditorViewModel?
    @State private var showingLocationPicker = false
    @AppStorage("toolbarVersion") private var toolbarVersion: Int = 1
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            // Title field
            TextField("Title", text: $note.title, axis: .vertical)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1...5)
                .padding(.horizontal, Theme.spacing)
                .padding(.top, Theme.spacing)

            Divider()
                .padding(.vertical, 4)

            // Content editor
            if let viewModel = viewModel {
                TextEditor(
                    text: Binding(
                        get: { viewModel.text },
                        set: { viewModel.text = $0 }
                    ),
                    selection: Binding(
                        get: { viewModel.selection },
                        set: { viewModel.selection = $0 }
                    )
                )
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
            if viewModel == nil {
                viewModel = NoteEditorViewModel(note: note)
            }
        }
        .sheet(isPresented: $showingLocationPicker) {
            LocationPickerView { location in
                viewModel?.insertLocation(location)
                showingLocationPicker = false
            }
        }
    }

    @ViewBuilder
    private var toolbarContent: some View {
        Group {
            switch toolbarVersion {
            case 1:
                SimpleFormattingToolbar(
                    viewModel: viewModel,
                    showingLocationPicker: $showingLocationPicker
                )
            case 2:
                CompactFormattingToolbar(
                    viewModel: viewModel,
                    showingLocationPicker: $showingLocationPicker
                )
            case 3:
                ContextualFormattingToolbar(
                    viewModel: viewModel,
                    showingLocationPicker: $showingLocationPicker
                )
            case 4:
                SegmentedFormattingToolbar(
                    viewModel: viewModel,
                    showingLocationPicker: $showingLocationPicker
                )
            default:
                SimpleFormattingToolbar(
                    viewModel: viewModel,
                    showingLocationPicker: $showingLocationPicker
                )
            }
        }
        .padding(.bottom, Theme.spacing)
        .padding(.horizontal, 8)
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
