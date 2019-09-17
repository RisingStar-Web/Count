//
//  RateManager.swift
//  Count
//
//  Created by Mac on 16.04.2018.
//  Copyright © 2018 FokinMC. All rights reserved.
//

import UIKit
import StoreKit

@available(iOS 10.3, *)

class RateManager {
    
    class func incrementCount() {
        //        let userDefaults = UserDefaults.standard
        let count = UserDefaults.standard.integer(forKey: "run_count")
        print(count)
        if count < 7 {
            UserDefaults.standard.set(count + 1, forKey: "run_count")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func showRatesController() {
        
        let count = UserDefaults.standard.integer(forKey: "run_count")
        if count == 7 {
            UserDefaults.standard.set(17, forKey: "run_count")
            UserDefaults.standard.set(true, forKey: "i_see_rate_manager")
            UserDefaults.standard.synchronize()
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {  // тут реализована задержка AC
                SKStoreReviewController.requestReview()
            })
        }
    }
    
    class func showRatesControllerNow() {
        SKStoreReviewController.requestReview()
    }
}
