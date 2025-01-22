//
//  timer.swift
//  StarJar
//
//  Created by Leena  on 20/07/1446 AH.
//



import SwiftUI
import AVFoundation

struct TimerView: View {
    var selectedCharacter: String = "DefaultCharacter"// Passed selected character
    var timerDuration: Int = 60// Passed timer duration in minutes

    @State private var isRunning = false
    @State private var showOverlay = false // For "Congrats" overlay
    @State private var showTimeUpOverlay = false // For "Time is Up" overlay
    @State private var timeRemaining: Int // Timer duration in seconds
    @State private var timer: Timer?
    @State private var progress: CGFloat = 0.0
    @State private var showChat = false // Control when to show the chat bubble
    private let synthesizer = AVSpeechSynthesizer() // Ensure synthesizer persists

    @Environment(\.presentationMode) var presentationMode // Allows navigation back to TasksView

    init(selectedCharacter: String, timerDuration: Int) {
        self.selectedCharacter = selectedCharacter
        self.timerDuration = timerDuration
        _timeRemaining = State(initialValue: timerDuration * 60) // Initialize timeRemaining in seconds
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if !isRunning {
                    // Start Page
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                                .frame(width: 200, height: 200)
                            Image(selectedCharacter) // Dynamically load character image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding()
                        }
                        Button(action: startTimer) {
                            Text("Start")
                                .padding()
                                .frame(width: 150)
                                .background(Color(hex: "#f2df88")) // Use the provided color
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 30)
                    }
                } else {
                    // Timer Page
                    VStack {
                        if showChat {
                            HStack {
                                Spacer()
                                ChatBubble(
                                    message: "Are you ready? Let the challenge begin.",
                                    color: Color(hex: "#f2df88")
                                )
                                .padding(.trailing, 30)
                                .padding(.top, -80) // Adjusted position to be higher
                            }
                            .transition(.opacity)
                        }
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                                .frame(width: 200, height: 200)
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear, value: progress)
                            Image(selectedCharacter) // Dynamically load character image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                        Text(formatTime())
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        HStack(spacing: 30) {
                            Button(action: resetTimer) {
                                ZStack {
                                    Image("starrr") // Replace with your star image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    Text("Reset")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                            }
                            Button(action: stopTimer) {
                                ZStack {
                                    Image("starrr") // Replace with your star image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    Text("Stop")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                // Congrats Overlay
                if showOverlay {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(12)
                            .frame(width: 300, height: 450)
                            .shadow(radius: 10)
                        VStack(spacing: 20) {
                            Text("Congrats you won!")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding()
                            Image("congrats") // Replace with your celebratory star image name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                            Image("confettiImage") // Replace with your confetti image name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 50)
                                .padding(.top, -20)
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Text("Home")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color(hex: "#f2df88"))
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                }
                // Time Up Overlay
                if showTimeUpOverlay {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(12)
                            .frame(width: 300, height: 300)
                            .shadow(radius: 10)
                        VStack(spacing: 20) {
                            Text("Time is Up!")
                                .font(.title)
                                .bold()
                                .padding()
                            Image("timeisup") // Replace with an alarm image if available
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Text("Dismiss")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color(hex: "#f2df88"))
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }

    // MARK: - Timer Functions
    private func startTimer() {
        timer?.invalidate()
        isRunning = true
        progress = 0.0
        timeRemaining = timerDuration * 60
        showChat = true
        speakMessage("Are you ready? Let the challenge begin.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            if isRunning { showChat = false }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = CGFloat(timerDuration * 60 - timeRemaining) / CGFloat(timerDuration * 60)
            } else {
                showTimeUpOverlay = true
                playAlarmSound()
                timer?.invalidate()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        isRunning = false
        showOverlay = true
        showChat = false
    }

    private func resetTimer() {
        timer?.invalidate()
        timeRemaining = timerDuration * 60
        progress = 0.0
        showChat = true
        isRunning = true
        startTimer()
    }

    private func playAlarmSound() {
        let systemSoundID: SystemSoundID = 1005
        AudioServicesPlayAlertSound(systemSoundID)
    }

    private func speakMessage(_ message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    private func formatTime() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Chat Bubble View
struct ChatBubble: View {
    let message: String
    let color: Color

    var body: some View {
        ZStack {
            Text(message)
                .font(.footnote)
                .foregroundColor(.black)
                .padding(10)
                .background(color)
                .cornerRadius(13)
        }
    }
}

// MARK: - Custom Color Extension
extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexSanitized)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}


