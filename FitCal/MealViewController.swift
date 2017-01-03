//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Mason Wesolek on 3/4/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import UIKit
import WatchConnectivity

@available(iOS 10.0, *)
class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var workoutButton: UIButton!
    @IBOutlet weak var myDate: UIDatePicker!
    @IBOutlet weak var workoutTime: UITextField!
    @IBOutlet weak var savedWorkout: UIButton!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var savedPicker: UIPickerView!
    @IBOutlet weak var hidePicker: UIButton!
    
    /*
    This value is either passed by MealTableViewController in
        prepareForSegue(_:sender:)
    or constructed as part of adding a new meal.
    */
    
    var task: AnyObject?
    static var savedWorkouts = [Task]()
    let dataManager = DataController(context: DataController.getContext())
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.savedPicker.dataSource = self
        self.savedPicker.delegate = self
        pickerView.isHidden = true
        savedWorkout.isEnabled = false
        
       // Handle the text field's user imput through delegate callbacks
        nameTextField.delegate = self
        print(task.debugDescription)
        if task != nil {
            if let tasks = task as? Workout {
                photoImageView.image = UIImage(named: "workout")
                ratingControl.rating = Int(tasks.importance)
                navigationItem.title = tasks.name
                nameTextField.text = tasks.name
            }
            if let tasks = task as? Todo {
                photoImageView.image = UIImage(named: "todo")
                ratingControl.rating = Int(tasks.importance)
                navigationItem.title = tasks.name
                nameTextField.text = tasks.name
            }
            
        }
        
               
        
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName()
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set PhotoImageView to display the selected image
        photoImageView.image = selectedImage
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
        dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let barButton = sender as? UIBarButtonItem {
        if saveButton === barButton {
            let name = nameTextField.text ?? ""
            let rating = ratingControl.rating
            let date = myDate.date
            let workoutTime = self.workoutTime.text ?? ""
            
            if(photoImageView.image == UIImage(named: "todo")) {
                dataManager.createTodo(date: date as NSDate, name: name, isCompleted: false, timeToComplete: 60, importance: rating, location: "Home")
                print("saved!")
            }
            if(photoImageView.image == UIImage(named: "workout")) {
                dataManager.createWorkout(date: date as NSDate, timeLength: 60, name: name, isCompleted: false, importance: rating)
            }
        }
        }
    }
    
    // MARK: Actions
    /*
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyboard
        nameTextField.resignFirstResponder()
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        //Only allows photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    */
    
    @IBAction func donePicker(_ sender: Any) {
        pickerView.isHidden = true
    }
    
    @IBAction func workout(_ sender: AnyObject) {
        
        photoImageView.image = UIImage(named: "workout")
        savedWorkout.isEnabled = true
    }
    
   
    @IBAction func todo(_ sender: AnyObject) {
        
        photoImageView.image = UIImage(named: "todo")
        savedWorkout.isEnabled = false
        
    }
    
    @IBAction func displaySaved(_ sender: Any) {
        pickerView.isHidden = false
    }
   
    @IBAction func addSaved(_ sender: Any) {
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let date = myDate.date
        let workoutTime = self.workoutTime.text ?? ""
        
        if(photoImageView.image == UIImage(named: "todo")) {
            let alertController = UIAlertController(title: "Not a workout", message:
                "Please only save workouts", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        if(photoImageView.image == UIImage(named: "workout")) {
            task = Task(name: name, photo: photo, rating: rating, date: date, workoutTime: workoutTime)
            MealViewController.savedWorkouts.append(task! as! Task)
            print(MealViewController.savedWorkouts[0].name)
        }

        
    }
    
    

  }

@available(iOS 10.0, *)
extension MealViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ savedPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(MealViewController.savedWorkouts.count == 0) {
            return 1
        }
        else {
            return MealViewController.savedWorkouts.count;
        }
    }
    
    func pickerView(_ savedPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(MealViewController.savedWorkouts.count == 0) {
            return "None"
        }
        else {
            return MealViewController.savedWorkouts[row].name
        }
    }
    
    func pickerView(_ savedPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        nameTextField.text = MealViewController.savedWorkouts[row].name
        photoImageView.image = UIImage(named: "workout")
        ratingControl.rating = MealViewController.savedWorkouts[row].rating
        myDate.date = MealViewController.savedWorkouts[row].date
        self.workoutTime.text = MealViewController.savedWorkouts[row].workoutTime
    
    }
    
    
    
}

