//
//  CalendarViewController.swift
//  FoodTracker
//
//  Created by Mason Wesolek on 11/15/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import UIKit
import CVCalendar
import WatchConnectivity



class CalendarViewController: UIViewController, WCSessionDelegate  {
    
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    @IBOutlet weak var calendarView: CVCalendarView!

    @IBOutlet weak var todoText: UITextView!
    @IBOutlet weak var workoutText: UITextView!
    
   
    var selectedDay:DayView!
    var session: WCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.contentController.refreshPresentedMonth()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self;
            session.activate()
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        print(MealTableViewController.tasks[0].name)
        selectedDay = dayView
        workoutText.text = "Workouts: "
        todoText.text = "To-do's: "
        for Task in MealTableViewController.tasks {
            print("hi")
            print(Task.date)
            print(selectedDay.date.convertedDate()!)
            if(NSCalendar.current.compare(Task.date, to: selectedDay.date.convertedDate()!, toGranularity: .day) == .orderedSame) {
                if(Task.photo == UIImage(named: "workout")) {
                    workoutText.text.append("\n" + Task.name + " for " + Task.workoutTime)
                }
                if(Task.photo == UIImage(named: "todo")) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .short
                    let string = dateFormatter.string(from: Task.date)
                    todoText.text.append("\n" + Task.name + " at " + string)
                }
                
            }
        selectedDay = dayView
            
        }
        
        
    }
 
    //Watch Message
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        NSLog("Got the message")
        let alertController = UIAlertController(title: "Workouts left", message:
            generateTimes(), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func generateTimes() -> String {
        
        var incompleteWork = [Task]()
        for workouts in MealTableViewController.tasks {
            if(workouts.isCompleted == false && workouts.photo == UIImage(named: "workout")) {
                incompleteWork.append(workouts)
            }
            
        }
        
        let alert = String.init(format: "You have: %d tasks left\n\n3 mile run\n\n5 mile run", incompleteWork.count)
        
        
        return alert
        
        
        
    }
    
    
    

    
    
}

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
  
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription  {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
 
    }
}
    
   
    
    







