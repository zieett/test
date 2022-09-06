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
//  GameOverView.swift
//  CardGame
//
//  Created by Việt Trần Vũ Hoàng on 27/08/2022.
//

import SwiftUI

struct GameOverView: View {
    @Binding var showGameOver: Bool
    @Binding var score: Int
    @Binding var title: String
    @Binding var state: String
    @State var highestScore = 0
    @AppStorage("name") var name: String?
    var startTime: () -> Void
    var body: some View {
        ZStack{
            Color.gray.opacity(0.6)
            Rectangle().fill(.brown).frame(width: 250, height: 300).cornerRadius(25).overlay(
                VStack{
                    ZStack{
                        Capsule().fill(title == "CONGRATULATION" ? .green: .red).frame(width: 200, height: 50)
                        Text(title).fontWeight(.bold)
                    }
                    .padding(.top,40)
                    Spacer()
                    Text("Score: ")
                    Text("\(score)")
                    Spacer()
                    Text("Highest score: ")
                    if( title == "GAME OVER"){
                        Text("\(highestScore)")
                    }
                    else{
                        Text("\(score >= highestScore ? score : highestScore)")
                    }
                   
                    Spacer()
                    HStack{
                        Spacer()
                        Circle().stroke(.black,lineWidth: 3).frame(width: 60, height: 60).overlay(
                            Circle().fill(.green).overlay(
                                Image(systemName: "arrow.backward").resizable().frame(width: 30, height: 30)
                            )
                        ).onTapGesture {
                            playSound(sound: "click", type: "wav")
                            state = "menu"
                        }
                        Spacer()
                        Circle().stroke(.black,lineWidth: 3).frame(width: 60, height: 60).overlay(
                            Circle().fill(.green).overlay(
                                    Image("play_again").resizable().frame(width: 60, height: 60)
                            )
                        ).onTapGesture {
                            playSound(sound: "click", type: "wav")
                            showGameOver = false
                            startTime()
                        }
                        Spacer()
                    }
             
                    Spacer()
                }
            )
        }.onAppear(perform: {
            var leaderboard = UserDefaults.standard.object(forKey: "leaderboard") as? [String : Int] ?? [:]
            if (title == "CONGRATULATION"){
                var isSet = false
                for (key,value) in leaderboard{
                    if(value >= highestScore){
                        highestScore = value
                    }
                    if(key == name ){
                        if(score > value){
                            leaderboard[key] = score
                            UserDefaults.standard.set(leaderboard, forKey: "leaderboard")
                        }
                        isSet = true
                    }
                }
                if(isSet) {return}
                if ((name) != nil){
                    leaderboard[name!] = score
                }
                UserDefaults.standard.set(leaderboard, forKey: "leaderboard")
               
            }
            else {
                for (_,value) in leaderboard{
                    if(value >= highestScore){
                        highestScore = value
                    }
                }
            }
        })
    }
}

//struct GameOverView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameOverView()
//    }
//}
