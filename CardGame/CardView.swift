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
//  CardView.swift
//  CardGame
//
//  Created by Việt Trần Vũ Hoàng on 25/08/2022.
//

import SwiftUI

struct CardView: View{
    @Environment(\.colorScheme) var colorScheme
    var numberOfPairs :Int
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    @Binding var correct:Int
    @Binding var isFlippedArray : Array<String>
    @Binding var score:Int
    @Binding var timer:Int
    @Binding var pause:Bool
    @Binding var correctFlippedCard: Array<CardView>
    var icon = "house"
    let durationAndDelay : CGFloat = 0.3
    let chooseTime = 1.2
    //MARK: -- Flip card function
    func flipCard () {
        if (timer <= 0 || pause || isFlipped || isFlippedArray.count == 2){
            return
        }
        
        isFlipped = true
        playSound(sound: "flip", type: "wav")
        correctFlippedCard.append(self)
        if isFlipped {
            if (isFlippedArray.count == 0){
                isFlippedArray.append(self.icon)
                withAnimation(.linear(duration: durationAndDelay)) {
                    backDegree = 90
                }
                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                    frontDegree = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + chooseTime) {
                    if (isFlippedArray.count == 2){
                        if(isFlippedArray[0] == isFlippedArray[1]){
                            isFlippedArray.removeAll()
                        }
                        else{
                            self.flipBackCard()
                        }
                    }
                    else if(isFlippedArray.count == 1){
                        self.flipBackCard()
                        isFlippedArray.remove(at:0)
                    }
                }
            }
            else if (isFlippedArray.count == 1){
                isFlippedArray.append(self.icon)
                withAnimation(.linear(duration: durationAndDelay)) {
                    backDegree = 90
                }
                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                    frontDegree = 0
                }
                if(isFlippedArray[0] == isFlippedArray[1]){
                    playSound(sound: "correct", type: "wav")
                    score = score + 1 + timer
                    correct+=1
                    if(correct == numberOfPairs){
                        playSound(sound: "winGame", type: "wav")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        //                        isFlippedArray.removeAll()
                    }
                    
                }
                else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + chooseTime) {
                        self.flipBackCard()
                        isFlippedArray.removeAll()
                    }
                }
            }
        }
        print(isFlippedArray)
    }
    //MARK: Flip back card
    func flipBackCard(){
        isFlipped = false
        withAnimation(.linear(duration: durationAndDelay)) {
            frontDegree = -90
        }
        withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
            backDegree = 0
        }
    }
    var body: some View{
        ZStack{
            CardFront(icon:icon, degree: $frontDegree)
            CardBack(degree: $backDegree)
        }.onTapGesture {
            flipCard()
            //            print(isFlippedArray)
        }
    }
}
//MARK: Frond card
struct CardFront: View {
    @Environment(\.colorScheme) var colorScheme
    var imageSize = 40
    var icon = "house"
    @Binding var degree : Double
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(UIColor(red: 0.91, green: 0.89, blue: 0.80, alpha: 1.00)))
                .overlay(
                    Rectangle()
                        .fill(colorScheme == .dark ? .red :.blue)
                        .frame(width:   70, height:  70)
                        .cornerRadius(15)
                        .overlay(
                            Image(systemName: icon).font(.system(size:CGFloat(imageSize) )).foregroundColor(colorScheme == .dark ? .white : .black)
                        )
                )
                .frame(width:  100, height:100).cornerRadius(30)
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

//MARK: Back card
struct CardBack : View {
    @Environment(\.colorScheme) var colorScheme
    let width : CGFloat = 100
    let height : CGFloat = 100
    @Binding var degree : Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorScheme == .dark ? .red : .blue, lineWidth: 3)
                .frame(width: width, height: height)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? .red.opacity(0.5) : .blue.opacity(0.5))
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 2, x: 0, y: 0)
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
