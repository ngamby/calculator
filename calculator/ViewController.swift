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
    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var Display: UILabel! //? vs ! doesn't change the type, changes the usage
    
    var UserIsInTheMiddleOfTypingANumber = false
    var userIsAboutToEnterANewCalculation = true
    
//    var previousAnswer: Double? = nil;
    
    var numStr: String = ""
    var displayIntStr: String = ""
    //if the char pushed is an integer,
    @IBAction func appendDigit(sender: UIButton) {
        //func = says its a method
        // "sender" name of param, "UIButton" = type of param
        let char = sender.currentTitle!
        
//        if !brain.isOp(char) && char != "." && (count(displayNumStr) - 1)%3 == 0  && displayNumStr != "nil"{
//            Display.text = Display.text! + ","
//            displayNumStr = displayNumStr + char
//        } else if char == "." {
//            displayNumStr = "nil"
//        } else if brain.isOp(char) {
//            displayNumStr = ""
//        } else if displayNumStr != "nil" {
//            displayNumStr = displayNumStr + char
//        }
        
        if  userIsAboutToEnterANewCalculation // user is about to enter a new calculation
//            || Display.text == "0.0" // hack
//            || Display.text == "0" // hack
//            || (char == "." && Display.text=="0")) // case when user sees "0" and wants to enter decimal
            && !brain.isOp(char) {
                Display.text = char
        } else {
                Display.text = Display.text! + char
        }
        userIsAboutToEnterANewCalculation = false
    }
    
    
    @IBAction func deleteChar(sender: AnyObject) {
        let text = Display.text!
        var newText = text.substringToIndex(text.endIndex.predecessor())
        print(newText.endIndex)
        if newText[newText.endIndex] == "," {
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

