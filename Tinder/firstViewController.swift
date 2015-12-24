//
//  firstViewController.swift
//  UOB
//
//  Created by Carlos Lovera on 6/8/15.
//  Copyright (c) 2015 Appfish. All rights reserved.
//

import UIKit

class firstViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passText: UITextField!
    
    @IBOutlet weak var errorPass: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func passSegue(sender: AnyObject) {
        var my_password = "default"
        var query = PFQuery(className:"user_pwd")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    
                    my_password = object["password"] as! String
                    
                    println(my_password)
                    
                    if self.passText.text == my_password {
                        self.performSegueWithIdentifier("goToFb", sender: self)
                    } else {
                        self.errorPass.alpha = 1
                    }
                }
            } else {
                var my_password = "default"
                println(error)
            }
        }
        
     

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

}
