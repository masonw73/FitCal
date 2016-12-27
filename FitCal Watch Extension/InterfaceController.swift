//
//  InterfaceController.swift
//  FitCal Watch Extension
//
//  Created by Mason Wesolek on 11/6/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session : WCSession!
    
    override func willActivate() {
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sendToPhone(key: String, message: AnyObject) {
        NSLog("Sending to phone")
        // Grab our phone session we activated earlier
        if let ses = session {
            // If we can reach the phone
            if (WCSession.default().isReachable) {
                // Make a key value pair with our cached data.
                let applicationData = [key:message]
                // Send it to the phone
                ses.sendMessage(applicationData, replyHandler: {(replyMessage: [String : Any]) -> Void in
                NSLog("def sent")
                    // Grab a from the phone right here.
                    NSLog("Got reply" + (replyMessage["reply"] as! String))
                }, errorHandler: {(error ) -> Void in
                    // In case we get an error from the phone
                    NSLog("Error :( " + error.localizedDescription)
                })
            } else {
                NSLog("Well, we couldn't reach the iPhone");
            }
            NSLog("Sent to phone")
        }
    }

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
        
        /*
         Called when the activation of a session finishes. Your implementation
         should check the value of the activationState parameter to see if
         communication with the counterpart app is possible. When the state is
         WCSessionActivationStateActivated, you may communicate normally with
         the other app.
         */
        
        print("session activated with state: \(activationState.rawValue)")
    }
    
    
    @IBAction func bigButtonPress() {
        sendToPhone(key: "pushed", message: "Hey there!" as AnyObject)
    }
    
    

}
