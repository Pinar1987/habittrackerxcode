import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var notes = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    
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
            .alert("Oops!", isPresented: $showAlert) {
                Button("Okej", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    private func saveHabit() {
        
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "please write your habit name!"
            showAlert = true
        } else {
            // save the habit to the database
            let newHabit = habit(name: name, notes: notes)
            modelContext.insert(newHabit)
            
            // notifications are scheduled when the habit is created
            NotificationManager.instance.scheduleNotification(habitName: name)
            
            dismiss()
        }
    }
}
