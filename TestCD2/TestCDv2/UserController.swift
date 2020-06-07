//
//  ViewController.swift
//  TestCDv2
//
//  Created by Zlatan Haljeta on 02/06/2020.
//  Copyright © 2020 Zlatan Haljeta. All rights reserved.
//

import UIKit
import CoreData

class UserController: UIViewController, UITextFieldDelegate {

    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
   
    @IBOutlet var fullName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var passwordSP: UITextField!
    
    @IBOutlet var loggedUser: UILabel!
    
  
    var users: [NSManagedObject] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
      
        userName?.delegate = self;
        password?.delegate = self;
        fullName?.delegate = self;
        email?.delegate = self;
        passwordSP?.delegate = self;
        
    }
    
    func checkUser(userName: String, password: String, users: [NSManagedObject])-> Bool{
        //cheking authentication (need to upgrade)
        for u in users {
            if u.value(forKey: "fullName") as! String == userName &&
                password == u.value(forKey: "password") as!String
            {
                return true
            }
        }
        return false
    }
    
    func getUsers()  {
        //getting all users
       guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else{
            return;
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do{
            users = try managedContext.fetch(fetchRequest)
            
        }catch let error as NSError{
            print("Could not fetch.")
        }
    }
    
    @IBAction func SING_IN(_ sender: Any) {
         //the name says it all
       
        getUsers();
        
        if checkUser(userName: userName.text!, password: password.text!, users: users) {
           //"Dodati label"
        }
        else{
            
            let login = storyboard?.instantiateViewController(identifier: "LoginSB");
            present(showPopUp(check: "signIN"), animated: true, completion: nil);
            present(login!, animated: false, completion: nil);
            
        }
    }
    
    
    
    func showPopUp(check: String) -> UIAlertController{
        
        // showing varius options of pop-ups, upgradeable
        
        var alertController: UIAlertController;
        let okAction = UIAlertAction(title: "OK", style: .default)
        if check == "signIN" {
             alertController = UIAlertController(title: "", message:"The username and password doesn't match any account. Please, try again.", preferredStyle: .alert)
             alertController.addAction(okAction)
            return alertController;
        }
        else if check == "signUP"{
             alertController = UIAlertController(title: "", message:"Email already in use. Please, try with a different one.", preferredStyle: .alert)
          alertController.addAction(okAction)
            return alertController;
        }
        alertController = UIAlertController(title: "", message:"", preferredStyle: .alert)
        
        return alertController;
        
       
    }
    
    func checkEmail(email: String) -> Bool{
        //checking if email is already in use after sing up
        getUsers()
        for u in users {
            if u.value(forKey: "email") as! String == email{
                return true;
            }
        }
        return false;
    }
    
//    func checkFields(email: String){
//        textField.attributedPlaceholder = NSAttributedString(string: "Required!",
//                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]);
//    }
    @IBAction func SING_UP(_ sender: Any) {
        
        // says it all
        if checkEmail(email: email.text!){
        
            let signUP = storyboard?.instantiateViewController(identifier: "signUP");
            present(showPopUp(check: "signUP"), animated: true, completion: nil);
            present(signUP!, animated: false, completion: nil);
            
        }
        else{
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                    return
                  }
            let managedContext = appDelegate.persistentContainer.viewContext;
                  
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
                  
            let user = NSManagedObject(entity: entity, insertInto: managedContext)
                  
            
            user.setValue(fullName.text!, forKeyPath:"fullName")
            user.setValue(email.text!, forKeyPath:"email")
            user.setValue(passwordSP.text!, forKeyPath:"password")
                  
            do{
                try managedContext.save()
                users.append(user)
            }
            catch {
                    print("Could not save" ) // add error message
            }
        }
    }
    
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.endEditing(true); //dissmises the keyboard after pressing GO
         return true;
         //this method saves the input text after the user pressess the
        //Go button on keyboard
    }

//     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != ""{
//             return true;
//        }
//         else{
//
//
//             return false;
//         }
//         //prevents the user to search without typing a country
//     }
    
    
    
}

