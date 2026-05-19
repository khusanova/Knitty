//
//  EditorView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI

struct EditorView: View {
    var viewModel: ProjectViewModel
    let partIndex: Int

    private struct DisplayGroup: Identifiable {
        let id: String
        let rowGroupID: UUID?
        let startIndex: Int
        let repeatCount: Int
        let rows: [Row]
    }

    private var displayGroups: [DisplayGroup] {
        let order = viewModel.project.projectParts[partIndex].rowGroupOrder
        guard !order.isEmpty else {
            return [DisplayGroup(id: "placeholder", rowGroupID: nil, startIndex: 0, repeatCount: 1, rows: [])]
        }
        var groups: [DisplayGroup] = []
        var currentID: UUID? = nil
        var currentStart = 0
        var currentCount = 0
        var groupIndex = 0
        let flush = {
            if let id = currentID {
                let rowsForID = viewModel.project.rowGroups[id]?.rows ?? []
                groups.append(DisplayGroup(
                    id: "\(id.uuidString)-\(groupIndex)",
                    rowGroupID: id,
                    startIndex: currentStart,
                    repeatCount: currentCount,
                    rows: rowsForID
                ))
                groupIndex += 1
            }
        }
        for (i, id) in order.enumerated() {
            if id == currentID {
                currentCount += 1
            } else {
                flush()
                currentID = id
                currentStart = i
                currentCount = 1
            }
        }
        flush()
        return groups
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(displayGroups) { group in
                    RowGroupBlock(
                        repeatCount: group.repeatCount,
                        rows: group.rows,
                        onAddRow: { instructions in
                            if let id = group.rowGroupID {
                                viewModel.appendRow(toRowGroupID: id, instructions: instructions)
                            } else {
                                viewModel.addRowToNewRowGroup(toPartIndex: partIndex, instructions: instructions)
                            }
                        },
                        onChangeRepeatCount: group.rowGroupID.map { _ in
                            { newCount in
                                viewModel.setRowGroupRepeatCount(
                                    toPartIndex: partIndex,
                                    atOrderIndex: group.startIndex,
                                    oldCount: group.repeatCount,
                                    newCount: newCount
                                )
                            }
                        },
                        onDelete: group.rowGroupID.map { _ in
                            {
                                viewModel.deleteRowGroup(
                                    fromPartIndex: partIndex,
                                    atOrderIndex: group.startIndex,
                                    oldCount: group.repeatCount
                                )
                            }
                        }
                    )
                }
                Button {
                    viewModel.addEmptyRowGroup(toPartIndex: partIndex)
                } label: {
                    Label("Add new row group", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle(viewModel.project.projectParts[partIndex].name)
    }
}

private struct RowGroupBlock: View {
    let repeatCount: Int
    let rows: [Row]
    let onAddRow: (String) -> Void
    let onChangeRepeatCount: ((Int) -> Void)?
    let onDelete: (() -> Void)?

    @State private var isAddingRow = false
    @State private var newInstructions = ""
    @State private var showDeleteConfirm = false
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("[")
                .font(.system(size: 100, weight: .ultraLight))
                .foregroundStyle(.primary)
            VStack(spacing: 8) {
                ForEach(rows) { row in
                    RowBlock(text: row.instructions)
                }
                if isAddingRow {
                    TextField("Row instructions", text: $newInstructions)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                        .onSubmit(submitNewRow)
                } else {
                    Button {
                        isAddingRow = true
                        isFocused = true
                    } label: {
                        Label("Add row", systemImage: "plus")
                    }
                }
            }
            .padding(.vertical, 12)
            Text("]")
                .font(.system(size: 100, weight: .ultraLight))
                .foregroundStyle(.primary)
            VStack(spacing: 4) {
                Text("× \(repeatCount)")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                if let onChangeRepeatCount {
                    Stepper(
                        "",
                        value: Binding(
                            get: { repeatCount },
                            set: { onChangeRepeatCount($0) }
                        ),
                        in: 1...99
                    )
                    .labelsHidden()
                }
                if repeatCount == 1, onDelete != nil {
                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .alert("Delete this row group?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) { onDelete?() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove all of its rows.")
        }
    }

    private func submitNewRow() {
        let trimmed = newInstructions.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            isAddingRow = false
            newInstructions = ""
            return
        }
        onAddRow(trimmed)
        newInstructions = ""
        isAddingRow = false
    }
}

private struct RowBlock: View {
    let text: String

    var body: some View {
        Text(text)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.secondary.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        EditorView(viewModel: ProjectViewModel(store: ProjectStore()), partIndex: 0)
    }
}
