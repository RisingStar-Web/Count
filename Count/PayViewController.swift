//
//  PayViewController.swift
//  Count
//
//  Created by Mac on 17.04.2018.
//  Copyright © 2018 FokinMC. All rights reserved.
//


import UIKit
import StoreKit
//import Appodeal


class PayViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var switchOfAdsLabel: UIButton!
    @IBOutlet weak var switchOfAdsDescriptionLabel: UILabel!
    @IBOutlet weak var switchOfAdsPriceLabel: UILabel!


    @IBOutlet weak var fullVersionLabel: UIButton!
    @IBOutlet weak var fullVersionDescriptionLabel: UILabel!
    @IBOutlet weak var fullVersionPriceLabel: UILabel!


    @IBOutlet weak var restoreBtLabel: UIButton!
    @IBOutlet weak var termsOfUseLabel: UIButton!
    @IBOutlet weak var privacyPolicyLabel: UIButton!
    
    @IBOutlet var viewLabel: UIView!

    var priceArray = [String](repeatElement("", count: 2))
//    var priceArray: String!

    var spinner: UIActivityIndicatorView!
    var listOfProducts = [SKProduct]()
    var productToPurchase = SKProduct()
    
    
    func buySwitchOfAds() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "switchOfAds")
        userDefaults.synchronize()
    }
    func buyFullVersion() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "fullVersionIsBuy")
        userDefaults.synchronize()
    }
    
    @IBAction func termsOfUsePressed(_ sender: UIButton) {
        let url = NSURL(string: "https://goo.gl/QNxETy")!
//        UIApplication.shared.openURL(url as URL) // в версии до 10
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        let url = NSURL(string: "https://goo.gl/vLuKLc")!
//        UIApplication.shared.openURL(url as URL) // в версии до 10
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canBuy()
        title = NSLocalizedString("Purchases", comment: "")
        headerLabel.text = NSLocalizedString("You can buy these options for your app", comment: "")
        switchOfAdsLabel.setTitle(NSLocalizedString("Switch off Ads", comment: ""), for: .normal)
        switchOfAdsDescriptionLabel.text = NSLocalizedString("Disable all ads in your application", comment: "")
        
        fullVersionLabel.setTitle(NSLocalizedString("Pro version", comment: ""), for: .normal)
        fullVersionDescriptionLabel.text = NSLocalizedString("Any number of items on your list", comment: "")
        
        
        restoreBtLabel.setTitle(NSLocalizedString("Restore", comment: ""), for: .normal)
        termsOfUseLabel.setTitle(NSLocalizedString("Terms of Use", comment: ""), for: .normal)
        privacyPolicyLabel.setTitle(NSLocalizedString("Privacy Policy", comment: ""), for: .normal)
        headerLabel.textColor = #colorLiteral(red: 0.9554153085, green: 0.5483239889, blue: 0.1346469223, alpha: 1)

        switchOfAdsLabel.setTitleColor(#colorLiteral(red: 0.9618350863, green: 0.481810987, blue: 0, alpha: 0.3809128853), for: .disabled)
        fullVersionLabel.setTitleColor(#colorLiteral(red: 0.9618350863, green: 0.481810987, blue: 0, alpha: 0.3809128853), for: .disabled)
        restoreBtLabel.setTitleColor(#colorLiteral(red: 0.9618350863, green: 0.481810987, blue: 0, alpha: 1), for: .normal)
        
        
        termsOfUseLabel.setTitleColor(#colorLiteral(red: 0.9618350863, green: 0.481810987, blue: 0, alpha: 1), for: .normal)
        
        privacyPolicyLabel.setTitleColor(#colorLiteral(red: 0.9618350863, green: 0.481810987, blue: 0, alpha: 1), for: .normal)
        

//        switchOfAdsLabel.isHidden = true
        switchOfAdsLabel.isEnabled = false
//        fullVersionLabel.isHidden = true
        fullVersionLabel.isEnabled = false
        
        spinnerFunc()
        
        //MARK: Реклама
        let userDefaults = UserDefaults.standard
        let isSwitchOfAds = userDefaults.bool(forKey: "switchOfAds")
        /*
        if isSwitchOfAds == false {
            Appodeal.showAd(AppodealShowStyle.bannerBottom, rootViewController: self)
        }
        */
    }
    
    func canBuy() {
        if SKPaymentQueue.canMakePayments() { //проверка возможности покупок аккаунтом
            print("Покупки доступны")
            
            let productID: Set<String> = ["fullVersionCount_fokinmc", "switchOfAds_count"] //создали id продукта
            let request = SKProductsRequest(productIdentifiers: productID) //создали запрос в App Store
            request.delegate = self
            request.start()
        } else {
            print("Покупки не доступны")
        }
    }
    
    func buyProduct() {
        print("Покупаем " + productToPurchase.productIdentifier) // видим id продукта для покупки
        
        let pay = SKPayment(product: productToPurchase) // создаем платеж, как только создан платеж приложение должно добавить "наблюдателя" в очередь платежей, если к очереди нет прикрепленного Наблюдателя то очередь оплаты не синхронизируется со списком незавершенных сделок в App Store + если приложение завершает работу во время обработки сделки то она не теряется, и в следующий раз при закгрузку приложения очередь возобновится.
        SKPaymentQueue.default().add(self) // - наблюдатель
        SKPaymentQueue.default().add(pay) // добавили платеж в очередь
        
        spinnerFunc ()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request phase")
        
        priceArray.removeAll()
        
        let myProducts = response.products // продукт создаются из ответа (который является экземляром класса response и представляет собой массив. Response имеет некоторые свойста в тч products - это продукты которые есть у нас в App Srore
        // дальше нужно перебрать массив продуктов
        
        
        for product in myProducts {
            let localPrice = "\(product.price)"
            
            priceArray.append(localPrice) // массив для передачи цен в label
            
            print("Товар добавлен")
            print("Идентификатор продукта \(product.productIdentifier)")
            print("\(product.localizedTitle)")
            print("\(product.localizedDescription)")
            

            switchOfAdsLabel.isHidden = false
            switchOfAdsLabel.isEnabled = true
            fullVersionLabel.isHidden = false
            fullVersionLabel.isEnabled = true
            switchOfAdsLabel.setTitleColor(#colorLiteral(red: 0.9618350863, green: 0.481810987, blue: 0, alpha: 1), for: .normal)
            fullVersionLabel.setTitleColor(#colorLiteral(red: 0.9618350863, green: 0.481810987, blue: 0, alpha: 1), for: .normal)
            
            restoreBtLabel.isHidden = false
            restoreBtLabel.isEnabled = true

            if switchOfAdsPriceLabel.text == "29" {
//                carencyLabel.text = "р."
            }
            listOfProducts.append(product)
            spinner.stopAnimating()
        }
        
        let userDefaults = UserDefaults.standard
        let switchOfAds = userDefaults.bool(forKey: "switchOfAds")
        if switchOfAds == true {
            switchOfAdsPriceLabel.text = "√"
            switchOfAdsLabel.isEnabled = false
        } else {
            switchOfAdsPriceLabel.text = priceArray[1]
        }
        let fullVersionIsBuy = userDefaults.bool(forKey: "fullVersionIsBuy")
        if fullVersionIsBuy == true {
            fullVersionPriceLabel.text = "√"
            fullVersionLabel.isEnabled = false
        } else {
            fullVersionPriceLabel.text = priceArray[0]
        }
    }
    
    
    
    //добавляем наблюдателя
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print("ошибка: \(transaction.error)")
            
            switch transaction.transactionState {
            case .purchased:
                print("Оптата прошла успешно")
                print("Продукт: " + productToPurchase.productIdentifier)
                
                let prodID = productToPurchase.productIdentifier
                
                switch prodID {
                case "switchOfAds_count":
                    print ("Покупаем Отключение рекламы")
                    // тут запускаем функцию которая говорит что покупка совершена
                    buySwitchOfAds()
                case "fullVersionCount_fokinmc":
                    print ("Покупаем полный доступ")
                    // тут запускаем функцию которая говорит что покупка совершена
                    buyFullVersion()
                default:
                    print("выполнился Default при SKPaymentQueue")
                    break
                }
                queue.finishTransaction(transaction)
                
                alertController(acTitle: NSLocalizedString("Thank you!", comment: ""), acMassage: NSLocalizedString("", comment: ""), nameOkButton: NSLocalizedString("Ok", comment: ""))
                
                break
//            case .restored: // удалили тк restored перенесли в отдельную фунукцию
//                spinnerFunc()
                
            case .failed:
                print("ошибка транзакции")
                queue.finishTransaction(transaction) //чтоб при ошибке не пыталсь выполнится транзакция
                alertController(acTitle: NSLocalizedString("Filed", comment: ""), acMassage: NSLocalizedString("App store declined your purchase", comment: ""), nameOkButton: NSLocalizedString("Ok", comment: ""))
            default:
                print("Выполняется дефолтный case")
                break
            }
        }
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            let prodID = transaction.payment.productIdentifier as String
            
            switch prodID {
            case "switchOfAds_count":
                print ("Покупаем отключение рекламы")
                // тут запуcкаем функцию которая говорит что покупка совершена
                buySwitchOfAds()
                spinner.stopAnimating()
            case "fullVersionCount_fokinmc":
                print ("Покупаем полный доступ")
                // тут запускаем функцию которая говорит что покупка совершена
                buyFullVersion()
                spinner.stopAnimating()
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("Удаляем транзакцию из очереди")
    }
    
    
    @IBAction func pressedSwitchOffAds(_ sender: UIButton) {
        //если покупка одна в приложении то перебирать массив не нужно... тут перебираем (видимо нет)
        for product in listOfProducts {
            let productID = product.productIdentifier
            if productID == "switchOfAds_count" {
                productToPurchase = product
                buyProduct() // запускаем функцию покупки
                break
            }
        }
    }
    @IBAction func pressedFullVersion(_ sender: UIButton) {
        //если покупка одна в приложении то перебирать массив не нужно... тут перебираем (видимо нет)
        for product in listOfProducts {
            let productID = product.productIdentifier
            if productID == "fullVersionCount_fokinmc" {
                productToPurchase = product
                buyProduct() // запускаем функцию покупки
                break
            }
        }
    }
    @IBAction func restoreBtnPressed(_ sender: UIButton) {
        
        let ac = UIAlertController(title: NSLocalizedString("Restore", comment: ""), message: NSLocalizedString("If you have bought any options, your purchases will be restored free. This may take a few minutes.", comment: ""), preferredStyle: .alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (action) in
            self.spinnerFunc ()
            SKPaymentQueue.default().add(self)  // - наблюдатель
            SKPaymentQueue.default().restoreCompletedTransactions()
        })
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)

        
//        SKPaymentQueue.default().add(self)  // - наблюдатель
//        SKPaymentQueue.default().restoreCompletedTransactions()
        // ! ! ! ! !  ! ! !  ! !  может не особо изящно но функция Restore перенес в тело func alertController при соблюдении условия что заголовок acTitle==Restore
//        alertController(acTitle: NSLocalizedString("Restore", comment: ""), acMassage: NSLocalizedString("If you bought full version - it is restored for you", comment: ""), nameOkButton: NSLocalizedString("Ok", comment: ""))
    }
    
    
    func alertController(acTitle: String, acMassage: String, nameOkButton: String) {
        let ac = UIAlertController(title: acTitle, message: acMassage, preferredStyle: .alert)
        //        let back = UIAlertAction(title: "Back to the menu", style: .default, handler: { (action) in
        //            self.menuView.isHidden = false
        //        })
        let ok = UIAlertAction(title: nameOkButton, style: .cancel, handler: { (action) in
//            self.goToBack()
//            if acTitle == "Restore" { // запуск Restore
//                SKPaymentQueue.default().add(self)  // - наблюдатель
//                SKPaymentQueue.default().restoreCompletedTransactions()
//            }
            self.spinner.stopAnimating()
        })
        //        ac.addAction(back)
        ac.addAction(ok)
        present(ac, animated: true, completion: nil)
    }
    
    func spinnerFunc () {
        spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        spinner.color = #colorLiteral(red: 0.7625332475, green: 0.3907764554, blue: 0, alpha: 0.6954730308) // белый на белом фоне не видно
        spinner.translatesAutoresizingMaskIntoConstraints = false // запрет автоконстнейнтов
        spinner.hidesWhenStopped = true // скрывается когда остановка
        spinner.startAnimating()
        viewLabel.addSubview(spinner) // размещение в tableView
        
        //        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        //        spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: viewLabel, attribute: .centerX, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: viewLabel, attribute: .centerY, multiplier: 1, constant: 1).isActive = true
    }
}
