//
//  ViewController.swift
//  calculator
//
//  Created by Noah Gamboa on 3/17/15.
//  Copyright (c) 2015 Noah Gamboa. All rights reserved.
//

import UIKit

class ViewController: UIViewController { // single inheritance only
    //all the instance methods and variables in the class
    //properties = instance variable
    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var Display: UILabel! //? vs ! doesn't change the type, changes the usage
    
    var UserIsInTheMiddleOfTypingANumber: Bool = false
    //we can remove ": bool" because value is inferred
    var userIsAboutToEnterANewCalculation: Bool = true
    
    var numStr: String = ""
    //if the char pushed is an integer,
    @IBAction func appendDigit(sender: UIButton) {
        //func = says its a method
        // "sender" name of param, "UIButton" = type of param
        let char = sender.currentTitle!
        
        if (userIsAboutToEnterANewCalculation || // user is about to enter a new calculation 
            Display.text == "0.0" || // hack
            Display.text == "0" || // hack
            (char == "." && Display.text=="0")) // case when user sees "0" and wants to enter decimal
            && !brain.isOp(char)   {
                Display.text = char
        } else {
                Display.text = Display.text! + char
        }
        userIsAboutToEnterANewCalculation = false
        return
//        if userIsAboutToEnterANewCalculation && brain.isOp(char) {
//        if let num = NSNumberFormatter().numberFromString(Display.text!) {
//        if num != 0 {
//            brain.pushOperand(num.doubleValue)
//            brain.pushOperation(char)
//            numStr=""
//            Display.text = Display.text! + char
//            userIsAboutToEnterANewCalculation = false
//            return
//        }}}
//        
//        if userIsAboutToEnterANewCalculation {
//            Display.text = ""
//            userIsAboutToEnterANewCalculation = false
//        }
//        if brain.isOp(char) {
//            if let numFormat = NSNumberFormatter().numberFromString(numStr) {
//                brain.pushOperand(numFormat.doubleValue)
//            }
//            brain.pushOperation(char)
//            numStr = ""
//            Display.text = Display.text! + char
//        }
//        else if UserIsInTheMiddleOfTypingANumber {
//            numStr = numStr + char
//            Display.text = Display.text! + char
//             //display.text is an optional so you need to unwrap it
//        } else {
//            numStr = char
//            Display.text = Display.text! + char
//            UserIsInTheMiddleOfTypingANumber = true
//        }
    }
    
    
    @IBAction func deleteChar(sender: AnyObject) {
        let text = Display.text!
        let newText = text.substringToIndex(text.endIndex.predecessor())
        println("text: \(text) and newText: \(newText)")
        if newText == "" || userIsAboutToEnterANewCalculation {
            Display.text = "0"
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
        userIsAboutToEnterANewCalculation = true
        
    }
    private func convertToArray() {
        if let expression = Display.text {
            var numStr = ""
            for (index, char) in enumerate(expression) {
                let charStr = String(char)
                if brain.isOp(charStr) && numStr != "" {
                    println("current char: \(charStr) and number: \(numStr)")
                    if let num = NSNumberFormatter().numberFromString(numStr) {
                        brain.pushOperand(num.doubleValue)
                    } else {
                        println("poooooo \(numStr)")
                    }
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

