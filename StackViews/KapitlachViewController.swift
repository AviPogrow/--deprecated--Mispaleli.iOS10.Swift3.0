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
    
   
    @IBOutlet weak var storyTextView: UIView!
    var bookTextView: UITextView!
  
   
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
        
        gameView.layer.borderWidth = 1.35
        gameView.layer.borderColor = UIColor.red.cgColor
        gameView.layer.cornerRadius = 10
        
        
        drawNewName(withPerson: person, atCurrentIndex: currentLocalIndex)
      
		
        do {
            try fetchedResultsController.performFetch()
       		 } catch {}
    }
	
	
    func addGestures() {
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeChapter(_:)))
        
        swipeRightGesture.direction = .right
        
        storyTextView.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeChapter(_:)))
        
        swipeLeftGesture.direction = .left
        
        storyTextView.addGestureRecognizer(swipeLeftGesture)
    }
    
    
    func changeChapter(_ gesture:UISwipeGestureRecognizer) {
        
       audioController.playEffect(SoundPop)
       if gesture.direction == .right {
            
            currentLocalIndex = (currentLocalIndex + 1)
        }
     
        if gesture.direction == .left {
           
            currentLocalIndex = (currentLocalIndex - 1)
            
        }
        updateNameDisplay()
    }
    
    //update the text view with chapter Text
    // update the gameView view
    func updateNameDisplay(){
        
        for view in gameView.subviews {
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
    
    //3. current row and column number
    var row = 0
    var column = 1
    
    
    //4. calculate the width and height of each square tile
    let tileSide = ceil(ScreenWidth / CGFloat(14.5))
    
    var  marginX = view.bounds.width - 3
    let x = marginX
    
    
    var  marginY = (CGFloat(row) * tileSide)
    var y = marginY + 10
        

  //********************** start the for loop ***************************
   for (index, lettr) in person.lettersInName.enumerated() {
            
              let tile = TileView(letter: lettr.hebrewLetterString!, sideLength: tileSide)
 
            tile.frame = CGRect(
                x: x + (CGFloat(column) * -tileSide),  //22 is the same as tileSide
                // the first letter is drawn
                // margin x (-3 points from right edge)
                // + (0 * -22) so it gets drawn -25 from right edge
                y: y,
                
                width: tileSide, height: tileSide)
            
            print("******************the value of tileside is \(tileSide)")
            print("the value of the frame is \(tile.frame)")
            
            gameView.addSubview(tile)
    let viewToExplode = gameView.subviews.last
    let explode = ExplodeView(frame:CGRect(x: viewToExplode!.center.x, y: viewToExplode!.center.y, width: 2,height: 2))
    tile.superview?.addSubview(explode)
    tile.superview?.sendSubview(toBack: explode)
    
    if index == currentLocalIndex {
        
        //get a referene to the path to the SampleData.plist
        let path = Bundle.main.path(forResource: "Tehillim119", ofType: "plist")
        
        //pull out the array holding one dictionary
        let dataArray = NSArray(contentsOfFile: path!)!
                
        //extract the first object from the array
        // which will be a dictionary with key:Values for all Kapitlach
        var textDict  = dataArray.firstObject as! NSDictionary
                
        //get the string for the current kapitel for current letter
        var textStringForKapitel = "\(lettr.kapitelImageString!)"
        
        //Use the string as a key to extract the associated value 
        // use the associated string to set the bookTextView
        bookTextView = UITextView()
        
        let bookTextViewHeight = ScreenHeight * 0.90
        bookTextView.frame = CGRect(x: 0,
                                    y: ScreenHeight-bookTextViewHeight,
                                    width: ScreenWidth,
                                    height: bookTextViewHeight)
        
        //bookTextView.frame = storyTextView.bounds
        bookTextView.textAlignment = .center
        
        bookTextView.font = UIFont.systemFont(ofSize: 25)
        bookTextView.isSelectable = false
        bookTextView.isEditable = false
        bookTextView.text = textDict[textStringForKapitel] as! String
        
        bookTextView.contentOffset = .zero
        bookTextView.scrollRectToVisible(
            CGRect(origin: .zero, size: bookTextView.bounds.size),
            animated: false)
        
        
        print("state of bookTextView.text is \(bookTextView.text.description)")
                
                tile.alpha = 1.0
                tile.layer.borderWidth = 3.35
                tile.layer.borderColor = UIColor.red.cgColor
                tile.layer.cornerRadius = 3
            }
            
            
            gameView.addSubview(tile)
            storyTextView.addSubview(bookTextView)
            
            column += 1
            if column == columnsPerPage {
                column = 0; row = row + 1; marginY = marginY + 30
                
            }
        }
    }
    // MARK:- Scroll text on rotation
    
    override func viewDidLayoutSubviews() {
        bookTextView.scrollRangeToVisible(visibleRangeOfTextView(bookTextView))
    }
    
    // courtesy of
    // http://stackoverflow.com/a/28896715/359578    
    
    fileprivate func visibleRangeOfTextView(_ textView: UITextView) -> NSRange {
        let bounds = textView.bounds
        let origin = CGPoint(x: 100,y: 100) //Overcome the default UITextView left/top margin
        let startCharacterRange = textView.characterRange(at: origin)
        if startCharacterRange == nil {
            return NSMakeRange(0,0)
        }
        let startPosition = textView.characterRange(at: origin)!.start
        
        let endCharacterRange = textView.characterRange(at: CGPoint(x: bounds.maxX, y: bounds.maxY))
        if endCharacterRange == nil {
            return NSMakeRange(0,0)
        }
        let endPosition = textView.characterRange(at: CGPoint(x: bounds.maxX, y: bounds.maxY))!.end
        
        let startIndex = textView.offset(from: textView.beginningOfDocument, to: startPosition)
        let endIndex = textView.offset(from: startPosition, to: endPosition)
        return NSMakeRange(startIndex, endIndex)
    }
    
    
    
    
    
    
    
    
    /*
     func loadKapitelForCurrentLetter() {
     
     //1. get a referene to the path to the SampleData.plist
     let path = Bundle.main.path(forResource: "Tehillim119", ofType: "plist")
     
     //2. pull out the array holding one dictionary
     let dataArray = NSArray(contentsOfFile: path!)!
     print("data array looks like this \(dataArray)")
     
     //3. extract first object from array which is an NSDictionary
     // store it in textDict
     var textDict  = dataArray.firstObject as! NSDictionary
     
     //4.get the string for the current kapitel for current letter
     
     var textStringForKapitel = "\(lettr.kapitelImageString!)"
     
     //5. Use the string as a key to extract the associated value
     // use the associated string value to set the bookTextView.text property
     
     bookTextView.text = textDict[textStringForKapitel] as! String
     }
     */
    
    
    
    
    
    
    
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
