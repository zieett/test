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
//  SplashView.swift
//  test333
//
//  Created by Việt Trần Vũ Hoàng on 06/08/2022.
//

import SwiftUI

struct SplashView: View {
    @State var size = 0.7
    @State var opacity = 0.5
    @Binding var welcomeScreen : Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            Color(UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00))
            VStack{
                Image(systemName: "rectangle.on.rectangle").font(.system(size: 120)).padding(.vertical,5)
                Text("Card matching game").font(.largeTitle).fontWeight(.bold)
            }            .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 0.7)){
                        self.size = 0.9
                        self.opacity = 1
                    }
                }
        }.foregroundColor(colorScheme == .dark ? .black  : .black)
            .ignoresSafeArea()
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                    welcomeScreen = false
                }
            }
        
    }
}
