//
//  charecterselection.swift
//  StarJar
//
//  Created by Leena  on 19/07/1446 AH.
//

import SwiftUI

struct CharacterSelectionView: View {
    @Binding var selectedCharacter: String
    let timerDuration: Int

    var body: some View {
        VStack {
            // Title
            Text("Choose Your Character")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.top, 15) // Adjust spacing from the top
                .padding(.bottom, 15) // Space between the title and characters

            Spacer() // Push characters and button to the middle

            // Character Grid
            VStack(spacing: 20) { // Control spacing between rows of characters
                HStack(spacing: 20) { // Adjust spacing between characters in a row
                    characterImage("lucy")
                    characterImage("Mia")
                    characterImage("Zoe")
                }
                HStack(spacing: 20) {
                    characterImage("Jack")
                    characterImage("Leo")
                    characterImage("Alex")
                }
            }

            Spacer() // Push the button towards the bottom

            // Choose Button
            if !selectedCharacter.isEmpty {
                NavigationLink(
                    destination: TimerView(selectedCharacter: selectedCharacter, timerDuration: timerDuration),
                    label: {
                        Text("Choose")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color(hex: "#f2df88"))
                            .cornerRadius(10)
                    })
                    .padding(.bottom, 40) // Adjust spacing from the bottom of the screen
            }
        }
        .padding(.horizontal, 20) // Add some horizontal padding
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Add your custom back action here
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white) // Set the back button arrow to white
                        Text("Back")
                            .foregroundColor(.white) // Set the back button text to white
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func characterImage(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .border(selectedCharacter == name ? Color.yellow : Color.clear, width: 3)
            .onTapGesture {
                selectedCharacter = name
            }
    }
}
