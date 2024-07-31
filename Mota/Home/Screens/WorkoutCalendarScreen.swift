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
    let calendar = Calendar.current
    let startDate: Date
    let endDate: Date
    
    init () {
        startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
        endDate = calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!
    }
    
    
    
    var body: some View {
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
                dataDependency: nil)
            .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func loadCompletedWorkouts() {
        isLoading = true
        Task {
            let start = Date()
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
    
    return
        AsyncPreviewView(
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


