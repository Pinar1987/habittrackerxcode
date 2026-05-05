//
//  ContentView.swift
//  Habittrackerxcode
//
//  Created by Pinar Bildirici on 2026-04-30.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \habit.timestamp, order: .reverse) private var habits: [habit]
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
                Group {
            if habits.isEmpty {
                ContentUnavailableView("No Habits Yet", systemImage: "figure.walk", description: Text("Start your journey by adding a new habit!"))
                        } else {
            List {
                ForEach(habits) { item in
                    HStack(spacing: 12) {
                       
                        Capsule()
                            .fill(Color(hex: item.hexColor))
                            .frame(width: 4, height: 35)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.headline)
                            
                        
                            HStack(spacing: 4) {
                                Text("\(item.currentStreak) günlük seri")
                                Text("🔥")
                                    .opacity(item.currentStreak > 0 ? 1 : 0.3)
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }

                        Spacer()

                     
                        Button(action: {
                            if !item.isCompletedToday {
                                item.completedDates.append(Date())
                            }
                        }) {
                            Image(systemName: item.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundStyle(item.isCompletedToday ? .green : Color(hex: item.hexColor))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteItems)
                    }
                }
        
             }
                .navigationTitle("Habit Tracker")
                .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                #endif
            }
            .sheet(isPresented: $showingAddSheet) {
                AddHabitView()
            }
        }
     }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(habits[index])
        }
    }
}
// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}




