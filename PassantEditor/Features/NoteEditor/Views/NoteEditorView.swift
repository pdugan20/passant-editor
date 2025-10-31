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
    @State private var locationIDs: Set<Location.ID> = []
    @State private var keyboardHeight: CGFloat = 0
    @AppStorage("toolbarVersion") private var toolbarVersion: Int = 1
    @Environment(\.modelContext) private var modelContext

    private let toolbarHeight: CGFloat = 54

    var body: some View {
        ScrollView {
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
                    .scrollDisabled(true)
                    .frame(minHeight: 500)
                    .padding(Theme.spacing)
                }
            }
            .padding(.bottom, keyboardHeight > 0 ? keyboardHeight + toolbarHeight + 16 : 0)
        }
        .scrollDismissesKeyboard(.interactively)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(ThemeColors.background)
        .attributedTextFormattingDefinition(
            NoteFormattingDefinition(
                locations: locationIDs
            )
        )
        .overlay(alignment: .bottom) {
            if keyboardHeight > 0 {
                toolbarContent
                    .ignoresSafeArea(.container, edges: .horizontal)
            }
        }
        .onAppear {
            setupKeyboardObservers()

            if viewModel == nil {
                viewModel = NoteEditorViewModel(note: note)
            }

            // Extract location IDs directly from the attributed text content
            // This ensures we use the same backing type as stored in the content
            if let vm = viewModel {
                locationIDs = vm.locationIDsFromContent()
            }
        }
        .onChange(of: note.content) { _, _ in
            // When content changes, update location IDs from content
            if let vm = viewModel {
                locationIDs = vm.locationIDsFromContent()
            }
        }
        .onDisappear {
            removeKeyboardObservers()
        }
        .sheet(isPresented: $showingLocationPicker) {
            LocationPickerView { location in
                viewModel?.insertLocation(location)
                showingLocationPicker = false
            }
        }
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            keyboardHeight = 0
        }
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @ViewBuilder
    private var toolbarContent: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .glassEffect()
                .frame(maxWidth: .infinity)

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
                default:
                    SimpleFormattingToolbar(
                        viewModel: viewModel,
                        showingLocationPicker: $showingLocationPicker
                    )
                }
            }
        }
        .frame(height: 54)
        .padding(.horizontal, 8)
        .padding(.bottom, 16)
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
