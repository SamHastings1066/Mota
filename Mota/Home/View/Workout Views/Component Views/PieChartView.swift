//
//  PieChartView.swift
//  Mota
//
//  Created by sam hastings on 01/08/2024.
//



import SwiftUI
import Charts

struct MuscleVolume: Identifiable {
    var name: String
    var volume: Int
    var id = UUID()
    var color: Color
}

struct PieChartView: View {
    @State private var musclesUsed: [MuscleVolume]
    private var maxMuscles: Int
    
    init(musclesUsed: [String : Int], maxMuscles: Int = 3) {
        self.musclesUsed = musclesUsed.map { MuscleVolume(name: $0.key, volume: $0.value, color: Self.randomColor()) }
        self.maxMuscles = maxMuscles
    }
    
    static func randomColor() -> Color {
        Color(hue: .random(in: 0...1), saturation: 0.7, brightness: 0.7)
    }
    
    var body: some View {
        HStack {
            Chart(topThreeMuscles, id: \.id) { muscleUse in
                SectorMark(
                    angle: .value("Volume", muscleUse.volume),
                    innerRadius: .ratio(0.6),
                    angularInset: 8
                )
                .foregroundStyle(muscleUse.color)
            }
            .chartLegend(.hidden) // Hide the default legend

            // Custom legend
            VStack(alignment: .leading) {
                ForEach(topThreeMuscles, id: \.id) { muscleUse in
                    HStack {
                        Circle()
                            .fill(muscleUse.color)
                            .frame(width: 10, height: 10)
                        Text(muscleUse.name)
                    }
                }
            }
        }
        .padding()
    }
    
    var topThreeMuscles: [MuscleVolume] {
        musclesUsed
            .sorted { $0.volume > $1.volume }
            .prefix(maxMuscles)
            .map { $0 }
    }
}

#Preview {
    PieChartView(musclesUsed: ["chest": 1000, "lower back": 2000, "quadriceps": 3000, "biceps": 500, "triceps": 800], maxMuscles: 4)
}
