//
//  LaunchViewController.swift
//  FitCal
//
//  Created by Mason Wesolek on 1/17/17.
//  Copyright © 2017 Mason Wesolek. All rights reserved.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell"
    var items = ["todos", "calendar", "streak"]

    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.white.cgColor
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LaunchCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.descLabel.text = self.items[indexPath.item]
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1.5
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}
