//
//  StarJarApp.swift
//  StarJar
//
//  Created by Leena  on 19/07/1446 AH.
//

import SwiftUI

@main
struct StarJarApp: App {
    @State private var selectedCharacter = "DefaultCharacter" // Add a State variable

    // Customizing Tab Bar Appearance
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground() // Make the background transparent
        appearance.backgroundEffect = UIBlurEffect(style: .light) // Add a blur effect
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.black // Selected icon color (black)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black] // Selected title color (black)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray // Unselected icon color (gray)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray] // Unselected title color (gray)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance // For devices with rounded tab bars
    }

    var body: some Scene {
        WindowGroup {
            NavigationView { // Wrap the entire TabView in a single NavigationView
                TabView {
                    StartView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Tracker")
                        }

                    Starjar()
                        .tabItem {
                            Image(systemName: "star")
                            Text("Star Jar")
                        }

                    CharacterSelectionView(selectedCharacter: $selectedCharacter, timerDuration: 60) // Pass the Binding
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Character")
                        }
                }
                .navigationViewStyle(StackNavigationViewStyle()) // Consistent NavigationView behavior
            }
        }
    }
}
