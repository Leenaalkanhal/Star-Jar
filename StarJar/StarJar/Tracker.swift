//
//  tracker.swift
//  StarJar
//
//  Created by Leena  on 19/07/1446 AH.
//


import SwiftUI

struct TrackerView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Image("tracker") // Replace with your background image name
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Stars in Zigzag Pattern
                VStack(spacing: 55) { // Adjust spacing for consistency
                    StarButton(number: 7, xOffset: 90)    // Right under title
                        .padding(.bottom, -30)
                        .offset(y: 90)  // Lowered slightly
                    StarButton(number: 6, xOffset: -120)  // More left
                        .padding(.top, -15)
                        .offset(y: 120)  // Lowered slightly
                    StarButton(number: 5, xOffset: 130)
                        .offset(y: 90) // More right
                    StarButton(number: 4, xOffset: -130)
                        .offset(y: 65) // More left
                    StarButton(number: 3, xOffset: 86)
                        .offset(y: 65) // More right
                    StarButton(number: 2, xOffset: -100)
                        .offset(y: 65) // Further left
                    StarButton(number: 1, xOffset: 100)
                        .padding(.bottom, 150)           // Allow room for a tab bar
                }
                .padding(.vertical, 20) // Adjust vertical padding for alignment
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide the back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Tracker")
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
    }
}

struct StarButton: View {
    let number: Int
    let xOffset: CGFloat

    var body: some View {
        NavigationLink(destination: TasksView(day: number)) { // Navigate to TasksView based on the day
            ZStack {
                Image("starImage") // Replace with your star image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70) // Adjusted star size
                
                Text("\(number)")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .offset(x: xOffset) // Adjust horizontal offset for zigzag
    }
}

// Preview
#Preview {
    TrackerView()
}








