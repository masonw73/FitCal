//
//  DataController.swift
//  FitCal
//
//  Created by Mason Wesolek on 12/27/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import UIKit
import CoreData
@available(iOS 10.0, *)
class DataController: NSObject {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    override  init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Data", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("Data.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }

    
    
    func getAllTodo() -> [Todo] {
        return getTodo(withPredicate: NSPredicate(value: true))
    }
    
    func getAllWorkout() -> [Workout] {
        return getWorkout(withPredicate: NSPredicate(value: true))
    }
    
    
//    create new Todo and return for use
    func createTodo(date: NSDate, name: String, isCompleted: Bool, timeToComplete: Double, importance: Int, location: String) -> Todo {
        let moc = self.context
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: moc) as! Todo
        entity.date = date
        entity.location = location
        entity.timeToComplete = timeToComplete
        entity.name = name
        entity.isCompleted = isCompleted
        entity.importance = Int16(importance)
        
        return entity
    }
    
    //Get todo by ID
    func getTodoById(id: NSManagedObjectID) -> Todo? {
        return context.object(with: id) as? Todo
    }
    
    
    //Get workout by ID
    func getWorkoutById(id: NSManagedObjectID) -> Workout? {
        return context.object(with: id) as? Workout
    }
    
    
    //Create new workout and return for use
    func createWorkout(date: NSDate, timeLength: Double, name: String, isCompleted: Bool, importance: Int) -> Workout {
        let moc = self.context
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: moc) as! Workout
        entity.date = date
        entity.timeLength = timeLength
        entity.name = name
        entity.isCompleted = isCompleted
        entity.importance = Int16(importance)
        
        return entity
    }
    //Gets all Todos that fulfill the specified predicate
    //Example:
    // NSPredicate(format: "name == %@", "Clean dishes")
    func getTodo(withPredicate queryPredicate: NSPredicate) -> [Todo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try context.fetch(fetchRequest) as! [Todo]
            return response
        } catch {
            return [Todo]()
            
            
            
        }
        
    }
    //Gets all Workouts that fulfill the specified predicate
    //Example:
    // NSPredicate(format: "name == %@", "Clean dishes")
    func getWorkout(withPredicate queryPredicate: NSPredicate) -> [Workout] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try context.fetch(fetchRequest) as! [Workout]
            return response
        } catch {
            return [Workout]()
            
            
            
        }
        
    }
    //Update a todo
    func updateTodo(updatedTodo: Todo) {
        if let entity = getTodoById(id: updatedTodo.objectID) {
            entity.date = updatedTodo.date
            entity.location = updatedTodo.location
            entity.timeToComplete = updatedTodo.timeToComplete
            entity.name = updatedTodo.name
            entity.isCompleted = updatedTodo.isCompleted
            entity.importance = Int16(updatedTodo.importance)
        }
    }
    
    //Update a workout
    func updateWorkout(updatedWorkout: Workout) {
        if let entity = getWorkoutById(id: updatedWorkout.objectID) {
            entity.date = updatedWorkout.date
            entity.timeLength = updatedWorkout.timeLength
            entity.name = updatedWorkout.name
            entity.isCompleted = updatedWorkout.isCompleted
            entity.importance = Int16(updatedWorkout.importance)

        }
    }
    
    //Delete todo from CoreData
    func deleteTodo(id: NSManagedObjectID) {
        if let todoToDelete = getTodoById(id: id) {
            context.delete(todoToDelete)
        }
    }
    
    //Delete workout from CoreData
    func deleteWorkout(id: NSManagedObjectID) {
        if let workoutToDelete = getWorkoutById(id: id) {
            context.delete(workoutToDelete)
        }
    }
    
    
    func nsToDate(date: NSDate) -> Date {
        
        let strTime = String(describing: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateNew = formatter.date(from: strTime)
        
        return dateNew!
        
        
    }
    
    
    
    //Saves all changes
    func saveData() {
        let moc = self.context
        do{
            try moc.save()
        } catch let error as NSError {
            // failure
            print(error)
        }
            
    }
    
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
        
        
        
        
        
        
        
        
    
}
