import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(false)
                }
                Section("Notes (optional)") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveHabit() }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveHabit() {
        // Attempt to create and insert a new habit using the available model.
        // The existing model in ContentView shows `habit(timestamp: Date())`.
        // We'll create the same and ignore name/notes if those properties don't exist yet.
        let newItem = habit(timestamp: Date())
        // If you later add properties like `title` or `notes` to `habit`, set them here.
        // Example:
        // newItem.title = name
        // newItem.notes = notes
        modelContext.insert(newItem)
        dismiss()
    }
}

#Preview {
    AddHabitView()
        .modelContainer(for: habit.self, inMemory: true)
}
