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
//  MenuView.swift
//  CardGame
//
//  Created by Việt Trần Vũ Hoàng on 20/08/2022.
//

import SwiftUI


struct MenuView: View {
    @State var state = "menu"
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("name") var name = ""
    @State var leaderboard : [String: Int] = [:]
    @State var gameMode:String = "easy"
    @State var showHowToPlay = false
    @AppStorage("backgroundSound") var backgroundSoud = true
    @State var leaderboardView = false
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    var body: some View {
        ZStack{
            //MARK: State management
            switch state {
            case "menu":
                ZStack{
                    Color(colorScheme == .dark ? .black : UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00))
                    VStack{
                        Spacer()
                        if(name != ""){
                            Text("Hi, \(name)").bold()
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        MenuButtonView(text: "Play").padding(.vertical,5).onTapGesture {
//                                                    resetDefaults()
                            playSound(sound: "click", type: "wav")
                            if(name != ""){
                                state = "modeView"
                                return
                            }
                            state = "logIn"
                        }
                        MenuButtonView(text: name == "" ? "Log In " : "Log out").padding(.vertical,5)
                            .onTapGesture {
                                playSound(sound: "click", type: "wav")
                                if(name == ""){
                                    state = "logIn"
                                    return
                                }
                                name = ""
                            }
                        //                MenuButtonView(text: "Exit").padding(.vertical,5)
                        Spacer()
                        HStack{
                            SecondaryMenuButtonView(imageName: "questionmark").padding(.horizontal,5)
                                .onTapGesture {
                                    playSound(sound: "click", type: "wav")
                                    showHowToPlay.toggle()
                                }
                                .sheet(isPresented: $showHowToPlay) {
                                    HowToPlayView()
                                }
                            SecondaryMenuButtonView(imageName: "star.fill").padding(.horizontal,5)
                            SecondaryMenuButtonView(imageName: backgroundSoud ?"speaker.wave.2.fill" : "speaker.slash.fill").padding(.horizontal,5)
                                .onTapGesture {
                                    backgroundSoud.toggle()
                                    if backgroundSoud {
                                        playBackgroundSound(sound: "background", type: "mp3",true)
                                    }
                                    else{
                                        stopBackgroundSound()
                                    }
                                }
                        }
                    }.padding(.bottom,50)
                        .onTapGesture {
                            playSound(sound: "click", type: "wav")
                            leaderboardView = true
                        }
                    if(leaderboardView){
                        LeaderBoardView(leaderboardView: $leaderboardView)
                    }
                       
                }
                .transition(.backslide)
                .animation(.default)
                
            case "gameView":
                switch gameMode {
                case "easy":
                    MainGameView(collumns: [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible())],row: 2,numberOfPairs: 3,state: $state,gameTime: 30,timer: 30)
                case  "normal":
                    MainGameView(collumns: [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible())],random: [1,1,2,2,3,3,4,4,5,5,6,6,].shuffled(), row: 4,numberOfPairs:6, state: $state,gameTime:60, timer: 60)
                        
                case "hard":
                    MainGameView(collumns: [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible())],random: [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9],row: 6,numberOfPairs:9, state: $state,gameTime:100, timer: 100)
                        
                default:
                    Text("Hello")
                }
                
                
            case "modeView":
                ChooseModeView(state: $state,gameMode: $gameMode)
                    .transition(.backslide).animation(.default)
            case "logIn":
                LogInView(name:$name, state: $state)
                    .transition(.backslide).animation(.default)
            default:
                Text("Hello!")
            }
        }.transition(.backslide)
            .onAppear(perform: {
                playBackgroundSound(sound: "background", type: "mp3",true)
                backgroundSoud = true
            })
            
        
    }
}

