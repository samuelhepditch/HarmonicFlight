//
//  MenuView.swift
//  Harmonic Flight
//
//  Created by Sam Hepditch on 2024-03-14.
//
import SwiftUI


enum frequencyRange: String, CaseIterable {
    
    case low = "Low Range"
    case mid = "Mid Range"
    case high = "High Range"
    
    var frequencyRange: (min: Double, max: Double) {
        switch self {
        case .low:
            return (80, 200)
        case .mid:
            return (200, 350)
        case .high:
            return (350, 700)
        }
    }
}

enum volumeRange: String, CaseIterable {
    
    case soft = "Soft"
    case medium = "Medium"
    case loud = "Loud"
    
    var volumeRange: (min: Double, max: Double) {
        switch self {
        case .soft:
            return (0.0, 0.25)
        case .medium:
            return (0.0, 0.5)
        case .loud:
            return (0.0, 1.0)
        }
    }
    
}

struct MenuView: View {
    
    @Binding var visiblePage: page
    @Binding var frequencyRange: (Double, Double)
    @Binding var amplitudeRange: (Double, Double)
    @State private var selectedRangeIndex: Int = 0
    @State private var selectedVolumeIndex: Int = 0
    
    
    let ranges = ["Low Range", "Mid Range", "High Range"]
    let volumes = ["Soft", "Medium", "Loud"]
    
    var body: some View {
        ZStack {

            VStack(spacing: 20) {
                Text("Harmonic Flight")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 50, leading: 0, bottom: 50, trailing: 0))
                    .zIndex(1)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Choose Your Humming Range")
                        .font(.headline)
                    
                    Picker("Select Range", selection: $selectedRangeIndex) {
                        ForEach(0..<ranges.count, id: \.self) {
                            Text(self.ranges[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .zIndex(1)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Your Volume Level")
                        .font(.headline)
                    
                    Picker("Select Volume", selection: $selectedVolumeIndex) {
                        ForEach(0..<volumes.count, id: \.self) {
                            Text(self.volumes[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .zIndex(1)
                
                Spacer()
                
                CustomButton(action: {
                    self.visiblePage = .game
                }, buttonText: "Start Game")
                
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 25, trailing: 20))
            .zIndex(1)
        }
    }
}


