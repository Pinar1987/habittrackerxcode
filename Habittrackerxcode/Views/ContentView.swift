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
                   
                    ContentUnavailableView {
                        Label("No Habits Yet", systemImage: "figure.walk.circle.fill")
                    } description: {
                        Text("Start your journey by adding a new habit!")
                    } actions: {
                        Button("Add My First Habit") {
                            showingAddSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                } else {
               
                    List {
                        ForEach(habits) { item in
                           
                            HStack(spacing: 15) {
                                
                                // Process Cirkular Ring//
                                CircularProgressView(progress: item.isCompletedToday ? 1.0 : 0.0, color: Color(hex: item.hexColor))
                                    .frame(width: 45, height: 45)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                     
                                        .strikethrough(item.isCompletedToday, color: .secondary)
                                    
                                    HStack(spacing: 4) {
                                        
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(item.currentStreak > 0 ? .orange : .gray)
                                        Text("\(item.currentStreak) günlük seri")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }

                                Spacer()

                   
                                Button(action: {
                                   
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        if !item.isCompletedToday {
                                            item.completedDates.append(Date())
                                     
                                            let generator = UIImpactFeedbackGenerator(style: .medium)
                                            generator.impactOccurred()
                                        }
                                    }
                                }) {
                                    Image(systemName: item.isCompletedToday ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 28))
                                        .foregroundStyle(item.isCompletedToday ? .green : Color(hex: item.hexColor))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
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



//  (CircularProgressView) style //
struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)
        }
    }
}

// Hex color extension//
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


