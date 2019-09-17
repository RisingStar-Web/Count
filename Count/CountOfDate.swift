//
//  Date.swift
//  Count
//
//  Created by Mac on 17.04.2018.
//  Copyright © 2018 FokinMC. All rights reserved.
//

import UIKit

class CountOfDate {
    var language: String!
    //    func userLanguage() {
    //        let locale = NSLocale.preferredLanguages.first!
    //
    //        if locale.hasPrefix("ru") {
    //            print(locale)
    //            language = ""
    //        }
    //    }
    func userLanguage () {
        let locale = NSLocale.preferredLanguages.first! // определение языка
        if locale.hasPrefix("ru") { // определение префикса
            // можно написать блок при соблюдении условия ru
        }
    }
    
    class func countInterval(dateForCount: Date?, labelDate: UILabel!, labelTime: UILabel!) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.default
        
        let today = Date()
        let todayDay = calendar.component(.day, from: today)
        
        
        if dateForCount != nil {
            let useDay = calendar.component(.day, from: dateForCount!)
            let useMonth = calendar.component(.month, from: dateForCount!)
            let useYear = calendar.component(.year, from: dateForCount!)
            let useHour = calendar.component(.hour, from: dateForCount!)
            let useMimute = calendar.component(.minute, from: dateForCount!)
            
            let textUseDate = "\(useDay).\(useMonth).\(useYear)"
            let textUseTime: String!
            if useMimute > 9 {
                textUseTime = "\(useHour):\(useMimute)"
            } else {
                textUseTime = "\(useHour):0\(useMimute)"

            }
            let interval = Int((dateForCount?.timeIntervalSinceNow)! / -86400)
            if interval > 1 {
                labelDate.text = textUseDate
                labelTime.text = textUseTime
            } else {
                if todayDay != useDay {
                    labelDate.text = NSLocalizedString("Yesterday", comment: "")
                } else {
                    labelDate.text = NSLocalizedString("Today", comment: "")
                }
                labelTime.text = textUseTime
            }
        } else {
            labelDate.text = ""
            labelTime.text = ""
        }
    }
    
    class func timeIntervalCalc () {
        // блок для расчета времени для интенсивности рекламы
        let userDefaults = UserDefaults.standard
        let dateInstall = userDefaults.object(forKey: "dateInstall") as! Date

        let howMuchDay = Int(dateInstall.timeIntervalSinceNow) / -86400 // приведение секунд в дни
        guard howMuchDay > 7 else {
            userDefaults.set(10, forKey: "howTapForAd")
            return
        }
        userDefaults.set(3, forKey: "howTapForAd")
        // блок для расчета времени для интенсивности рекламы
    }
}

/*
 class func countInterval(lastUseData: Date?, label: UILabel!) {
 
 
 if lastUseData != nil {
 let locale = NSLocale.preferredLanguages.first! // определение языка
 
 var text: String!
 var interval = Int((lastUseData?.timeIntervalSinceNow)! / -86400)
 guard interval > 1 else {
 interval = Int((lastUseData?.timeIntervalSinceNow)! / -3600)
 if locale.hasPrefix("ru") { // определение префикса
 switch interval {
 case 0:
 text = "Меньше часа назад"
 case 1:
 text = "\(interval) час назад"
 case 2:
 text = "\(interval) часа назад"
 case 3:
 text = "\(interval) часа назад"
 case 4:
 text = "\(interval) часа назад"
 case 5:
 text = "\(interval) часов назад"
 case 6:
 text = "\(interval) часов назад"
 case 7:
 text = "\(interval) часов назад"
 case 8:
 text = "\(interval) часов назад"
 case 9:
 text = "\(interval) часов назад"
 case 10:
 text = "\(interval) часов назад"
 case 11:
 text = "\(interval) часов назад"
 case 12:
 text = "\(interval) часов назад"
 case 13:
 text = "\(interval) часов назад"
 case 14:
 text = "\(interval) часов назад"
 case 15:
 text = "\(interval) часов назад"
 case 16:
 text = "\(interval) часов назад"
 case 17:
 text = "\(interval) часов назад"
 case 18:
 text = "\(interval) часов назад"
 case 19:
 text = "\(interval) часов назад"
 case 20:
 text = "\(interval) часов назад"
 case 21:
 text = "\(interval) час назад"
 case 22:
 text = "\(interval) часа назад"
 case 23:
 text = "\(interval) часа назад"
 case 24:
 text = "\(interval) часа назад"
 default:
 break
 }
 label.text = String(text)
 } else {
 switch interval {
 case 0:
 text = "less hour ago" //на английском при ноле не срабатывает
 case 1:
 text = "\(interval) hour ago"
 default:
 text = "\(interval) hours ago"
 }
 label.text = String(text)
 }
 
 return
 }
 label.text = String("\(interval) дней назад" )
 }
 }
 }*/

