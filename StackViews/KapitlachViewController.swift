//
//  YehiRatzonViewController.swift
//  StackViews
//
//  Created by new on 7/31/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//
import UIKit
import CoreData
import AVFoundation

class KapitlachViewController: UIViewController, NSFetchedResultsControllerDelegate {
	
    var currentLocalIndex: Int = 0
    
    @IBOutlet weak var gameView: UIView!
    
   
    @IBOutlet weak var bookTextView: UITextView!
   
	var person:Person!
	
	fileprivate  var audioController: AudioController
	
	lazy var sharedContext: NSManagedObjectContext = {
	 return CoreDataStackManager.sharedInstance().managedObjectContext
	 }()
	
	
    lazy var fetchedResultsController: NSFetchedResultsController<LetterInName> = {
        
        let fetchRequest = NSFetchRequest<LetterInName>()
        let entity = LetterInName.entity()
        fetchRequest.entity = entity
        
		fetchRequest.predicate  = NSPredicate(format: "person == %@", self.person)
		fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
        }()
	
	
	
	required init?(coder aDecoder: NSCoder) {
		
		audioController = AudioController()
		audioController.preloadAudioEffects(AudioEffectFiles)
		
		super.init(coder: aDecoder)
		
		// tell UIKit that his VC uses a custom presentation
		modalPresentationStyle = .custom
		
		//set the delegate that will call the methods for the 
		// custom presentation
		transitioningDelegate = self
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
          addGestures()
        
        drawNewName(withPerson: person, atCurrentIndex: currentLocalIndex)
      
		
        do {
            try fetchedResultsController.performFetch()
       		 } catch {}
    }
	
	
    func addGestures() {
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeChapter(_:)))
        
        swipeRightGesture.direction = .right
        
        bookTextView.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeChapter(_:)))
        
        swipeLeftGesture.direction = .left
        
        bookTextView.addGestureRecognizer(swipeLeftGesture)
    }
    
    
    func changeChapter(_ gesture:UISwipeGestureRecognizer) {
        
       //var chapter = kapitelString
        
       if gesture.direction == .right {
            
            currentLocalIndex = (currentLocalIndex + 1)
            bookTextView.backgroundColor = UIColor.red
        
        
        }
     
        if gesture.direction == .left {
           
            currentLocalIndex = (currentLocalIndex - 1)
            bookTextView.backgroundColor = UIColor.cyan
        }
        
        updateNameDisplay()
    }
    
    
    
    //update the text view with chapter Text
    // update the gameView view
    func updateNameDisplay(){
        
        for view in gameView.subviews {
            view.removeFromSuperview()
        }
        for view in bookTextView.subviews {
            view.removeFromSuperview()
        }
        
    drawNewName(withPerson: person, atCurrentIndex: currentLocalIndex)
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	
		audioController.playEffect(SoundPop)
	}
	
	@IBAction func closeButtonPressed(_ sender: AnyObject) {
		audioController.playEffect(SoundWin)
		dismiss(animated: true, completion: nil)
    }
	
	func close() {
		audioController.playEffect(SoundWin)
		dismiss(animated: true, completion: nil)
     }
    func drawNewName(withPerson person: Person, atCurrentIndex: Int) {
        
        // the default is to have 20 buttons across the screen
        let columnsPerPage = 15
        
        
        //distance from right side of screen
        let marginX = view.bounds.width - 26
        
        //the distance from the top of the cell's view
        var marginY: CGFloat = 5
        
        // first row across is numbered 0 and set as default
        var row = 0
        
        // first column going down is numbered 0 and set as default
        var column = 0
        
        // set x to the value of margin x (0-2)
        let x = marginX
        
        
        //********* Draw Hebrew Letters of Name on GameView
        //********************************************************************************
        
        for (index, lettr) in person.lettersInName.enumerated() {
            
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.lightGray
            
            let image = UIImage(named: lettr.hebrewLetterString!)
            
            //get a referene to the path to the SampleData.plist
            let path = Bundle.main.path(forResource: "Tehillim119", ofType: "plist")
            
            //pull out the array holding one dictionary
            let dataArray = NSArray(contentsOfFile: path!)!
            print("data array looks like this \(dataArray)")
            
            
            var textDict  = dataArray.firstObject as! NSDictionary
            
            bookTextView.text = textDict["LamedLetterKapitel"] as! String
            
            //bookTextView.text = textDict[(lettr.kapitelImageString)!] as! String
            
        //****************************************************************************
            //   let text = lettr.kapitelImageString
            
            imageView.image = image
            imageView.frame = CGRect(
                x: x + (CGFloat(column * -19)),
                
                y: marginY,
                
                width: 20, height: 20)
            
            imageView.contentMode = .scaleAspectFill
            
            
            print("the value of index is \(index) and \(currentLocalIndex)")
            if index == currentLocalIndex {
                
                
                imageView.alpha = 0.5
                imageView.layer.borderWidth = 1.35
                imageView.layer.borderColor = UIColor.red.cgColor
                imageView.layer.cornerRadius = 3
            }
            
            gameView.addSubview(imageView)
            
            column += 1
            if column == columnsPerPage {
                column = 0;row = row + 1; marginY = marginY + 30
                
            }
        }
    }

    deinit {
		print("deinint \(self)")
	}

}
extension KapitlachViewController: UIViewControllerTransitioningDelegate {

