//
//  ViewController.swift
//  StackViews
//
//  Created by new on 6/17/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class NameEditorViewController: UIViewController {
	
	fileprivate  var audioController: AudioController
	
	var person:Person!
	
	lazy var sharedContext: NSManagedObjectContext = {
	 return CoreDataStackManager.sharedInstance().managedObjectContext
	 }()
	
	@IBOutlet weak var gameView: UIView!
	@IBOutlet weak var backButtonStackView: UIImageView!
    @IBOutlet weak var spaceButtonStackView: UIImageView!
	
	var imageStringArray = [String]()
	
	
    required init?(coder aDecoder: NSCoder) {
		audioController = AudioController()
		//audioController.preloadAudioEffects(AudioEffectFiles)
		
        super.init(coder: aDecoder)
		//tell UIKit that this view controller uses a custom presentation object
		modalPresentationStyle = .custom
		transitioningDelegate = self
  	}
	
   
    fileprivate func animateView(_ view: UIView,  toHidden hidden: Bool) {
		UIView.animate(withDuration: 0.8,
		 delay: 0.2,
		usingSpringWithDamping: 0.8,
		initialSpringVelocity: 10.0, options: [], animations: { ()
			-> Void in
			view.isHidden = hidden
		}, completion: nil)
	}
	
	func handleBackSpaceButtonAnimation() {
		
		if  imageStringArray.isEmpty {
		 
        animateView(backButtonStackView, toHidden: true)
		animateView(spaceButtonStackView, toHidden: true)
		} else {
		animateView(spaceButtonStackView, toHidden: false)
		animateView(backButtonStackView, toHidden:false)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
  
	}
	
    override func viewWillAppear(_ animated: Bool) {
   	 super.viewWillAppear(animated)
	
        gameView.layer.borderWidth = 1.35
		gameView.layer.borderColor = UIColor.red.cgColor
		gameView.layer.cornerRadius = 10
	
		audioController.playEffect(SoundPop)
	
	 if imageStringArray.isEmpty {
		 
        animateView(backButtonStackView, toHidden: true)
		animateView(spaceButtonStackView, toHidden: true)
		} else {
		animateView(spaceButtonStackView, toHidden: false)
		animateView(backButtonStackView, toHidden: false)
		}
	}
	
	@IBAction func donePressed(_ sender: AnyObject) {
	
        person = Person(context: sharedContext)
		person.addPersonToCoreDataUsingStringArray(person: person,imageStringArray)
        
        
        dismissAnimationsStyle = .slide
	
        let hudView = HudView.hudInView(self.view, animated: true)
		
		hudView.text = "Saved"
		audioController.playEffect(SoundWin)
	
		afterDelay(1.3) {
		
		self.animateView(self.gameView, toHidden: true)
		self.dismiss(animated: true, completion: nil)
        }
    }



	
     func stringForTag(_ kind:Int) -> String {
      switch kind {
	  case 100: return "SpaceNew1"
	  case 101: return "AlephLetter"
	  case 102: return "BeisLetter"
      case 103: return "GimmelLetter"
      case 104: return "DaledLetter"
      case 105: return "HeyLetter"
      case 106: return "VovLetter"
	  case 107: return "ZayinLetter"
      case 108: return "ChesLetter"
      case 109: return "TesLetter"
      case 110: return "YudLetter"
	  case 111: return "ChofLetter"
	  case 112: return "ChofSofitLetter"
	  case 113: return "LamedLetter"
	  case 114: return "MemLetter"
	  case 115: return "MemSofitLetter"
	  case 116: return "NunLetter"
	  case 117: return "NunSofitLetter"
	  case 118: return "SamechLetter"
	  case 119: return "AyinLetter"
	  case 120: return "PeyLetter"
	  case 121: return "PeySofitLetter"
	  case 122: return "TzaddikLetter"
	  case 123: return "TzaddikSofitLetter"
	  case 124: return "KufLetter"
	  case 125: return "SpaceLetter"
	  case 126: return "RayshLetter"
	  case 127: return "ShinLetter"
	  case 128: return "TofLetter"
	
      default: return "TV"
      }
    }
	
	@IBAction func letterTapped(_ sender: UIGestureRecognizer ) {
	
		var kind: Int!	
		kind = sender.view!.tag
        
        let viewTapped = sender.view!
		
   		let tempTransform = viewTapped.transform
		
        UIView.animate(withDuration: 0.15,
		delay: 0.00,
		options: UIViewAnimationOptions.curveEaseOut,
		animations: {
			
				
        viewTapped.transform = viewTapped.transform.scaledBy(x: 2.1, y: 2.1) },
		 completion: {
		  (value:Bool) in
		  
		  
		  viewTapped.transform = tempTransform
		 })
		
		let newLetterImageString = stringForTag(kind)
	
		imageStringArray.append(newLetterImageString)
	
		updateTheHudWithStringArray(imageStringArray)
	
		audioController.playEffect(SoundDing)
	}
	
	func updateTheHudWithStringArray(_ imageStringArray: [String]) {
		
		handleBackSpaceButtonAnimation()
	
		drawLettersInGameView(imageStringArray)
	}
    
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
	
//iterate through the array and position letters from Right to Left
	
		for s in imageStringArray {
		
		let tile = TileView(letter: s, sideLength: tileSide)
		
		tile.frame = CGRect(
		x: x + (CGFloat(column) * -tileSide),
		y: y,
		
		width: tileSide, height: tileSide)
		
		tile.addLayerEffect()
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

    @IBAction func backSpaceButtonTapped(_ sender: UITapGestureRecognizer) {

		let viewTapped = sender.view!
		print("the view tapped was \(viewTapped)")
		
		UIView.animate(withDuration: 0.20,
		delay: 0.00,
		options: UIViewAnimationOptions.curveEaseOut,
		animations: {
				viewTapped.backgroundColor = UIColor.gray
				},
		 completion: {
		  (value:Bool) in
		  viewTapped.backgroundColor = UIColor.white
		 })
	
		imageStringArray.removeLast()
	
        for view in gameView.subviews {
			view.removeFromSuperview()
		}
	
		updateTheHudWithStringArray(imageStringArray)
	
		audioController.playEffect(SoundPop)
	
		}
	
    @IBAction func cancelPressed(_ sender: AnyObject) {
		dismissAnimationsStyle = .fade
		dismiss(animated: true, completion: nil)
		audioController.playEffect(SoundWin)
		}
	
    enum AnimationStyle {
	  case slide
	  case fade
	}
	
    var dismissAnimationsStyle = AnimationStyle.fade
  }

//tell UIKit what objects the detail view controller should use when transitioning to the detail view
extension NameEditorViewController: UIViewControllerTransitioningDelegate {
	
  func presentationController(
  		forPresented presented: UIViewController,
		presenting: UIViewController?,
  		source: UIViewController)
		 -> UIPresentationController? {
   
	
	 return DimmingPresentationController(
	   					presentedViewController: presented,
						presenting: presenting)
		}
	
	
	
		func animationController(forPresented presented: UIViewController,
	 	 presenting: UIViewController,
	 	 source: UIViewController)
	 		 -> UIViewControllerAnimatedTransitioning? {
		
	
			return BounceAnimationController()
  		}	
	
	//this method gets called when the view is being dismissed
	// it returns the SlideOutAnimationController that handles the animation details
	func animationController(
		 					forDismissed dismissed: UIViewController)
   							-> UIViewControllerAnimatedTransitioning? {
		
		switch dismissAnimationsStyle {
    case .fade:
	   return FadeOutAnimationController()
    default:
        return SlideOutAnimationController()
			}
		}
	}
	



	








