//
//  AudioController.swift
//  StackViews
//
//  Created by new on 8/10/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//



import AVFoundation


// Sound effects
let SoundDing = "ding.mp3"
let SoundWrong = "wrong.m4a"
let SoundWin = "win.mp3"
let SoundPop = "hitCatLady.wav"
let AudioEffectFiles = [SoundDing,SoundWin,SoundPop]

class AudioController {
 
fileprivate var audio = [String:AVAudioPlayer]()
  
func preloadAudioEffects(_ effectFileNames:[String]) {
    for effect in AudioEffectFiles {
      //1 get the file path URL
      let soundPath = (Bundle.main.resourcePath! as NSString).appendingPathComponent(effect)
		print("the value for sound path is \(soundPath)")
		
	    let soundURL = URL(fileURLWithPath: soundPath)
      
      //2 load the file contents
      var loadError:NSError?
      let player: AVAudioPlayer!
      do {
        player = try AVAudioPlayer(contentsOf: soundURL)
      } catch let error as NSError {
        loadError = error
        player = nil
      }
	 print("the error was \(loadError)")
		
	  assert(loadError == nil, "Load sound failed")
      
      //3 prepare the play
      player.numberOfLoops = 0
      player.prepareToPlay()
      
      //4 add to the audio dictionary
      audio[effect] = player
    }
  }
  
  func playEffect(_ name:String) {
    if let player = audio[name] {
      if player.isPlaying {
        player.currentTime = 0
      } else {
        player.play()
      }
    }
  }
  
}

