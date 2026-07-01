//
//  InlineNameEntry.swift
//  Knitty
//
//  Created by Y. Khusanova on 26.04.26.
//

import SwiftUI

struct InlineNameEntry<Accessory: View>: View {
    let buttonLabel: String
    let placeholder: String
    let defaultName: String
    let existingNames: [String]
    let onSubmit: (String) -> Void
    let accessory: () -> Accessory

    @State private var isAdding = false
    @State private var name: String
    @State private var showValidationRules = false
    @FocusState private var isFocused: Bool

    init(
        buttonLabel: String,
        placeholder: String,
        defaultName: String,
        existingNames: [String],
        onSubmit: @escaping (String) -> Void,
        @ViewBuilder accessory: @escaping () -> Accessory = { EmptyView() }
    ) {
        self.buttonLabel = buttonLabel
        self.placeholder = placeholder
        self.defaultName = defaultName
        self.existingNames = existingNames
        self.onSubmit = onSubmit
        self.accessory = accessory
        self._name = State(initialValue: defaultName)
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !existingNames.contains(name)
    }

    var body: some View {
        Button(buttonLabel) {
            isAdding = true
            isFocused = true
        }
        if isAdding {
            accessory()
            TextField(placeholder, text: $name)
                .focused($isFocused)
                .onSubmit(handleSubmit)
            if showValidationRules {
                Text("Name must be unique and non-empty.")
            }
        }
    }

    private func handleSubmit() {
        guard isValid else {
            showValidationRules = true
            if existingNames.contains(name) {
                name += " (2)"
                isFocused = true
            }
            return
        }
        onSubmit(name)
        isAdding = false
        showValidationRules = false
        name = defaultName
    }
}
