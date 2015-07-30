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
        if userIsAboutToEnterANewCalculation && brain.isOp(char) {
             if let num = NSNumberFormatter().numberFromString(Display.text!) {
                brain.pushOperand(num.doubleValue)
                brain.pushOperation(char)
                numStr=""
                Display.text = Display.text! + char
                userIsAboutToEnterANewCalculation = false
                return
            }
        }
        if userIsAboutToEnterANewCalculation {
            Display.text = ""
            userIsAboutToEnterANewCalculation = false
        }
        if brain.isOp(char) {
            if let numFormat = NSNumberFormatter().numberFromString(numStr) {
                brain.pushOperand(numFormat.doubleValue)
            }
            brain.pushOperation(char)
            numStr = ""
            Display.text = Display.text! + char
        }
        else if UserIsInTheMiddleOfTypingANumber {
            numStr = numStr + char
            Display.text = Display.text! + char
             //display.text is an optional so you need to unwrap it
        } else {
            numStr = char
            Display.text = Display.text! + char
            UserIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enter() {
        if UserIsInTheMiddleOfTypingANumber  {
            if let numFormat = NSNumberFormatter().numberFromString(numStr) {
                brain.pushOperand(numFormat.doubleValue)
            }
        }
        UserIsInTheMiddleOfTypingANumber = false
        var num = brain.evaluate()!
        Display.text = num.description
        userIsAboutToEnterANewCalculation = true
        
    }

}

