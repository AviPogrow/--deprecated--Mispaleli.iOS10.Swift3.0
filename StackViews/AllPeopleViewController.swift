//
//  AllPeopleViewController.swift
//  StackViews
//
//  Created by new on 7/10/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

class AllPeopleViewController: UITableViewController,
                    UINavigationControllerDelegate { //1.Declare conformance
                                            //NavControllerDelegateProtocol
	
	@IBOutlet weak var addPersonButton: UIBarButtonItem!
	
	var person:Person!
	
	var dataModel: DataModel!
    
    lazy var sharedContext: NSManagedObjectContext = {
	 return CoreDataStackManager.sharedInstance().managedObjectContext
	 }()
    
  lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
        let fetchRequest = NSFetchRequest<Person>()
        
        let entity = Person.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor1 = NSSortDescriptor(key: "dateCreated", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    deinit {
        fetchedResultsController.delegate = nil
        print("deinint \(self)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

	}
	override func viewDidLoad() {
	  super.viewDidLoad()
        
        //2. set ourselves as the delegate of the navigationController
        navigationController?.delegate = self
        navigationItem.leftBarButtonItem = self.editButtonItem
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
	 
    }
	
    @IBAction func addPerson(_ sender: UIBarButtonItem) {
		
		performSegue(withIdentifier: "ShowNameEditor", sender: sender)
	
	}
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //3. get the value for the key "indexOfSelectedChecklist"
        let index = dataModel.indexOfSelectedChecklist
        print("the value for index is \(index)")
        
        let indexPath = NSIndexPath(item: index, section: 0)
        
        //4. if index is NOT -1 then we need to segue
        if index != -1 {
        let person = fetchedResultsController.object(at: indexPath as IndexPath)
            performSegue(withIdentifier: "ShowKapitlach", sender: person)
       
        }
    }
   
    //keep track if view controller is in edit mode the user can't open the nameEditor scene
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		if editing {
		 addPersonButton.isEnabled = false
		 } else {
		 addPersonButton.isEnabled = true 
		 }
	}
	// MARK: - Table View Data Source Methods
    
	override func numberOfSections(in tableView: UITableView) -> Int {
    
     return fetchedResultsController.sections!.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     _ = fetchedResultsController.sections![section]
   
	 return "Tap a Name to Read Psalm 119"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
		
        return sectionInfo.numberOfObjects
    }
	
	override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let CellIdentifier = "PersonCell"
            
		let person = fetchedResultsController.object(at: indexPath)
      
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! PersonCell
   
		configureCell(cell, withPerson:  person)
		return cell
    }
	
	override func tableView(_ tableView: UITableView, commit
 							editingStyle: UITableViewCellEditingStyle,
							forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
      
      let person = fetchedResultsController.object(at: indexPath)
      sharedContext.delete(person)
      
      do {
        try sharedContext.save()
      } catch {
		//print("core data error")
		//fatalCoreDataError(error)
            }
        }
    }
	
    override func tableView(_ tableView: UITableView,
						didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
        
        //5. write the value of the indexPath.row into UserDefaults
        // so we can segue to it later
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        print("the state of dataModel.index is \(dataModel.indexOfSelectedChecklist)")
        
        let person = fetchedResultsController.object(at: indexPath)
        
        performSegue(withIdentifier: "ShowKapitlach", sender: person)
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowKapitlach" {
            
        let navigationController = segue.destination as! UINavigationController
        let kapitlachViewController = navigationController.topViewController as!
                KapitlachViewController
            
            let person = sender as! Person
            
            kapitlachViewController.person = person
            
        } else if segue.identifier == "ShowNameEditor" {
            _ = segue.destination as! NameEditorViewController
        }
    }    
    //6. If navigation controller pops the KapitelVC then set index
    // to -1
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
           print("popped")
        }
    }
    
   override  func tableView(_ tableView: UITableView,
  		heightForRowAt indexPath: IndexPath) -> CGFloat {
	
    
      return 86.0
     }
  }

	//Helper Method to configure table view cell
	func configureCell(_ cell:PersonCell, withPerson person: Person) {
	
       
        drawNewNameInCell(cell, withPerson: person)
	}

	func drawNewNameInCell(_ cell:PersonCell, withPerson person: Person) {

	// the default is to have 15 buttons across the screen
		let columnsPerPage = 13
	
        var row = 0
        var column = 1
        
        let tileSide = ceil(ScreenWidth / CGFloat(14.5))
    
        //distance from right side of screen
		let marginX = ScreenWidth - 3
        // set x to the value of margin x (0-2)
        let x = marginX
	
    
        let marginY = (CGFloat(row) * tileSide)
        var y = marginY + 10
   
	
        for (_, lettr) in person.lettersInName.enumerated() {
		
            let tile = TileView(letter: lettr.hebrewLetterString!, sideLength: tileSide)
            
            tile.frame = CGRect(
                x: x + (CGFloat(column) * -tileSide),
                y: y,
                width: tileSide, height: tileSide)
            
        tile.addLayerEffect()
        cell.contentView.addSubview(tile)
         
		
		column = column +  1
		if column == columnsPerPage {
		column = 1;row = row + 1; y = y + 30

			}
		}
}



//******* NSFetchedResults Controller Delegate methods ***********************
	
extension AllPeopleViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //print("*** controllerWillChangeContent")
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      //print("*** NSFetchedResultsChangeInsert (object)")
      tableView.insertRows(at: [newIndexPath!], with: .fade)
	  //tableView.reloadData()
      
    case .delete:
     // print("*** NSFetchedResultsChangeDelete (object)")
      tableView.deleteRows(at: [indexPath!], with: .fade)
      
    case .update:
    //  print("*** NSFetchedResultsChangeUpdate (object)")
      if let cell = tableView.cellForRow(at: indexPath!) as? PersonCell {
        let person = controller.object(at: indexPath!) as! Person
        configureCell(cell, withPerson: person)
      }
    case .move:
      //print("*** NSFetchedResultsChangeMove (object)")
      tableView.deleteRows(at: [indexPath!], with: .fade)
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
   //   print("*** NSFetchedResultsChangeInsert (section)")
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
      
    case .delete:
    //  print("*** NSFetchedResultsChangeDelete (section)")
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
      
    case .update:
      print("*** NSFetchedResultsChangeUpdate (section)")
      
    case .move:
      print("*** NSFetchedResultsChangeMove (section)")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //print("*** controllerDidChangeContent")
    tableView.endUpdates()
  }
}


	
	
	
	



