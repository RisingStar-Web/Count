//
//  SwipeViewController.swift
//  Count
//
//  Created by Mac on 14.04.2018.
//  Copyright © 2018 FokinMC. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController {

    @IBOutlet weak var seeButtonLabel: UIButton!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    @IBAction func seeButtonPressed(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "isWatchedSwipe")
        // запись даты установки
        let dateInstall = Date()
        userDefaults.set(dateInstall, forKey: "dateInstall")
        userDefaults.synchronize()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLabel.image = UIImage(named: NSLocalizedString("swipe", comment: ""))
        
        seeButtonLabel.setTitle(NSLocalizedString("Ok", comment: ""), for: .normal)
        seeButtonLabel.setTitleColor( #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1) , for: .normal)
        swipeLabel.text = NSLocalizedString("Swipe the row to the left in order to edit the price or delete", comment: "")
        addLabel.text = NSLocalizedString("To add a new object, tap plus", comment: "")
    }

}
