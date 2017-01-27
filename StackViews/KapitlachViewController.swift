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

class KapitlachViewController: UIViewController,
			UITableViewDelegate, UITableViewDataSource , NSFetchedResultsControllerDelegate {
	
	
	@IBOutlet weak var tapOutsideBox: UIButton!
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
	
	@IBOutlet weak var tableView: UITableView!
	
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
		
		automaticallyAdjustsScrollViewInsets = false 
		
		tableView.layer.cornerRadius = 10
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(KapitlachViewController.close))
		gestureRecognizer.cancelsTouchesInView = false
		gestureRecognizer.delegate = self
		view.addGestureRecognizer(gestureRecognizer)
		
		view.backgroundColor = UIColor.clear
		
		// Step 2: invoke fetchedResultsController.performFetch(nil) here
       		 do {
            try fetchedResultsController.performFetch()
       		 } catch {}
        
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	
		tapOutsideBox.layer.cornerRadius = 5
	
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
    
    // MARK: - Table View Data Source Methods
    func numberOfSections(in tableView: UITableView) -> Int {
		
	 return fetchedResultsController.sections!.count
 	 }
	
	  // MARK: - UITableViewDelegate
  
	var row = 0
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

	let separatorRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 0.5, width: tableView.bounds.size.width - 15, height: 0.5)
    let separator = UIView(frame: separatorRect)
    separator.backgroundColor = tableView.separatorColor
    let viewRect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.sectionHeaderHeight)
    let view = UIView(frame: viewRect)
	view.addSubview(separator)
	view.backgroundColor = UIColor.white
	
	// the default is to have 20 buttons across the screen
		let columnsPerPage = 15
	
	
		//distance from right side of screen
		let marginX = view.bounds.width - 26
	
		//the distance from the top of the cell's view
		var marginY: CGFloat = 5
	
		// first row across is numbered 0 and set as default
		  row = 0
	
		// first column going down is numbered 0 and set as default
		var column = 0
	
		// set x to the value of margin x (0-2)
		let x = marginX
	
        for (_, lettr) in person.lettersInName.enumerated() {

		let imageView = UIImageView()
		let image = UIImage(named: lettr.hebrewLetterString!)
	
	    _ = CGRect(x: 5,
	        y: 2,
	       width: 20,
	       height: 20)
	 
	    imageView.image = image
	
	    imageView.frame = CGRect(
		x: x + (CGFloat(column * -19)),
		
		y: marginY,
		
		width: 20, height: 20)
	
		imageView.contentMode = .scaleAspectFill
		
		view.addSubview(imageView)
		
		column += 1
		if column == columnsPerPage {
		column = 0;row = row + 1; marginY = marginY + 30
		
		}
	}
		return view
  }
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
   
	 return "Psalm 119 In Order of The Letters"
  	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     let sectionInfo = self.fetchedResultsController.sections![section]
		
     return sectionInfo.numberOfObjects
    }
	
	var aspectRatioForImage = 1/1
	
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
	let CellIdentifier = "KapitelCell"
	
	let  cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)

	let letter = fetchedResultsController.object(at: indexPath) 
	let kapitelImageString = letter.kapitelImageString
	
	let imageForKapitel = UIImage(named: kapitelImageString!)
	
	_ = tableView.bounds.size.width / imageForKapitel!.size.width
	let kapitelSide:CGFloat = tableView.bounds.size.width
	
	//set up the kapitel image view
	let kapitelImageView = TileView(letter: kapitelImageString!, sideLength: kapitelSide)
	
	if UIImage(named: kapitelImageString!) != nil {
	
	cell.contentView.addSubview(kapitelImageView)
	}
    return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
	
		return tableView.bounds.size.width
	}

	
	func drawNewNameInHeaderViewWithPerson(_ person: Person) {
		
    // the default is to have 20 buttons across the screen
		let columnsPerPage = 15
	
	
		//distance from right side of screen
		let marginX = view.bounds.width - 26
	
		//the distance from the top of the cell's view
		var marginY: CGFloat = 5
	
		// first row across is numbered 0 and set as default
		  row = 0
	
		// first column going down is numbered 0 and set as default
		var column = 0
	
		// set x to the value of margin x (0-2)
		let x = marginX
	
		
		//********* Draw Hebrew Letters of Name on TableView Cell************************
		//********************************************************************************
		
		for (_, lettr) in person.lettersInName.enumerated() {
		
		let imageView = UIImageView()
		let image = UIImage(named: lettr.hebrewLetterString!)
		
		imageView.image = image
		imageView.frame = CGRect(
		x: x + (CGFloat(column * -19)),
		
		y: marginY,
		
		width: 20, height: 20)
		
		imageView.contentMode = .scaleAspectFill
		
		view.addSubview(imageView)
		
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

















