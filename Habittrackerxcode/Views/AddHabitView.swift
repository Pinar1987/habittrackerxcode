import SwiftUI
import SwiftData


struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Habit Details") {
                    TextField("Habit Name", text: $name)
                    TextField("Notes (Optional)", text: $notes)
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newHabit = habit(name: name, notes: notes)
                        modelContext.insert(newHabit)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
