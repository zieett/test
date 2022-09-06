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
//  MenuButtonView.swift
//  CardGame
//
//  Created by Việt Trần Vũ Hoàng on 20/08/2022.
//

import SwiftUI

struct MenuButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    var text:String;
    var body: some View {
        ZStack{
            Capsule()
                .strokeBorder(colorScheme == .dark ? .gray : .black, lineWidth:10)
                .background(
                    ZStack{
                        Capsule().fill(Color(UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)))
                        Text(text).foregroundColor(.black).font(.system(size: 40, weight: .bold))
                    }
                )
                .frame(width: 175, height: 85)
        }
    }
}

struct SecondaryMenuButtonView:View{
    @Environment(\.colorScheme) var colorScheme
    var imageName: String;
    var body: some View{
        ZStack{
            Circle()
                .strokeBorder(colorScheme == .dark ? .white : .white,lineWidth: 15)
                .background(
                    ZStack{
                        Circle().fill(Color.yellow)
                        Image(systemName: imageName).foregroundColor(.white).font(.system(size: 40, weight: .heavy))
                    }
                    
                )
                .frame(width:100,height:100)
        }
    }
}


struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(text: "Log in").ignoresSafeArea()
        SecondaryMenuButtonView(imageName: "list.bullet").ignoresSafeArea()
    }
}
