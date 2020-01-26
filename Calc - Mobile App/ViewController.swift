//
//  ViewController.swift
//  Calc - Mobile App
//
//  Created by Cicely Beckford on 1/17/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipControlView: UIView!
    @IBOutlet weak var subView: UIView!
    
    let defaults = UserDefaults.standard
    var currentString = ""
    var up = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.setAnimationsEnabled(false)
        let tipIdx = defaults.integer(forKey: "defaultTip")
        let themeIdx = defaults.integer(forKey: "appTheme")
        up = defaults.bool(forKey: "showAnim") 
        
        switch themeIdx {
            case 1:
                self.view.backgroundColor = UIColor.darkBackground
                self.view.tintColor = UIColor.darkTint
                tipControlView.backgroundColor = UIColor.darkBackground
                subView.backgroundColor = UIColor.subDarkBackground
                billField.attributedPlaceholder = NSAttributedString(string: Locale.current.currencySymbol!,
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.darkTint])
                billField.textColor = UIColor.darkTint
                for view in self.subView.subviews as [UIView] {
                    if let txt = view as? UILabel {
                        txt.textColor = UIColor.darkTint
                    }
                }
            default:
                self.view.backgroundColor = UIColor.lightBackground
                self.view.tintColor = UIColor.lightTint
                tipControlView.backgroundColor = UIColor.lightBackground
                subView.backgroundColor = UIColor.subLightBackground
                billField.attributedPlaceholder = NSAttributedString(string: Locale.current.currencySymbol!,
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.lightTint])
                billField.textColor = UIColor.lightTint
                for view in self.subView.subviews as [UIView] {
                    if let txt = view as? UILabel {
                        txt.textColor = UIColor.lightTint
                    }
                }
        }
        tipControl.selectedSegmentIndex = tipIdx
        tipControl.sendActions(for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(true)
        showAnimation(textField: billField, show: up)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currentString != "" {
            defaults.set(!up, forKey: "showAnim")
        } else {
            defaults.set(up, forKey: "showAnim")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.textAlignment = .right
        billField.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
        billField.delegate = self
        billField.becomeFirstResponder()
        
        let start = defaults.object(forKey: "startTime") as? NSDate
        if (start != nil) {
            let currString = defaults.string(forKey: "currString")
            let elapsed = NSDate().timeIntervalSince(start as! Date)
            if elapsed <= 600 {
                currentString = currString!
                billField.text = formatCurrency(currentString)
            } else {
                defaults.removeObject(forKey:"startTime")
                defaults.removeObject(forKey:"currString")
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveData(_ sender: Any) {
        defaults.set(currentString, forKey: "currString")
        defaults.set(NSDate(), forKey: "startTime")
        defaults.synchronize()
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let temp = billField.text!.replacingOccurrences(of: Locale.current.groupingSeparator!, with: "")
        let bill = Double(temp.replacingOccurrences(of: Locale.current.decimalSeparator!, with: ".")) ?? 0
        let tipPercentages = [0.15, 0.18, 0.2]
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        print(temp, bill)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        tipLabel.text = formatter.string(from: tip as NSNumber)
        totalLabel.text = formatter.string(from: total as NSNumber)

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                currentString += string
                textField.text = formatCurrency(currentString)
            default:
                if string.characters.count == 0 && currentString.characters.count != 0 {
                    currentString = String(currentString.characters.dropLast())
                    textField.text = formatCurrency(currentString)
                }
        }
        showAnimation(textField: textField, show: up)
        textField.sendActions(for: UIControlEvents.editingChanged)
        return false
    }

    func formatCurrency(_ string: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let numberFromField = (NSString(string: currentString).doubleValue)/100
        let temp = formatter.string(from: NSNumber(value: numberFromField))
        
        if currentString == "" {
            return currentString
        }
        return String(temp!.characters.dropFirst(1))
    }
    
    func showAnimation(textField:UITextField, show:Bool){
        if textField.text == "" && show == true {
            animateTextField(textField: textField, up: false)
            up = false
        } else if textField.text != "" && show == false {
            animateTextField(textField: textField, up: true)
            up = true
        }
    }
    
    func animateTextField (textField:UITextField, up:Bool) {
        let movementDistance = 190
        let movementDuration = 0.4
        let movement = CGFloat(up ? -movementDistance : movementDistance)
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

