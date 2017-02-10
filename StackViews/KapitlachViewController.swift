//
//  YehiRatzonViewController.swift
//  StackViews
//
//  Created by new on 7/31/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//
import UIKit
import CoreData

//1. import AVFoundation
import AVFoundation

class KapitlachViewController: UIViewController, NSFetchedResultsControllerDelegate {
	
    //2. store audio player as a property
    var dingSoundEffect: AVAudioPlayer!
    
    //A.
    //B. 4 View instance variables
    //1
    let cancelButton = UIButton()
    //2
    
    @IBOutlet weak var gameView: UIView!
    
    //3
    @IBOutlet weak var storyTextView: UIView!
    
    var bookTextView: UITextView!
   
    //C. 3 Data Model instance variables
    
    //1. person object to pass into fetch request
    var person:Person!
    
    //3. managedObject context to pass to the fetchedResultsController
    // to interface with core data stack
	lazy var sharedContext: NSManagedObjectContext = {
	 return CoreDataStackManager.sharedInstance().managedObjectContext
	 }()
	
	//4. FRC to make fetchRequest/ hold the results/ and update the tableView
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
	
    //D. 1 instance variable to handle audio effects
   // fileprivate  var audioController: AudioController
	
    
    // MARK:- 4 View Controller methods
    //1. required init
    required init?(coder aDecoder: NSCoder) {
			super.init(coder: aDecoder)
        //audioController = AudioController()
		//audioController.preloadAudioEffects(AudioEffectFiles)
		
	// tell UIKit that this VC uses a custom presentation
		modalPresentationStyle = .custom
		
		//set the delegate that will call the methods for the 
		// custom presentation
		transitioningDelegate = self
		
	}
	//2. viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
     
        
        //1. data model  fetch method
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        //2.
        //3. color the gameView
        colorViews()
        
        //4. add two gesture recognizers to detect swipe
        // right or left
        addGestures()
        
        //4. add subviews to main view
        //addViews()
        
        //5. setup frames or setup constraints
        //6. Update gameView and textView with newly fetched data
        updateNameAndTextDisplay()
        
        //7. play sound during scene loading
        //3. find sound file using path(forResourse:)
        let path = Bundle.main.path(forResource: "button_press.wav", ofType: nil)!
        //4. create a file url
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            dingSoundEffect = sound
            sound.play()
            
        } catch {
            print("couldn't load file")
        }
        //audioController.playEffect(SoundPop)
    }
    
    // 3. ViewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        //print("scroll range function invoked")
        //bookTextView.scrollRangeToVisible(visibleRangeOfTextView(bookTextView))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let dataModel = DataModel()
        dataModel.indexOfSelectedChecklist = -1
        print("the state of indexOfChecklist  is \(dataModel.indexOfSelectedChecklist)")
    }
    
    func addGestures() {
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeChapter(_:)))
        
        swipeRightGesture.direction = .right
        
        storyTextView.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeChapter(_:)))
        
        swipeLeftGesture.direction = .left
        
        storyTextView.addGestureRecognizer(swipeLeftGesture)
    }
    
    //2. Change the highlighted letter and displayed text
    func changeChapter(_ gesture:UISwipeGestureRecognizer) {
        
       //audioController.playEffect(SoundPop)
       if gesture.direction == .right {
        
        person.currentKapitelIndex = (person.currentKapitelIndex + 1)
      
        print("the current state of person is \(person.currentKapitelIndex)")
        
        if person.currentKapitelIndex > (100 + person.lettersInName.count) {
         print("person index is too high")
        person.currentKapitelIndex = (person.currentKapitelIndex - 1)
        print("the current state of person is \(person.currentKapitelIndex)")
        }
          CoreDataStackManager.sharedInstance().saveContext()
        }
     
        if gesture.direction == .left {
        
            person.currentKapitelIndex = (person.currentKapitelIndex - 1)
            
            print("the current state of person is \(person.currentKapitelIndex)")
        
            if person.currentKapitelIndex < 101 {
            print("person index is too low")
            person.currentKapitelIndex = (person.currentKapitelIndex + 1)
                }
            CoreDataStackManager.sharedInstance().saveContext()
        }
        updateNameAndTextDisplay()
    }
  
    //3. load and reload the gameView with highlighted letter
    // load and reload the textView
    func updateNameAndTextDisplay(){
        
        for view in gameView.subviews {
            view.removeFromSuperview()
        }
        
        drawNameAndLoadText(withPerson: person)
    }
    
    //4. Color the views
    func colorViews() {
        
        gameView.layer.borderWidth = 1.35
        gameView.layer.borderColor = UIColor.red.cgColor
        gameView.layer.cornerRadius = 10
    }
	
    //5. If user taps cancel dismiss VC with sound effect
	@IBAction func saveButtonPressed(_ sender: AnyObject) {
		//audioController.playEffect(SoundWin)
		dismiss(animated: true, completion: nil)
    }
	
    @IBAction func doneButtonPressed(_ sender: Any) {
        person.currentKapitelIndex = 101
        CoreDataStackManager.sharedInstance().saveContext()
        
        //audioController.playEffect(SoundWin)
        dismiss(animated: true, completion: nil)
    }
	
    func drawNameAndLoadText(withPerson person: Person) {
    
    // the default is to have 15 buttons across the screen
    let columnsPerPage = 13
    
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
                x: x + (CGFloat(column) * -tileSide),
                y: y,
                width: tileSide, height: tileSide)
            
            tile.addLayerEffect()
            
            gameView.addSubview(tile)
            column = column +  1
    
        let viewToExplode = gameView.subviews.last
        let explode = ExplodeView(frame:CGRect(x: viewToExplode!.center.x, y: viewToExplode!.center.y, width: 2,height: 2))
        tile.superview?.addSubview(explode)
        tile.superview?.sendSubview(toBack: explode)
    
        if column == columnsPerPage {
        column = 1; row = row + 1; y = y + 30
      }
    
     let index = Int16(index + 101)
    
      if index == person.currentKapitelIndex {
       
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
        let bookTextViewHeight = ScreenHeight * 1.00
        
        bookTextView.frame = CGRect(
            x: 0,
            y: ScreenHeight - bookTextViewHeight,
            width: ScreenWidth - 8,
            height: bookTextViewHeight)
 
        //bookTextView.frame = CGRect(origin: .zero, size: storyTextView.bounds.size)
        bookTextView.textAlignment = .center
        bookTextView.makeTextWritingDirectionRightToLeft(self)
        
      
       
        bookTextView.font = UIFont.systemFont(ofSize: 26.5)
        
        
        
        bookTextView.isSelectable = false
        bookTextView.isEditable = false
        
        bookTextView.text = textDict[textStringForKapitel] as! String
                tile.alpha = 1.0
                tile.layer.borderWidth = 3.35
                tile.layer.borderColor = UIColor.red.cgColor
                tile.layer.cornerRadius = 3
        
        storyTextView.addSubview(bookTextView)
            }
        }
    }
    // courtesy of
    // http://stackoverflow.com/a/28896715/359578    
    
    fileprivate func visibleRangeOfTextView(_ textView: UITextView) -> NSRange {
        
        print("visibleRangeOfTextView inoked")
        
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


