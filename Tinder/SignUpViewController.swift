//
//  SignUpViewController.swift
//  Tinder
//
//  Created by Carlos Lovera on 5/29/15.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var middleName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var dateOfBirth: UITextField!
   
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phoneNum: UITextField!
    
    @IBOutlet weak var thaiSwitch: UISwitch!
    
    @IBOutlet weak var citiNum: UITextField!
    
    @IBOutlet weak var passNum: UITextField!
    
    @IBOutlet weak var thai: UITextField!
    
    @IBAction func saveButton(sender: AnyObject) {
        var user = PFUser.currentUser()

            println(self.firstName.text)
          //  println(self.middleName.text)
      
  
        
        var posts = PFObject(className: "Users")
        
        
        var first_name = self.firstName.text
        posts["first_name"] = first_name
        
//        var middle_name = self.middleName.text
//        posts["first_name"] = middle_name
        
        var last_name = self.lastName.text
        posts["last_name"] = last_name
        
//        var email = self.email.text
//        posts["email"] = email
        
//        var phoneNum = self.phoneNum.text
//        posts["phoneNum"] = phoneNum
        
        var citiNum = self.citiNum.text
        posts["citiNum"] = citiNum
        
//        var passNum = self.passNum.text
//        posts["passNum"] = passNum
//        
//        var thai = self.thai.text
//        posts["thai"] = thai
        
        
        
        posts.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                /**success saving, Now save image.***/
                
                
                var first_name = self.firstName.text
             //   first_name.delegate = self
                posts["first_name"] = first_name
                
               // var middle_name = self.middleName.text
                //posts["middle_name"] = middle_name
                
                var last_name = self.lastName.text
                posts["last_name"] = last_name
                
              //  var email = self.email.text
                //posts["email"] = email
                
             //   var phoneNum = self.phoneNum.text
              //  posts["phoneNum"] = phoneNum
                
                var citiNum = self.citiNum.text
                posts["citiNum"] = citiNum
                
              //  var passNum = self.passNum.text
               // posts["passNum"] = passNum
                
                //var thai = self.thai.text
                //posts["thai"] = thai
                
                posts.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    
                    if error == nil {
                        //take user home
                        println("data uploaded")
                        
                        
                    }else {
                        
                        println(error)
                    }
                    
                    
                })
                
                
            }else {
                println(error)
                
            }
            
        })

        user.save()
        
        performSegueWithIdentifier("finalSegue", sender: self)
    }
    
// all the fun happens here:

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()
        
        var FBSession = PFFacebookUtils.session()
        
        var accessToken = FBSession.accessTokenData.accessToken
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let image = UIImage(data: data)

            
            user["image"] = data
            
            user.save()
            
            FBRequestConnection.startForMeWithCompletionHandler({
                connection, result, error in
                
                user["gender"] = result["gender"]
                user["first_name"] = result["first_name"]
                user["last_name"] = result["last_name"]
                user["locale"] = result["locale"]
                user["timezone"] = result["timezone"]
                user["email"] = result["email"]
                user["link"] = result["link"]
               
                
                user.save()
                
                println(result)
                
                
            
            
            var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
            friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                let resultdict = result as! NSDictionary
                
                    PFUser.currentUser().addUniqueObject(resultdict, forKey:"user_likes")
                    PFUser.currentUser().save()
                
                let friends : NSArray = resultdict.objectForKey("data") as! NSArray
                //                        friends.append(id)

                println("Found: \(friends.count) friends")
                for friend in friends {
                    let id = friend.objectForKey("id") as! String
                    println("I have a friend named \(friend.name) with id " + id)
                    
                }
                                        PFUser.currentUser().addUniqueObject(friends, forKey:"friends")
                                        PFUser.currentUser().save()
            }
            
          }) // end fbRequest
            
            // Get List Of Friends
//            var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
//            friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//                var resultdict = result as! NSDictionary
//                println("Result Dict: \(resultdict)")
//                var data : NSArray = resultdict.objectForKey("data") as! NSArray
//                
//                for i in 0 ..< data.count {
//                        let valueDict : NSDictionary = data[i] as! NSDictionary
//                        let id = valueDict.objectForKey("id") as! String
//                        friends.append(id)
//                        PFUser.currentUser().addUniqueObject(friends, forKey:"friends")
//                        PFUser.currentUser().save()
//                        println("the id value is \(id)")
//                    
//                }
//                
//
//                
//                var friends_local = resultdict.objectForKey("data") as! NSArray
//                println("Found \(friends_local.count) friends")
//            }
            
            
            
            // to get the current location
            PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
                if error == nil {
            
                    println(geopoint)
            
                    var user = PFUser.currentUser()
        
                    user["location"] = geopoint
                }
            }
            
        }) //end of the asynchronous
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    } // end of didLoad method
            
            
            
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
