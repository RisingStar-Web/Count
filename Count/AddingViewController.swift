//
//  AddingViewController.swift
//  Count
//
//  Created by Mac on 12.04.2018.
//  Copyright © 2018 FokinMC. All rights reserved.
//

import UIKit
import CoreData
//import Appodeal


class AddingViewController: UIViewController {
    var typeSegue: String!
    var trainingArray = [Training]()
    var name: String!
    var price: Float!
    var count: Int!
    var fetchResultsController: NSFetchedResultsController<Training>!
    var howMuchSeeForAds: Int!
    var fullVersionIsBuy: Bool!
    
    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var priceDescriprtionLabe: UITextField!
    @IBOutlet weak var addingButtonLabel: UIButton!
    @IBOutlet weak var aboutPayLabel: UILabel!
    @IBOutlet weak var lookPriceLabel: UIButton!

    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let userDefaults = UserDefaults.standard
        fullVersionIsBuy = userDefaults.bool(forKey: "fullVersionIsBuy")
        if fullVersionIsBuy == true {
            nameLabel.isEnabled = true
            priceLabel.isEnabled = true
            addingButtonLabel.isEnabled = true
            aboutPayLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil) //убрать заголовок кнопки назад в navigationBar
        
        lookPriceLabel.setTitle(NSLocalizedString("See price", comment: ""), for: .normal)
        lookPriceLabel.setTitleColor(#colorLiteral(red: 1, green: 0.4590259194, blue: 0, alpha: 1), for: .normal)
        addingButtonLabel.setTitleColor(#colorLiteral(red: 0.9554153085, green: 0.5483239889, blue: 0.1346469223, alpha: 1), for: .normal)
        addingButtonLabel.layer.cornerRadius = 13
        addingButtonLabel.clipsToBounds = true
        addingButtonLabel.setTitleColor(#colorLiteral(red: 1, green: 0.4855661392, blue: 0, alpha: 0.5), for: .disabled)
//        priceLabel.attributedPlaceholder = NSAttributedString(string: "Hello", attributes: [.font: UIFont.systemFont(ofSize: 33)])

//        lookPriceLabel.titleLabel?.font = UIFont(name: "Helvetica", size: 20)

        
        if typeSegue != "addingSegue" { //редактирование
            title = NSLocalizedString("Edit object", comment: "")
            nameLabel.text = name
            nameLabel.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("New name", comment: ""), attributes: [.font: UIFont.systemFont(ofSize: 15)])
            priceLabel.text = String(price)
//            priceLabel.placeholder = NSLocalizedString("New price", comment: "")
//            priceLabel.font = UIFont(name: "Helvetica", size: 20)
            priceLabel.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("New price", comment: ""), attributes: [.font: UIFont.systemFont(ofSize: 15)])

            addingButtonLabel.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            aboutPayLabel.isHidden = true
            priceDescriprtionLabe.text = NSLocalizedString("Price per visit", comment: "")
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
        } else { //добавление
            adding()
            priceDescriprtionLabe.isHidden = true
        }
        
        //MARK: Реклама
        CountOfDate.timeIntervalCalc()
        let userDefaults = UserDefaults.standard
        howMuchSeeForAds = userDefaults.integer(forKey: "howMuchSeeForAds")
        let isSwitchOfAds = userDefaults.bool(forKey: "switchOfAds")
        let howTapForAd = userDefaults.integer(forKey: "howTapForAd")
        
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
    
    
    func adding () {
        
        let userDefaults = UserDefaults.standard
        fullVersionIsBuy = userDefaults.bool(forKey: "fullVersionIsBuy")
        
        guard count < 3 || fullVersionIsBuy == true else  {   //количество
            
            nameLabel.text = NSLocalizedString("Name", comment: "")
            addingButtonLabel.setTitle(NSLocalizedString("Add", comment: ""), for: .normal)
            nameLabel.isEnabled = false
            priceLabel.isEnabled = false
            addingButtonLabel.isEnabled = false
            aboutPayLabel.text = NSLocalizedString("Hello! \nWe are glad that you use the \"Pay to Others\" application. \n\nYou have a free version installed. You can simultaneously use 3 points in it. \n\nYou can remove the restrictions in the pro version.", comment: "")
            
            return
        }
        title = NSLocalizedString("New object", comment: "")
        nameLabel.text = NSLocalizedString("Name", comment: "")
        nameLabel.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Enter name", comment: ""), attributes: [.font: UIFont.systemFont(ofSize: 15)])
        priceLabel.text = NSLocalizedString("Price", comment: "")
        priceLabel.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Price per visit", comment: ""), attributes: [.font: UIFont.systemFont(ofSize: 15)])
        addingButtonLabel.setTitle(NSLocalizedString("Add", comment: ""), for: .normal)
        
        aboutPayLabel.isHidden = true
    }
    
    
    @IBAction func addingPresses(_ sender: UIButton) {
        if typeSegue == "addingSegue" {
            if priceLabel.text == NSLocalizedString("Price one time", comment: "") || priceLabel.text == "" || priceLabel.text == NSLocalizedString("Price", comment: "") {
                
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("No price", comment: ""), comment: ""), message: NSLocalizedString("Enter the price for one item", comment: ""), preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil)
                ac.addAction(cancel)
                self.present(ac, animated: true, completion: nil)
            }
            else {
                if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                    // create entity of our restaurant class in the context
                    let training = Training(context: context)
                    // set all the properties
                    training.name = nameLabel.text
                    training.price = Float(priceLabel.text!)!
                    
                    // trying save context
                    do {
                        try context.save()
                        print("Сохранение удалось!")
                    } catch let error as NSError {
                        print("Не удалось сохранить данные \(error), \(error.userInfo)")
                    }
                }
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "isAdding")
                userDefaults.synchronize()
            }
        } else { //правка
            
            if priceLabel.text == "" {
                
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("No price", comment: ""), comment: ""), message: NSLocalizedString("Enter the price for one item", comment: ""), preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil)
                ac.addAction(cancel)
                self.present(ac, animated: true, completion: nil)
            } else {
                
                if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                    if trainingArray.count > 0 {
                        for training in trainingArray {
                            if name == training.value(forKey: "name") as? String {
                                price = Float(priceLabel.text!)!
                                training.setValue(price, forKey: "price")
                                name = nameLabel.text
                                training.setValue(name, forKey: "name")
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
}
