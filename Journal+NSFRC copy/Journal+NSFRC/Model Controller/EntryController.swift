//
//  EntryController.swift
//  Journal+NSFRC
//
//  Created by Karl Pfister on 5/9/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.


import Foundation
import CoreData

class EntryController {
    
    static let sharedInstance = EntryController()
    
    // Needs initializer
    var fetchedResultsController: NSFetchedResultsController<Entry>
    
    // Initializer for above property to give its value
    init() {
        
        // Created in order to fulfill the parameter requerment of the resultscontroller's initializer
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        // accessed sortdescriptors property on our fetch request and told it how we want it sorted when it returns the values
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        // constant called resultscontroller that equaals a nsfetchedresultscontroller initialized from the available initializer
        let resultsController: NSFetchedResultsController<Entry> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // assigned our variable the value of the results controller
        fetchedResultsController = resultsController
        
        // performing the fetch can cause an error, so docatch block is required
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch: \(error.localizedDescription)")
        }
    }
    
//    var entries: [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
//    }
    
    //CRUD
    func createEntry(withTitle: String, withBody: String) {
        let _ = Entry(title: withTitle, body: withBody)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, newTitle: String, newBody: String) {
        entry.title = newTitle
        entry.body = newBody
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        entry.managedObjectContext?.delete(entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
             try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object. Items not saved!! \(#function) : \(error.localizedDescription)")
        }
    }
}
