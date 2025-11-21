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
    @State private var toolbarMode: ToolbarMode = .main
    @State private var showBlockFormatPicker = false
    @State private var keyboardObserversSetUp = false
    @FocusState private var isEditorFocused: Bool
    @Environment(\.modelContext) private var modelContext

    private let toolbarHeight: CGFloat = 49
    private let debug = true

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
                if keyboardHeight > 0 || showBlockFormatPicker {
                    let gridHeight = showBlockFormatPicker ? lastKeyboardHeight : 0
                    let contentHeight = toolbarHeight + gridHeight
                    let toolbarGap: CGFloat = 4
                    // Keep toolbar at consistent position - always toolbarGap above keyboard/grid area
                    let bottomOffset = (showBlockFormatPicker ? 0 : keyboardHeight) + toolbarGap

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
                        y: geo.size.height - bottomOffset - contentHeight / 2
                    )
                }
            }
            .ignoresSafeArea()
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

    private func log(_ message: String) {
        if debug {
            print("[NoteEditor] \(message)")
        }
    }

    private func handleToolbarModeChange(from oldValue: ToolbarMode, to newValue: ToolbarMode) {
        log("toolbarMode: \(oldValue) -> \(newValue)")

        if newValue == .blockFormats {
            // Set flag BEFORE dismissing keyboard so it's ready when keyboard hides
            log("Setting showBlockFormatPicker = true")
            showBlockFormatPicker = true
            // Now dismiss keyboard - grid will be revealed as it hides
            isEditorFocused = false
            log("Set isEditorFocused = false")
        } else if oldValue == .blockFormats && newValue == .main {
            // Closing block picker without selection - restore keyboard
            log("Closing block picker, setting showBlockFormatPicker = false")
            // Set keyboardHeight first to prevent toolbar flash during transition
            keyboardHeight = lastKeyboardHeight
            showBlockFormatPicker = false
            isEditorFocused = true
            log("Set isEditorFocused = true to restore keyboard")
        } else if oldValue == .blockFormats && newValue == .textStyles {
            // Switching from block picker to text styles
            log("Switching to textStyles, setting showBlockFormatPicker = false")
            keyboardHeight = lastKeyboardHeight
            showBlockFormatPicker = false
            isEditorFocused = true
        }
    }

    private func handleBlockFormatSelection(_ format: BlockFormatType) {
        log("Selected block format: \(format)")
        viewModel?.insertBlockFormat(format)
        // Set keyboardHeight first to prevent toolbar flash during transition
        keyboardHeight = lastKeyboardHeight
        showBlockFormatPicker = false
        toolbarMode = .main
        // Re-focus to bring keyboard back
        isEditorFocused = true
        log("Block format applied, restored keyboard focus")
    }

    private func setupKeyboardObservers() {
        guard !keyboardObserversSetUp else {
            log("Keyboard observers already set up, skipping")
            return
        }
        keyboardObserversSetUp = true
        log("Setting up keyboard observers")

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
                log("Keyboard will show, height: \(keyboardFrame.height), duration: \(duration)")
                withAnimation(.easeOut(duration: duration)) {
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
            log("Keyboard will hide, showBlockFormatPicker: \(showBlockFormatPicker), duration: \(duration)")
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
        .onAppear { log("MainFormattingToolbar appeared") }
    }
}

// MARK: - Ghost Text Overlay

private struct GhostTextOverlay: View {
    let text: String
    let contentLineCount: Int

    // Approximate line height for body font
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
