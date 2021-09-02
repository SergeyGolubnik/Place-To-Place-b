//
//  Validators.swift
//  Place-To-Place-b
//
//  Created by СОВА on 02.09.2021.
//

import Foundation


class Validators {
    
    static func isFilled(lastName: String?, email: String?, password: String?) -> Bool {
        guard
            !(lastName ?? "").isEmpty,
            !(email ?? "").isEmpty,
            !(password ?? "").isEmpty else {
                return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
    static func sredRating(commnt: Dictionary<String, Int>) -> Int {
        var countRating = 0
        var summRatinr = 0
        var result: Double = 0
        var intResalt = 0
        if commnt.count != 0 {
            for (_, appraisal) in commnt {
                if appraisal > 0 {
                countRating += 1
                summRatinr += appraisal
                }
            }
            if summRatinr > 0 {
                result = Double(summRatinr) / Double(countRating)
                intResalt = Int(result.rounded())
            } else {
                summRatinr = 0
            }
            
        }
        return intResalt
    }
    static func isFilled(username: String?) -> Bool {
        guard let username = username,
            username != "" else {
                return false
        }
        return true
    }
}
