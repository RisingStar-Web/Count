//
//  TableViewController.swift
//  Count
//
//  Created by Mac on 05.04.2018.
//  Copyright © 2018 FokinMC. All rights reserved.
//

import UIKit
import CoreData
//import Appodeal

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var priceHeaderLabel: UILabel!
    @IBOutlet weak var balanceHeaderLabel: UILabel!
    
    @IBOutlet weak var viewForAds: UIView!
    
    var fetchResultsController: NSFetchedResultsController<Training>!
    
    
    var trainingArray = [Training]()
    let priceArray = [Training]()
    var balanceArray = [Int]()
    var howMuchSeeForAds: Int!




    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.3, *) { // отзывы
            RateManager.showRatesController()
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil) //убрать заголовок кнопки назад в navigationBar
        
        balanceHeaderLabel.text = NSLocalizedString("Balance", comment: "")
        priceHeaderLabel.text = NSLocalizedString("Price", comment: "")

        title = NSLocalizedString("Pay another", comment: "")

        let fetchRequest: NSFetchRequest<Training> = Training.fetchRequest() // запрос
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) //создание фильтра
        fetchRequest.sortDescriptors = [sortDescriptor] //применение фильтра
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self // для автоматического обновления данных в таблице при при использовании coreData
            
            do {
                try fetchResultsController.performFetch()
                trainingArray = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print("Не удалось получить данные \(error), \(error.userInfo)")
            }
        }
    }

     // MARK: обновление данных при core Data
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates() // позволяет перегружать конкретные строки
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {  // тут реализована задержка AC
        
            switch type {
            case .insert: guard let indexPath = newIndexPath else {break}
                self.tableView.insertRows(at: [indexPath], with: .fade)
            case .delete: guard let indexPath = indexPath else {break}
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            case .update: guard let indexPath = indexPath else {break}
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.tableView.reloadRows(at: [indexPath], with: .middle)
                })
            default:
                self.tableView.reloadData()
            }
//        })
        trainingArray = controller.fetchedObjects as! [Training]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
//    обновление данных при core Data конец

    
    //этот метод сработает сразу после загрузки основного экрана - поверх
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //метод проверяющий добавили ли объект
        let userDefaults = UserDefaults.standard
//        let isAdding = userDefaults.bool(forKey: "isAdding")
//        print(isAdding)
//
//        guard isAdding else { return } //смотрим было ли добавление или выходим из функции и загружаем основное APP
        
        //метод проверяющий смотрели ли инструкцию
        let isWatchedSwipe = userDefaults.bool(forKey: "isWatchedSwipe")
        guard !isWatchedSwipe else { return } //смотрим PageVC или выходим из функции и загружаем основное APP
        // !isWatchedSwipe для показа инструкции
        
        //ниже метод загружающий pageVC
        if let SwipeViewController = storyboard?.instantiateViewController(withIdentifier: "SwipeViewController") as? SwipeViewController {
            present(SwipeViewController, animated: true, completion: nil)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trainingArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! TableViewCell

        cell.typeLabel.text = trainingArray[indexPath.row].name
        
        cell.balanceLabel.text = String(trainingArray[indexPath.row].balance)
        
        cell.priceLabel.text = String(trainingArray[indexPath.row].price)

//        if trainingArray[indexPath.row].balance < 0 {
//            cell.typeLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
//            cell.balanceLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
//            cell.priceLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
//        }
        
        return cell
    }
 
    // убрали выделение ячейки после tap
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //свайп влево---------начало--------------------------------------------------------
    
    var favoritesArray = [Bool](repeatElement(false, count: 152))   //массив для того чтоб не повторялась галочка(152 от фонаря)
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let object = trainingArray[indexPath.row].name
        let delete = UITableViewRowAction(style: .default, title: NSLocalizedString("Delete", comment: "")) { (action, indexPath) in
            let ac = UIAlertController(title: NSLocalizedString("Delete", comment: ""), message: NSLocalizedString("Are you sure you want to delete the object ", comment: "") + "\(object!)?", preferredStyle: .alert)
            let delete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default, handler: { (action) in
                if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                    let objectForDelete = self.fetchResultsController.object(at: indexPath)
                    context.delete(objectForDelete)
                    
                    do {
                        try context.save()
                        print("Сохранение удалось!")
                    } catch let error as NSError {
                        print("Не удалось сохранить данные \(error), \(error.userInfo)")
                    }
                }
            })
            
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            ac.addAction(delete)
            ac.addAction(cancel)
            self.present(ac, animated: true, completion: nil)
        }
        
        let edit = UITableViewRowAction(style: .default, title: NSLocalizedString("Edit", comment: "")) { (action, indexPath) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddingViewController") as! AddingViewController
            vc.typeSegue = "edditing"
            vc.name = self.trainingArray[indexPath.row].name
            vc.price = self.trainingArray[indexPath.row].price

            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.8925095201, green: 0, blue: 0, alpha: 1)
        edit.backgroundColor = #colorLiteral(red: 0, green: 0.8704724908, blue: 0, alpha: 0.5850278253)
        
        return [edit, delete]
    }    //свайп влево----------окончание--------------

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        let userDefaults = UserDefaults.standard
        howMuchSeeForAds = userDefaults.integer(forKey: "howMuchSeeForAds")
        howMuchSeeForAds = howMuchSeeForAds + 1
        userDefaults.set(howMuchSeeForAds, forKey: "howMuchSeeForAds")
        userDefaults.synchronize()
        
        switch segue.identifier {
        case "toSecondUnitsSegue":
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! ViewController
                dvc.name = trainingArray[indexPath.row].name
                dvc.price = String(trainingArray[indexPath.row].price)
                dvc.balance = String(trainingArray[indexPath.row].balance)
                dvc.lastUseData = trainingArray[indexPath.row].dateUse
                dvc.lastAddData = trainingArray[indexPath.row].dateAdd
            }
        case "addingSegue":
                let dvc = segue.destination as! AddingViewController
                dvc.typeSegue = "addingSegue"
                dvc.count = trainingArray.count
        default:
            break
        }
        

//        if segue.identifier == "toSecondUnitsSegue" {
//            //определили ячейку
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let dvc = segue.destination as! ViewController
//                dvc.name = trainingArray[indexPath.row].name
//
//            }
//        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
