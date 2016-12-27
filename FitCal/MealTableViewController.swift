//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Mason Wesolek on 3/10/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import UIKit


class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    
    static var tasks = [Task]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        

        //Load the sample data
        loadSampleMeals()
      
        
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
        return MealTableViewController.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MealTableViewCell
        
        //Fetches the appropriate meal for the data source layout.
        let meal = MealTableViewController.tasks[(indexPath as NSIndexPath).row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let stringDate = dateFormatter.string(from: meal.date)
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        cell.completeToggle.setOn(false, animated: true)
        
        if(meal.photo == UIImage(named: "todo")) {
            cell.dateLabel.text = stringDate
        }
        if(meal.photo == UIImage(named: "workout")) {
            cell.dateLabel.text = meal.workoutTime
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
                let selectedMeal = MealTableViewController.tasks[(indexPath as NSIndexPath).row]
                mealDetailViewController.task = selectedMeal
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
            MealTableViewController.tasks[selectedIndexPath.row] = task
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        // Add a new meal.
        let newIndexPath = IndexPath(row: MealTableViewController.tasks.count, section: 0)
        MealTableViewController.tasks.append(task)
        tableView.insertRows(at: [newIndexPath], with: .bottom)
    }
  }
}



