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
    var locale = NSLocale(localeIdentifier: "en_US")
    var brain = CalculatorBrain()
    
    @IBOutlet weak var Delete: UIButton!
    @IBOutlet weak var Display: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Display.adjustsFontSizeToFitWidth = true
    }
    
    var UserIsInTheMiddleOfTypingANumber = false
    var userIsAboutToEnterANewCalculation = true
    var lastNumberInDisplay: String = "" // used for commas
    
    @IBAction func appendChar(sender: UIButton) {
        // if user enters ".0" for first characters, it turns to "0"
        let char = sender.currentTitle!
 
        if  userIsAboutToEnterANewCalculation && (brain.couldBePartOfNum(char) || brain.isUnaryOpChar(char)){
            setDisplayText(char)
        } else {
            Display.text = Display.text! + char // TODO wrap in function
        }
        
        // commas and stuff
        if brain.couldBePartOfNum(char) {
            lastNumberInDisplay = lastNumberInDisplay + char
            print("about to format: \(lastNumberInDisplay)")
            var numWithCommas = formatNumber(lastNumberInDisplay)!
            println("num with commas: \(numWithCommas)")
            replaceLastNumberInDisplay(numWithCommas)
        } else if brain.isOp(char) {
            lastNumberInDisplay = ""
        }
        
        userIsAboutToEnterANewCalculation = false
        Delete.setTitle("⌫", forState: .Normal)
        println("")
    }
    
    private func formatNumber(number: String) -> String? {
        if number == "." {
            return number
        }
        if let num = addCommas((number as NSString).doubleValue) {
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
    private func addCommas(number: Double) -> String? {
        let nf = NSNumberFormatter()
        nf.locale = locale
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return nf.stringFromNumber(number)
    }
    
    private func replaceLastNumberInDisplay(replacement: String) {
        var text = Display.text!
        print("current display text: \(text)")
        for (index, char) in enumerate(reverse(text)) {
            if !brain.couldBePartOfNum(String(char)) {
                let range = advance(text.endIndex, (0-index))..<text.endIndex
                text.replaceRange(range, with: replacement)
                setDisplayText(text)
                return
            }
        }
        setDisplayText(replacement)
    }
    
    @IBAction func deleteChar(sender: AnyObject) {
        let text = Display.text!
        
        if brain.couldBePartOfNum(String(text[text.endIndex.predecessor()])) {
            replaceLastNumberInDisplay("")
            lastNumberInDisplay = ""
        } else {
            var newText = text.substringToIndex(text.endIndex.predecessor())
            setDisplayText(newText)
        }
    }
    
    
    
    @IBAction func enter() {
        convertToArray()
        var num = brain.evaluate()!
        setDisplayText(addCommas(num)!)
        Delete.setTitle("C", forState: .Normal)
        lastNumberInDisplay = ""
        userIsAboutToEnterANewCalculation = true
    }
    private func convertToArray() {
        let expression = Display.text!
        var numStr: String = ""
        for (index, char) in enumerate(expression) {
            let charStr = String(char)
            if brain.isOp(charStr) && numStr != "" {
                brain.pushOperand((numStr as NSString).doubleValue)
                brain.pushOperation(charStr)
                numStr = ""
            } else if brain.isOp(charStr) {
                brain.pushOperation(charStr)
            } else if charStr != "," {
                numStr = numStr + charStr
            }
        }
        if numStr != "" {
            brain.pushOperand((numStr as NSString).doubleValue)
        }
    }
    
    private func setDisplayText(val: String) {
        if val == "" {
            Display.text = "0"
            userIsAboutToEnterANewCalculation = true
            lastNumberInDisplay = ""
            Delete.setTitle("C", forState: .Normal)
        } else {
            Display.text = val
        }
    }

}

