//
//  CalculatorViewController.swift
//  CalculatorDemo
//
//  Created by Vladislav Kiryukhin on 19.09.16.
//  Copyright © 2016 Vladislav Kiryukhin. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var lastOperationLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    private var isUserTyping = false
    private var calculator = SimpleCalculator()
    
    private var lastOperation: String!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let currentDigit = sender.currentTitle!
        if resultLabel.text!.range(of: ",") != nil && currentDigit == "," {
            return
        }
        if isUserTyping {
            if resultLabel.text!.characters.count < 16 {
                resultLabel.text?.append(currentDigit)
                resultLabel.text = formatResult(resultLabel.text!)
            }
        } else {
            if currentDigit == "," {
                resultLabel.text = "0,"
            } else {
                resultLabel.text = currentDigit
            }
        }
        isUserTyping = true
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        let currentOperation = sender.currentTitle!
        let currentResult = deformatResult(resultLabel.text!)
        
        if currentOperation == "C" {
            if isUserTyping {
                resultLabel.text = formatResult(currentResult.substring(to: currentResult.index(before: currentResult.endIndex)))
                if resultLabel.text!.isEmpty {
                    resultLabel.text = "0"
                    isUserTyping = false
                }
            } else {
                clearLabels()
                calculator.reset()
            }
        } else {
            calculator.setOperand(operand: NSString(string: currentResult).doubleValue)
            
            // update label with last operation
            if calculator.isNotUnaryOperation(op: currentOperation) {
                let operands = calculator.getOperands()
                if operands.0 != nil && operands.1 != nil {
                    if calculator.isEqualsOperation(op: currentOperation) {
                        lastOperationLabel.text = "\(stripZero(formatResult(String(operands.0!)))) \(lastOperation!) \(stripZero(formatResult(String(operands.1!))))"
                    } else {
                        lastOperationLabel.text = ""
                    }
                }
            }
            
            calculator.performOperation(symbol: currentOperation)
            isUserTyping = false
            if calculator.result != nil {
                resultLabel.text = formatResult(String(describing: calculator.result!))
                // pretty 0: 2,0 -> 2
                resultLabel.text = stripZero(resultLabel.text!)
            } else {
                resultLabel.text = "Error"
            }
            
            lastOperation = currentOperation
        }
    }
    
    private func stripZero(_ numberRepresentation: String) -> String {
        return (numberRepresentation + "\n").replacingOccurrences(of: ",0\n", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    private func formatResult(_ result: String) -> String {
        return result.replacingOccurrences(of: ".", with: ",")
    }
    
    private func deformatResult(_ result: String) -> String {
        return result.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")
    }
    
    func clearLabels() {
        resultLabel.text = "0"
        lastOperationLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.minimumScaleFactor = 0.5
        resultLabel.adjustsFontSizeToFitWidth = true
        
        lastOperationLabel.minimumScaleFactor = 0.5
        lastOperationLabel.adjustsFontSizeToFitWidth = true
        
        clearLabels();
    }


}