	//what object should I use to present with?
	func presentationController(forPresented presented: UIViewController,
	                 presenting: UIViewController?,
					 source: UIViewController)
					 -> UIPresentationController? {
		
			
			//initialize and return an instance of this presentation 
			// controller to handle transition between
			// the specified view controllers
			return DimmingPresentationController(
							presentedViewController: presented,
							presenting: presenting)
		}
	
    //What animation object should I use to handle the transition between the view controllers?
	func animationController(forPresented presented: UIViewController,
	                presenting: UIViewController,
	                source: UIViewController)
	                   -> UIViewControllerAnimatedTransitioning? {
		
		return BounceAnimationController()

	}
	func animationController(
	                          forDismissed dismissed: UIViewController)
	                          -> UIViewControllerAnimatedTransitioning? {
		return SlideOutAnimationController()
    }
}
extension KapitlachViewController: UIGestureRecognizerDelegate {

	func  gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
								shouldReceive touch: UITouch) -> Bool {
        //only return a touch if the touch was on the background view
		// otherwise return false
		return (touch.view === self.view)
	}
}

/*
 func drawNewName(withPerson person: Person, atCurrentIndex: Int) {
 
 // the default is to have 20 buttons across the screen
 let columnsPerPage = 15
 
 
 //distance from right side of screen
 let marginX = view.bounds.width - 26
 
 //the distance from the top of the cell's view
 var marginY: CGFloat = 5
 
 // first row across is numbered 0 and set as default
 var row = 0
 
 // first column going down is numbered 0 and set as default
 var column = 0
 
 // set x to the value of margin x (0-2)
 let x = marginX
 
 
 //********* Draw Hebrew Letters of Name on TableView Cell************************
 //********************************************************************************
 
 for (index, lettr) in person.lettersInName.enumerated() {
 
 let imageView = UIImageView()
 imageView.backgroundColor = UIColor.cyan
 
 let image = UIImage(named: lettr.hebrewLetterString!)
 //****************************************************************************
 //let text = lettr.kapitelImageString
 // print("the value of kapitelString is \(text)")
 

 
 
 imageView.image = image
 imageView.frame = CGRect(
 x: x + (CGFloat(column * -19)),
 
 y: marginY,
 
 width: 20, height: 20)
 
 imageView.contentMode = .scaleAspectFill
 
 if index == currentLocalIndex {
 imageView.alpha = 0.5
 imageView.layer.borderWidth = 1.35
 imageView.layer.borderColor = UIColor.red.cgColor
 imageView.layer.cornerRadius = 3
 }
 
 gameView.addSubview(imageView)
 
 
  bookTextView.text = lettr.kapitelImageString
 
 
 
 column += 1
 if column == columnsPerPage {
 column = 0;row = row + 1; marginY = marginY + 30
 
 }
 }
 }*/
 
*/*/*/
