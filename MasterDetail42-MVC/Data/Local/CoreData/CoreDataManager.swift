//
//  CoreDataManager.swift
//  MasterDetail42-MVC
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/09.
//

import Foundation
import CoreData

// MARK: - CoreDataManager

class CoreDataManager {
    
    // MARK: - Core Data stack

    static let shared = CoreDataManager()
    
    private let containerName = "Tracks"
    private let entityName = "Track"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Insert, Get, Delete methods
    
    func insertTracks(trackList: TrackList?) {
        guard let tracks = trackList?.tracks else { return }
        
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        
        for item in tracks {
            let track = NSManagedObject(entity: entity, insertInto: context)
            track.setValue(item.artwork, forKeyPath: "artwork")
            track.setValue(item.genre, forKeyPath: "genre")
            track.setValue(item.longDescription, forKeyPath: "longDescription")
            track.setValue(item.price, forKeyPath: "price")
            track.setValue(item.trackName, forKeyPath: "trackName")
            saveContext()
        }
    }
    
    func getTracks() -> [Track]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        }
        catch {
            debugPrint(error)
        }
        
        return nil
    }
    
    func deleteTracks() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }

}
