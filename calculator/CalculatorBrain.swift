//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Noah Gamboa on 3/18/15.
//  Copyright (c) 2015 Noah Gamboa. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case Constant(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case openParen(String)
        case closeParen(String)

        var isOperation: Bool {
            switch self {
            case .UnaryOperation, .BinaryOperation:
                return true
            default:
                return false
            }
        }
        
        var isOpenParen: Bool {
            switch self {
            case .openParen:
                return true
            default:
                return false
            }
        }

        
        var precedence: Int {
            switch self {
            case .BinaryOperation(let val,_):
                if(val == "×" || val == "÷") {return 2}
                else {return 1}
            case .UnaryOperation(let val, _):
                return 0
            default:
                return 0
            }
        }
        
        var associativity: String {
            switch self {
            case .BinaryOperation(let val, _):
                if val == "^" {return "right"}
                else {return "left"}
            default: return "left"
            }
            
        }
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Constant(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .openParen(let symbol):
                    return symbol
                case .closeParen(let symbol):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var infixOpStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 })
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["-"] = Op.BinaryOperation("-", { $1 - $0 })
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["π"] = Op.Constant("π", M_PI)
        
        knownOps["("] = Op.openParen("(")
        knownOps[")"] = Op.closeParen(")")
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops;
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Constant(_, let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    var result = operation(operand)
                    return (result, operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operand1Evaluation = evaluate(remainingOps)
                if let operand1 = operand1Evaluation.result {
                    let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                    if let operand2 = operand2Evaluation.result {
                        var result = operation(operand1, operand2)
                        return (result, operand2Evaluation.remainingOps)
                    }
                }
            default:
                return (nil, remainingOps)
            }
        }
        return (nil, ops)
    }
    
    
    private struct Stack {
        var items = [Op]()
        mutating func push(item: Op) {
            items.append(item)
        }
        mutating func pop() -> Op {
            return items.removeLast()
        }
        func peek() -> Op? {
            return items.last
        }
    }
    
    private func infixToRPN(ops: [Op]) -> [Op] {
        var opStack = Stack()
        var returnOps = [Op]()
        for op in ops {
            switch op {
            case .Constant:
                returnOps.append(op)
            case .Operand:
                returnOps.append(op)
            case .BinaryOperation, .UnaryOperation:
                var top = opStack.peek()
                while top != nil && top?.isOperation == true &&
                ((op.associativity == "left" && op.precedence <= top?.precedence) ||
                (op.associativity == "right" && op.precedence < top?.precedence))
                {
                    returnOps.append(opStack.pop())
                    top = opStack.peek()
                }
                opStack.push(op)
            case .openParen:
                opStack.push(op)
            case .closeParen:
                opStack.pop() // remove close paren
                var top = opStack.peek()
                while top?.isOpenParen != true && top != nil {
                    returnOps.append(opStack.pop())
                    top = opStack.peek()
                }
                if top != nil {
                    opStack.pop() // remove open paren
                }
            }
        }
        while opStack.peek() != nil {
            returnOps.append(opStack.pop())
        }
        return returnOps
    }
    
    func isOp(op: String) -> Bool {
        return knownOps[op] != nil
    }
    
    func pushOperation(op: String) {
        infixOpStack.append(knownOps[op]!)
    }
    
    func pushOperand(val: Double) {
        infixOpStack.append(Op.Operand(val))
    }
    
    func evaluate() -> Double? {
        println(infixOpStack);
        opStack = infixToRPN(infixOpStack)
        let result = evaluate(opStack)
        infixOpStack = [Op]()
        opStack = [Op]()
        return result.result!
    }

}