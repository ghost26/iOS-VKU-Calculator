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
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let currentDigit = sender.currentTitle!
        if resultLabel.text!.range(of: ",") != nil && currentDigit == "," {
            return
        }
        if isUserTyping {
            resultLabel.text?.append(currentDigit)
            resultLabel.text = formatResult(resultLabel.text!)
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
                resultLabel.text = "0"
                calculator.reset()
            }
        } else {
            calculator.setOperand(operand: NSString(string: currentResult).doubleValue)
            calculator.performOperation(symbol: currentOperation)
            isUserTyping = false
            if calculator.result != nil {
                resultLabel.text = formatResult(String(describing: calculator.result!))
                // pretty 0: 2,0 -> 2
                resultLabel.text?.append("\n")
                resultLabel.text = resultLabel.text!.replacingOccurrences(of: ",0\n", with: "")
            } else {
                resultLabel.text = "Error"
            }
        }
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
        
        clearLabels();
    }


}

