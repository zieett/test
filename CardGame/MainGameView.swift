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
//  MainGameView.swift
//  CardGame
//
//  Created by Việt Trần Vũ Hoàng on 25/08/2022.
//

import SwiftUI
import Foundation
struct MainGameView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    @State var icons = ["airplane","car","bus","tram","ferry","gamecontroller","bicycle","scooter","star","list.bullet"]
    var collumns: Array<GridItem> = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State var random:  Array<Int> = [1,1,2,2,3,3].shuffled()
    var row = 4
    var imageSize = 30
    var numberOfPairs = 3
    @Binding var state: String
    @AppStorage("backgroundSound") var backgroundSound :Bool?
    @State var times: Timer?
    @State var score = 0
    @State var gameTime = 15
    @State var timer = 15
    @State var pause = false
    @State var showGameOver = false
    @State var isFlippedArray : Array<String> = []
    @State var correctFlippedCard : Array<CardView> = []
    @State var correct = 0
    @State var title = "GAME OVER"
    //MARK: Game over function
    func gameOver(_ t: Timer){
        t.invalidate()
        playSound(sound: "loseGame", type: "wav")
        showGameOver = true
    }
    //MARK: Check winning game
    func winningGame(_ t: Timer){
        t.invalidate()
        showGameOver = true
        title = "CONGRATULATION"
    }
    
    //MARK: Continue game after pause
    func continueTime(){
        times = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if (correct == numberOfPairs){
                winningGame(t)
            }
            if(timer == 0 ){
                gameOver(t)
            }
            else{
                timer-=1
            }
        }
    }
    
    //MARK: Restart game
    func startTime(){
        if(state == "menu"){
            times?.invalidate()
            return
        }
        for (index,_) in correctFlippedCard.enumerated() {
            correctFlippedCard[index].flipBackCard()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            icons = icons.shuffled()
            random = random.shuffled()
            correct = 0
            score = 0
            timer = gameTime
            times = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
                if (correct == numberOfPairs){
                    winningGame(t)
                }
                if(timer == 0 ){
                    gameOver(t)
                }
                else{
                    timer-=1
                }
            }
        }
        
    }
    var body: some View {
        ZStack{
            Color(colorScheme == .dark ? .black : UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00))
            //MARK: Sound button and Pause button
            VStack{
                HStack{
                    Button(action: {
                        playSound(sound: "click", type: "wav")
                        pause = !pause;
                        if(pause){
                            times?.invalidate()
                        }
                        else if(!pause && numberOfPairs != correct){
                            times = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
                                if (correct == numberOfPairs){
                                    winningGame(t)
                                }
                                if(timer == 0 ){
                                    gameOver(t)
                                }
                                else{
                                    timer-=1
                                }
                            }
                        }
                    }) {
                        Image(systemName: pause ? "play.circle": "pause.circle")
                            .font(.system(size: 30))
                    }.padding(.horizontal).foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    Button(action: {
                        playSound(sound: "click", type: "wav")
                        backgroundSound! = !backgroundSound!
                        if backgroundSound! {
                            playBackgroundSound(sound: "background", type: "mp3",true)
                        }
                        else{
                            stopBackgroundSound()
                        }
                    }) {
                        Image(systemName: backgroundSound! ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .font(.system(size: 30))
                    }.padding(.horizontal).foregroundColor(colorScheme == .dark ? .white : .black)
                }
                Spacer()
                
                //MARK: Timer and score
                HStack{
                    Text("Time: \(timer)")
                    Spacer()
                    Text("Score: \(score)")
                }.padding()
                
                //MARK: Card grid
                LazyVGrid(columns: collumns,spacing: 20) {
                    ForEach((0...collumns.count * row - 1),id:\.self){ index in
                        CardView(numberOfPairs:numberOfPairs, correct:$correct,isFlippedArray:$isFlippedArray, score:$score,timer: $timer, pause: $pause ,correctFlippedCard: $correctFlippedCard , icon: icons[random[index]])
                    }
                }.padding()
                Spacer()
            }.padding(.vertical,50)
            
            //MARK: Game over View
            if(showGameOver){
                GameOverView(showGameOver: $showGameOver,score:$score, title:$title, state:$state, startTime:self.startTime)
            }
            
            //MARK: Pause game view
            if(pause){
                PauseGameView(continueTime: continueTime,startTime:startTime, pause:$pause,state:$state)
            }
        }.onAppear(perform: {
            icons = icons.shuffled()
            times = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
                if (correct == numberOfPairs){
                    winningGame(t)
                }
                if(timer == 0 ){
                    gameOver(t)
                }
                else{
                    timer-=1
                }
            }
        })
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                pause = true
                times?.invalidate()
            } else if newPhase == .inactive {
                times?.invalidate()
                pause = true
            } else if newPhase == .background {
                times?.invalidate()
                pause = true
            }
        }
    }
}
