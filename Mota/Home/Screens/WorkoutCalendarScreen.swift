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
    @State var selectedDate: Date?
    //@State private var workoutsForSelectedDay: [WorkoutCompleted] = []
    @State private var presentedWorkouts: [[WorkoutCompleted]] = []
    let calendar = Calendar.current
    let startDate: Date
    let endDate: Date
    
    init () {
        startDate = calendar.date(from: DateComponents(year: 2024, month: 07, day: 01))!
        endDate = calendar.date(from: DateComponents(year: 2024, month: 09, day: 30))!
    }
    
    
    
    var body: some View {
        if isLoading {
            ProgressView("Retrieving workout information")
                .onAppear {
                    loadCompletedWorkouts()
                }
        } else {
            NavigationStack(path: $presentedWorkouts) {
                CalendarViewRepresentable(
                    calendar: calendar,
                    visibleDateRange: startDate...endDate,
                    monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
                    dataDependency: nil
                )
                .onDaySelection { day in
                    selectedDate = calendar.date(from: day.components)
                    let dateComponents = day.components
                    if let date = calendar.date(from: dateComponents) {
                        let workoutsForSelectedDay = completedWorkouts.filter { workout in
                            calendar.isDate(workout.startTime, equalTo: date, toGranularity: .day)
                        }
                        presentedWorkouts = [workoutsForSelectedDay]
                    }
                }
                .days { day in
                    let dateComponents = day.components
                    if let date = calendar.date(from: dateComponents){
                        let filteredWorkouts = completedWorkouts.filter { workout in
                            calendar.isDate(workout.startTime, equalTo: date, toGranularity: .day)
                        }
                        let totalVolume: Int = {
                            var volume = 0
                            for workout in filteredWorkouts {
                                volume += workout.computeWorkoutStats().totalVolume
                            }
                            return volume
                        }()
                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(
                                        filteredWorkouts.count > 0 ? Color(UIColor.systemGreen) : Color(UIColor.clear),
                                        lineWidth: 3)
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
        isLoading = true
        Task {
            let descriptor = FetchDescriptor<WorkoutCompleted>()
            let fetchedWorkouts: [WorkoutCompleted]? = try? await database.fetch(descriptor)
            if let fetchedWorkouts {
                self.completedWorkouts = fetchedWorkouts
                print("Fetched workout count is \(fetchedWorkouts.count)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
            else {
                print("cannot load completedworkouts")
                await MainActor.run {
                    self.isLoading = false
                }
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


