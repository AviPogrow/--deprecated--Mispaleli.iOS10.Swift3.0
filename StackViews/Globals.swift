//
//  Functions.swift
//  StackViews
//
//  Created by new on 7/27/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//
import UIKit 
import Dispatch

func afterDelay(_ seconds: Double, closure: @escaping () -> ()) {
  let when = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
  DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

//UI Constants
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height


func customizeAppearance() {
    UINavigationBar.appearance().barTintColor = UIColor.black
    UINavigationBar.appearance().titleTextAttributes = [
        NSForegroundColorAttributeName: UIColor.white]
}
var sampleImageStringArray =
    
    ["YudLetter","ChesLetter","YudLetter","AlephLetter","LamedLetter","SpaceLetter",
     "BeisLetter","NunLetter","TzaddikLetter","YudLetter","VovLetter",
     "NunSofitLetter","SpaceLetter","BeisLetter","NunSofitLetter","SpaceLetter",
     "MemLetter","YudLetter","RayshLetter","LamedLetter"]

/*
//1. pass in array of strings
func drawLettersInGameView(_ imageStringArray: [String]) {
    
    
    let columnsPerPage = 15
    
    //3. current row and column number
    var rowNumber = 0
    var column = 1
    
    //4. calculate the width and height of each square tile
    let tileSide = ceil(ScreenWidth / CGFloat(14.5))
    
    let marginX = view.bounds.width - 3
    let x = marginX
    
    let marginY = (CGFloat(rowNumber) * tileSide)
    var y = marginY + 10
    
    for s in imageStringArray {
        
        let tile = TileView(letter: s, sideLength: tileSide)
        
        tile.frame = CGRect(
            x: x + (CGFloat(column) * -tileSide),
            y: y,
            
            width: tileSide, height: tileSide)
        
        gameView.addSubview(tile)
        
        column = column + 1
        
        let viewToExplode = gameView.subviews.last
        let explode = ExplodeView(frame:CGRect(x: viewToExplode!.center.x, y: viewToExplode!.center.y, width: 2,height: 2))
        tile.superview?.addSubview(explode)
        tile.superview?.sendSubview(toBack: explode)
        
        // check if we are at the end of the row
        if column == columnsPerPage {
            
            column = 1;rowNumber = rowNumber + 1; y = y + 30
        }
    }
}
*/

/*
func drawNameAndLoadText(withPerson person: Person) {
    
    // the default is to have 15 buttons across the screen
    let columnsPerPage = 13
    
    //3. current row and column number
    var row = 0
    var column = 1
    
    //4. calculate the width and height of each square tile
    let tileSide = ceil(ScreenWidth / CGFloat(14.5))
    
    //5.
    var  marginX = view.bounds.width - 3
    let x = marginX
    
    var  marginY = (CGFloat(row) * tileSide)
    var y = marginY + 10
    
    
    //6.
    //********************** start the for loop ***************************
    //for (index, lettr) in person.lettersInName.enumerated() {
        
        let tile = TileView(letter: lettr.hebrewLetterString!, sideLength: tileSide)
        
        tile.frame = CGRect(
            x: x + (CGFloat(column) * -tileSide),
            y: y,
            width: tileSide, height: tileSide)
        
        gameView.addSubview(tile)
        column = column +  1
        
        let viewToExplode = gameView.subviews.last
        let explode = ExplodeView(frame:CGRect(x: viewToExplode!.center.x, y: viewToExplode!.center.y, width: 2,height: 2))
        tile.superview?.addSubview(explode)
        tile.superview?.sendSubview(toBack: explode)
        
        if column == columnsPerPage {
            column = 1; row = row + 1; y = y + 30
}

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */
*/