struct BackButtonView:View{
    @Environment(\.colorScheme) var colorScheme
    var body: some View{
        Circle()
            .strokeBorder(colorScheme == .dark ? .white : .black, lineWidth:5)
            .background(
                ZStack{
                    Circle().fill(colorScheme == .dark ? .black :  Color(UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)))
                    Image(systemName: "arrow.backward").font(.system(size: 20, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            )
            .frame(width: 50,height: 50)
    }
}

struct ChooseModeView:View{
    @Environment(\.colorScheme) var colorScheme
    @Binding var state: String
    @Binding var gameMode : String
    var body: some View{
        ZStack{
            Color(colorScheme == .dark ? .black : UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00))
            VStack{
                HStack{
                    BackButtonView()
                        .onTapGesture {
                            playSound(sound: "click", type: "wav")
                            state = "menu"
                        }
                    Spacer()
                }.padding(25)
                    .padding(.vertical,25)
                Spacer()
                MenuButtonView(text: "Easy").padding(.vertical,5)
                    .onTapGesture{
                        playSound(sound: "click", type: "wav")
                        gameMode = "easy"
                        state = "gameView"
                    }
                MenuButtonView(text: "Normal").padding(.vertical,5)
                    .onTapGesture {
                        playSound(sound: "click", type: "wav")
                        gameMode = "normal"
                        state = "gameView"
                    }
                MenuButtonView(text: "Hard").padding(.vertical,5)
                    .onTapGesture {
                        playSound(sound: "click", type: "wav")
                        gameMode = "hard"
                        state = "gameView"
                    }
                Spacer()
            }
        }
    }
}

struct HowToPlayView :View{
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            VStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    playSound(sound: "click", type: "wav")
                } label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.largeTitle)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
            VStack{
                Text("Instructions").font(.system(size: 30, weight: .bold))
                    .padding(.vertical)
                Text("Rules").font(.system(size: 30, weight: .bold))
                    .padding(.vertical)
                Text("This is a memory game. The cards are shuffled and laid face down. The point of the game is to find all the matches; the total of pairs of cards is depend on your mode")
                    .multilineTextAlignment(.center)
                Text(
                    "Click on a card to flip it over.\nIf the two cards match, they will remain flipped.\nIf they don't match, they will be turned over.\nRemember what was on each card and where it was.\nThe game is over when all the cards have been matched or time is up."
                )
                .multilineTextAlignment(.center)
            }.padding()
            
        }
    }
}

struct LogInView: View{
    @Environment(\.colorScheme) var colorScheme
    @Binding var name: String
    @Binding var state: String
    @State var error = false
    var body: some View{
        ZStack{
            Color(colorScheme == .dark ? .black : UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00))
            VStack{
                HStack{
                    BackButtonView()
                        .onTapGesture {
                            playSound(sound: "click", type: "wav")
                            state = "menu"
                        }
                    Spacer()
                }.padding(25)
                    .padding(.vertical,25)
                Spacer()
                HStack {
                    Image(systemName: "person").foregroundColor(colorScheme == .dark ? .white : .gray)
                    TextField("Enter your name", text: $name)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                        .background(colorScheme == .dark ? .black :  Color(UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(colorScheme == .dark ? .white : .black, lineWidth: 1))
                        .disableAutocorrection(true)
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 30))
                        .onTapGesture {
                            playSound(sound: "click", type: "wav")
                            if name == "" {
                                error = true
                                return
                            }
                            state = "modeView"
                            
                        }
                }
                .frame(width:300)
                if (error){
                    Text("Please enter your name").foregroundColor(.red)
                }
                Spacer()
            }
        }
        
    }
}

struct LeaderBoardView: View{
    @State var leaderboard : [String: Int] = [:]
    @Binding var leaderboardView: Bool
    var body: some View{
        ZStack{
            Color.gray.opacity(0.6)
            VStack{
                
                Rectangle().fill(.brown).frame(width: 250, height: 300).cornerRadius(25).overlay(
                    VStack{
                        Button {
                            leaderboardView = false
                        } label: {
                            Image(systemName: "x.circle")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack{
                                ForEach(leaderboard.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                                    HStack{
                                        Text("\(key):").font(.system(size: 30, weight: .bold))
                                        Spacer()
                                        Text("\(value) points").font(.system(size: 30))
                                    }.padding(.horizontal)
                                }
                                Spacer()
                            }
                            
                        }
                    }
                )
            }.onAppear(perform: {
                leaderboard = UserDefaults.standard.object(forKey: "leaderboard") as? [String : Int] ?? [:]
            })
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().ignoresSafeArea()
    }
}

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge:.trailing),
            removal: .move(edge:.leading))
    }
}
