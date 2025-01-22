//
//  ContentView.swift
//  StarJar
//
//  Created by Leena  on 19/07/1446 AH.
//

import SwiftUI

struct StartView: View {
    @State private var showSplash = true // State to control splash visibility

    var body: some View {
        ZStack {
            if showSplash {
                ZStack {
                    Image("interface")
                        .resizable()
                        .frame(width: 400, height: 900)
                        .scaledToFit()
                        .ignoresSafeArea()

                    VStack {
                        Spacer()
                        Image("Jar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 800, height: 500)
                            .offset(y: -70) // Moved the jar higher
                            .overlay(
                                ZStack {
                                    Image("STAR1 1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 150)
                                        .offset(x: 0, y: 140) // Adjusted position relative to the jar
                                    Image("STAR2 1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 1000, height: 90)
                                        .offset(x: -70, y: 120) // Adjusted position
                                    Image("STAR3 1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 1000, height: 90)
                                        .offset(x: 70, y: 120) // Adjusted position

                                    Text("Hello!")
                                        .font(.system(size: 75, weight: .bold, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding()
                                        .offset(x: 0, y: -20) // Moved text slightly higher
                                }
                            )
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showSplash = false // Hide splash screen after 3 seconds
                    }
                }
            } else {
                TrackerView() // Navigate to the Tracker page after the splash screen
            }
        }
    }
}


