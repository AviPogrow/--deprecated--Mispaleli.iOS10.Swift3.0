//
//  AllPeopleViewController.swift
//  StackViews
//
//  Created by new on 7/10/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

class AllPeopleViewController: UITableViewController, UINavigationControllerDelegate {
	
	@IBOutlet weak var addPersonButton: UIBarButtonItem!
	
	var person:Person!
	
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
    }
    
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

	}
	override func viewDidLoad() {
	  super.viewDidLoad()
	 
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
        
        //1. set ourselves as the delegate of the navigationController
        navigationController?.delegate = self
        
        //2. get the value for the key "indexOfSelectedChecklist"
        //let index = person.indexOfSelectedChecklist
        
        //3. if index is NOT -1 then we need to segue
        //if index != -1 {
        //    let person = fetchedResultsController.object(at: index)
         //   performSegue(withIdentifier: "ShowKapitlach", sender: person)
        //}
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
      performSegue(withIdentifier: "ShowKapitlach", sender: indexPath)
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowKapitlach" {
            
        let navigationController = segue.destination as! UINavigationController
        let kapitlachViewController = navigationController.topViewController as!
                KapitlachViewController
            
            let indexPath = sender as! IndexPath
            
              let person = fetchedResultsController.object(at: indexPath)
            
            //4. write the value of the indexPath.row into UserDefaults
            // so we can segue to it later
            person.indexOfSelectedChecklist = indexPath.row
            
            kapitlachViewController.person = person
            
        } else if segue.identifier == "ShowNameEditor" {
            
            _ = sender as! UIBarButtonItem
            _ = segue.destination as! NameEditorViewController
        }
    }    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            person.indexOfSelectedChecklist = -1
        }
    }
    
    
    
    
    var row = 0
    override  func tableView(_ tableView: UITableView,
  		heightForRowAt indexPath: IndexPath) -> CGFloat {
	
    switch row  {
     case (0):
      return 60
     case (1):
		return 60
     default:
      return 90
     }
  }

	//Helper Method to configure table view cell
	func configureCell(_ cell:PersonCell, withPerson person: Person) {
	
        drawNewNameInCell(cell, withPerson: person)
	}

	func drawNewNameInCell(_ cell:PersonCell, withPerson person: Person) {

	// the default is to have 15 buttons across the screen
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
		
		cell.contentView.addSubview(imageView)
		
		column += 1
		if column == columnsPerPage {
		column = 0;row = row + 1; marginY = marginY + 30

			}
		}
	}
}

//denit ????????????????????????????????????????????????
//fetchedResultsController.delegate = nil??????????????????????????
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


	
	
	
	



