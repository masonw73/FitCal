//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Mason Wesolek on 3/4/16.
//  Copyright © 2016 Mason Wesolek. All rights reserved.
//

import UIKit
import XCTest
@testable import FitCal

class FitCalTests: XCTestCase {
    
    //MARK: FoodTracker Tests
    
    //Tests to confirm that the Meal initializer returns when no name or a negative rating is provided
    func testMealInitialization() {
        let potentialItem = Task(name: "Newest meal", photo: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        //Failure Cases
        let noName = Task(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badRating = Task(name: "Really bad rating", photo: nil, rating: -1)
        XCTAssertNil(badRating, "Negative ratings are invalid, be positive")
    }
    
}
