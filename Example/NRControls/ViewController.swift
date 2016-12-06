//
//  ViewController.swift
//  NRControls
//
//  Created by naveenrana1309 on 08/21/2016.
//  Copyright (c) 2016 naveenrana1309. All rights reserved.
//

import UIKit
import NRControls

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //IBActions
    @IBAction func takeChoosePhoto(sender: UIButton) {
        NRControls.sharedInstance.takeOrChoosePhoto(self) { (selectedImage) in
            self.imageView.image = selectedImage
        }
    }

    @IBAction func alertViewButtonClicked(sender: UIButton) {
        NRControls.sharedInstance.openAlertViewFromViewController(self, title: "Logout Alert", message: "Are you sure you want to logout?", buttonsTitlesArray: ["Cancel","Ok"]) { (alertController, index) in
            print("index = \(index)")
        }
    }
    
    @IBAction func actionSheetViewButtonClicked(sender: UIButton) {
        NRControls.sharedInstance.openActionSheetFromViewController(self, title: "Action Sheet", message: "This is action sheet test message", buttonsTitlesArray: ["Login", "Logout"]) { (alertController, index) in
            print("index = \(index)")

        }
    }
    
    @IBAction func mailComposerButtonClicked(sender: UIButton) {
        NRControls.sharedInstance.openMailComposerInViewController(["naveen.rana@appster.in"], viewcontroller: self) { (result, error) in
            print(result)
        }
    }
    
    @IBAction func alertViewWithTextFieldButtonClicked(sender: UIButton) {
        NRControls.sharedInstance.openAlertViewWithTextFieldFromViewController(self, title: "TextField demo", message: "This is textfield test", placeHolder: "Enter your email", isSecure: false, buttonsTitlesArray: ["Cancel","Submit"], isNumberKeyboard: false) { (alertController, index, text) in
            print(text)
        }
    }
}

