//
//  starjar.swift
//  StarJar
//
//  Created by Leena  on 19/07/1446 AH.
//


import SwiftUI

struct Starjar: View {
    @State private var score = 0

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Image("interface")
                    .resizable()
                    .frame(width: 400, height: 900)
                    .scaledToFit()
                    .ignoresSafeArea()

                // Counter above the jar
                VStack {
                    Spacer()
                        .frame(height: 200) // Add space to position the counter above the jar
                    
                    Text("\(score)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(15)
                        .background(Color.white.opacity(0.8)) // Rectangular background with transparency
                        .cornerRadius(15) // Rounded corners
                        .shadow(radius: 5) // Add shadow for aesthetics
                    
                    Spacer()
                }

                // The jar in the middle
                VStack {
                    Spacer()
                    Image("Jar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 500) // Jar size
                        .onTapGesture {
                            score += 1 // Increment score on tap
                        }
                        .padding(.bottom, 70) // Ensure the jar is above the tab bar
                }
            }
        }
        .navigationBarHidden(true) // Hide the navigation bar
    }
}

#Preview {
    Starjar()
}

