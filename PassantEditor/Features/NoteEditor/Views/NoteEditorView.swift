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
    @State private var lastKeyboardHeight: CGFloat = 260
    @State private var preSheetKeyboardHeight: CGFloat = 0
    @State private var ignoreKeyboardUntil: Date = .distantPast
    @State private var toolbarMode: ToolbarMode = .main
    @State private var showBlockFormatPicker = false
    @State private var keyboardObserversSetUp = false
    @FocusState private var isEditorFocused: Bool
    @Environment(\.modelContext) private var modelContext

    private let toolbarHeight: CGFloat = 49

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

                // Content editor
                if let viewModel = viewModel {
                    ZStack(alignment: .topLeading) {
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
                        .focused($isEditorFocused)

                        // Ghost text overlay
                        if let ghostText = viewModel.ghostText {
                            GhostTextOverlay(
                                text: ghostText,
                                contentLineCount: viewModel.text.characters.filter { $0 == "\n" }.count
                            )
                        }
                    }
                    .frame(minHeight: 500)
                    .padding(Theme.spacing)
                }
            }
            .padding(.bottom, bottomPadding)
        }
        .scrollDismissesKeyboard(.interactively)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(ThemeColors.background)
        .attributedTextFormattingDefinition(
            NoteFormattingDefinition(
                locations: locationIDs
            )
        )
        .overlay {
            GeometryReader { geo in
                let screenHeight = geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom

                // Show toolbar when: keyboard visible, block picker open, location sheet showing, OR transitioning from sheet
                if keyboardHeight > 0 || showBlockFormatPicker || showingLocationPicker || preSheetKeyboardHeight > 0 {
                    let gridHeight = showBlockFormatPicker ? lastKeyboardHeight : 0
                    let contentHeight = toolbarHeight + gridHeight
                    let toolbarGap: CGFloat = 4
                    let effectiveKeyboardHeight = preSheetKeyboardHeight > 0 ? preSheetKeyboardHeight : keyboardHeight
                    let bottomOffset = (showBlockFormatPicker ? 0 : effectiveKeyboardHeight) + toolbarGap
                    let yPos = screenHeight - bottomOffset - contentHeight / 2

                    VStack(spacing: 0) {
                        toolbarContent

                        if showBlockFormatPicker {
                            BlockFormatPickerView { format in
                                handleBlockFormatSelection(format)
                            }
                            .frame(height: lastKeyboardHeight)
                        }
                    }
                    .frame(width: geo.size.width)
                    .position(
                        x: geo.size.width / 2,
                        y: yPos
                    )
                }
            }
            .ignoresSafeArea()
        }
        .onChange(of: showingLocationPicker) { old, new in
            if new {
                preSheetKeyboardHeight = keyboardHeight
            } else {
                ignoreKeyboardUntil = Date().addingTimeInterval(0.5)
            }
        }
        .onAppear {
            setupKeyboardObservers()

            if viewModel == nil {
                viewModel = NoteEditorViewModel(note: note)
            }

            if let vm = viewModel {
                locationIDs = vm.locationIDsFromContent()
            }
        }
        .onChange(of: note.content) { _, _ in
            if let vm = viewModel {
                locationIDs = vm.locationIDsFromContent()
            }
        }
        .onDisappear {
            removeKeyboardObservers()
        }
        .sheet(isPresented: $showingLocationPicker, onDismiss: {
            keyboardHeight = preSheetKeyboardHeight
            preSheetKeyboardHeight = 0
            isEditorFocused = true
        }) {
            LocationPickerView { location in
                viewModel?.insertLocation(location)
                showingLocationPicker = false
            }
        }
        .onChange(of: toolbarMode) { oldValue, newValue in
            handleToolbarModeChange(from: oldValue, to: newValue)
        }
    }

    // MARK: - Computed Properties

    private var bottomPadding: CGFloat {
        if showBlockFormatPicker {
            return lastKeyboardHeight + toolbarHeight + 16
        } else if keyboardHeight > 0 {
            return keyboardHeight + toolbarHeight + 16
        }
        return 0
    }

    // MARK: - Actions

    private func handleToolbarModeChange(from oldValue: ToolbarMode, to newValue: ToolbarMode) {
        if newValue == .blockFormats {
            showBlockFormatPicker = true
            isEditorFocused = false
        } else if oldValue == .blockFormats && newValue == .main {
            keyboardHeight = lastKeyboardHeight
            showBlockFormatPicker = false
            isEditorFocused = true
        } else if oldValue == .blockFormats && newValue == .textStyles {
            keyboardHeight = lastKeyboardHeight
            showBlockFormatPicker = false
            isEditorFocused = true
        }
    }

    private func handleBlockFormatSelection(_ format: BlockFormatType) {
        viewModel?.insertBlockFormat(format)
        keyboardHeight = lastKeyboardHeight
        showBlockFormatPicker = false
        toolbarMode = .main
        isEditorFocused = true
    }

    private func setupKeyboardObservers() {
        guard !keyboardObserversSetUp else { return }
        keyboardObserversSetUp = true

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25

                // Skip notifications within the ignore window (after sheet dismiss)
                if Date() < ignoreKeyboardUntil {
                    return
                }

                if duration > 0 {
                    withAnimation(.easeOut(duration: duration)) {
                        keyboardHeight = keyboardFrame.height
                    }
                } else {
                    keyboardHeight = keyboardFrame.height
                }
                lastKeyboardHeight = keyboardFrame.height
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { notification in
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
            withAnimation(.easeOut(duration: duration)) {
                keyboardHeight = 0
            }
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
        MainFormattingToolbar(
            viewModel: viewModel,
            toolbarMode: $toolbarMode,
            showingLocationPicker: $showingLocationPicker
        )
        .padding(.horizontal, Theme.smallSpacing)
        .frame(height: 49)
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.clear)
                .glassEffect()
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 13)
    }
}

// MARK: - Ghost Text Overlay

private struct GhostTextOverlay: View {
    let text: String
    let contentLineCount: Int

    private let lineHeight: CGFloat = 22

    var body: some View {
        Text(text)
            .font(.body)
            .foregroundColor(ThemeColors.tertiaryLabel)
            .padding(.top, 8 + CGFloat(contentLineCount) * lineHeight)
            .padding(.leading, 5)
            .allowsHitTesting(false)
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
