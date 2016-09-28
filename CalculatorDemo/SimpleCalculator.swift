//
//  SimpleCalculator.swift
//  CalculatorDemo
//
//  Created by Vladislav Kiryukhin on 28.09.16.
//  Copyright © 2016 Vladislav Kiryukhin. All rights reserved.
//

import Foundation

class SimpleCalculator {
    
    private enum Operation {
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "±" : Operation.UnaryOperation({ ($0 == 0.0 ? 0.0 : -$0) }),
        "%" : Operation.UnaryOperation({ $0 / 100 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "–" : Operation.BinaryOperation({ $0 - $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "=" : Operation.Equals
    ]
    
    private var firstOperand: Double? = nil
    private var secondOperand: Double? = nil
    private var pendingOperation: ((Double, Double) -> Double)? = nil
    
    func setOperand(operand: Double) {
        firstOperand = secondOperand
        secondOperand = operand
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .UnaryOperation(let op):
                if secondOperand != nil {
                    secondOperand = op(secondOperand!)
                }
            case .BinaryOperation(let op):
                performPendingOperation()
                pendingOperation = op
            case .Equals:
                (secondOperand == nil ? (secondOperand = 0.0) : performPendingOperation())
            }
        }
    }
    
    func performPendingOperation() {
        if pendingOperation != nil && firstOperand != nil && secondOperand != nil {
            secondOperand = pendingOperation!(firstOperand!, secondOperand!)
            firstOperand = nil; pendingOperation = nil
        }
    }
    
    func reset() {
        firstOperand = nil; secondOperand = nil; pendingOperation = nil
    }
    
    var result: Double? {
        get {
            return secondOperand
        }
    }
}
