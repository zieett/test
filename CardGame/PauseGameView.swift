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
//  PauseGameView.swift
//  CardGame
//
//  Created by Việt Trần Vũ Hoàng on 27/08/2022.
//

import SwiftUI

struct PauseGameView: View {
    var continueTime: () -> Void
    var startTime : () -> Void
    @Binding var pause:Bool
    @Binding var state : String
    var body: some View {
        ZStack{
            Color.gray.opacity(0.6)
            Rectangle().fill(.brown).frame(width: 200, height: 180).cornerRadius(25).overlay(
                VStack{
                    HStack{
                        Circle().stroke(.black,lineWidth: 3).frame(width: 60, height: 60).overlay(
                            Circle().fill(.green).overlay(
                                Image("play").resizable().frame(width: 40, height: 40)
                            )
                        ).padding(10)
                            .onTapGesture {
                                playSound(sound: "click", type: "wav")
                                continueTime()
                                pause = false
                            }
                        Circle().stroke(.black,lineWidth: 3).frame(width: 60, height: 60).overlay(
                            Circle().fill(.green).overlay(
                                Image("play_again").resizable().frame(width: 60, height: 60)
                            )
                        ).padding(10)
                            .onTapGesture {
                                playSound(sound: "click", type: "wav")
                                pause = false
                                startTime()
                            }
                    }
                    ZStack{
                        Capsule().fill(.red).frame(width: 180, height: 50)
                        Text("Back to main menu").fontWeight(.bold)
                    }.onTapGesture {
                        playSound(sound: "click", type: "wav")
                        state = "menu"
                        startTime()
                    }
                    
                }
                
            )
        }.ignoresSafeArea()
    }
}
//
//struct PauseGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        PauseGameView()
//    }
//}
