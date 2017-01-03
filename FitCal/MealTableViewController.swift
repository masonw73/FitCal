//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Mason Wesolek on 3/10/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import UIKit
import CoreData


@available(iOS 10.0, *)
class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    
    static var tasks = [Task]()
    let dataManager = DataController(context: DataController.getContext())
    
    var todo = [Todo]()
    var workout = [Workout]()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        todo = dataManager.getAllTodo()
        workout = dataManager.getAllWorkout()
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        self.tableView.reloadData()

        //Load the sample data
        //loadSampleMeals()
      
        
    }
    
    
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "todo")
        let task1 = Task(name: "Take out Trash", photo: photo1, rating: 4, date: NSDate() as Date)!
        
        let photo2 = UIImage(named: "workout")
        let task2 = Task(name: "3 mile run", photo: photo2, rating: 5, date: NSDate() as Date!, workoutTime: "30 min")!
        
        let photo3 = UIImage(named: "todo")
        let task3 = Task(name: "Clean dishes", photo: photo3, rating: 3, date: NSDate() as Date)!
        
        let photo4 = UIImage(named: "workout")
        let task4 = Task(name: "5 mile run", photo: photo4, rating: 5, date: NSDate() as Date!, workoutTime: "45 min")!
        
        MealTableViewController.tasks += [task1, task2, task3, task4]
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (todo.count + workout.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MealTableViewCell
        
        
        
        //Fetches the appropriate task for the data source layout.
        if (indexPath as NSIndexPath).row < todo.count {
            let todo = self.todo[(indexPath as NSIndexPath).row]
        
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            let stringDate = dateFormatter.string(from: (todo.date as! Date))
            
            cell.nameLabel.text = todo.name
            cell.photoImageView.image = UIImage(named: "todo")
            cell.ratingControl.rating = Int(todo.importance)
            cell.completeToggle.setOn(false, animated: true)
            cell.dateLabel.text = stringDate
        }
        else {
            let workout = self.workout[(indexPath as NSIndexPath).row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            
            cell.nameLabel.text = workout.name
            cell.photoImageView.image = UIImage(named: "workout")
            cell.ratingControl.rating = Int(workout.importance)
            cell.completeToggle.setOn(false, animated: true)
            cell.dateLabel.text = String(workout.timeLength)
        }

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            MealTableViewController.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destination as! MealViewController
            //Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPath(for: selectedMealCell)!
                todo = dataManager.getAllTodo()
                workout = dataManager.getAllWorkout()
                if(indexPath.row < todo.count) {
                    let selectedMeal = todo[(indexPath as NSIndexPath).row]
                    mealDetailViewController.task = selectedMeal
                } else {
                    let selectedMeal = workout[(indexPath as NSIndexPath).row]
                    mealDetailViewController.task = selectedMeal
                }
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToMealList(_ sender: UIStoryboardSegue) {
       if let sourceViewController = sender.source as? MealViewController, let task =
    sourceViewController.task {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Update an existing meal
            if task is Workout {
                let work = task as! Workout
                let workout = dataManager.getWorkoutById(id: work.objectID)!
                workout.date = work.date
                workout.importance = work.importance
                workout.isCompleted = work.isCompleted
                workout.name = work.name
                workout.timeLength = work.timeLength
                dataManager.saveData()
                
                
            }
            if task is Todo {
                let todo = task as! Todo
                let todos = dataManager.getTodoById(id: todo.objectID)!
                todos.date = todo.date
                todos.importance = todo.importance
                todos.isCompleted = todo.isCompleted
                todos.name = todo.name
                todos.timeToComplete = todo.timeToComplete
                dataManager.saveData()

            }
            
            self.tableView.reloadData()
        }
        else {
        // Add a new meal.
        let newIndexPath = IndexPath(row: MealTableViewController.tasks.count, section: 0)
        if task is Workout {
         let work = task as! Workout
         dataManager.createWorkout(date: work.date!, timeLength: work.timeLength, name: work.name!, isCompleted: work.isCompleted, importance: Int(work.importance))
        }
        if task is Todo {
         let todo = task as! Todo
         dataManager.createTodo(date: todo.date!, name: todo.name!, isCompleted: todo.isCompleted, timeToComplete: todo.timeToComplete, importance: Int(todo.importance), location: "Home")
        }
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        }
    }
  }
}



