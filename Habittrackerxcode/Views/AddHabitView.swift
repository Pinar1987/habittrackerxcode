import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var notes = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var selectedColor = Color.blue
    @State private var reminderTime = Date()
    @State private var isReminderEnabled = false
    @State private var targetDays: Int = 5
   
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Send Notification", isOn: $isReminderEnabled)
                        .tint(.blue)
                    
                    if isReminderEnabled {
                        DatePicker("Choose Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("Challenge Goal")) {
                    Picker("Target Days", selection: $targetDays) {
                        Text("5 Days").tag(5)
                        Text("10 Days").tag(10)
                        Text("30 Days").tag(30)
                        Text("100 Days").tag(100)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Goal: Maintain this habit for \(targetDays) days to complete the challenge!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                    
                
                Section("Habit Details") {
                    TextField("Habit Name", text: $name)
                    TextField("Notes (Optional)", text: $notes)
                    ColorPicker("Choose a color", selection: $selectedColor, supportsOpacity: false)
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHabit()
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
            let hexString = selectedColor.toHex() ?? "#3498db"
            
            let newHabit = habit(
                name: name,
                notes: notes,
                timestamp: Date(),
                hexColor: hexString
            )
            
            modelContext.insert(newHabit)
            
           
            if isReminderEnabled {
                NotificationManager.instance.scheduleNotification(habitName: name, at: reminderTime)
            }
            
           
            dismiss()
        }
    }
}

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else { return nil }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
