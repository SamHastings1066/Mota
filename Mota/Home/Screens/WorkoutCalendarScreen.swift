//
//  WorkoutCalendarScreen.swift
//  Mota
//
//  Created by sam hastings on 30/07/2024.
//

import SwiftUI
import HorizonCalendar
import SwiftData

struct WorkoutCalendarScreen: View {
    @Environment(\.database) private var database
    @State private var completedWorkouts: [WorkoutCompleted] = []
    @State private var isLoading = true
    @State private var selectedDate: Date?
    @State private var presentedWorkouts: [[WorkoutCompleted]] = []
    
    let calendar = Calendar.current
    let startDate: Date
    let endDate: Date
    
    init() {
        startDate = calendar.date(from: DateComponents(year: 2024, month: 08, day: 01))!
        endDate = calendar.date(from: DateComponents(year: 2024, month: 10, day: 30))!
    }
    
    var body: some View {
        NavigationStack(path: $presentedWorkouts) {
            if isLoading {
                ProgressView("Retrieving workout information")
                    .onAppear {
                        loadCompletedWorkouts()
                    }
            } else {
                CalendarViewRepresentable(
                    calendar: calendar,
                    visibleDateRange: startDate...endDate,
                    monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
                    dataDependency: nil
                )
                .onDaySelection { day in
                    selectedDate = calendar.date(from: day.components)
                    if let date = calendar.date(from: day.components) {
                        let workoutsForSelectedDay = completedWorkouts.filter { workout in
                            calendar.isDate(workout.startTime, equalTo: date, toGranularity: .day)
                        }
                        presentedWorkouts = [workoutsForSelectedDay]
                    }
                }
                .days { day in
                    let dateComponents = day.components
                    if let date = calendar.date(from: dateComponents) {
                        let filteredWorkouts = completedWorkouts.filter { workout in
                            calendar.isDate(workout.startTime, equalTo: date, toGranularity: .day)
                        }
                        let totalVolume: Int = filteredWorkouts.reduce(0) { $0 + $1.computeWorkoutStats().totalVolume }
                        
                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(
                                        filteredWorkouts.count > 0 ? Color(UIColor.systemGreen) : Color(UIColor.clear),
                                        lineWidth: 3
                                    )
                                    .frame(width: 40, height: 40)
                                Text("\(day.day)")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(UIColor.label))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            Text(totalVolume == 0 ? "~" : "\(totalVolume)")
                                .font(.system(size: 12))
                        }
                    } else {
                        Text("Error")
                    }
                }
                .interMonthSpacing(24)
                .verticalDayMargin(38)
                .horizontalDayMargin(8)
                .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationDestination(for: [WorkoutCompleted].self) { workoutsForSelectedDay in
                    CompletedWorkoutsForDayScreen(workoutsCompleted: workoutsForSelectedDay, date: selectedDate)
                }
            }
        }
    }
    
    private func loadCompletedWorkouts() {
        Task {
            let descriptor = FetchDescriptor<WorkoutCompleted>()
            let fetchedWorkouts: [WorkoutCompleted]? = try? await database.fetch(descriptor)
            if let fetchedWorkouts {
                self.completedWorkouts = fetchedWorkouts
                print("Fetched workout count is \(fetchedWorkouts.count)")
            } else {
                print("Cannot load completed workouts")
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}

#Preview {
    //    WorkoutCalendarScreen()
    //        .environment(\.database, SharedDatabase.preview.database)
    
    return AsyncPreviewView(
        asyncTasks: {
            await SharedDatabase.preview.loadExercises()
            _ = await SharedDatabase.preview.loadDummyCompletedWorkout()
            return nil
        },
        content: { _ in
            WorkoutCalendarScreen()
        }
    )
    
    .environment(\.database, SharedDatabase.preview.database)
}


