//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Noah Gamboa on 3/18/15.
//  Copyright (c) 2015 Noah Gamboa. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    private var opStack = [Op]()
    
    
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+") { $0 + $1 }
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    private func evaluate(ops: [Op]) -> (result: Double?, remaingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops // makes a copy of ops (sorta) dont worry about it
            let op = remainingOps.removeLast() //this throws an error because ops is immutable
            //cannot be done because this is still a copy
            switch op {
                case .Operand(let operand): return (operand, remainingOps)
                case .UnaryOperation(_, let operation): //underbar is universal idk
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remaingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remaingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remaingOps)
                        }
                    }
            }
            
            
        }
        return (nil, ops)
    }
    func evaluate() -> Double? {
        let (result, _ ) = evaluate(opStack)
        return result
    }
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}