//
//  ViewController.swift
//  calculator
//
//  Created by Noah Gamboa on 3/17/15.
//  Copyright (c) 2015 Noah Gamboa. All rights reserved.
//

import UIKit

extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}

class ViewController: UIViewController { // single inheritance only
    //all the instance methods and variables in the class
    //properties = instance variable
    var locale = NSLocale(localeIdentifier: "en_US")
    var brain = CalculatorBrain()
    
    @IBOutlet weak var Display: UILabel! //? vs ! doesn't change the type, changes the usage
    
    var UserIsInTheMiddleOfTypingANumber = false
    var userIsAboutToEnterANewCalculation = true
    
//    var previousAnswer: Double? = nil;
    
    var numStr: String = ""
    var displayIntStr: String = ""
    //if the char pushed is an integer,
    @IBAction func appendDigit(sender: UIButton) {
        let char = sender.currentTitle!
 
        if  userIsAboutToEnterANewCalculation && !brain.isOp(char) {
                Display.text = char
        } else {
                Display.text = Display.text! + char
        }
        
        if brain.couldBePartOfNum(char) {
            displayIntStr = displayIntStr + char
            var numWithCommas = addCommas(displayIntStr)!
            replaceLastNumberInDisplay(numWithCommas)
        } else if brain.isOp(char) {
            displayIntStr = ""
        }
        
        userIsAboutToEnterANewCalculation = false
        println("")
    }
    
    func addCommas(number: String) -> String? {
        if number == "." {
            return number
        }
        let nf = NSNumberFormatter()
        nf.locale = locale
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if let num = nf.stringFromNumber((number as NSString).doubleValue) {
            if count(number) > 1 && number.substringFromIndex(advance(number.endIndex, -1)) == "." {
                let ans = num + "."
                return ans
            } else if count(number) > 2 && number.substringFromIndex(advance(number.endIndex, -2)) == ".0" {
                let ans = num + ".0"
                return ans
            }
            return num
        }
        return nil
    }
    
    func replaceLastNumberInDisplay(replacement: String) {
        var text = Display.text!
        for (index, char) in enumerate(reverse(text)) {
            if !brain.couldBePartOfNum(String(char)) {
                let range = advance(text.endIndex, (0-index))..<text.endIndex
                text.replaceRange(range, with: replacement)
                Display.text = text
                return
            }
        }
        Display.text = replacement
    }

    
    
    @IBAction func deleteChar(sender: AnyObject) {
//        replaceLastNumberInDisplay("")
//        displayIntStr = ""
        let text = Display.text!
        var newText = text.substringToIndex(text.endIndex.predecessor())
        print(newText.endIndex)
        if newText[newText.endIndex.predecessor()] == "," {
            newText = newText.substringToIndex(text.endIndex.predecessor())
        }
        println("text: \(text) and newText: \(newText)")
        if newText == "" || userIsAboutToEnterANewCalculation {
            Display.text = "0"
            userIsAboutToEnterANewCalculation = true
        } else {
            Display.text = newText
        }
    }
    
    
    
    @IBAction func enter() {
//        if UserIsInTheMiddleOfTypingANumber  {
//            if let numFormat = NSNumberFormatter().numberFromString(numStr) {
//                brain.pushOperand(numFormat.doubleValue)
//            }
//        }
//        UserIsInTheMiddleOfTypingANumber = false
        convertToArray()
        var num = brain.evaluate()!
        var displayStr = num.description
        var end = displayStr.substringWithRange(Range<String.Index>(start: displayStr.endIndex.predecessor().predecessor(), end: displayStr.endIndex))
        if end == ".0" {
            Display.text = String(Int(num))
        } else {
            Display.text = num.description
        }
//        previousAnswer = num
        userIsAboutToEnterANewCalculation = true
        
    }
    private func convertToArray() {
        if let expression = Display.text {
            var numStr: String = ""
            for (index, char) in enumerate(expression) {
                let charStr = String(char)
                if brain.isOp(charStr) && numStr != "" {
                    println("current char: \(charStr) and number: \(numStr)")
                    let num = (numStr as NSString).doubleValue
//                    if num != 0.0 {
                    brain.pushOperand(num)
//                    }
                    brain.pushOperation(charStr)
                    numStr = ""
                } else if brain.isOp(charStr) {
                    brain.pushOperation(charStr)
                } else {
                    numStr = numStr + charStr
                }
            }
            if numStr != "" {
                brain.pushOperand(NSNumberFormatter().numberFromString(numStr)!.doubleValue)
            }
        }
    }

}

