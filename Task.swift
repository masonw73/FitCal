//
//  Task.swift
//  FitCal
//
//  Created by Mason Wesolek on 3/8/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import UIKit

class Task {
    //MARK: Properties

    var name: String
    var photo: UIImage?
    var rating: Int
    var date: Date
    var workoutTime: String
    var isCompleted: Bool
    
    //MARK: Types
    
    
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int, date: Date) {
        //Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
        self.date = date
        self.workoutTime = "notworkout"
        self.isCompleted = false
        
        // Initialization should fail if there is no name or if the rating is negative
        if name.isEmpty || rating < 0 {
            return nil
        }
}
    init?(name: String, photo: UIImage?, rating: Int, date: Date, workoutTime: String) {
        //Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
        self.date = date
        self.workoutTime = workoutTime
        self.isCompleted = false
        
        // Initialization should fail if there is no name or if the rating is negative
        if name.isEmpty || rating < 0 {
            return nil
        }
    }

}
