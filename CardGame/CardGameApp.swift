/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Tran Vu Hoang Viet
  ID: Your student id (e.g. 1234567)
  Created  date: 09/08/2022
  Last modified: 09/08/2022
*/
//
//  CardGameApp.swift
//  CardGame
//
//  Created by Việt Trần Vũ Hoàng on 20/08/2022.
//


import SwiftUI

@main
struct CardGameApp: App {
    @State private var welcomeScreen: Bool = true
    var body: some Scene {
        WindowGroup {
            if (welcomeScreen){
                SplashView(welcomeScreen: $welcomeScreen)
            }
            else {
                MenuView().ignoresSafeArea()
            }
        }
    }
}
