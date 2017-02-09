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
  
    
    //3. find sound file using path(forResourse:)
    
    /*
    let path = Bundle.main.path(forResource: "ding.mp3", ofType: nil)!
    //4. create a file url
    let url = URL(fileURLWithPath: path)
    
    do {
    let sound = try AVAudioPlayer(contentsOf: url)
    dingSoundEffect = sound
    sound.play()
    
    } catch {
    print("couldn't load file")
    }
*/
/*
func preloadAudioEffects(_ effectFileNames:[String]) {
    for effect in AudioEffectFiles {
      
        //1 get the file path URL
       let path = Bundle.main.path(forResource: effect, ofType: nil)!
        
	   //create a file url
       let url = URL(fileURLWithPath: path)
      
      //2 load the file contents
      var loadError:NSError?
      let player: AVAudioPlayer!
      do {
        player = try AVAudioPlayer(contentsOf: url)
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
  */
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

