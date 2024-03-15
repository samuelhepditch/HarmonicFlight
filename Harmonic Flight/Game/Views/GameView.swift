//
//  GameView.swift
//  Harmonic Flight
//
//  Created by Sam Hepditch on 2024-03-13.
//

import SwiftUI


import SwiftUI

struct GameView: View {
    @Binding var visiblePage: page
    @Binding var frequencyRange: (Double, Double)
    @Binding var amplitudeRange: (Double, Double)

    @State private var score: Int = 0
    @State private var playerPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @State private var playerSize: Double = UIScreen.main.bounds.width / 1.5
    @State private var pipeXPosition = UIScreen.main.bounds.width
    @State private var upperPipeHeight: CGFloat = CGFloat.random(in: 100...300)
    @State private var isAnimating = false
    @State private var movePipe = false
    
    private let analyzer = AudioAnalyzer()
    private let pipeWidth: CGFloat = 60
    private let gapHeight: CGFloat = 200 // Adjust based on difficulty

    var body: some View {
        ZStack {
            // Player
            PlayerNode(playerSize: $playerSize)
                .position(playerPosition)
                .foregroundColor(.black)
                .onAppear {
                    startGame()
                }
            
            GeometryReader { geometry in
                PipeView(height: upperPipeHeight)
                    .position(x: movePipe ? -pipeWidth : geometry.size.width + pipeWidth, y: upperPipeHeight / 2)
                    .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: movePipe)

                PipeView(height: geometry.size.height - upperPipeHeight - gapHeight)
                    .position(x: movePipe ? -pipeWidth : geometry.size.width + pipeWidth, y: geometry.size.height - (geometry.size.height - upperPipeHeight - gapHeight) / 2)
                    .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: movePipe)
            }.onAppear {
                movePipe = true
            }.onChange(of: movePipe) { _ in
                if !movePipe {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
                        upperPipeHeight = CGFloat.random(in: 100...300)
                        movePipe = true
                    }
                }
            }

        }
    }
    
    private func startGame() {
        analyzer.onUpdate = { frequency, amplitude in
            DispatchQueue.main.async {
                withAnimation {
                    self.playerPosition.y = self.mapFrequencyToPosition(frequency)
                    self.playerSize = computeSize(amplitude)
                }
            }
        }
        analyzer.start()
    }
    
    private func computeSize(_ amplitude: Double) -> Double {
        let screenWidthFraction = UIScreen.main.bounds.width / 1.5
        let size = ((self.amplitudeRange.1 - amplitude) / self.amplitudeRange.1) * screenWidthFraction
        return max(size, 75)
    }
    
    private func mapFrequencyToPosition(_ frequency: Double) -> CGFloat {
        let midFrequency = (frequencyRange.1 + frequencyRange.0) / 2
        let diff = frequency - midFrequency
        let unit = UIScreen.main.bounds.height / (frequencyRange.1 - frequencyRange.0)
        var position = UIScreen.main.bounds.height / 2 - diff * unit
        position = max(min(position, UIScreen.main.bounds.height - self.playerSize), self.playerSize)
        return position
    }
}

struct PipeView: View {
    var height: CGFloat
    private let width: CGFloat = 60 // Width of the pipe
    
    var body: some View {
        Rectangle()
            .fill(Color.green)
            .frame(width: width, height: height)
    }
}

struct PlayerNode: View {
    @Binding var playerSize: Double
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 4)
                .frame(width: playerSize < 50 ? 50 : playerSize, height: playerSize <  50 ? 50 : playerSize )
            Image(systemName: "music.note")
                .resizable()
                .scaledToFit()
                .frame(width: playerSize / 3, height: playerSize / 3)
        }
    }
}




