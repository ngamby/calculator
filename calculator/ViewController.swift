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
    //this is an implicitly unwrapped optional
    //things that are set very early and stay that way, might be good to always unwrap the value
    //all instances live in the heap and memory is managed for you
    //its not garbage collection, its reference counting
    //memory management is done for us. 
    //no syntax that says this a pointer. objects are always pointers.
    //exclamation point does something else.
    // "UILabel" is the type
    var UserIsInTheUserOfTypingANumber = false
    //we can remove ": bool" because value is inferred
    
    @IBAction func appendDigit(sender: UIButton) {
        //func = says its a method
        // "sender" name of param, "UIButton" = type of param
        let digit = sender.currentTitle!
        if UserIsInTheUserOfTypingANumber {
            Display.text = Display.text! + digit
             //display.text is an optional so you need to unwrap it
        } else {
            Display.text = digit
            UserIsInTheUserOfTypingANumber = true
        }
        //what does optional mean when this is printed?
        //  you never put a type for digit, but swift is great at type inference. it makes it the same type as what you assign it to be. the type is called ? = Optional. it can have two values: notSet (nil) or something.
        // the exclamation point unwraps that optional and gets the string from currentTitle.
        // let is the same as var but let is a constant
        
       
    }
    
    //This is the C portion of the MVC
//    func performOperation(operation: (Double, Double) -> Double)
//    {
//        if(operandStack.count >= 2) {
//            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter();
//        }
//    }
//    func performOperation(operation: Double -> Double)
//    {
//        if(operandStack.count >= 1) {
//            displayValue = operation(operandStack.removeLast())
//            enter();
//        }
//    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if(UserIsInTheUserOfTypingANumber) {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0;
            }
        }
    }
    
    
//    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        UserIsInTheUserOfTypingANumber = false
        var displayValue: Double {
            get { // gets the value you want from something
                return NSNumberFormatter().numberFromString(Display.text!)!.doubleValue
            }
            set { // set that value to the value you want to put
                Display.text = "\(newValue)"
                UserIsInTheUserOfTypingANumber = false
            }
        }
        if let result  = brain.pushOperand(displayValue) {
        brain.pushOperand(displayValue)
        }
        else  {
            displayValue = 0
        }
        
    }

}

