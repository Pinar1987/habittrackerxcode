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
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        if !item.notes.isEmpty {
                            Text(item.notes)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
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




