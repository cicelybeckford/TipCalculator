//
//  SettingsViewController.swift
//  Calc - Mobile App
//
//  Created by Cicely Beckford on 1/19/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var themeControl: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        let tipIdx = defaults.integer(forKey: "defaultTip")
        let themeIdx = defaults.integer(forKey: "appTheme")
        
        updateView(themeIdx)
        themeControl.selectedSegmentIndex = themeIdx
        tipControl.selectedSegmentIndex = tipIdx
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func setDefault(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(tipControl.selectedSegmentIndex, forKey: "defaultTip")
        defaults.synchronize()
    }
    
    @IBAction func setTheme(_ sender: Any) {
        let theme = themeControl.selectedSegmentIndex
        let defaults = UserDefaults.standard
        
        updateView(theme)
        print("response")
        defaults.set(theme, forKey: "appTheme")
        defaults.synchronize()
    }
    
    func updateView(_ theme: Int) {
        print(theme)
        print("fired")
        switch theme {
            case 1:
                self.view.backgroundColor = UIColor.darkBackground
                self.view.tintColor = UIColor.darkTint
                for view in self.view.subviews as [UIView] {
                    if let lbl = view as? UILabel {
                        lbl.textColor = UIColor.white
                    }
                }
            default:
                self.view.backgroundColor = UIColor.lightBackground
                self.view.tintColor = UIColor.lightTint
                for view in self.view.subviews as [UIView] {
                    if let lbl = view as? UILabel {
                        lbl.textColor = UIColor.black
                    }
                }
        }
    }
}
