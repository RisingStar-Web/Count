//
//  ViewController.swift
//  Count
//
//  Created by Mac on 05.04.2018.
//  Copyright © 2018 FokinMC. All rights reserved.
//

import UIKit
import CoreData
//import Appodeal


class ViewController: UIViewController {
    
    
    @IBOutlet weak var onceLabel: UILabel!
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var addBalanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var useTimeLabel: UITextField!
    @IBOutlet weak var addSumLabel: UITextField!
    @IBOutlet weak var lastVisitLabel: UILabel!
    @IBOutlet weak var lastVisitHeaderLabel: UILabel!
    @IBOutlet weak var lastVisitTimeLabel: UILabel!
    @IBOutlet weak var addBalanceDateHeaderLabel: UILabel!
    @IBOutlet weak var addBalanceDateLabel: UILabel!
    @IBOutlet weak var addBalanceTimeLabel: UILabel!
    
    var trainingArray = [Training]()
    var name: String!
    var price: String!
    var balance: String!
    var addSum: Float!
    var fetchResultsController: NSFetchedResultsController<Training>!
    var howMuchSeeForAds: Int!
    var lastUseData: Date!
    var lastAddData: Date!
    var language: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil) //убрать заголовок кнопки назад в navigationBar
        
        let titleName = name + " " + balance
        title = titleName
        priceLabel.text = String(price)
        addBalanceDateHeaderLabel.text = NSLocalizedString("Last refill", comment: "")
        addBalanceLabel.text = NSLocalizedString("Add balance", comment: "")
        useLabel.text = NSLocalizedString("Use visit", comment: "")
        onceLabel.text = NSLocalizedString("Price per visit", comment: "")
        lastVisitHeaderLabel.text = NSLocalizedString("Last visit", comment: "")
        
        
        
        CountOfDate.countInterval(dateForCount: lastUseData, labelDate: lastVisitLabel, labelTime: lastVisitTimeLabel) // for use
        
        CountOfDate.countInterval(dateForCount: lastAddData, labelDate: addBalanceDateLabel, labelTime: addBalanceTimeLabel) // for add
        if addBalanceDateLabel.text == "" {
            addBalanceDateHeaderLabel.isHidden = true
            lastVisitHeaderLabel.isHidden = true
        }
        
        
        let fetchRequest: NSFetchRequest<Training> = Training.fetchRequest() // запрос
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) //создание фильтра
        fetchRequest.sortDescriptors = [sortDescriptor] //применение фильтра
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            do {
                try fetchResultsController.performFetch()
                trainingArray = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print("Не удалось получить данные \(error), \(error.userInfo)")
            }
        }
        
        //MARK: Реклама
        /*
        CountOfDate.timeIntervalCalc()
        let userDefaults = UserDefaults.standard
        howMuchSeeForAds = userDefaults.integer(forKey: "howMuchSeeForAds")
        let isSwitchOfAds = userDefaults.bool(forKey: "switchOfAds")
        let howTapForAd = userDefaults.integer(forKey: "howTapForAd")
        */

        /*
        if isSwitchOfAds == false {
            Appodeal.showAd(AppodealShowStyle.bannerBottom, rootViewController: self)
            if howMuchSeeForAds >= howTapForAd {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {  // тут реализована задержка AC
                    Appodeal.showAd(AppodealShowStyle.interstitial, rootViewController: self)
                })
                userDefaults.set(0, forKey: "howMuchSeeForAds")
            }
        }
        */
    }
    
    @IBAction func pressedAddSum(_ sender: UIButton) {
        
        addSum = Float(addSumLabel.text!)
        if addSumLabel.text == "" {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("Field is empty", comment: ""), comment: ""), message: NSLocalizedString("Enter the sum for refill acount", comment: ""), preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil)
                ac.addAction(cancel)
                self.present(ac, animated: true, completion: nil)
            })
            
        } else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                if trainingArray.count > 0 {
                    for training in trainingArray {
                        if name == training.value(forKey: "name") as? String {
                            if let balance = training.value(forKey: "balance") as? Float {
                                training.setValue(balance + addSum, forKey: "balance")
                                let today = Date()
                                
                                training.setValue(today, forKey: "dateAdd")
                                // trying save context
                                do {
                                    try context.save()
                                    print("Сохранение удалось!")
                                } catch let error as NSError {
                                    print("Не удалось сохранить данные \(error), \(error.userInfo)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func usePressed(_ sender: UIButton) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            if useTimeLabel.text != "" {
                if trainingArray.count > 0 {
                    for training in trainingArray {
                        if name == training.value(forKey: "name") as? String {
                            let price = training.value(forKey: "price") as? Float
                            if let balance = training.value(forKey: "balance") as? Float {
                                let useTime = Float(useTimeLabel.text!)!
                                training.setValue(balance - price! * useTime, forKey: "balance")
                                let today = Date()
                                
                                training.setValue(today, forKey: "dateUse")
                                
                                // trying save context
                                do {
                                    try context.save()
                                } catch let error as NSError {
                                    print("Не удалось сохранить данные \(error), \(error.userInfo)")
                                }
                            }
                        }
                    }
                }
            }
        }
        useTimeLabel.text = ""
    }
}

