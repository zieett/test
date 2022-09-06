//
//  PlaySound.swift
//  CardGame
//
//  Created by Việt Trần Vũ Hoàng on 29/08/2022.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?
var audioPlayer2: AVAudioPlayer?

func playSound(sound: String, type: String,_ background : Bool = false) {
    if let path = Bundle.main.path (forResource: sound, ofType: type) {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:URL(fileURLWithPath: path))
            if(background){
                audioPlayer?.numberOfLoops = -1
            }
            audioPlayer?.play()
        }
        catch{
            print ("ERROR: Could not find and play the sound file!")
        }
    }
}
func playBackgroundSound(sound: String, type: String,_ background : Bool = false) {
    if let path = Bundle.main.path (forResource: sound, ofType: type) {
        do{
            audioPlayer2 = try AVAudioPlayer(contentsOf:URL(fileURLWithPath: path))
            if(background){
                audioPlayer2?.numberOfLoops = -1
            }
            audioPlayer2?.play()
        }
        catch{
            print ("ERROR: Could not find and play the sound file!")
        }
    }
}

func stopBackgroundSound(){
    audioPlayer2?.stop()
}
